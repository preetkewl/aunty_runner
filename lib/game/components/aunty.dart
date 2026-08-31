import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../aunty_runner_game.dart';
import '../game_config.dart';
import 'coin.dart';
import 'obstacle.dart';

/// The runner. Placeholder vector art (design ships an 8-frame sprite later);
/// anchor is the feet centre, matching the design's pink crosshair.
class Aunty extends PositionComponent
    with HasGameReference<AuntyRunnerGame>, CollisionCallbacks {
  Aunty() : super(anchor: Anchor.bottomCenter);

  double _vy = 0;
  bool _onGround = true;
  double _timeSinceGround = 0;
  double _runPhase = 0;
  bool alive = true;

  double get _baselineY => game.size.y * GameConfig.groundLineFraction;

  @override
  Future<void> onLoad() async {
    size = Vector2(GameConfig.playerWidth, GameConfig.playerHeight);
    position = Vector2(
      game.size.x * GameConfig.playerXFraction,
      _baselineY,
    );
    // Hitbox is tighter than the art box (design: 52x126 inside 104x150).
    add(
      RectangleHitbox(
        size: Vector2(size.x * 0.5, size.y * 0.86),
        position: Vector2(size.x * 0.25, size.y * 0.12),
      ),
    );
  }

  void reset() {
    _vy = 0;
    _onGround = true;
    _timeSinceGround = 0;
    _runPhase = 0;
    alive = true;
    position = Vector2(game.size.x * GameConfig.playerXFraction, _baselineY);
  }

  void jump() {
    if (!alive) return;
    final canJump = _onGround || _timeSinceGround < GameConfig.coyoteTime;
    if (!canJump) return;
    _vy = GameConfig.jumpVelocity;
    _onGround = false;
    _timeSinceGround = GameConfig.coyoteTime;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isRunning) return;

    if (_onGround) {
      _runPhase += dt * (6 + game.speed / 120);
    } else {
      _vy += GameConfig.gravity * dt;
      position.y += _vy * dt;
      _timeSinceGround += dt;
      if (position.y >= _baselineY) {
        position.y = _baselineY;
        _vy = 0;
        _onGround = true;
        _timeSinceGround = 0;
      }
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (!alive) return;
    if (other is Obstacle) {
      alive = false;
      game.onPlayerHit();
    } else if (other is Coin) {
      other.collect();
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final bob = _onGround ? sin(_runPhase * 2) * 3 : 0.0;
    canvas.translate(0, bob);

    final ink = Paint()..color = AppColors.ink;
    final saree = Paint()..color = AppColors.secondary;
    final blouse = Paint()..color = AppColors.primary;
    final skin = Paint()..color = const Color(0xFFE8B98C);
    final hair = Paint()..color = AppColors.ink;

    // shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w / 2, h - 2), width: w * 0.8, height: 10),
      Paint()..color = Colors.black.withValues(alpha: 0.25),
    );

    final swing = _onGround ? sin(_runPhase) * 10 : 6.0;

    // back leg
    _leg(canvas, w / 2 - 6, h - 34, -swing, ink);
    // front leg
    _leg(canvas, w / 2 + 4, h - 34, swing, Paint()..color = const Color(0xFF0F8B80));

    // saree drape (torso -> knees)
    final drape = Path()
      ..moveTo(w / 2 - 20, h * 0.32)
      ..lineTo(w / 2 + 20, h * 0.32)
      ..lineTo(w / 2 + 26, h - 30)
      ..lineTo(w / 2 - 26, h - 30)
      ..close();
    canvas.drawPath(drape, saree);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w / 2 - 18, h * 0.22, 36, h * 0.16),
        const Radius.circular(8),
      ),
      blouse,
    );

    // back arm
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w / 2 - 24, h * 0.24, 10, 34),
        const Radius.circular(5),
      ),
      Paint()..color = AppColors.primary.withValues(alpha: 0.8),
    );
    // front arm (pumping)
    canvas.save();
    canvas.translate(w / 2 + 16, h * 0.26);
    canvas.rotate(swing * 0.05);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-5, 0, 10, 34),
        const Radius.circular(5),
      ),
      blouse,
    );
    canvas.restore();

    // head + bun + face
    final headC = Offset(w / 2, h * 0.16);
    canvas.drawCircle(headC + const Offset(7, -8), 8, hair); // bun
    canvas.drawCircle(headC, 13, skin);
    canvas.drawArc(
      Rect.fromCircle(center: headC, radius: 13),
      -pi, pi, false,
      Paint()
        ..color = AppColors.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    // bindi
    canvas.drawCircle(headC + const Offset(0, -1), 2, Paint()..color = AppColors.primary);
  }

  void _leg(Canvas canvas, double x, double y, double angle, Paint paint) {
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle * pi / 180);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-5, 0, 10, 32),
        const Radius.circular(5),
      ),
      paint,
    );
    canvas.restore();
  }
}
