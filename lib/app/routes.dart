import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/player_setup/player_setup_screen.dart';
import '../screens/imposter_setup/imposter_setup_screen.dart';
import '../screens/card_reveal/card_reveal_screen.dart';
import '../screens/game/game_screen.dart';
import '../models/game_config.dart';

/// Centralized application routes
abstract final class AppRoutes {
  static const String splash = '/';
  static const String playerSetup = '/player-setup';
  static const String imposterSetup = '/imposter-setup';
  static const String cardReveal = '/card-reveal';
  static const String game = '/game';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case playerSetup:
        return MaterialPageRoute<void>(
          builder: (_) => const PlayerSetupScreen(),
          settings: settings,
        );

      case imposterSetup:
        final args = settings.arguments as Map<String, int>;
        return MaterialPageRoute<void>(
          builder: (_) => ImposterSetupScreen(
            playerCount: args['playerCount']!,
          ),
          settings: settings,
        );

      case cardReveal:
        final args = settings.arguments as Map<String, int>;
        final config = GameConfig.generate(
          playerCount: args['playerCount']!,
          imposterCount: args['imposterCount']!,
        );
        return MaterialPageRoute<void>(
          builder: (_) => CardRevealScreen(config: config),
          settings: settings,
        );

      case game:
        final GameConfig config;
        if (settings.arguments is GameConfig) {
          config = settings.arguments as GameConfig;
        } else {
          final args = settings.arguments as Map<String, int>;
          config = GameConfig.generate(
            playerCount: args['playerCount']!,
            imposterCount: args['imposterCount']!,
          );
        }
        return MaterialPageRoute<void>(
          builder: (_) => GameScreen(config: config),
          settings: settings,
        );

      case splash:
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
    }
  }
}
