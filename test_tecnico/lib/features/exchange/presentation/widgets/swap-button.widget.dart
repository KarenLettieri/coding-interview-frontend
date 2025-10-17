import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SwapButton extends StatelessWidget {
  const SwapButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFFF7AC09);
    return Material(
      color: brand,
      shape: const CircleBorder(),
      elevation: 6,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 56,
          height: 56,
          child: Icon(Icons.compare_arrows_rounded, color: Colors.white),
        ),
      ),
    );
  }
}