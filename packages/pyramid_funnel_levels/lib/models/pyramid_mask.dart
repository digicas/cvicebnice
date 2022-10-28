/// Mask defining the to be edited cells within task/solution
class PyramidMask {
  PyramidMask(this._mask);

  final List<int> _mask;

  int get length => _mask.length;

  List<bool> get mask => _mask.map((v) => v == 1).toList();

  ///
  /// get the amount of rows given the length of the pyramid
  ///
  int get rows {
    final length = _mask.length;
    assert(length >= 0 && length < 11, '');
    final map = [0, 1, 2, 2, 3, 3, 3, 4, 4, 4, 4];
    return map[length];
  }

  static String _toSpacedString(List<int> mask) {
    var out = '';
    for (var i = 0, j = 1; i + j <= mask.length; i = i + j, j++) {
      for (var cx = i; cx < i + j; cx++) {
        out += '${mask[cx]}';
      }
      out += ' ';
    }
    return out.trim();
  }

  String toPrettyString() {
    switch (_mask.length) {
      case 0:
        return '[]';
      case 1:
        return '[${_mask[0]}]';
      case 3:
        return '[${_toSpacedString(_mask)}]';
      case 6:
        return '[${_toSpacedString(_mask)}]';
      case 10:
        return '[${_toSpacedString(_mask)}]';
      default:
        throw Exception('invalid mask');
    }
  }
}
