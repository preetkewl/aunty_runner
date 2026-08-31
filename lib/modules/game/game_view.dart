import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/app_colors.dart';
import 'game_controller.dart';
import 'widgets/game_panels.dart';
import 'widgets/hud_overlay.dart';

class GameView extends GetView<GameController> {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(child: GameWidget(game: controller.game)),
          Obx(() {
            switch (controller.phase.value) {
              case GamePhase.ready:
                return ReadyPanel(onStart: controller.startGame);
              case GamePhase.running:
                return const HudOverlay();
              case GamePhase.paused:
                return const Stack(
                  children: [HudOverlay(), PausedPanel()],
                );
              case GamePhase.gameOver:
                return const GameOverPanel();
            }
          }),
        ],
      ),
    );
  }
}
