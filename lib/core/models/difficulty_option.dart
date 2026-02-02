/// Display model for a difficulty level (1-3): label and description for the UI.
class DifficultyOption {
  const DifficultyOption({
    required this.level,
    required this.label,
    required this.description,
  });

  /// Numeric level passed to game logic (1 = easy, 2 = medium, 3 = hard).
  final int level;

  /// Short label shown on chips (e.g. "Easy", "Medium", "Hard").
  final String label;

  /// Short description shown below the difficulty selector.
  final String description;

  /// All difficulty options in order (1, 2, 3).
  static const List<DifficultyOption> all = [
    DifficultyOption(
      level: 1,
      label: 'Easy',
      description: 'Bot plays random moves.',
    ),
    DifficultyOption(
      level: 2,
      label: 'Medium',
      description: 'Blocks your wins and tries to win when possible.',
    ),
    DifficultyOption(
      level: 3,
      label: 'Hard',
      description: 'Optimal play; very hard to beat.',
    ),
  ];

  /// Returns the option for the given [level], or the first option if not found.
  static DifficultyOption forLevel(int level) {
    return all.firstWhere((o) => o.level == level, orElse: () => all.first);
  }
}
