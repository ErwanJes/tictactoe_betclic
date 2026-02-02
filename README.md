# Tic Tac Toe

A Flutter Tic Tac Toe game for iOS and Android. Play against an AI with three difficulty levels (1–3).

## Tech stack

- **Flutter** – cross-platform UI
- **Riverpod** – state management and dependency injection
- **Clean Architecture** – domain, data, presentation layers with SOLID principles
- **go_router** – declarative routing
- **flutter_animate** – UI animations

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel, SDK ^3.10.8)

## Getting started

```bash
flutter pub get
flutter run
```

Run on a specific device:

```bash
flutter devices
flutter run -d <device_id>
```

## Project structure

```
lib/
├── main.dart              # App entry, ProviderScope
├── app.dart               # MaterialApp.router, theme
├── injection.dart         # Riverpod providers (repos, use cases, AI)
├── core/
│   ├── theme/             # Design system (colors, spacing, theme)
│   └── router/            # GoRouter config
├── domain/
│   ├── entities/         # Player, GameState, GameResult, GameStatus
│   ├── repositories/     # GameRepository, AiStrategy (interfaces)
│   └── use_cases/        # StartGame, PlayTurn, GetBotMove, CheckGameOver
├── data/
│   ├── repositories/     # GameRepositoryImpl (in-memory)
│   └── ai/               # RandomAiStrategy, BlockWinAiStrategy, MinimaxAiStrategy
└── presentation/
    ├── screens/          # Welcome, Game, EndGame
    ├── widgets/          # AppPrimaryButton, GameCell
    └── providers/        # GameNotifier
```

## Game flow

1. **Welcome** – Choose difficulty (1–3) and tap *Play*.
2. **Game** – You play as X, bot as O. Tap an empty cell to move; bot responds automatically.
3. **End game** – Win, lose, or draw. Tap *Play again* to return to the welcome screen.

## Difficulty levels

- **1** – Random empty cell (easy).
- **2** – Blocks your win and tries to win when possible; otherwise random (medium).
- **3** – Minimax (optimal play, hard).

## Building for release

```bash
# Android
flutter build apk --release
# or
flutter build appbundle --release

# iOS
flutter build ios --release
```

## Testing

```bash
flutter test
```

Unit tests cover domain use cases and AI strategies. Widget tests cover the welcome and game screens.
