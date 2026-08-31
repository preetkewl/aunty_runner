/// Every gameplay tunable in one place. Phase 1 keeps it deliberately small.
class GameConfig {
  GameConfig._();

  // World scroll speed (logical px / second).
  static const double startSpeed = 300;
  static const double maxSpeed = 620;
  static const double speedRampPerSecond = 6; // startSpeed -> maxSpeed in ~53s

  // Player jump.
  static const double gravity = 2600;
  static const double jumpVelocity = -1020; // negative = up
  static const double coyoteTime = 0.08;

  // Where the runner's feet sit, as a fraction of screen height.
  static const double groundLineFraction = 0.84;

  // Player fixed horizontal position, as a fraction of screen width.
  static const double playerXFraction = 0.18;

  // Player sprite box (design: 104 x 150 at 1x).
  static const double playerWidth = 84;
  static const double playerHeight = 122;

  // Spawn pacing. Gap is measured in screen-widths of clear road, so the
  // rhythm stays fair as the speed climbs.
  static const double minGapScreens = 0.62;
  static const double maxGapScreens = 1.15;
  static const double coinRunChance = 0.34;

  // Scoring.
  static const double scorePerSecondAtStartSpeed = 12;
}
