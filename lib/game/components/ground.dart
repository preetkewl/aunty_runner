import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../aunty_runner_game.dart';

/// The street: sidewalk band + kerb + asphalt, with lane dashes scrolling at
/// full world speed (1.0x layer from the design board).
class Ground extends PositionComponent with HasGameReference<AuntyRunnerGame> {
  Ground() : super(priority: -10);

  double _scroll = 0;

  /// Top edge of the road strip in screen coordinates.
  double get roadTop => game.size.y * 0.72;

  @override
  Future<void> onLoad() async {
    size = game.size;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void update(double dt) {
    if (!game.isRunning) return;
    _scroll += game.speed * dt;
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final top = roadTop;
    final h = size.y - top;

    // sidewalk
    canvas.drawRect(
      Rect.fromLTWH(0, top, w, 18),
      Paint()..color = AppColors.sidewalk,
    );
    // kerb
    canvas.drawRect(
      Rect.fromLTWH(0, top + 18, w, 10),
      Paint()..color = AppColors.roadKerb,
    );
    // asphalt
    canvas.drawRect(
      Rect.fromLTWH(0, top + 28, w, h - 28),
      Paint()..color = AppColors.roadAsphalt,
    );

    // centre lane dashes
    const dash = 46.0;
    const stride = 94.0;
    final y = top + 28 + (h - 28) * 0.42;
    final paint = Paint()..color = AppColors.roadLine;
    double x = -(_scroll % stride);
    for (; x < w; x += stride) {
      canvas.drawRect(Rect.fromLTWH(x, y, dash, 6), paint);
    }
  }
}
