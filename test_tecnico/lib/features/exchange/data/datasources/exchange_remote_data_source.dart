import 'dart:io';
import 'package:dio/dio.dart';
import 'package:test_tecnico/core/network/api_client.dart';

abstract class ExchangeRemoteDataSource {
  Future<Map<String, dynamic>> getRecommendation({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required double amount,
    required String amountCurrencyId,
  });
}

class ExchangeRemoteDataSourceImpl implements ExchangeRemoteDataSource {
  final ApiClient apiClient;

  ExchangeRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> getRecommendation({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required double amount,
    required String amountCurrencyId,
  }) async {
    try {
      final response = await apiClient.dio.get(
        '/recommendations',
        queryParameters: {
          'type': '$type',
          'cryptoCurrencyId': cryptoCurrencyId,
          'fiatCurrencyId': fiatCurrencyId,
          'amount': amount.toString(),
          'amountCurrencyId': amountCurrencyId,
        },
      );

      final body = response.data;
      final data = body['data'];
    final byPrice = data?['byPrice'];
    final byAmount = data?['byAmount'];

    dynamic ftc =
        byPrice?['fiatToCryptoExchangeRate'] ??
        byAmount?['fiatToCryptoExchangeRate'] ??
        data?['fiatToCryptoExchangeRate'];

    dynamic ctf =
        byPrice?['cryptoToFiatExchangeRate'] ??
        byAmount?['cryptoToFiatExchangeRate'] ??
        data?['cryptoToFiatExchangeRate'];

    final ftcNum = _toDoubleSafe(ftc);
    final ctfNum = _toDoubleSafe(ctf);

    if ((ftcNum == null || ftcNum == 0) && (ctfNum == null || ctfNum == 0)) {
      return {
        'rate': null,
        'receive': null,
        'eta': '≈ 10 Min',
        'message': 'No hay cotización disponible para este par.',
      };
    }

    final double rawCtf;
    final double rawFtc;

    if (ftcNum != null && ftcNum > 0) {
      rawCtf = ftcNum;
      rawFtc = 1 / ftcNum;
    } else {
      rawCtf = ctfNum!;
      rawFtc = 1 / ctfNum;
    }

    double rateToShow;
    double receive;

    if (type == 0) {
      // CRYPTO → FIAT
      rateToShow = rawCtf;
      receive = amount * rawCtf;
    } else {
      // FIAT → CRYPTO
      rateToShow = rawFtc;
      receive = amount * rawFtc;
    }

      return {
        'rate': rateToShow,
        'receive': receive,
        'eta': '≈ 10 Min',
        'rawFtc': rawFtc,
        'rawCtf': rawCtf,
      };
    } on DioError catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      throw HttpException('HTTP ${status ?? 'Error'}: ${data ?? e.message}');
    }
  }

  double? _toDoubleSafe(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) {
      final s = v.trim().replaceAll(',', '.');
      return double.tryParse(s);
    }
    return double.tryParse(v.toString());
  }
}
