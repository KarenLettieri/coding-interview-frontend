import 'package:dartz/dartz.dart';
import 'package:test_tecnico/core/error/failures.dart';

abstract class ExchangeRepository {
  Future<Either<Failure, Map<String, dynamic>>> getExchange({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required double amount,
    required String amountCurrencyId,
  });
}
