import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../aunty_runner_game.dart';

enum ObstacleType { auto, dog, pothole, bin }

/// One component for every obstacle; [type] switches the art and hitbox.
/// Danger reads as a warm saturated body — nothing collectible is red-orange.
class Obstacle extends PositionComponent with HasGameReference<AuntyRunnerGame> {
  Obstacle(this.type) : super(anchor: Anchor.bottomCenter);

  final ObstacleType type;

  @override
  Future<void> onLoad() async {
    size = switch (type) {
      ObstacleType.auto => Vector2(112, 84),
      ObstacleType.dog => Vector2(84, 56),
      ObstacleType.pothole => Vector2(96, 22),
      ObstacleType.bin => Vector2(52, 62),
    };
    position = Vector2(game.size.x + size.x, game.groundY);

    final inset = switch (type) {
      ObstacleType.pothole => Vector2(size.x * 0.1, 2),
      _ => Vector2(size.x * 0.12, size.y * 0.14),
    };
    add(
      RectangleHitbox(
        size: Vector2(size.x - inset.x * 2, size.y - inset.y * 2),
        position: inset,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isRunning) {
      position.x -= game.speed * dt;
    }
    if (position.x < -size.x * 2) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    switch (type) {
      case ObstacleType.auto:
        _renderAuto(canvas);
      case ObstacleType.dog:
        _renderDog(canvas);
      case ObstacleType.pothole:
        _renderPothole(canvas);
      case ObstacleType.bin:
        _renderBin(canvas);
    }
  }

  void _shadow(Canvas canvas, double rx) {
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y - 2),
        width: rx * 2,
        height: 10,
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.28),
    );
  }

  void _renderAuto(Canvas canvas) {
    _shadow(canvas, size.x * 0.46);
    final body = Paint()..color = const Color(0xFFFFD23F);
    final roof = Path()
      ..moveTo(6, size.y * 0.5)
      ..quadraticBezierTo(size.x * 0.28, 6, size.x * 0.6, 10)
      ..lineTo(size.x * 0.72, size.y * 0.36)
      ..lineTo(6, size.y * 0.44)
      ..close();
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(4, size.y * 0.28, size.x - 8, size.y * 0.42),
        const Radius.circular(6),
      ),
      body,
    );
    canvas.drawPath(roof, Paint()..color = AppColors.ink);
    canvas.drawRect(
      Rect.fromLTWH(4, size.y * 0.62, size.x - 8, 6),
      Paint()..color = AppColors.secondary,
    );
    for (final cx in [size.x * 0.28, size.x * 0.8]) {
      canvas.drawCircle(Offset(cx, size.y - 8), 12, Paint()..color = const Color(0xFF221A2E));
      canvas.drawCircle(Offset(cx, size.y - 8), 4, Paint()..color = AppColors.sidewalk);
    }
  }

  void _renderDog(Canvas canvas) {
    _shadow(canvas, size.x * 0.42);
    final fur = Paint()..color = const Color(0xFFC98A4B);
    final furDark = Paint()..color = const Color(0xFFB0723A);
    // legs
    for (final lx in [14.0, 30.0, 50.0, 64.0]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(lx, size.y - 18, 7, 16),
          const Radius.circular(3),
        ),
        lx % 2 == 0 ? fur : furDark,
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(8, size.y * 0.34, size.x * 0.72, size.y * 0.42),
        const Radius.circular(14),
      ),
      fur,
    );
    // head
    canvas.drawCircle(Offset(size.x - 16, size.y * 0.4), 14, fur);
    // ear
    final ear = Path()
      ..moveTo(size.x - 24, size.y * 0.22)
      ..lineTo(size.x - 16, size.y * 0.06)
      ..lineTo(size.x - 10, size.y * 0.26)
      ..close();
    canvas.drawPath(ear, furDark);
    // tail
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2, size.y * 0.24, 8, 22),
        const Radius.circular(4),
      ),
      furDark,
    );
    canvas.drawCircle(Offset(size.x - 10, size.y * 0.4), 2.5, Paint()..color = AppColors.ink);
  }

  void _renderPothole(Canvas canvas) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = AppColors.ink,
    );
    canvas.drawArc(
      Rect.fromLTWH(size.x * 0.12, -size.y * 0.4, size.x * 0.76, size.y),
      3.6, 2.1, false,
      Paint()
        ..color = const Color(0xFF5A5366)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  void _renderBin(Canvas canvas) {
    _shadow(canvas, size.x * 0.5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(6, size.y * 0.2, size.x - 12, size.y * 0.8),
        const Radius.circular(4),
      ),
      Paint()..color = AppColors.secondary,
    );
    // ribs
    for (int i = 1; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(6, size.y * 0.2 + i * size.y * 0.24, size.x - 12, 3),
        Paint()..color = const Color(0xFF0F8B80),
      );
    }
    // lid
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.y * 0.06, size.x, size.y * 0.16),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF8B5E34),
    );
  }
}
