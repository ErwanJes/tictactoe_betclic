import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../providers/game_notifier.dart';
import '../../widgets/app_primary_button.dart';

/// Welcome screen: title, difficulty selection, Play button.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  int _difficulty = 1;

  void _onPlay() {
    ref.read(gameNotifierProvider.notifier).startGame(_difficulty);
    context.goNamed(AppRoutes.game);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tic Tac Toe',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Play against the bot. Choose difficulty and tap Play.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Difficulty',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [1, 2, 3].map((d) {
                  final selected = _difficulty == d;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: ChoiceChip(
                      label: Text('$d'),
                      selected: selected,
                      onSelected: (_) => setState(() => _difficulty = d),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppPrimaryButton(
                label: 'Play',
                onPressed: _onPlay,
                semanticsLabel: 'Start game with difficulty $_difficulty',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
