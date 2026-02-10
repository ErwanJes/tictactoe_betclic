# Architecture

Clean Architecture with three layers. Dependencies point **inward**: presentation and data depend on domain; domain depends on nothing.

```
┌─────────────────────────────────────────────────────────┐
│  PRESENTATION  – Screens, widgets, GameNotifier, router │
│  Depends on: domain, core, Riverpod, Flutter            │
└────────────────────────────┬────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────┐
│  DOMAIN  – Entities, repository interfaces, use cases   │
│  Depends on: nothing (pure Dart)                        │
└────────────────────────────┬────────────────────────────┘
                             ▲
                             │
┌────────────────────────────┴────────────────────────────┐
│  DATA  – GameRepositoryImpl, AI strategies               │
│  Depends on: domain only                                 │
└──────────────────────────────────────────────────────────┘
```

- **Domain**: what the app does (rules, entities, contracts). Use cases live in `domain/use_cases/`.
- **Data**: how it’s done (repository implementation, AI). Implements domain interfaces.
- **Presentation**: UI and flow; uses domain via notifier and use cases.

**Core** (`lib/core/`): theme, router, shared models (e.g. `DifficultyOption`, `EndGamePayload`). Used by presentation; no business logic.

---

## Layers

### Domain (`lib/domain/`)

- **Entities**: `Player`, `GameState`, `GameResult`, `GameStatus`. Board = 9 cells, index 0 = top-left, row-major.
- **Repository interfaces**: `GameRepository` (getState, startNewGame, applyMove), `AiStrategy` (getMove).
- **Use cases**: `CheckGameOverUseCase`, `StartGameUseCase`, `PlayTurnUseCase`, `GetBotMoveUseCase`. They call repository/strategy; no Flutter.

### Data (`lib/data/`)

- **GameRepositoryImpl**: in-memory state; uses `CheckGameOverUseCase` for win/draw.
- **AI strategies**: `RandomAiStrategy` (1), `BlockWinAiStrategy` (2), `MinimaxAiStrategy` (3). Each implements `AiStrategy`.

### Dependency injection (`lib/injection.dart`)

Riverpod providers wire use cases to implementations. Use **`ref.watch`** for dependencies so providers rebuild when their dependencies change.

| Provider | Role |
|----------|------|
| `checkGameOverUseCaseProvider` | Singleton. |
| `gameRepositoryProvider` | `GameRepositoryImpl(checkGameOver)`. |
| `aiStrategyProvider(difficulty)` | Random / BlockWin / Minimax by 1/2/3. |
| `getBotMoveUseCaseProvider(difficulty)` | `GetBotMoveUseCase(aiStrategy(difficulty))`. |
| `startGameUseCaseProvider` | `StartGameUseCase(repo)`. |
| `playTurnUseCaseProvider` | `PlayTurnUseCase(repo)`. |

**Consumer**: only `GameNotifier` reads these; screens use `gameNotifierProvider`.

### Presentation (`lib/presentation/`)

- **GameNotifier**: holds `GameNotifierState` (gameState, isBotThinking). Methods: `startGame(level)`, `playAt(index)`, `playAgain()`. Calls use cases via `ref.read(...)`; schedules bot move with `Future.delayed` (400 ms).
- **Routing** (GoRouter): `/` welcome, `/game` (extra: `DifficultyOption?`), `/end` (extra: `EndGamePayload?`). One action to start or restart: push/go to `/game` with difficulty; game screen starts the game when it has difficulty and no active game (or game over).
- **Screens**: Welcome (difficulty chips, Play → push game with `DifficultyOption`). Game (grid, turn label, starts/restarts from route). End (result + difficulty from payload; “Play again” → go to game with same difficulty).
- **Widgets**: `GameCell`, `AppPrimaryButton`.

---

## Data flow (summary)

1. **Start / restart**: Navigate to `/game` with `DifficultyOption` → Game screen calls `startGame(difficulty.level)` → `StartGameUseCase` → repository → notifier state updated.
2. **Human move**: Tap cell → `playAt(index)` → `PlayTurnUseCase` → repository → state updated; if O’s turn, bot move scheduled after delay.
3. **Bot move**: `GetBotMoveUseCase(difficulty)` → strategy → index; `PlayTurnUseCase(index)` → state updated.
4. **Game over**: Listener in game screen pushes `/end` with `EndGamePayload(result, difficulty)`. “Play again” goes to `/game` with same difficulty (game screen starts a new game).

---

## Conventions

- **Board**: flat list of 9 cells; index `i` → row `i ~/ 3`, col `i % 3`. Win lines: rows [0,1,2], [3,4,5], [6,7,8]; cols [0,3,6], [1,4,7], [2,5,8]; diagonals [0,4,8], [2,4,6].
- **Design**: `lib/core/theme/` (colors, spacing, theme). Widgets use theme and `AppColors` / `AppSpacing`.
- **Human = X**, **bot = O**.
