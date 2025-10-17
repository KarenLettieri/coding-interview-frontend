import '../../domain/entities/exchange_result.dart';

class ExchangeModel extends ExchangeResult {
  ExchangeModel({
    required super.rate,
    required super.totalReceived,
    required super.estimatedTime,
  });

  factory ExchangeModel.fromApi({
    required Map<String, dynamic> raw,
    required int type,
    required double amount,
  }) {
    final dynamic rateRaw =
        raw['data']?['byPrice']?['fiatToCryptoExchangeRate'];

    double rate = 0.0;
    if (rateRaw is num) {
      rate = rateRaw.toDouble();
    } else if (rateRaw is String) {
      rate = double.tryParse(rateRaw) ?? 0.0;
    } else {
      rate = 0.0;
    }

    double totalReceived = 0.0;

    if (rate <= 0) {
      totalReceived = 0.0;
    } else if (type == 1) {
      totalReceived = amount * rate;
    } else {
      totalReceived = amount / rate;
    }

    const estimatedTime = '≈ 10 Min';

    return ExchangeModel(
      rate: rate,
      totalReceived: totalReceived,
      estimatedTime: estimatedTime,
    );
  }
}
