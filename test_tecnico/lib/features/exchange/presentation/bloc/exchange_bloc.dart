import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:dartz/dartz.dart';
import '../../domain/usecases/get_exchange_rate.dart';
import 'exchange_event.dart';
import 'exchange_state.dart';
import 'package:test_tecnico/core/error/failures.dart';

EventTransformer<E> _debounce<E>(Duration d) {
  return (events, mapper) => events.debounce(d).switchMap(mapper);
}

const Map<String, String> _cryptoApiIds = {'USDT': 'TATUM-TRON-USDT'};

String _toApiId(String code, {required bool isCrypto}) {
  if (isCrypto) return _cryptoApiIds[code] ?? code;
  return code;
}

class ExchangeBloc extends Bloc<ExchangeEvent, ExchangeState> {
  final GetExchangeRate getExchangeRate;
  ExchangeBloc({required this.getExchangeRate})
    : super(ExchangeState.initial()) {
    on<AmountChanged>(
      _onAmountChanged,
      transformer: _debounce(const Duration(milliseconds: 350)),
    );
    on<FromCurrencySelected>(_onFromSelected, transformer: droppable());
    on<ToCurrencySelected>(_onToSelected, transformer: droppable());
    on<SwapRequested>(_onSwap, transformer: droppable());
    on<ExchangeRequested>(_onRequested, transformer: restartable());
  }

  void _onAmountChanged(AmountChanged e, Emitter<ExchangeState> emit) {
    emit(state.copyWith(amountText: e.amountText, error: null));
    add(const ExchangeRequested());
  }

  void _onFromSelected(FromCurrencySelected e, Emitter<ExchangeState> emit) {
    emit(
      state.copyWith(
        fromCode: e.code,
        fromIsCrypto: e.isCrypto,
        error: null,
        clearQuote: true,
      ),
    );
    add(const ExchangeRequested());
  }

  void _onToSelected(ToCurrencySelected e, Emitter<ExchangeState> emit) {
    emit(
      state.copyWith(
        toCode: e.code,
        toIsCrypto: e.isCrypto,
        error: null,
        clearQuote: true,
      ),
    );
    add(const ExchangeRequested());
  }

  void _onSwap(SwapRequested e, Emitter<ExchangeState> emit) {
    emit(
      state.copyWith(
        fromCode: state.toCode,
        fromIsCrypto: state.toIsCrypto,
        toCode: state.fromCode,
        toIsCrypto: state.fromIsCrypto,
        error: null,
        clearQuote: true,
      ),
    );
    add(const ExchangeRequested());
  }

  Future<void> _onRequested(
    ExchangeRequested e,
    Emitter<ExchangeState> emit,
  ) async {
    final amount = double.tryParse(state.amountText.replaceAll(',', '.')) ?? 0;
    final hasOneCryptoOneFiat = (state.fromIsCrypto ^ state.toIsCrypto);
    if (!hasOneCryptoOneFiat || amount <= 0) {
      emit(
        state.copyWith(loading: false, rate: null, receive: null, error: null),
      );
      return;
    }

    final cryptoCode = state.fromIsCrypto ? state.fromCode : state.toCode;
    final fiatCode = state.toIsCrypto ? state.fromCode : state.toCode;

    final cryptoId = _toApiId(cryptoCode, isCrypto: true);
    final fiatId = _toApiId(fiatCode, isCrypto: false);
    final amountCurrencyId = _toApiId(
      state.fromCode,
      isCrypto: state.fromIsCrypto,
    );

    final int type = state.fromIsCrypto ? 0 : 1;

    emit(state.copyWith(loading: true, error: null));
    final resp = await getExchangeRate.call(
      type: type,
      cryptoCurrencyId: cryptoId,
      fiatCurrencyId: fiatId,
      amount: amount,
      amountCurrencyId: amountCurrencyId,
    );

    resp.fold((f) => emit(state.copyWith(loading: false, error: f.message)), (
      data,
    ) {
      final rate = _toDouble(data['rate']);
      final receive =
          _toDouble(data['receive']) ?? (rate != null ? rate * amount : null);
      final eta = (data['eta']?.toString() ?? state.eta);
      emit(
        state.copyWith(
          loading: false,
          rate: rate,
          receive: receive,
          eta: eta,
          error: null,
        ),
      );
    });
  }

  double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }
}
