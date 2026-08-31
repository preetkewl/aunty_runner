import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../game/aunty_runner_game.dart';

enum GamePhase { ready, running, paused, gameOver }

class GameController extends GetxController {
  final phase = GamePhase.ready.obs;
  final score = 0.0.obs;
  final coins = 0.obs;
  final best = 0.obs;

  late final AuntyRunnerGame game;

  final GetStorage _box = GetStorage();
  static const _bestKey = 'best_score';

  int get scoreInt => score.value.floor();
  bool get isNewBest => phase.value == GamePhase.gameOver && scoreInt >= best.value && scoreInt > 0;

  @override
  void onInit() {
    super.onInit();
    best.value = _box.read<int>(_bestKey) ?? 0;
    game = AuntyRunnerGame(this);
  }

  void startGame() {
    score.value = 0;
    coins.value = 0;
    phase.value = GamePhase.running;
    game.startRun();
  }

  void addScore(double delta) => score.value += delta;

  void addCoin() => coins.value += 1;

  void togglePause() {
    if (phase.value == GamePhase.running) {
      phase.value = GamePhase.paused;
      game.pauseEngine();
    } else if (phase.value == GamePhase.paused) {
      phase.value = GamePhase.running;
      game.resumeEngine();
    }
  }

  void gameOver() {
    if (phase.value == GamePhase.gameOver) return;
    if (scoreInt > best.value) {
      best.value = scoreInt;
      _box.write(_bestKey, best.value);
    }
    phase.value = GamePhase.gameOver;
    game.pauseEngine();
  }

  void retry() => startGame();
}
