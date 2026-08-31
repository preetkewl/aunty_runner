import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_text.dart';
import '../game_controller.dart';
import 'hud_bits.dart';

/// Flutter overlay on top of the Flame view. Nothing here is drawn in the game
/// world, so it never scales with the camera (design board, HUD rules).
class HudOverlay extends GetView<GameController> {
  const HudOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // score + best (top-left safe area)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      formatScore(controller.scoreInt),
                      style: AppText.score(size: 40).copyWith(
                        shadows: const [
                          Shadow(color: AppColors.surface, offset: Offset(0, 3)),
                          Shadow(color: Color(0x66000000), blurRadius: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.emoji_events_rounded,
                          size: 14, color: AppColors.accent),
                      const SizedBox(width: 6),
                      Obx(
                        () => Text(
                          'BEST ${formatScore(controller.best.value)}',
                          style: AppText.number(
                            size: 14,
                            color: AppColors.textPrimary.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // coin pill + pause (one 44px tap row, pause outermost)
            Row(
              children: [
                Obx(() => CoinPill(count: controller.coins.value)),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: controller.togglePause,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.textPrimary.withValues(alpha: 0.22),
                        width: 1.5,
                      ),
                    ),
                    child: Obx(
                      () => Icon(
                        controller.phase.value == GamePhase.paused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        color: AppColors.textPrimary,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
