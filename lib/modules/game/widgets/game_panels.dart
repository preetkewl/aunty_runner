import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_text.dart';
import '../../common/pill_button.dart';
import '../game_controller.dart';
import 'hud_bits.dart';

class ReadyPanel extends StatelessWidget {
  const ReadyPanel({super.key, required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStart,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: AppColors.background.withValues(alpha: 0.35),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('TAP TO RUN', style: AppText.display(size: 34)),
            const SizedBox(height: 10),
            Text(
              'Tap anywhere to jump the auto,\nthe dog, the bin and the potholes.',
              textAlign: TextAlign.center,
              style: AppText.body(size: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class PausedPanel extends GetView<GameController> {
  const PausedPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return _Scrim(
      child: _Card(
        children: [
          Text('PAUSED', style: AppText.display(size: 32)),
          const SizedBox(height: 20),
          PillButton(
            label: 'RESUME',
            expand: true,
            color: AppColors.secondary,
            shadowColor: const Color(0xFF0F8B80),
            onPressed: controller.togglePause,
          ),
          const SizedBox(height: 12),
          PillButton(
            label: 'QUIT',
            expand: true,
            color: AppColors.surfaceRaised,
            shadowColor: AppColors.ink,
            onPressed: () => Get.back<void>(),
          ),
        ],
      ),
    );
  }
}

class GameOverPanel extends GetView<GameController> {
  const GameOverPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return _Scrim(
      child: _Card(
        children: [
          Text('GAME OVER', style: AppText.display(size: 36)),
          const SizedBox(height: 18),
          _StatRow(
            label: 'SCORE',
            value: formatScore(controller.scoreInt),
            highlight: controller.isNewBest,
          ),
          const SizedBox(height: 8),
          _StatRow(label: 'BEST', value: formatScore(controller.best.value)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const RupeeCoin(size: 20),
              const SizedBox(width: 8),
              Text(
                '${controller.coins.value} collected',
                style: AppText.number(size: 15, color: AppColors.accent),
              ),
            ],
          ),
          if (controller.isNewBest) ...[
            const SizedBox(height: 10),
            Text('NEW BEST!', style: AppText.label(size: 12, color: AppColors.success)),
          ],
          const SizedBox(height: 22),
          PillButton(
            label: 'RETRY',
            expand: true,
            onPressed: controller.retry,
          ),
          const SizedBox(height: 12),
          PillButton(
            label: 'HOME',
            expand: true,
            color: AppColors.surfaceRaised,
            shadowColor: AppColors.ink,
            onPressed: () => Get.back<void>(),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value, this.highlight = false});
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppText.label(size: 12)),
        Text(
          value,
          style: AppText.score(
            size: 22,
            color: highlight ? AppColors.success : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _Scrim extends StatelessWidget {
  const _Scrim({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background.withValues(alpha: 0.72),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      child: child,
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
