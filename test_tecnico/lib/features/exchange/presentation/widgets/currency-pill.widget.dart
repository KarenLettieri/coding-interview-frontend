import 'package:flutter/material.dart';
import 'package:test_tecnico/features/exchange/presentation/pages/exchange_page.dart';
import 'circle-icon.dart';


class CurrencyPill extends StatelessWidget {
  const CurrencyPill({
    super.key,
    required this.label,
    required this.currency,
    required this.onTap,
    this.showBorder = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  });

  final String label;
  final Currency currency;
  final VoidCallback onTap;

  final bool showBorder;


  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFFF7AC09);

    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      child: Container(
        padding: contentPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: showBorder ? Border.all(color: brand, width: 2) : null,
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                letterSpacing: 0.6,
                color: Color(0xFF7D7D7D),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleIcon(assetKey: currency.assetKey),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    currency.code,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
