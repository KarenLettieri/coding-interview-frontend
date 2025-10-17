import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  ApiClient(this.dio) {
    dio.options.baseUrl =
        'https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage/orderbook/public';
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
  }
}
