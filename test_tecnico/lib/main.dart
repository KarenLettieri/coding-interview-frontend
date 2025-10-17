
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_tecnico/core/di/service_locator.dart' as di;
import 'features/exchange/presentation/bloc/exchange_bloc.dart';
import 'features/exchange/presentation/pages/exchange_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exchange Demo',
      home: BlocProvider(
        create: (_) => ExchangeBloc(getExchangeRate: di.sl()),
        child: const ExchangePage(),
      ),
    );
  }
}
