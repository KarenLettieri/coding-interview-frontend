import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  const CircleIcon({super.key, required this.assetKey});
  final String assetKey;

  String assetPath() {
    const prefix = 'assets/images';
    return '$prefix/$assetKey.png';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        assetPath(),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
      
          return Container(
            color: Colors.grey[200],
            child: const Icon(Icons.error, size: 20, color: Colors.redAccent),
          );
        },
      ),
    );
  }
}

