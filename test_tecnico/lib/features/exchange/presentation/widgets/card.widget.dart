import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Card extends StatelessWidget {
  const Card({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, 8))],
      ),
      child: child,
    );
  }
}