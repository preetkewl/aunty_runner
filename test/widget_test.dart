import 'package:aunty_runner/game/game_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('speed never exceeds the configured max', () {
    double speedAt(double t) => (GameConfig.startSpeed + t * GameConfig.speedRampPerSecond)
        .clamp(GameConfig.startSpeed, GameConfig.maxSpeed);

    expect(speedAt(0), GameConfig.startSpeed);
    expect(speedAt(10000), GameConfig.maxSpeed);
  });
}
