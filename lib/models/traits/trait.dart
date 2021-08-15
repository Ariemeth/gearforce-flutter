final RegExp traitNameMatch = RegExp(r'^([a-zA-Z+]+)', caseSensitive: false);
final RegExp auxMatch = RegExp(r'(Aux)', caseSensitive: false);

final RegExp levelMatch = RegExp(r':([+-]?\d)');

class Trait {
  const Trait({
    required this.name,
    this.level,
    this.isAux = false,
  });
  final String name;
  final int? level;
  final bool isAux;

  @override
  String toString() {
    var levelStr = this.level == null ? '' : ':${this.level}';
    if (this.isAux) {
      levelStr = '$levelStr (Aux)';
    }
    return '${this.name}$levelStr';
  }

  factory Trait.fromString(String str) {
    final nameCheck = traitNameMatch.firstMatch(str)?.group(1);
    assert(nameCheck != null, 'trait [$str] name must match, but did not');
    final auxCheck = auxMatch.hasMatch(str);
    final levelCheck = levelMatch.firstMatch(str)?.group(1);

    return Trait(
      name: nameCheck!,
      level: levelCheck != null ? int.parse(levelCheck) : null,
      isAux: auxCheck,
    );
  }
}
