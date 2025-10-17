import 'package:equatable/equatable.dart';

class ExchangeState extends Equatable {
  final String fromCode;   
  final bool fromIsCrypto;
  final String toCode;      
  final bool toIsCrypto;

  final String amountText;  
  final bool loading;       
  final String? error;      

  final double? rate;      
  final double? receive;    
  final String eta;         

  const ExchangeState({
    required this.fromCode,
    required this.fromIsCrypto,
    required this.toCode,
    required this.toIsCrypto,
    required this.amountText,
    required this.loading,
    required this.error,
    required this.rate,
    required this.receive,
    required this.eta,
  });

  factory ExchangeState.initial() => const ExchangeState(
        fromCode: 'USDT',
        fromIsCrypto: true,
        toCode: 'VES',
        toIsCrypto: false,
        amountText: '5.00',
        loading: false,
        error: null,
        rate: null,
        receive: null,
        eta: '≈ 10 Min',
      );

  ExchangeState copyWith({
    String? fromCode,
    bool? fromIsCrypto,
    String? toCode,
    bool? toIsCrypto,
    String? amountText,
    bool? loading,
    String? error,
    double? rate,
    double? receive,
    String? eta,
    bool clearQuote = false, 
  }) {
    return ExchangeState(
      fromCode: fromCode ?? this.fromCode,
      fromIsCrypto: fromIsCrypto ?? this.fromIsCrypto,
      toCode: toCode ?? this.toCode,
      toIsCrypto: toIsCrypto ?? this.toIsCrypto,
      amountText: amountText ?? this.amountText,
      loading: loading ?? this.loading,
      error: error,
      rate: clearQuote ? null : (rate ?? this.rate),
      receive: clearQuote ? null : (receive ?? this.receive),
      eta: eta ?? this.eta,
    );
  }

  @override
  List<Object?> get props =>
      [fromCode, fromIsCrypto, toCode, toIsCrypto, amountText, loading, error, rate, receive, eta];
}
