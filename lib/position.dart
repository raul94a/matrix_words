class Position {
  int x;
  int y;
  int wordIndex;
  String char;
  Position({required this.x, required this.y, required this.wordIndex, required this.char});

  @override
  String toString() {
    return 'Position(x: $x, y: $y, wordIndex: $wordIndex, char: $char)';
  }
}
