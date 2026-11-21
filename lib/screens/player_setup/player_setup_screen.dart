import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/theme_controller.dart';
import '../../widgets/custom_button.dart';

/// Screen asking how many players are in the game with top-right theme toggle
class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  static const int _minPlayers = 3;
  static const int _maxPlayers = 16;
  int _playerCount = 4;

  void _increment() {
    if (_playerCount < _maxPlayers) {
      setState(() {
        _playerCount++;
      });
    }
  }

  void _decrement() {
    if (_playerCount > _minPlayers) {
      setState(() {
        _playerCount--;
      });
    }
  }

  void _setPlayerCount(int count) {
    setState(() {
      _playerCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = appThemeController.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // Title & Subtitle
              Text(
                AppStrings.howManyPlayers,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.playerSetupSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Counter Stepper Container
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colorScheme.outline.withAlpha(50),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Decrement Button
                    IconButton.filledTonal(
                      onPressed: _playerCount > _minPlayers ? _decrement : null,
                      icon: const Icon(Icons.remove_rounded, size: 28),
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(width: 32),

                    // Player Count Number Display
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$_playerCount',
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          AppStrings.playersLabel.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),

                    // Increment Button
                    IconButton.filledTonal(
                      onPressed: _playerCount < _maxPlayers ? _increment : null,
                      icon: const Icon(Icons.add_rounded, size: 28),
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Quick Selection Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [3, 4, 5, 6, 7, 8, 10].map((count) {
                  final isSelected = _playerCount == count;
                  return ChoiceChip(
                    label: Text('$count'),
                    selected: isSelected,
                    onSelected: (_) => _setPlayerCount(count),
                    selectedColor: colorScheme.secondaryContainer,
                    labelStyle: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? colorScheme.onSecondaryContainer
                          : colorScheme.onSurface,
                    ),
                  );
                }).toList(),
              ),

              const Spacer(flex: 2),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: CustomButton(
                  text: AppStrings.continueButton,
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.imposterSetup,
                      arguments: {'playerCount': _playerCount},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
