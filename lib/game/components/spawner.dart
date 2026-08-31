import 'package:flame/components.dart';

import '../aunty_runner_game.dart';
import '../game_config.dart';
import 'coin.dart';
import 'obstacle.dart';

/// Drives the endless stream. Keeps a fair minimum gap by measuring the pause
/// in screen-widths of clear road rather than seconds.
class Spawner extends Component with HasGameReference<AuntyRunnerGame> {
  double _distanceToNext = 0;

  void reset() {
    _distanceToNext = game.size.x * 0.6;
  }

  @override
  void update(double dt) {
    if (!game.isRunning) return;
    _distanceToNext -= game.speed * dt;
    if (_distanceToNext <= 0) {
      _spawn();
      final screens = GameConfig.minGapScreens +
          game.random.nextDouble() *
              (GameConfig.maxGapScreens - GameConfig.minGapScreens);
      _distanceToNext = game.size.x * screens;
    }
  }

  void _spawn() {
    if (game.random.nextDouble() < GameConfig.coinRunChance) {
      _spawnCoinRun();
    } else {
      final type = ObstacleType
          .values[game.random.nextInt(ObstacleType.values.length)];
      game.add(Obstacle(type));
    }
  }

  void _spawnCoinRun() {
    final count = 3 + game.random.nextInt(3);
    final arc = game.random.nextBool();
    final startX = game.size.x + 40;
    final baseY = game.groundY - 70;
    for (int i = 0; i < count; i++) {
      final coin = Coin();
      final lift = arc ? _arcLift(i, count) : 0.0;
      coin.position = Vector2(startX + i * 42.0, baseY - lift);
      game.add(coin);
    }
  }

  double _arcLift(int i, int count) {
    final t = count == 1 ? 0.0 : i / (count - 1);
    // simple parabola peaking mid-run
    return 90 * (1 - (2 * t - 1) * (2 * t - 1));
  }
}
