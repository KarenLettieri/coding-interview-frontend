import 'package:dartz/dartz.dart';
import 'package:test_tecnico/core/error/failures.dart';
import 'package:test_tecnico/core/network/network_info.dart';
import 'package:test_tecnico/features/exchange/domain/repositories/exchange_repository.dart';
import '../datasources/exchange_remote_data_source.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  final ExchangeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ExchangeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> getExchange({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required double amount,
    required String amountCurrencyId,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('Sin conexión a Internet'));
    }
    try {
      final data = await remoteDataSource.getRecommendation(
        type: type,
        cryptoCurrencyId: cryptoCurrencyId,
        fiatCurrencyId: fiatCurrencyId,
        amount: amount,
        amountCurrencyId: amountCurrencyId,
      );
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
