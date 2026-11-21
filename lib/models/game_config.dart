import 'dart:math';
import '../core/constants/arabic_words.dart';

/// Represents the full configuration for a game session, including randomly
/// assigned roles for each player and the secret Arabic word.
class GameConfig {
  final int playerCount;
  final int imposterCount;

  /// Shuffled role list: index = player number (0-based), value = true if imposter.
  final List<bool> roles;

  /// Secret Arabic item/object word drawn randomly for this round.
  final String secretWord;

  const GameConfig({
    required this.playerCount,
    required this.imposterCount,
    required this.roles,
    required this.secretWord,
  });

  /// Generates a [GameConfig] by randomly assigning [imposterCount] imposters
  /// among [playerCount] players and selecting a random secret word from the 500-word bank.
  factory GameConfig.generate({
    required int playerCount,
    required int imposterCount,
    String? secretWord,
  }) {
    // Build ordered list then shuffle with secure randomness
    final roles = [
      ...List.filled(imposterCount, true),
      ...List.filled(playerCount - imposterCount, false),
    ]..shuffle(Random.secure());

    // Pull a random Arabic word from the 500-word bank if not specified
    final chosenWord = secretWord ??
        ArabicWords.items[Random.secure().nextInt(ArabicWords.items.length)];

    return GameConfig(
      playerCount: playerCount,
      imposterCount: imposterCount,
      roles: roles,
      secretWord: chosenWord,
    );
  }

  bool isImposter(int playerIndex) => roles[playerIndex];
}
