import 'package:matrix_words/position.dart';

List<List<String>> matrix = [
  ['a', 'e', 't', 'l'],
  ['d', 'a', 'e', 'u'],
  ['t', 'e', 'a', 'r'],
  ['c', 'h', 'x', 'g'],
];
List<String> words = [
  'leadtech',
  'notleadtech',
  'potato',
  'anotherCompany',
  'great',
];

List<(int, int)> findPositions(
  (int, int) startPoint,
  (int, int) matrixDimensions,
  List<Position> trackedPositions,
) {
  final x = startPoint.$1;
  final y = startPoint.$2;
  final maxX = matrixDimensions.$1;
  final maxY = matrixDimensions.$2;
  List<(int, int)> positions = [];
  for (var i = x - 1; i <= x + 1; i++) {
    for (var j = y - 1; j <= y + 1; j++) {
      var position = (i, j);

      final mappedTrackedPositions = trackedPositions.map((e) => (e.x, e.y));
      if (mappedTrackedPositions.contains(position) || position == startPoint) {
        continue;
      }
      if ((i >= 0 && i <= maxX) && (j >= 0 && j <= maxY)) {
        positions.add((i, j));
      }
    }
  }
  return positions;
}

List<String> findWords(List<List<String>> matrix, List<String> words) {
  List<String> foundWords = [];
  final matrixDimensions = (matrix.length - 1, matrix[0].length - 1);
  for (final word in words) {
    // store the reference of a position used to navigate through the matrix to build the word
    List<Position> trackedPositions = [];
    // store the rest of letters that can be used in the future to build the word
    List<Position> backTracking = [];
    int wordIndex = 0;
    var char = word[wordIndex];

    for (var i = 0; i < matrix.length; i++) {
      for (var j = 0; j < matrix[i].length; j++) {
        if (matrix[i][j] == char) {
          // The position points to the next wordIndex
          final position =
              Position(x: i, y: j, wordIndex: wordIndex + 1, char: char);
          backTracking.add(position);
        }
      }
    }
    // wordIndex++;
    // We cannot find the letter in the matrix, so the word cannot be built
    if (backTracking.isEmpty) {
      continue;
    }
    // add first letter to tracked positions
    trackedPositions.addAll(backTracking);
    while (backTracking.isNotEmpty) {
      final position = backTracking.removeAt(0);
      trackedPositions.add(position);
      wordIndex = position.wordIndex;
      if (wordIndex == word.length && word[wordIndex - 1] == position.char) {
        foundWords.add(word);
        backTracking.clear();
        continue;
      }
      final newTrackedPositions = findPositions(
              (position.x, position.y), matrixDimensions, trackedPositions)
          .map((e) => Position(
              x: e.$1,
              y: e.$2,
              wordIndex: wordIndex + 1,
              char: matrix[e.$1][e.$2]))
          .where((e) => word[wordIndex] == e.char)
          .toList();
      if (newTrackedPositions.isNotEmpty) {
        final positionToInsert = newTrackedPositions.removeAt(0);
        backTracking.insert(0, positionToInsert);
        backTracking.addAll(newTrackedPositions);
        trackedPositions.add(positionToInsert);
      } else {
        trackedPositions.removeWhere(
            (e) => e.wordIndex == wordIndex && e.char == position.char);
      }
    }
  }
  return foundWords;
}

void main(List<String> args) {
  print(findWords(matrix, words));
}
