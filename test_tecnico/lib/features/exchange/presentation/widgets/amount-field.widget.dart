import 'package:flutter/material.dart';

class AmountField extends StatelessWidget {
  const AmountField({
    required this.controller,
    required this.prefix,
    required this.borderColor,
    this.onChanged,
  });

  final TextEditingController controller;
  final String prefix; 
  final Color borderColor;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
      
        prefix: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            prefix,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
        isDense: true,
        hintText: '0.00',
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2.4),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
