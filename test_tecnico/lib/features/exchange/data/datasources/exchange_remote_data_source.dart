
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

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
  static const _host = '74j6q7lg6a.execute-api.eu-west-1.amazonaws.com';
  static const _path = '/stage/orderbook/public/recommendations';

  ExchangeRemoteDataSourceImpl();

  @override
  Future<Map<String, dynamic>> getRecommendation({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required double amount,
    required String amountCurrencyId,
  }) async {
    final uri = Uri.https(_host, _path, {
      'type': '$type',
      'cryptoCurrencyId': cryptoCurrencyId,
      'fiatCurrencyId': fiatCurrencyId,
      'amount': amount.toString(),
      'amountCurrencyId': amountCurrencyId,
    });

    print('📡 GET $uri');

    final res = await http
        .get(uri, headers: {HttpHeaders.acceptHeader: 'application/json'})
        .timeout(const Duration(seconds: 15));

    print('➡️  STATUS: ${res.statusCode}');

    if (res.statusCode < 200 || res.statusCode >= 300) {
      print('❌ Body (error): ${res.body}');
      throw HttpException('HTTP ${res.statusCode}: ${res.body}');
    }

    final body = json.decode(res.body);
    final data = body['data'];
    final byPrice = data?['byPrice'];
    final byAmount = data?['byAmount']; 


    dynamic ftc = byPrice?['fiatToCryptoExchangeRate'] ??
        byAmount?['fiatToCryptoExchangeRate'] ??
        data?['fiatToCryptoExchangeRate'];

    dynamic ctf = byPrice?['cryptoToFiatExchangeRate'] ??
        byAmount?['cryptoToFiatExchangeRate'] ??
        data?['cryptoToFiatExchangeRate'];

    final ftcNum = _toDoubleSafe(ftc);
    final ctfNum = _toDoubleSafe(ctf);

    print('🧩 Keys: data=${data?.keys} | ftc=$ftcNum | ctf=$ctfNum | byPriceType=${byPrice.runtimeType}');


    if ((ftcNum == null || ftcNum == 0) && (ctfNum == null || ctfNum == 0)) {
      print('⚠️  No hay exchangeRate disponible. Body: ${res.body}');
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
      rawFtc = 1 / ctfNum!;  
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
