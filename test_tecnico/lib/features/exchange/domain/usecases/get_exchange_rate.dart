import 'package:dartz/dartz.dart';
import 'package:test_tecnico/core/error/failures.dart';
import 'package:test_tecnico/features/exchange/domain/repositories/exchange_repository.dart';


class GetExchangeRate {
  final ExchangeRepository repository;
  GetExchangeRate(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required double amount,
    required String amountCurrencyId,
  }) {
    return repository.getExchange(
      type: type,
      cryptoCurrencyId: cryptoCurrencyId,
      fiatCurrencyId: fiatCurrencyId,
      amount: amount,
      amountCurrencyId: amountCurrencyId,
    );

  }
}
