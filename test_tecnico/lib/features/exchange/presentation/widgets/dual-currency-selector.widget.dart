import 'package:flutter/material.dart';

class ExchangeHeader extends StatelessWidget {
  const ExchangeHeader({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.leftIcon,
    required this.leftCode,
    required this.rightIcon,
    required this.rightCode,
    required this.onLeftTap,
    required this.onRightTap,
    required this.onSwap,
  });

  final String leftLabel;
  final String rightLabel;
  final String leftIcon;
  final String leftCode;
  final String rightIcon;
  final String rightCode;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;
  final VoidCallback onSwap;

  static const brand = Color(0xFFF7AC09);

  @override
  Widget build(BuildContext context) {
    const double pillHeight = 86;
    const double swapSize = 56;
    

    return SizedBox(
      height: pillHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
       
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: brand, width: 2),
              borderRadius: BorderRadius.circular(26),
            ),
          ),

         
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: _CurrencySelector(
                    label: leftLabel,
                    code: leftCode,
                    assetPath: leftIcon,
                    onTap: onLeftTap,
                    alignRight: false,
                  ),
                ),
                SizedBox(width: swapSize),
                Expanded(
                  child: _CurrencySelector(
                    label: rightLabel,
                    code: rightCode,
                    assetPath: rightIcon,
                    onTap: onRightTap,
                    alignRight: true,
                  ),
                ),
              ],
            ),
          ),

         
          Center(
            child: _SwapButton(size: swapSize, onTap: onSwap),
          ),
        ],
      ),
    );
  }
}

class _HeaderLinePainter extends CustomPainter {
  final Color color;
  final double swapSize;

  _HeaderLinePainter({required this.color, required this.swapSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double centerX = size.width / 2;
    final double gapCenter = swapSize + 12;
    const double edgePadding = 26;

  
    const double gapLabelWidth = 60;
    const double leftGapStart = edgePadding + 6;
    final double leftGapEnd = leftGapStart + gapLabelWidth;
    final double rightGapEnd = size.width - edgePadding - 6;
    final double rightGapStart = rightGapEnd - gapLabelWidth;

    final double y = 0;


    final segments = [
      Offset(edgePadding, y),
      Offset(leftGapStart, y),
      Offset(leftGapEnd, y),
      Offset(centerX - gapCenter / 2, y),
      Offset(centerX + gapCenter / 2, y),
      Offset(rightGapStart, y),
      Offset(rightGapEnd, y),
      Offset(size.width - edgePadding, y),
    ];

    for (var i = 0; i < segments.length - 1; i += 2) {
      canvas.drawLine(segments[i], segments[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HeaderLinePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.swapSize != swapSize;
}

class _CurrencySelector extends StatelessWidget {
  const _CurrencySelector({
    required this.label,
    required this.code,
    required this.assetPath,
    required this.onTap,
    required this.alignRight,
  });

  final String label;
  final String code;
  final String assetPath;
  final VoidCallback onTap;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF7D7D7D),
              letterSpacing: 0.6,
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40),
          child: Row(
            mainAxisAlignment:
                alignRight ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!alignRight)
                _IconCircle(assetPath: assetPath),
              if (!alignRight) const SizedBox(width: 6),
              Text(
                code,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              if (alignRight) const SizedBox(width: 6),
              if (alignRight) _IconCircle(assetPath: assetPath),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Image.asset(
        'assets/images/$assetPath.png',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.error, color: Colors.redAccent),
      ),
    );
  }
}

class _SwapButton extends StatelessWidget {
  const _SwapButton({required this.size, required this.onTap});

  final double size;
  final VoidCallback onTap;

  static const brand = Color(0xFFF7AC09);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: brand,
      shape: const CircleBorder(),
      elevation: 6,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: const Icon(Icons.sync_alt_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
