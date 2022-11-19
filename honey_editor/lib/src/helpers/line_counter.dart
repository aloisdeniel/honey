// Character constants.
const _lf = 10;
const _cr = 13;

class LineCounter {
  const LineCounter();

  int count(String data, [int? maxIndex]) {
    if (data.isEmpty) {
      return 1;
    }
    var result = 1;
    final end = maxIndex != null ? (maxIndex) : data.length;
    for (var i = 0; i < end; i++) {
      final char = data.codeUnitAt(i);
      if (char == _cr || char == _lf) {
        result++;
      }
    }

    return result;
  }
}
