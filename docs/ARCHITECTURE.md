# Tic Tac Toe – Technical Architecture

This document describes how the Flutter Tic Tac Toe app is structured and how data and control flow through the layers.

---

## 1. Entry point and bootstrap

**File: `lib/main.dart`**

The app entry point must:

1. Call `runApp()` with the root widget.
2. Wrap the app in **`ProviderScope`** (from `package:flutter_riverpod`) so that all Riverpod providers are available.

Expected pattern:

```dart
void main() {
  runApp(const ProviderScope(child: App()));
}
```

**File: `lib/app.dart`**

`App` is a **`ConsumerWidget`** (Riverpod-aware). It builds:

- **`MaterialApp.router`** with:
  - `routerConfig: AppRouter.create()` (GoRouter)
  - `theme: AppTheme.light` (design system)

There is no `home:`; navigation is entirely driven by the router.

---

## 2. Architecture overview (Clean Architecture)

The project follows **Clean Architecture** with three layers. Dependencies point **inward**: presentation → domain ← data. The domain layer has **no** dependency on Flutter or implementation details.

```
┌─────────────────────────────────────────────────────────────────┐
│  PRESENTATION                                                    │
│  Screens, widgets, GameNotifier, router                          │
│  Depends on: domain, Riverpod, Flutter, go_router                │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│  DOMAIN                                                          │
│  Entities, repository interfaces, use cases                      │
│  Depends on: nothing (pure Dart)                                 │
└───────────────────────────┬─────────────────────────────────────┘
                            ▲
                            │
┌───────────────────────────┴─────────────────────────────────────┐
│  DATA                                                            │
│  GameRepositoryImpl, AI strategies (Random, BlockWin, Minimax)   │
│  Depends on: domain only                                         │
└─────────────────────────────────────────────────────────────────┘
```

- **Domain**: defines *what* the app does (entities, contracts, use cases).
- **Data**: implements *how* (repository, AI logic).
- **Presentation**: UI and orchestration; uses domain via use cases and Riverpod.

---

## 3. Domain layer

### 3.1 Entities

**Location: `lib/domain/entities/`**

- **`Player`** (enum): `x` or `o`. Convention: **human = X**, **bot = O**. Has `opposite` getter.

- **`GameResult`** (enum): outcome of a finished game: `humanWin`, `botWin`, `draw`.

- **`GameStatus`** (sealed class):
  - `GameStatusPlaying`: game in progress.
  - `GameStatusOver(GameResult result)`: game finished with a result.

- **`GameState`**: immutable snapshot of the game.
  - `board`: `List<Player?>` of **9 cells**. Index 0 = top-left, 8 = bottom-right; row-major (row 0: 0,1,2; row 1: 3,4,5; row 2: 6,7,8).
  - `currentPlayer`: whose turn (X or O).
  - `status`: `GameStatus` (playing or over).
  - `winningLine`: `List<int>?` – the 3 indices of the winning line when status is win; null for draw or playing.
  - `difficulty`: int 1–3, stored for the current game (used by presentation to choose AI).

### 3.2 Repository interface

**File: `lib/domain/repositories/game_repository.dart`**

Abstract contract for game state and moves:

- **`GameState? getState()`**: current state or null if no game.
- **`GameState startNewGame(int difficulty)`**: reset board, set human = X, bot = O, difficulty; return initial state.
- **`GameState applyMove(int index)`**: place `currentPlayer`’s symbol at `index` (0–8), then:
  - switch current player,
  - check game over (win/draw),
  - return new state.  
  Throws **`InvalidMoveException`** if cell occupied, index out of range, or game already over.

**File: `lib/domain/repositories/ai_strategy.dart`**

- **`int getMove(List<Player?> board, Player botPlayer)`**: returns a cell index (0–8) for the bot. Implementations live in the data layer.

### 3.3 Use cases

**Location: `lib/domain/use_cases/`**

- **`CheckGameOverUseCase`**: pure function. Input: board (9 cells). Output: `(GameResult? result, List<int>? winningLine)`. Checks the 8 lines (3 rows, 3 cols, 2 diagonals); returns win + line, or draw, or `(null, null)` if still playing. Human = X ⇒ X win = `humanWin`, O win = `botWin`.

- **`StartGameUseCase(repository)`**: calls `repository.startNewGame(difficulty)` and returns the new `GameState`.

- **`PlayTurnUseCase(repository)`**: calls `repository.applyMove(index)` and returns the new `GameState` (or propagates `InvalidMoveException`).

- **`GetBotMoveUseCase(aiStrategy)`**: calls `strategy.getMove(board, botPlayer)` and returns the cell index. The strategy is chosen by difficulty (injection layer).

---

## 4. Data layer

### 4.1 Game repository implementation

**File: `lib/data/repositories/game_repository_impl.dart`**

- Holds a single **in-memory** `GameState?` (`_state`).
- **`startNewGame(difficulty)`**: creates a new board (9 nulls), `currentPlayer: Player.x`, `status: GameStatusPlaying`, stores `difficulty`.
- **`applyMove(index)`**:
  1. Validates: game started, not over, index in 0–8, cell empty.
  2. Builds new board: copy current board, set `board[index] = currentPlayer`.
  3. Uses **`CheckGameOverUseCase`** on the new board to get `(result, winningLine)`.
  4. Sets `currentPlayer` to the opposite player.
  5. Sets `status` to `GameStatusOver(result)` if result non-null, else `GameStatusPlaying`.
  6. Updates `_state` with `copyWith` and returns it.

No Flutter; pure Dart. Depends only on domain (entities, repository interface, `CheckGameOverUseCase`).

### 4.2 AI strategies

**Location: `lib/data/ai/`**

Each implements **`AiStrategy`** (`getMove(board, botPlayer)`).

- **`RandomAiStrategy`** (difficulty 1): collects empty indices, returns one at random.
- **`BlockWinAiStrategy`** (difficulty 2):  
  - First: if opponent has two in a line and one empty, return that empty index (block).  
  - Second: if bot has two in a line and one empty, return that empty index (win).  
  - Else: random empty cell.
- **`MinimaxAiStrategy`** (difficulty 3): minimax on the 9-cell board; maximizes score for the bot, minimizes for the opponent; returns best move (or first valid if tie). On empty board, any move is equivalent; the implementation may not always pick the center.

---

## 5. Dependency injection (Riverpod)

**File: `lib/injection.dart`**

All injectable objects are provided via **providers**; presentation and data are wired here.

| Provider | Type | Role |
|----------|------|------|
| `checkGameOverUseCaseProvider` | `Provider<CheckGameOverUseCase>` | Singleton, no dependencies. |
| `gameRepositoryProvider` | `Provider<GameRepository>` | Builds `GameRepositoryImpl(checkGameOverUseCaseProvider)`. |
| `aiStrategyProvider(difficulty)` | `Provider.family<AiStrategy, int>` | Returns `RandomAiStrategy` (1), `BlockWinAiStrategy` (2), or `MinimaxAiStrategy` (3). |
| `getBotMoveUseCaseProvider(difficulty)` | `Provider.family<GetBotMoveUseCase, int>` | Builds `GetBotMoveUseCase(aiStrategyProvider(difficulty))`. |
| `startGameUseCaseProvider` | `Provider<StartGameUseCase>` | Builds `StartGameUseCase(gameRepositoryProvider)`. |
| `playTurnUseCaseProvider` | `Provider<PlayTurnUseCase>` | Builds `PlayTurnUseCase(gameRepositoryProvider)`. |

**Important**: Use cases that need the **current game’s difficulty** (e.g. bot move) use **`Provider.family<..., int>`** so the correct AI strategy is selected per difficulty. The game notifier reads `getBotMoveUseCaseProvider(difficulty)` with the difficulty from the current `GameState`.

---

## 6. Presentation layer

### 6.1 Game state (Riverpod Notifier)

**File: `lib/presentation/providers/game_notifier.dart`**

- **State**: `GameNotifierState` with a single field `GameState? gameState`. `null` means no game (welcome or after “Play again”).
- **Provider**: `gameNotifierProvider` = `NotifierProvider<GameNotifier, GameNotifierState>`.

**Actions**:

1. **`startGame(int difficulty)`**  
   Calls `StartGameUseCase(difficulty)` and sets `state = GameNotifierState(gameState: newState)`.

2. **`playAt(int index)`** (human move)  
   - If no game or game over or not human turn (`currentPlayer != Player.x`), return.  
   - Call `PlayTurnUseCase(index)` and update state.  
   - If after the move the game is still playing and it’s O’s turn, call **`_scheduleBotMove(difficulty, board)`**.

3. **`_scheduleBotMove(difficulty, board)`**  
   Schedules a **microtask** that:  
   - Reads `GetBotMoveUseCase(difficulty)`,  
   - Gets `botIndex = getMove(board, Player.o)`,  
   - Calls `PlayTurnUseCase(botIndex)` and updates state.  
   Using `Future.microtask` avoids the bot moving in the same synchronous frame as the human and keeps the UI responsive.

4. **`playAgain()`**  
   Sets `state = GameNotifierState()` (gameState = null).

The notifier **does not** depend on Flutter or routing; it only uses `ref.read(...)` on the use case providers.

### 6.2 Routing (GoRouter)

**File: `lib/core/router/app_router.dart`**

- **`GoRouter.create()`**: single router, `initialLocation: '/'`.
- **Routes**:
  - `/` (name: `welcome`): `WelcomeScreen`.
  - `/game` (name: `game`): `GameScreen`.
  - `/end` (name: `endGame`): `EndGameScreen`; **`state.extra`** is the `GameResult?` passed when pushing.

Navigation:

- Welcome → Game: `context.pushNamed(AppRoutes.game)` (push).
- Game → End: `context.pushNamed(AppRoutes.endGame, extra: result)` (push).
- End → Welcome: `context.goNamed(AppRoutes.welcome)` (replace stack).

### 6.3 Screens

**Welcome (`lib/presentation/screens/welcome/welcome_screen.dart`)**

- **ConsumerStatefulWidget**; local state `_difficulty` (1–3) with `ChoiceChip`s.
- On “Play”: `ref.read(gameNotifierProvider.notifier).startGame(_difficulty)` then `context.goNamed(AppRoutes.game)`.

**Game (`lib/presentation/screens/game/game_screen.dart`)**

- **ConsumerWidget**.
- **`ref.listen(gameNotifierProvider, ...)`**: when state changes and `gameState?.status` is `GameStatusOver`, navigates to end screen with `context.pushNamed(AppRoutes.endGame, extra: status.result)`.
- **`ref.watch(gameNotifierProvider).gameState`**: rebuilds when game state changes.
- Renders: turn label (“Your turn (X)” / “Bot’s turn (O)” / “Game over”), difficulty, and a 3×3 grid. Each cell is **`GameCell`** with `player`, `onTap: () => notifier.playAt(row * 3 + col)`, `enabled: isHumanTurn`, `highlight: winningLine.contains(index)`.
- Grid: `Expanded` → `AspectRatio(1)` → `LayoutBuilder` → `SizedBox` (square) → 3×3 of `Expanded`/`Row`/`GameCell` so the grid stays square and doesn’t overflow.

**End game (`lib/presentation/screens/end_game/end_game_screen.dart`)**

- Receives **`GameResult? result`** from route `extra`.
- Shows message and color from `result` (e.g. “You win!” / green, “You lose” / red, “It’s a draw” / grey).
- “Play again”: `ref.read(gameNotifierProvider.notifier).playAgain()` then `context.goNamed(AppRoutes.welcome)`.
- Uses `flutter_animate` for fade/scale on message and button.

### 6.4 Shared widgets

- **`AppPrimaryButton`**: design system primary button (label, onPressed, semantics).
- **`GameCell`**: one cell; shows X/O or empty; tap only when empty and enabled; optional highlight (e.g. winning line). Uses `AnimatedContainer` for highlight and `flutter_animate` for symbol appearance.

---

## 7. Data flow summary

1. **Start game**  
   User taps “Play” on Welcome → `GameNotifier.startGame(difficulty)` → `StartGameUseCase(difficulty)` → `GameRepository.startNewGame(difficulty)` → in-memory state set; notifier state updated → `goNamed(game)` → Game screen shows grid.

2. **Human move**  
   User taps cell → `GameNotifier.playAt(index)` → `PlayTurnUseCase(index)` → `GameRepository.applyMove(index)` → board updated, win/draw checked, state returned → notifier state updated → UI rebuilds. If game not over and turn is O, `_scheduleBotMove` runs in a microtask.

3. **Bot move**  
   Microtask: `GetBotMoveUseCase(difficulty).call(board, Player.o)` → `AiStrategy.getMove(...)` → index; `PlayTurnUseCase(botIndex)` → repository updates state → notifier state updated → UI rebuilds.

4. **Game over**  
   When `gameState.status` is `GameStatusOver`, the listener in Game screen calls `pushNamed(endGame, extra: result)` → End screen shows message; “Play again” clears state and `goNamed(welcome)`.

---

## 8. Board indexing and win lines

- Board: flat list of 9 elements, index `i` = row `i ~/ 3`, column `i % 3`.
- Win lines (indices):  
  Rows: [0,1,2], [3,4,5], [6,7,8].  
  Cols: [0,3,6], [1,4,7], [2,5,8].  
  Diagonals: [0,4,8], [2,4,6].

`CheckGameOverUseCase` and the AI strategies use this same indexing.

---

## 9. Design system (summary)

- **`lib/core/theme/app_theme.dart`**: `ThemeData` (Material 3, color scheme, text theme).
- **`lib/core/theme/app_colors.dart`**: semantic colors (e.g. win/lose/draw).
- **`lib/core/theme/app_spacing.dart`**: spacing constants (xs, sm, md, lg, xl).

Widgets use `Theme.of(context)` and these tokens so the app stays consistent and testable.
