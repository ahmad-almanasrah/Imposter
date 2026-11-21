import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/theme_controller.dart';
import '../../models/game_config.dart';

/// Clean, minimal game screen with results reveal and next round action
class GameScreen extends StatefulWidget {
  final GameConfig config;

  const GameScreen({
    super.key,
    required this.config,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _showResults = false;

  List<int> get _imposterPlayerNumbers {
    final list = <int>[];
    for (int i = 0; i < widget.config.roles.length; i++) {
      if (widget.config.roles[i]) {
        list.add(i + 1);
      }
    }
    return list;
  }

  void _startNextRound() {
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.cardReveal,
      arguments: {
        'playerCount': widget.config.playerCount,
        'imposterCount': widget.config.imposterCount,
      },
    );
  }

  void _changeSettings() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.playerSetup,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = appThemeController.isDarkMode(context);

    final imposterListText = _imposterPlayerNumbers.length == 1
        ? 'لاعب ${_imposterPlayerNumbers.first}'
        : _imposterPlayerNumbers.map((n) => 'لاعب $n').join(' و ');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: isDark ? 'Light Theme' : 'Dark Theme',
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? colorScheme.secondary : colorScheme.onPrimary,
            ),
            onPressed: () => appThemeController.toggleTheme(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // Title & Subtitle
              Text(
                AppStrings.gameTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.gameSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Game Info Chips
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chip(
                    avatar: const Icon(Icons.group_rounded, size: 16),
                    label: Text('${widget.config.playerCount} لاعبين'),
                  ),
                  const SizedBox(width: 10),
                  Chip(
                    avatar: const Icon(Icons.masks_rounded, size: 16),
                    label: Text('${widget.config.imposterCount} محتال'),
                    backgroundColor: colorScheme.primaryContainer.withAlpha(120),
                  ),
                ],
              ),

              const Spacer(flex: 1),

              // Reveal / Hide Results Button
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _showResults = !_showResults;
                  });
                },
                icon: Icon(
                  _showResults ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  size: 18,
                ),
                label: Text(
                  _showResults ? AppStrings.hideResults : AppStrings.revealResults,
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),

              // Results Container
              if (_showResults) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: colorScheme.outline.withAlpha(60)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppStrings.theSecretWordWas,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.config.secretWord,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.primary,
                        ),
                      ),
                      const Divider(height: 20),
                      Text(
                        AppStrings.theImpostersWere,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        imposterListText,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(flex: 2),

              // Primary Action: NEXT ROUND
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _startNextRound,
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text(
                    AppStrings.nextRound,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Secondary Action: CHANGE PLAYERS
              TextButton(
                onPressed: _changeSettings,
                child: const Text(AppStrings.changeSettings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
