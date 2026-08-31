import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../app/app_text.dart';

/// Design board 1c: hard bottom shadow, no gradient, no bevel.
/// Press = translateY to the shadow depth, 70 ms.
class PillButton extends StatefulWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.primary,
    this.shadowColor = AppColors.primaryShadow,
    this.textColor = AppColors.textPrimary,
    this.minHeight = 56,
    this.expand = false,
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color shadowColor;
  final Color textColor;
  final double minHeight;
  final bool expand;

  @override
  State<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<PillButton> {
  static const _depth = 5.0;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) {
        setState(() => _down = false);
        widget.onPressed();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _down ? _depth : 0, 0),
        constraints: BoxConstraints(minHeight: widget.minHeight),
        width: widget.expand ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 12),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: _down
              ? null
              : [
                  BoxShadow(
                    color: widget.shadowColor,
                    offset: const Offset(0, _depth),
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: Text(
          widget.label,
          textAlign: TextAlign.center,
          style: AppText.button(color: widget.textColor),
        ),
      ),
    );
  }
}
