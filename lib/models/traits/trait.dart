final traitNameMatch = RegExp(r'^([a-zA-Z +]+)', caseSensitive: false);
final auxMatch = RegExp(r'(Aux)', caseSensitive: false);
final levelMatch = RegExp(r':([+-]?\d+)');
final typeMatch = RegExp(r'([a-zA-Z+]+\**)$', caseSensitive: false);

class Trait {
  const Trait({
    required this.name,
    this.level,
    this.isAux = false,
    this.type,
    this.description,
  });
  final String name;
  final String? type;
  final int? level;
  final bool isAux;
  final String? description;

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

  @override
  bool operator ==(Object other) {
    return other is Trait &&
        name == other.name &&
        level == other.level &&
        isAux == other.isAux;
  }

  @override
  int get hashCode => name.hashCode ^ level.hashCode ^ isAux.hashCode;

  factory Trait.fromTrait(
    Trait original, {
    String? name,
  }) {
    return Trait(
      name: name == null ? original.name : name,
      type: original.type,
      level: original.level,
      isAux: original.isAux,
    );
  }

  factory Trait.fromString(String str) {
    var nameCheck = traitNameMatch.firstMatch(str)?.group(1)?.trim();
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
      // handle transport or occupancy traits
    } else if (nameCheck == 'Transport' || nameCheck == 'Occupancy') {
      var transportTypeCheck = typeMatch.firstMatch(str)?.group(1);
      assert(
        transportTypeCheck != null,
        'trait: [$str] type check should not be null',
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

  factory Trait.AA() {
    return const Trait(
      name: 'AA',
      description: 'Weapons with the AA trait receive +1D6 for ranged attacks' +
          ' against elevated VTOLs and airstrike counters. This model' +
          ' may retaliate against an airstrike counter when they' +
          ' perform an airstrike.',
    );
  }

  factory Trait.Advanced() {
    return const Trait(
        name: 'Advanced',
        description:
            'When a weapon with the Advanced trait attacks, add +1 to the result rolled (+1 R)');
  }

  factory Trait.AOE(int level) {
    return Trait(
        name: 'AOE',
        level: level,
        description:
            'Weapons with the AOE:X trait may be used to attack an area with a radius of X inches around a target point.');
  }

  factory Trait.Agile() {
    return const Trait(
        name: 'Agile',
        description:
            'Attacks targeting this model will miss on a margin of success of zero');
  }
}
