import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../aunty_runner_game.dart';

/// Gold ₹ coin. Pulses while idle, pops on pickup.
class Coin extends PositionComponent with HasGameReference<AuntyRunnerGame> {
  Coin() : super(anchor: Anchor.center, size: Vector2.all(30));

  double _t = 0;
  bool _collected = false;
  double _pop = 0;

  @override
  Future<void> onLoad() async {
    _t = game.random.nextDouble() * pi;
    add(CircleHitbox(radius: size.x * 0.5));
  }

  void collect() {
    if (_collected) return;
    _collected = true;
    game.onCoinCollected();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isRunning) {
      position.x -= game.speed * dt;
    }
    _t += dt;
    if (_collected) {
      _pop += dt * 6;
      scale = Vector2.all(1 + _pop);
      // fade handled in render via opacity
      if (_pop >= 1) removeFromParent();
    }
    if (position.x < -60) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final pulse = _collected ? 1.0 : 1 + sin(_t * 6) * 0.06;
    final r = size.x * 0.5 * pulse;
    final c = Offset(size.x / 2, size.y / 2);
    final alpha = _collected ? (1 - _pop).clamp(0.0, 1.0) : 1.0;

    canvas.drawCircle(c, r, Paint()..color = const Color(0xFFE0972A).withValues(alpha: alpha));
    canvas.drawCircle(
      c.translate(0, -1.5),
      r * 0.92,
      Paint()..color = AppColors.accent.withValues(alpha: alpha),
    );
    canvas.drawCircle(
      c.translate(0, -1.5),
      r * 0.62,
      Paint()
        ..color = const Color(0xFFE0972A).withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
    // rupee tick
    final tick = Paint()
      ..color = const Color(0xFF8E5A10).withValues(alpha: alpha)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(c.translate(-4, -6), c.translate(4, -6), tick);
    canvas.drawLine(c.translate(-4, -1), c.translate(4, -1), tick);
    canvas.drawLine(c.translate(2, -6), c.translate(-2, 7), tick);
  }
}
