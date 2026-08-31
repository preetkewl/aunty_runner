import 'package:flutter/material.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_text.dart';

String formatScore(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}

/// Gold rupee coin drawn from primitives — matches the in-world coin.
class RupeeCoin extends StatelessWidget {
  const RupeeCoin({super.key, this.size = 22});
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _CoinPainter());
  }
}

class _CoinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFFE0972A));
    canvas.drawCircle(c.translate(0, -1), r * 0.92, Paint()..color = AppColors.accent);
    final tick = Paint()
      ..color = const Color(0xFF8E5A10)
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(c.translate(-r * 0.35, -r * 0.4), c.translate(r * 0.35, -r * 0.4), tick);
    canvas.drawLine(c.translate(-r * 0.35, -r * 0.05), c.translate(r * 0.35, -r * 0.05), tick);
    canvas.drawLine(c.translate(r * 0.2, -r * 0.4), c.translate(-r * 0.15, r * 0.5), tick);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CoinPill extends StatelessWidget {
  const CoinPill({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.fromLTRB(8, 0, 14, 0),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.45),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const RupeeCoin(size: 22),
          const SizedBox(width: 7),
          Text(
            '$count',
            style: AppText.button(size: 17, color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}
