import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_betclic/core/models/difficulty_option.dart';
import 'package:tictactoe_betclic/core/router/app_router.dart';
import 'package:tictactoe_betclic/core/theme/app_colors.dart';
import 'package:tictactoe_betclic/core/theme/app_spacing.dart';
import 'package:tictactoe_betclic/presentation/widgets/app_primary_button.dart';

/// Welcome screen: title, difficulty selection, Play button.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  DifficultyOption _selectedOption = DifficultyOption.all.first;

  void _onPlay() {
    context.pushNamed(AppRoutes.game, extra: _selectedOption);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TIC TAC TOE',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.onBackground,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Play against the bot. Choose difficulty and tap Play.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onBackgroundSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Difficulty',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.onBackgroundSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: DifficultyOption.all.map((option) {
                  final selected = _selectedOption == option;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: ChoiceChip(
                      label: Text(option.label),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _selectedOption = option),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.sm,
                      ),
                      backgroundColor: AppColors.boardCell,
                      selectedColor: AppColors.cellInnerHighlight,
                      labelStyle: TextStyle(
                        color: selected
                            ? AppColors.onBackground
                            : AppColors.onBackgroundSecondary,
                      ),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _selectedOption.description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppPrimaryButton(
                label: 'Play',
                onPressed: _onPlay,
                semanticsLabel:
                    'Start game with difficulty ${_selectedOption.label}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
