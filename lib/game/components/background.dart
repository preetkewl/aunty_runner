import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../aunty_runner_game.dart';

/// Sky + parallax skyline + colony shopfronts. Placeholder vector art built
/// from primitives — silhouette-first, matches the design board's layer stack
/// (far skyline 0.12x, establishments 0.30x).
class Background extends PositionComponent with HasGameReference<AuntyRunnerGame> {
  Background() : super(priority: -20);

  static const _farFactor = 0.12;
  static const _midFactor = 0.30;

  double _far = 0;
  double _mid = 0;

  final _rng = Random(7);
  late final List<_Building> _skyline;
  late final List<_Building> _shops;

  @override
  Future<void> onLoad() async {
    size = game.size;
    _skyline = List.generate(14, (_) => _randomSkyline());
    _shops = List.generate(9, (i) => _randomShop(i));
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void update(double dt) {
    if (!game.isRunning) return;
    _far += game.speed * _farFactor * dt;
    _mid += game.speed * _midFactor * dt;
  }

  _Building _randomSkyline() {
    final h = 70 + _rng.nextDouble() * 150;
    final w = 34 + _rng.nextDouble() * 130;
    return _Building(w, h, AppColors.skylineFar.withValues(alpha: 0.45), false);
  }

  _Building _randomShop(int i) {
    const palette = [
      Color(0xFFE4B24C), // kirana yellow
      Color(0xFF6E7C8C), // gym grey
      Color(0xFFD8C79A), // police sand
      Color(0xFF3F6B6E), // mechanic teal
      Color(0xFFEDE7DC), // hospital cream
      Color(0xFFC8683F), // apartment terracotta
      Color(0xFF8B5E34), // chai tapri brown
    ];
    final h = 150 + _rng.nextDouble() * 150;
    final w = 118 + _rng.nextDouble() * 60;
    return _Building(w, h, palette[i % palette.length], true);
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final groundTop = h * 0.72;

    // --- Sky ---
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.skyTop,
          AppColors.skyMid,
          AppColors.skyWarm,
          AppColors.skyLow,
        ],
        stops: [0.0, 0.34, 0.62, 0.85],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), sky);

    // Sun haze.
    canvas.drawCircle(
      Offset(w * 0.66, h * 0.2),
      54,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xE6FFF0C8), Color(0x00FFDC96)],
        ).createShader(Rect.fromCircle(center: Offset(w * 0.66, h * 0.2), radius: 54)),
    );

    // --- Far skyline (0.12x) ---
    _renderRow(
      canvas,
      buildings: _skyline,
      gap: 20,
      baseline: groundTop - 24,
      scroll: _far,
      opacity: 0.55,
      signs: false,
    );

    // --- Colony shopfronts (0.30x) ---
    _renderRow(
      canvas,
      buildings: _shops,
      gap: 12,
      baseline: groundTop,
      scroll: _mid,
      opacity: 1.0,
      signs: true,
    );
  }

  void _renderRow(
    Canvas canvas, {
    required List<_Building> buildings,
    required double gap,
    required double baseline,
    required double scroll,
    required double opacity,
    required bool signs,
  }) {
    final tileWidth =
        buildings.fold<double>(0, (sum, b) => sum + b.width + gap);
    if (tileWidth <= 0) return;

    double startX = -(scroll % tileWidth);
    for (double ox = startX; ox < size.x + tileWidth; ox += tileWidth) {
      double x = ox;
      for (final b in buildings) {
        final rect = Rect.fromLTWH(x, baseline - b.height, b.width, b.height);
        final body = Paint()..color = b.color.withValues(alpha: opacity);
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            rect,
            topLeft: const Radius.circular(4),
            topRight: const Radius.circular(4),
          ),
          body,
        );
        if (signs && b.hasSign) {
          // sign board
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x + 8, baseline - b.height + 20, b.width - 16, 26),
              const Radius.circular(4),
            ),
            Paint()..color = AppColors.ink.withValues(alpha: opacity),
          );
          // a couple of windows
          for (int r = 0; r < 2; r++) {
            canvas.drawRect(
              Rect.fromLTWH(x + 14, baseline - b.height + 66 + r * 42, b.width - 28, 30),
              Paint()..color = AppColors.ink.withValues(alpha: 0.35 * opacity),
            );
          }
        }
        x += b.width + gap;
      }
    }
  }
}

class _Building {
  _Building(this.width, this.height, this.color, this.hasSign);
  final double width;
  final double height;
  final Color color;
  final bool hasSign;
}
