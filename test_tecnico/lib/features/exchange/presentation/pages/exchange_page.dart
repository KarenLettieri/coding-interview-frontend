import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_tecnico/features/exchange/presentation/bloc/exchange_bloc.dart';
import 'package:test_tecnico/features/exchange/presentation/bloc/exchange_event.dart';
import 'package:test_tecnico/features/exchange/presentation/bloc/exchange_state.dart';
import 'package:test_tecnico/features/exchange/presentation/widgets/amount-field.widget.dart';
import 'package:test_tecnico/features/exchange/presentation/widgets/circle-icon.dart';
import 'package:test_tecnico/features/exchange/presentation/widgets/dual-currency-selector.widget.dart';
import 'package:test_tecnico/features/exchange/presentation/widgets/info-row.widget.dart';
import 'package:test_tecnico/features/exchange/presentation/widgets/radio-circle.widget.dart';
import 'package:test_tecnico/features/exchange/presentation/widgets/section.widget.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  final TextEditingController _amountCtrl = TextEditingController(text: '5.00');

 final List<Currency> _fiats = const [
  Currency(code: 'VES', name: 'Bolívares (Bs)', kind: CurrencyKind.fiat, assetKey: 'VES'),
  Currency(code: 'COP', name: 'Pesos Colombianos (COL)', kind: CurrencyKind.fiat, assetKey: 'COP'),
  Currency(code: 'PEN', name: 'Soles Peruanos (S/)', kind: CurrencyKind.fiat, assetKey: 'PEN'),
  Currency(code: 'BRL', name: 'Real Brasileño (R)', kind: CurrencyKind.fiat, assetKey: 'BRL'),
];


  final List<Currency> _cryptos = const [
  Currency(code: 'USDT', name: 'Tether (USDT)', kind: CurrencyKind.crypto, assetKey: 'TATUM-TRON-USDT'),
];


  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  const bgLight = Color(0xFFE3F7F7);
  const brand = Color(0xFFF7AC09);
  const textGray = Color(0xFF6C6C6C);

  final size = MediaQuery.of(context).size;
  final isMobile = size.width < 600;



  return Scaffold(
    backgroundColor: bgLight,
    body: Stack(
      children: [
        Positioned(
          right: -MediaQuery.of(context).size.width * 1.5,
          top: MediaQuery.of(context).size.height * -0.20,
          child: Container(
            width: MediaQuery.of(context).size.width * 2,
            height: MediaQuery.of(context).size.width * 2.3,
          decoration: const BoxDecoration(
          color: brand,
          shape: BoxShape.circle,
    ),
  ),
),

        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Container(
                width: isMobile ? size.width * 0.88 : 400,
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: const [
                    BoxShadow(color: Color(0x1A000000), blurRadius: 20, offset: Offset(0, 8))
                  ],
                ),
                child: BlocConsumer<ExchangeBloc, ExchangeState>(
                  listener: (context, s) {
                    if (s.error != null && s.error!.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.error!)));
                    }
                    if (_amountCtrl.text != s.amountText) {
                      _amountCtrl.text = s.amountText;
                      _amountCtrl.selection = TextSelection.fromPosition(
                        TextPosition(offset: _amountCtrl.text.length),
                      );
                    }
                  },
                  builder: (context, s) {
                    final fromCur = _mapToCurrency(s.fromCode);
                    final toCur = _mapToCurrency(s.toCode);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                       
ExchangeHeader(
  leftLabel: 'TENGO',
  rightLabel: 'QUIERO',
  leftIcon: _mapToCurrency(s.fromCode).assetKey,
  leftCode: s.fromCode,
  rightIcon: _mapToCurrency(s.toCode).assetKey,
  rightCode: s.toCode,
  onLeftTap: () => _openSheet(context, selectFrom: true),
  onRightTap: () => _openSheet(context, selectFrom: false),
  onSwap: () => context.read<ExchangeBloc>().add(const SwapRequested()),
),

const SizedBox(height: 24),




                       
                        AmountField(
                          controller: _amountCtrl,
                          prefix: s.fromCode,
                          borderColor: brand,
                          onChanged: (v) =>
                              context.read<ExchangeBloc>().add(AmountChanged(v)),
                        ),
                        const SizedBox(height: 26),

                      
                        InfoRow(
                          label: 'Tasa estimada',
                          value: s.rate != null
                              ? '≈ ${_format2(s.rate!)} ${s.toCode}'
                              : '—',
                          labelColor: textGray,
                        ),
                        const SizedBox(height: 12),
                        InfoRow(
                          label: 'Recibirás',
                          value: s.receive != null
                              ? '≈ ${_format2(s.receive!)} ${s.toCode}'
                              : '—',
                          labelColor: textGray,
                        ),
                        const SizedBox(height: 12),
                        InfoRow(
                          label: 'Tiempo estimado',
                          value: s.eta,
                          labelColor: textGray,
                        ),
                        const SizedBox(height: 32),

                       
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brand,
                              foregroundColor: Colors.white,
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                            ),
                            onPressed: () => context
                                .read<ExchangeBloc>()
                                .add(const ExchangeRequested()),
                            child: s.loading
                                ? const SizedBox(
                                    width: 26,
                                    height: 26,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Cambiar',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


  // ---------- Helpers ----------

  void _openSheet(BuildContext context, {required bool selectFrom}) {
    showModalBottomSheet<Currency>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCDD2D7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 16),
                Section(title: 'FIAT', children: _fiats.map((c) => _tile(context, c, selectFrom)).toList()),
                const SizedBox(height: 8),
                Section(title: 'Cripto', children: _cryptos.map((c) => _tile(context, c, selectFrom)).toList()),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _tile(BuildContext context, Currency c, bool selectFrom) {
    return ListTile(
      leading: CircleIcon(assetKey: c.assetKey),
      title: Text(c.code, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(c.name),
      trailing: const RadioCircle(),
      onTap: () {
        Navigator.of(context).pop();
        final isCrypto = c.kind == CurrencyKind.crypto;
        if (selectFrom) {
          context.read<ExchangeBloc>().add(FromCurrencySelected(code: c.code, isCrypto: isCrypto));
        } else {
          context.read<ExchangeBloc>().add(ToCurrencySelected(code: c.code, isCrypto: isCrypto));
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
      minLeadingWidth: 40,
    );
  }

  Currency _mapToCurrency(String code) {
    final all = [..._fiats, ..._cryptos];
    return all.firstWhere(
      (c) => c.code == code,
      orElse: () => Currency(code: code, name: code, kind: CurrencyKind.fiat, assetKey: code),
    );
  }

  static String _format2(num v) => v.toStringAsFixed(2);
}

enum CurrencyKind { fiat, crypto }

class Currency {
  final String code;
  final String name;
  final CurrencyKind kind;
  final String assetKey; 

  const Currency({
    required this.code,
    required this.name,
    required this.kind,
    required this.assetKey,
  });
}
