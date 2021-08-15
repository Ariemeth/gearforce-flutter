class Trait {
  const Trait({
    required this.name,
    this.level,
  });
  final String name;
  final int? level;

  @override
  String toString() {
    final levelStr = this.level == null ? '' : ':${this.level}';
    return '${this.name}$levelStr';
  }
}
