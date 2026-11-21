import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/theme_controller.dart';
import '../../widgets/custom_button.dart';

/// Screen asking how many imposters, with a hard cap of 40% of player count
class ImposterSetupScreen extends StatefulWidget {
  final int playerCount;

  const ImposterSetupScreen({super.key, required this.playerCount});

  @override
  State<ImposterSetupScreen> createState() => _ImposterSetupScreenState();
}

class _ImposterSetupScreenState extends State<ImposterSetupScreen> {
  late int _imposterCount;

  /// Hard maximum: floor(playerCount × 40%), always at least 1
  int get _maxImposters =>
      (widget.playerCount * 0.40).floor().clamp(1, widget.playerCount - 1);

  /// Preferred default: floor(playerCount × 30%), clamped to valid range
  int get _defaultImposters =>
      (widget.playerCount * 0.30).floor().clamp(1, _maxImposters);

  @override
  void initState() {
    super.initState();
    _imposterCount = _defaultImposters;
  }

  void _increment() {
    if (_imposterCount < _maxImposters) {
      setState(() => _imposterCount++);
    }
  }

  void _decrement() {
    if (_imposterCount > 1) {
      setState(() => _imposterCount--);
    }
  }

  void _setImposterCount(int count) {
    setState(() => _imposterCount = count);
  }

  String _buildSubtitle() {
    return AppStrings.imposterSetupSubtitle
        .replaceAll('{max}', '$_maxImposters')
        .replaceAll('{count}', '${widget.playerCount}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = appThemeController.isDarkMode(context);

    // Dynamic chips: 1 through _maxImposters
    final chips = List.generate(_maxImposters, (i) => i + 1);

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
                AppStrings.howManyImposters,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _buildSubtitle(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Stepper Card
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
                    // Decrement
                    IconButton.filledTonal(
                      onPressed: _imposterCount > 1 ? _decrement : null,
                      icon: const Icon(Icons.remove_rounded, size: 28),
                      style: IconButton.styleFrom(padding: const EdgeInsets.all(16)),
                    ),
                    const SizedBox(width: 32),

                    // Count Display
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$_imposterCount',
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          AppStrings.impostersLabel.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),

                    // Increment
                    IconButton.filledTonal(
                      onPressed: _imposterCount < _maxImposters ? _increment : null,
                      icon: const Icon(Icons.add_rounded, size: 28),
                      style: IconButton.styleFrom(padding: const EdgeInsets.all(16)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Quick-select chips (1 … maxImposters)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: chips.map((count) {
                  final isSelected = _imposterCount == count;
                  return ChoiceChip(
                    label: Text('$count'),
                    selected: isSelected,
                    onSelected: (_) => _setImposterCount(count),
                    selectedColor: colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? colorScheme.onPrimaryContainer
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
                    Navigator.of(context).pushReplacementNamed(
                      AppRoutes.cardReveal,
                      arguments: {
                        'playerCount': widget.playerCount,
                        'imposterCount': _imposterCount,
                      },
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
