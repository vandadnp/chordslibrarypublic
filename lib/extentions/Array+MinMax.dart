import 'dart:core';

extension MinMax<T extends num> on List<T> {
  T get min => _sorted.first;

  T get max => _sorted.last;

  List<T> get _sorted => [...this]..sort();
}
