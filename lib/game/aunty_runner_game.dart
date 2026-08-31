import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';

import '../modules/game/game_controller.dart';
import 'components/aunty.dart';
import 'components/background.dart';
import 'components/coin.dart';
import 'components/ground.dart';
import 'components/obstacle.dart';
import 'components/spawner.dart';
import 'game_config.dart';

/// Phase 1 endless runner. The Flame side owns the simulation; the GetX
/// [GameController] owns score / coins / phase and the Flutter HUD reads from it.
class AuntyRunnerGame extends FlameGame
    with HasCollisionDetection, TapCallbacks {
  AuntyRunnerGame(this.controller);

  final GameController controller;
  final random = Random();

  late final Aunty aunty;
  late final Spawner _spawner;

  double speed = GameConfig.startSpeed;
  double runTime = 0;

  bool get isRunning => controller.phase.value == GamePhase.running;

  /// Feet baseline shared by the runner and every ground obstacle.
  double get groundY => size.y * GameConfig.groundLineFraction;

  @override
  Future<void> onLoad() async {
    add(Background());
    add(Ground());
    add(_spawner = Spawner());
    add(aunty = Aunty());
  }

  /// Called by the controller when a fresh run begins.
  void startRun() {
    children.whereType<Obstacle>().forEach((o) => o.removeFromParent());
    children.whereType<Coin>().forEach((c) => c.removeFromParent());
    speed = GameConfig.startSpeed;
    runTime = 0;
    aunty.reset();
    _spawner.reset();
    resumeEngine();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isRunning) return;

    runTime += dt;
    speed = min(
      GameConfig.maxSpeed,
      GameConfig.startSpeed + runTime * GameConfig.speedRampPerSecond,
    );

    final rate = GameConfig.scorePerSecondAtStartSpeed *
        (speed / GameConfig.startSpeed);
    controller.addScore(rate * dt);
  }

  void onPlayerHit() {
    if (controller.phase.value != GamePhase.running) return;
    controller.gameOver();
  }

  void onCoinCollected() => controller.addCoin();

  @override
  void onTapDown(TapDownEvent event) {
    switch (controller.phase.value) {
      case GamePhase.ready:
        controller.startGame();
      case GamePhase.running:
        aunty.jump();
      case GamePhase.paused:
      case GamePhase.gameOver:
        break;
    }
  }
}
