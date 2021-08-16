final traitNameMatch = RegExp(r'^([a-zA-Z+]+)', caseSensitive: false);
final auxMatch = RegExp(r'(Aux)', caseSensitive: false);
final levelMatch = RegExp(r':([+-]?\d+)');
final typeMatch = RegExp(r'([a-zA-Z+]+)$', caseSensitive: false);

class Trait {
  const Trait({
    required this.name,
    this.level,
    this.isAux = false,
    this.type,
  });
  final String name;
  final String? type;
  final int? level;
  final bool isAux;

  @override
  String toString() {
    String? levelStr;
    if (this.level != null) {
      levelStr = ':${this.level}';
    }

    if (this.type != null) {
      levelStr = levelStr == null ? ':${this.type}' : '$levelStr ${this.type}';
    }

    if (this.isAux) {
      levelStr = levelStr == null ? ' (Aux)' : '$levelStr (Aux)';
    }
    return levelStr != null ? '${this.name}$levelStr' : '${this.name}';
  }

  factory Trait.fromString(String str) {
    var nameCheck = traitNameMatch.firstMatch(str)?.group(1);
    assert(nameCheck != null, 'trait: [$str] name must match, but did not');
    final auxCheck = auxMatch.hasMatch(str);
    var levelCheck = levelMatch.firstMatch(str)?.group(1);
    String? type;

    // handle vuln and resist traits
    if (nameCheck == 'Vuln' || nameCheck == 'Resist') {
      type = typeMatch.firstMatch(str)?.group(1);
      assert(
        type != null,
        'trait: [$str] vuln,resist type check should not be null',
      );
      // handle transport traits
    } else if (nameCheck == 'Transport') {
      var transportTypeCheck = typeMatch.firstMatch(str)?.group(1);
      assert(
        transportTypeCheck != null,
        'trait: [$str] transport type check should not be null',
      );
      type = transportTypeCheck;
    }

    return Trait(
      name: nameCheck!,
      level: levelCheck != null ? int.parse(levelCheck) : null,
      isAux: auxCheck,
      type: type,
    );
  }
}
