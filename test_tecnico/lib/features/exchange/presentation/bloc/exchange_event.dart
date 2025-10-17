import 'package:equatable/equatable.dart';

abstract class ExchangeEvent extends Equatable {
  const ExchangeEvent();
  
  @override
  List<Object?> get props => [];
}


class AmountChanged extends ExchangeEvent {
  final String amountText;
  const AmountChanged(this.amountText);
  @override
  List<Object?> get props => [amountText];
}


class FromCurrencySelected extends ExchangeEvent {
  final String code;         
  final bool isCrypto;      
  const FromCurrencySelected({required this.code, required this.isCrypto});
  @override
  List<Object?> get props => [code, isCrypto];
}

class ToCurrencySelected extends ExchangeEvent {
  final String code;
  final bool isCrypto;
  const ToCurrencySelected({required this.code, required this.isCrypto});
  @override
  List<Object?> get props => [code, isCrypto];
}

class SwapRequested extends ExchangeEvent {
  const SwapRequested();
}


class ExchangeRequested extends ExchangeEvent {
  const ExchangeRequested();
}
