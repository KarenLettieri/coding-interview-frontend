import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:test_tecnico/core/network/api_client.dart';
import 'package:test_tecnico/core/network/network_info.dart';
import 'package:test_tecnico/features/exchange/data/datasources/exchange_remote_data_source.dart';
import 'package:test_tecnico/features/exchange/data/repositories_impl/exchange_repository_impl.dart';
import 'package:test_tecnico/features/exchange/domain/repositories/exchange_repository.dart';
import 'package:test_tecnico/features/exchange/domain/usecases/get_exchange_rate.dart';
import 'package:test_tecnico/features/exchange/presentation/bloc/exchange_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // -------- External --------
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());

  // -------- Core --------
  sl.registerLazySingleton(() => ApiClient(sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // -------- Data sources --------

  sl.registerLazySingleton<ExchangeRemoteDataSource>(
    () => ExchangeRemoteDataSourceImpl(sl()),
  );

  // -------- Repositories --------
  sl.registerLazySingleton<ExchangeRepository>(
    () => ExchangeRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // -------- Use cases --------
  sl.registerLazySingleton(() => GetExchangeRate(sl()));

  // -------- Bloc --------
  sl.registerFactory(() => ExchangeBloc(getExchangeRate: sl()));
}
