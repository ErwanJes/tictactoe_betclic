/// Represents a player symbol on the board.
enum Player {
  x,
  o;

  Player get opposite => this == Player.x ? Player.o : Player.x;
}
