import 'package:flutter/material.dart';

class RadioCircle extends StatelessWidget {
  const RadioCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF7A8593), width: 2),
      ),
    );
  }
}
