class KeyboardController<T> {
  KeyboardController({
    this.type = KeyboardType.numbers,
    this.values = const [],
    this.valuesMaxLengths = const [],
  }) {
    if (valuesMaxLengths.isEmpty) {
      valuesMaxLengths = List.generate(values.length, (_) => 4);
    }
  }

  final KeyboardType type;
  final List<T?> values;
  late List<int> valuesMaxLengths;

  void changeValueAt(int index, T value) {
    final oldValue = values.elementAt(index);
    if (oldValue is String && oldValue.length >= valuesMaxLengths[index] ||
        oldValue is int && oldValue.length() >= valuesMaxLengths[index]) return;
    if (oldValue == null) {
      values[index] = value;
      return;
    }
    values[index] = int.parse('$oldValue$value') as T;
  }

  void onDelete(int index) {
    final oldValue = values.elementAt(index);

    if (oldValue == null) return;

    if (oldValue is String) {
      values[index] = oldValue.length <= 1
          ? null
          : oldValue.substring(0, oldValue.length - 1) as T;
    }

    if (oldValue is int) {
      values[index] = oldValue.length() <= 1
          ? null
          : int.parse('$oldValue'.substring(0, oldValue.length() - 1)) as T;
    }
  }
}

enum KeyboardType {
  numbers,
  letters,
}

extension XNum on num {
  int length() => toString().length;
}
