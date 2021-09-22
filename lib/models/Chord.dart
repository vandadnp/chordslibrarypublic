class Chord {
  final String category;
  final String name;
  final String root;
  final String path;

  Chord({required this.category, required this.name, required this.root, required this.path});

  String get variationsPath => '$path/variations';
}
