import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/theme_controller.dart';
import '../../models/game_config.dart';

/// Shows each player a flippable card that reveals their secret role.
/// For innocent players: reveals the secret Arabic word.
/// After 4 seconds: card automatically turns back to prevent peeking.
/// If a player forgets, they can tap to re-flip the card again before passing.
class CardRevealScreen extends StatefulWidget {
  final GameConfig config;

  const CardRevealScreen({super.key, required this.config});

  @override
  State<CardRevealScreen> createState() => _CardRevealScreenState();
}

class _CardRevealScreenState extends State<CardRevealScreen>
    with SingleTickerProviderStateMixin {
  int _currentPlayer = 0;
  bool _isFlipped = false;
  bool _hasBeenRevealed = false;
  int _secondsLeft = 4;

  Timer? _autoFlipTimer;
  Timer? _countdownTimer;

  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _autoFlipTimer?.cancel();
    _countdownTimer?.cancel();
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    // Only block if currently face-up. Players can re-flip once it is face-down!
    if (_isFlipped) return;

    setState(() {
      _isFlipped = true;
      _hasBeenRevealed = true;
      _secondsLeft = 4;
    });
    _flipController.forward();

    // 1-second countdown ticker
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft > 1) {
        setState(() => _secondsLeft--);
      } else {
        timer.cancel();
      }
    });

    // Auto-turn the card back after 4 seconds
    _autoFlipTimer?.cancel();
    _autoFlipTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      _countdownTimer?.cancel();
      _flipController.reverse();
      setState(() {
        _isFlipped = false;
      });
    });
  }

  void _nextPlayer() {
    _autoFlipTimer?.cancel();
    _countdownTimer?.cancel();

    if (_currentPlayer >= widget.config.playerCount - 1) {
      // All players have seen their cards — navigate to game screen
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.game,
        arguments: widget.config,
      );
      return;
    }

    // Reset card state for the next player
    _flipController.reset();
    setState(() {
      _currentPlayer++;
      _isFlipped = false;
      _hasBeenRevealed = false;
      _secondsLeft = 4;
    });
  }

  bool get _isImposter => widget.config.isImposter(_currentPlayer);
  bool get _isLastPlayer => _currentPlayer == widget.config.playerCount - 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = appThemeController.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        automaticallyImplyLeading: false, // Prevent back navigation during secret role reveal
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              // Player Indicator
              Text(
                AppStrings.cardRevealPlayerLabel
                    .replaceAll('{n}', '${_currentPlayer + 1}'),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _isFlipped
                    ? AppStrings.cardRevealHidingIn
                        .replaceAll('{s}', '$_secondsLeft')
                    : (_hasBeenRevealed
                        ? AppStrings.cardRevealHiddenNotice
                        : AppStrings.cardRevealTapHint),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _isFlipped ? colorScheme.error : colorScheme.onSurfaceVariant,
                  fontWeight: _isFlipped ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 1),

              // Flippable Card (can be tapped to flip or re-flip when face down)
              GestureDetector(
                onTap: _isFlipped ? null : _flipCard,
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    final angle = _flipAnimation.value * math.pi;
                    final showBack = angle > math.pi / 2;

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      child: showBack
                          ? _buildCardBack(theme, colorScheme)
                          : _buildCardFront(theme, colorScheme),
                    );
                  },
                ),
              ),

              const Spacer(flex: 1),

              // Action button — appears once the card has been revealed at least once
              AnimatedOpacity(
                opacity: _hasBeenRevealed ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: AnimatedSlide(
                  offset: _hasBeenRevealed ? Offset.zero : const Offset(0, 0.3),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton.icon(
                      onPressed: _hasBeenRevealed ? _nextPlayer : null,
                      icon: Icon(
                        _isLastPlayer
                            ? Icons.sports_esports_rounded
                            : Icons.arrow_forward_rounded,
                      ),
                      label: Text(
                        _isLastPlayer
                            ? AppStrings.cardRevealStartGame
                            : AppStrings.cardRevealNextPlayer
                                .replaceAll('{n}', '${_currentPlayer + 2}'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Progress Indicator Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.config.playerCount, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _currentPlayer ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i <= _currentPlayer
                          ? colorScheme.primary
                          : colorScheme.outline.withAlpha(80),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardFront(ThemeData theme, ColorScheme colorScheme) {
    return _CardFace(
      color: colorScheme.surface,
      borderColor: colorScheme.outline.withAlpha(60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _hasBeenRevealed ? Icons.replay_rounded : Icons.person_rounded,
            size: 64,
            color: colorScheme.primary.withAlpha(140),
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.cardRevealPlayerLabel
                .replaceAll('{n}', '${_currentPlayer + 1}'),
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: colorScheme.primary,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withAlpha(90),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _hasBeenRevealed ? Icons.refresh_rounded : Icons.touch_app_rounded,
                  size: 18,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _hasBeenRevealed
                        ? AppStrings.cardRevealReTapHint
                        : AppStrings.cardRevealTapHint,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(ThemeData theme, ColorScheme colorScheme) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(math.pi),
      child: _isImposter
          ? _buildImposterCard(theme, colorScheme)
          : _buildInnocentCard(theme, colorScheme),
    );
  }

  /// Imposter Back Face: warns the player and does NOT show the secret word
  Widget _buildImposterCard(ThemeData theme, ColorScheme colorScheme) {
    return _CardFace(
      color: colorScheme.primaryContainer,
      borderColor: colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Auto-hide Timer Badge
            _buildTimerBadge(colorScheme),
            const Spacer(),
            Icon(Icons.masks_rounded, size: 68, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              AppStrings.roleImposter,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              AppStrings.roleImposterSub,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary.withAlpha(180),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surface.withAlpha(190),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                AppStrings.roleImposterDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  /// Innocent Back Face: reveals the Arabic secret word prominently
  Widget _buildInnocentCard(ThemeData theme, ColorScheme colorScheme) {
    return _CardFace(
      color: colorScheme.secondaryContainer,
      borderColor: colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Auto-hide Timer Badge
            _buildTimerBadge(colorScheme),
            const Spacer(),
            Icon(Icons.shield_rounded, size: 56, color: colorScheme.secondary),
            const SizedBox(height: 6),
            Text(
              AppStrings.roleInnocent,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.secondary,
              ),
            ),
            Text(
              AppStrings.roleInnocentSub,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.secondary.withAlpha(180),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            // Secret Word Focal Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colorScheme.secondary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.secretWordLabel,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.config.secretWord,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Text(
              AppStrings.roleInnocentDescription,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerBadge(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface.withAlpha(220),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 16, color: colorScheme.error),
          const SizedBox(width: 6),
          Text(
            '$_secondsLeft ثواني',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

/// Styled card face wrapper
class _CardFace extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final Widget child;

  const _CardFace({
    required this.color,
    required this.borderColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 420,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
