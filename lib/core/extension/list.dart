extension ListExtension<T> on List<T> {
  bool containsWhere(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return true;
    }
    return false;
  }
}