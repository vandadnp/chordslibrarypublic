import 'dart:core';

class ZeroBasedIndex extends Comparable<ZeroBasedIndex> {
  final int value;
  ZeroBasedIndex(this.value) : assert(value >= 0);

  @override
  int compareTo(ZeroBasedIndex other) => value.compareTo(other.value);

  factory ZeroBasedIndex.parse(String source) =>
      ZeroBasedIndex(int.parse(source));

  @override
  bool operator ==(Object rhs) => rhs is int ? rhs == value : false;

  bool operator >=(int rhs) => rhs is int ? value >= rhs : false;

  bool operator <(int rhs) => rhs is int ? value < rhs : false;
}
