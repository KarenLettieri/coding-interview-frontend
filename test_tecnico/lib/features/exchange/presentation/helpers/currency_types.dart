import 'package:test_tecnico/features/exchange/presentation/pages/exchange_page.dart';

final List<Currency> fiats = const [
    Currency(
      code: 'VES',
      name: 'Bolívares (Bs)',
      kind: CurrencyKind.fiat,
      assetKey: 'VES',
    ),
    Currency(
      code: 'COP',
      name: 'Pesos Colombianos (COL)',
      kind: CurrencyKind.fiat,
      assetKey: 'COP',
    ),
    Currency(
      code: 'PEN',
      name: 'Soles Peruanos (S/)',
      kind: CurrencyKind.fiat,
      assetKey: 'PEN',
    ),
    Currency(
      code: 'BRL',
      name: 'Real Brasileño (R)',
      kind: CurrencyKind.fiat,
      assetKey: 'BRL',
    ),
  ];

  final List<Currency> cryptos = const [
    Currency(
      code: 'USDT',
      name: 'Tether (USDT)',
      kind: CurrencyKind.crypto,
      assetKey: 'TATUM-TRON-USDT',
    ),
  ];