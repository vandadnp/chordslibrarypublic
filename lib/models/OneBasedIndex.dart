import 'dart:core';

class OneBasedIndex {
  final int value;

  const OneBasedIndex(this.value) : assert(value >= 1);

  factory OneBasedIndex.parse(String source) =>
      OneBasedIndex(int.parse(source));

  int get toZeroBasedIndex =>
      value - 1 >= 0 ? value - 1 : throw 'Unexpected value';
}
