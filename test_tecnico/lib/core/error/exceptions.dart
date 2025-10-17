class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server Exception']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network Exception']);
}
