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

  /// Checks if the [Trait] other has the same name.
  bool isSameType(Trait other) {
    return this.name == other.name;
  }

  /// Checks if the [Trait] other has the same level.
  bool isSameLevel(Trait other) {
    return this.level == other.level;
  }

  /// Checks to see if the [Trait] other has the same name and level.
  bool isSame(Trait other) {
    return this.name == other.name && this.level == other.level;
  }

  factory Trait.fromTrait(
    Trait original, {
    String? name,
    int? level,
    bool? isAux,
  }) {
    return Trait(
      name: name == null ? original.name : name,
      type: original.type,
      level: level != null ? level : original.level,
      isAux: isAux != null ? isAux : original.isAux,
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
        description: 'When a weapon with the Advanced trait attacks, add +1 ' +
            ' to the result rolled (+1 R)');
  }

  factory Trait.AOE(int level) {
    return Trait(
        name: 'AOE',
        level: level,
        description: 'Weapons with the AOE:X trait may be used to attack an ' +
            ' area with a radius of X inches around a target point.');
  }

  factory Trait.Agile() {
    return const Trait(
        name: 'Agile',
        description: 'Attacks targeting this model will miss on a margin' +
            ' of success of zero');
  }

  factory Trait.AI() {
    return const Trait(
        name: 'AI',
        description: 'Weapons with the AI trait may deal more than two damage' +
            ' to infantry on a successful attack. These weapons also' +
            ' have a bonus of +1D6 against infantry and cavalry models.');
  }

  factory Trait.Airdrop() {
    return const Trait(
        name: 'Airdrop',
        description: 'Combat groups composed entirely of models with the' +
            ' Airdrop trait may deploy using the airdrop deployment' +
            ' option. See Airdrop Deployment.');
  }

  factory Trait.Amphib() {
    return const Trait(
        name: 'Amphib',
        description: 'This model may move over water terrain at its full MR.');
  }

  factory Trait.AMS() {
    return const Trait(
        name: 'AMS',
        description: 'This model may reroll defense rolls against all' +
            ' indirect attacks and airstrikes.');
  }

  factory Trait.Apex() {
    return const Trait(
        name: 'Apex',
        description: 'Add +1 to this weapon’s base damage. Multiple sources' +
            ' of Apex are cumulative.');
  }

  factory Trait.AP(int level) {
    return Trait(
        name: 'AP',
        level: level,
        description: 'Armor piercing weapons are able to do damage on a' +
            ' successful attack even when the damage does not exceed' +
            ' the enemy’s armor.');
  }

  factory Trait.Auto() {
    return const Trait(
        name: 'Auto',
        description: 'A weapon with this trait may be used for retaliation' +
            ' once per round without spending an action point. If this is a' +
            ' combination weapon, then only one of the weapons may' +
            ' be used in this way per round.');
  }

  factory Trait.B() {
    return const Trait(
        name: 'B',
        description: 'Weapons with this trait can only be fired at targets' +
            ' within this model’s back arc (the back 180 degrees of the' +
            ' model).');
  }

  factory Trait.Blast() {
    return const Trait(
        name: 'Blast',
        description: '* If an attacking model has LOS to a target, indirect' +
            ' attacks with this weapon ignore the bonus defense' +
            ' dice for cover.\n' +
            '* A fire mission may also receive this benefit if the' +
            ' forward observer, or the attacking model has LOS to' +
            ' the target(s).');
  }

  factory Trait.Brace() {
    return const Trait(
        name: 'Brace',
        description: 'This weapon may only be fired if the model is braced.');
  }

  factory Trait.Brawl(int level) {
    return Trait(
        name: 'Brawl',
        level: level,
        description: '* A Brawl:X trait on a weapon will modify attack rolls' +
            ' by XD6 when using that weapon.\n' +
            '* A Brawl:X trait on a model will modify all melee rolls' +
            ' that model makes by XD6.');
  }

  factory Trait.Burst(int level) {
    return Trait(
        name: 'Burst',
        level: level,
        description: 'Add a +XD6 modifier to any attack roll made with this' +
            ' weapon (generally +1D6 or +2D6).');
  }

  factory Trait.Hands() {
    return const Trait(
        name: 'Hands',
        description: 'This model has additional upgrade options available and' +
            ' limited climbing ability. See Climbing.');
  }

  factory Trait.Reach(int level) {
    return Trait(
        name: 'Reach',
        level: level,
        description: 'This melee weapon can attack a target X inches from' +
            ' its base. This is not a ranged attack');
  }
}
