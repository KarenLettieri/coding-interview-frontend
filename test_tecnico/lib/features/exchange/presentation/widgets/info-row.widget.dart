import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({required this.label, required this.value, this.labelColor});
  final String label;
  final String value;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final styleLeft = TextStyle(fontSize: 18, color: labelColor ?? Colors.black87);
    const styleRight = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
    return Row(
      children: [
        Expanded(child: Text(label, style: styleLeft)),
        Text(value, style: styleRight),
      ],
    );
  }
}