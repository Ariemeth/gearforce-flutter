final traitNameMatch = RegExp(r'^([a-zA-Z +]+)', caseSensitive: false);
final auxMatch = RegExp(r'(Aux)', caseSensitive: false);
final levelMatch = RegExp(
  r':([+-]? ?\d+)',
);
final typeMatch = RegExp(r'([a-zA-Z+]+\**)$', caseSensitive: false);

class Trait {
  const Trait({
    required this.name,
    this.level,
    this.isAux = false,
    this.type,
    this.description,
    this.isDisabled = false,
  });
  final String name;
  final String? type;
  final int? level;
  final bool isAux;
  final String? description;
  final bool isDisabled;

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
        isAux == other.isAux &&
        isDisabled == other.isDisabled;
  }

  @override
  int get hashCode =>
      name.hashCode ^ level.hashCode ^ isAux.hashCode ^ isDisabled.hashCode;

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
      description: original.description,
    );
  }

  factory Trait.fromString(String str) {
    var nameCheck = traitNameMatch.firstMatch(str)?.group(1)?.trim();
    assert(
      nameCheck != null,
      'trait: [$str] name must match, but did not',
    );
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

    final level = levelCheck != null ? int.parse(levelCheck) : 0;

    switch (nameCheck) {
      case 'AA':
        return Trait.AA(isAux: auxCheck);
      case 'Advanced':
        return Trait.Advanced(isAux: auxCheck);
      case 'AOE':
        return Trait.AOE(level, isAux: auxCheck);
      case 'Agile':
        return Trait.Agile(isAux: auxCheck);
      case 'AI':
        return Trait.AI(isAux: auxCheck);
      case 'Airdrop':
        return Trait.Airdrop(isAux: auxCheck);
      case 'Amphib':
        return Trait.Amphib(isAux: auxCheck);
      case 'AMS':
        return Trait.AMS(isAux: auxCheck);
      case 'Apex':
        return Trait.Apex(isAux: auxCheck);
      case 'AP':
        return Trait.AP(level, isAux: auxCheck);
      case 'Auto':
        return Trait.Auto(isAux: auxCheck);
      case 'Aux':
        return Trait.Aux();
      case 'B':
        return Trait.B(isAux: auxCheck);
      case 'Blast':
        return Trait.Blast(isAux: auxCheck);
      case 'Brace':
        return Trait.Brace(isAux: auxCheck);
      case 'Brawl':
        return Trait.Brawl(level, isAux: auxCheck);
      case 'Burst':
        return Trait.Burst(level, isAux: auxCheck);
      case 'Climber':
        return Trait.Climber(isAux: auxCheck);
      case 'Conscript':
        return Trait.Conscript(isAux: auxCheck);
      case 'CBS':
        return Trait.CBS(isAux: auxCheck);
      case 'Comms':
        return Trait.Comms(isAux: auxCheck);
      case 'Corrosion':
        return Trait.Corrosion(isAux: auxCheck);
      case 'Demo':
        return Trait.Demo(level, isAux: auxCheck);
      case 'Duelist':
        return Trait.Duelist();
      case 'ECM':
        return Trait.ECM(isAux: auxCheck);
      case 'ECM+':
        return Trait.ECMPlus(isAux: auxCheck);
      case 'ECCM':
        return Trait.ECCM(isAux: auxCheck);
      case 'Field Armor':
        return Trait.FieldArmor(isAux: auxCheck);
      case 'Fire':
        return Trait.Fire(level, isAux: auxCheck);
      case 'Flak':
        return Trait.Flak(isAux: auxCheck);
      case 'Frag':
        return Trait.Frag(isAux: auxCheck);
      case 'Guided':
        return Trait.Guided(isAux: auxCheck);
      case 'Hand':
      case 'Hands':
        return Trait.Hands(isAux: auxCheck);
      case 'Haywire':
        return Trait.Haywire(isAux: auxCheck);
      case 'Jetpack':
        return Trait.Jetpack(level, isAux: auxCheck);
      case 'Jump Jets':
        return Trait.JumpJets(level, isAux: auxCheck);
      case 'L':
        return Trait.L(isAux: auxCheck);
      case 'LA':
        return Trait.LA(level, isAux: auxCheck);
      case 'Link':
        return Trait.Link(isAux: auxCheck);
      case 'Lumbering':
        return Trait.Lumbering(isAux: auxCheck);
      case 'Medic':
        return Trait.Medic(isAux: auxCheck);
      case 'Mine':
        return Trait.Mine(level, isAux: auxCheck);
      case 'Occupancy':
        if (type == null) {
          print('Occupancy type is null');
        }
        return Trait.Occupancy(level, type ?? 'Unknown', isAux: auxCheck);
      case 'or':
      case 'OR':
        return Trait.Or();
      case 'Offroad':
        return Trait.Offroad(isAux: auxCheck);
      case 'Precise':
        return Trait.Precise(isAux: auxCheck);
      case 'Proximity':
        return Trait.Proximity(isAux: auxCheck);
      case 'R':
        return Trait.R(isAux: auxCheck);
      case 'Reach':
        return Trait.Reach(level, isAux: auxCheck);
      case 'React':
        return Trait.React(isAux: auxCheck);
      case 'React+':
        return Trait.ReactPlus(isAux: auxCheck);
      case 'Repair':
        return Trait.Repair(isAux: auxCheck);
      case 'Resist':
        switch (type) {
          case 'C':
            return Trait.ResistC(isAux: auxCheck);
          case 'F':
            return Trait.ResistF(isAux: auxCheck);
          case 'H':
            return Trait.ResistH(isAux: auxCheck);
        }
      case 'Satup':
      case 'SatUp':
        return Trait.SatUp(isAux: auxCheck);
      case 'Sensor Boom':
        return Trait.SensorBoom(isAux: auxCheck);
      case 'Sensors':
        return Trait.Sensors(level, isAux: auxCheck);
      case 'Shield':
        return Trait.Shield(isAux: auxCheck);
      case 'Shield+':
        return Trait.ShieldPlus(isAux: auxCheck);
      case 'Silent':
        return Trait.Silent(isAux: auxCheck);
      case 'Smoke':
        return Trait.Smoke(isAux: auxCheck);
      case 'SP':
        return Trait.SP(level, isAux: auxCheck);
      case 'Split':
        return Trait.Split(isAux: auxCheck);
      case 'Spray':
        return Trait.Spray(isAux: auxCheck);
      case 'Stable':
        return Trait.Stable(isAux: auxCheck);
      case 'Stationary':
        return Trait.Stationary(isAux: auxCheck);
      case 'Stealth':
        return Trait.Stealth(isAux: auxCheck);
      case 'Sub':
        return Trait.Sub(isAux: auxCheck);
      case 'Supply':
        return Trait.Supply(isAux: auxCheck);
      case 'TD':
        return Trait.TD(isAux: auxCheck);
      case 'Towed':
        return Trait.Towed(isAux: auxCheck);
      case 'Transport':
        if (type == null) {
          print('Transport type is null');
        }
        return Trait.Transport(level, type ?? 'Unknown', isAux: auxCheck);
      case 'T':
        return Trait.T(isAux: auxCheck);
      case 'Vet':
        return Trait.Vet();
      case 'VTOL':
        return Trait.VTOL(isAux: auxCheck);
      case 'Vuln':
        switch (type) {
          case 'C':
            return Trait.VulnC();
          case 'F':
            return Trait.VulnF();
          case 'H':
            return Trait.VulnH();
        }
      default:
        print('Unknown trait name [$nameCheck]');
    }

    final unknownTrait = Trait(
      name: nameCheck!,
      level: levelCheck != null ? level : null,
      isAux: auxCheck,
      type: type,
    );

    print('Trait was not captured by switch: $str');
    return unknownTrait;
  }

  factory Trait.AA({bool isAux = false}) {
    return Trait(
      name: 'AA',
      isAux: isAux,
      description: 'Weapons with the AA trait receive +1D6 for ranged attacks' +
          ' against elevated VTOLs and airstrike counters. This model' +
          ' may retaliate against an airstrike counter when they' +
          ' perform an airstrike.',
    );
  }

  factory Trait.Advanced({bool isAux = false}) {
    return Trait(
      name: 'Advanced',
      isAux: isAux,
      description: 'When a weapon with the Advanced trait attacks, add +1 ' +
          ' to the result rolled (+1 R)',
    );
  }

  factory Trait.AOE(int level, {bool isAux = false}) {
    return Trait(
      name: 'AOE',
      level: level,
      isAux: isAux,
      description: 'Weapons with the AOE:X trait may be used to attack an ' +
          ' area with a radius of X inches around a target point.',
    );
  }

  factory Trait.Agile({bool isAux = false}) {
    return Trait(
      name: 'Agile',
      isAux: isAux,
      description: 'Attacks targeting this model will miss on a margin' +
          ' of success of zero',
    );
  }

  factory Trait.AI({bool isAux = false}) {
    return Trait(
      name: 'AI',
      isAux: isAux,
      description: 'Weapons with the AI trait may deal more than two damage' +
          ' to infantry on a successful attack. These weapons also' +
          ' have a bonus of +1D6 against infantry and cavalry models.',
    );
  }

  factory Trait.Airdrop({bool isAux = false}) {
    return Trait(
      name: 'Airdrop',
      isAux: isAux,
      description: 'Combat groups composed entirely of models with the' +
          ' Airdrop trait may deploy using the airdrop deployment' +
          ' option. See Airdrop Deployment.',
    );
  }

  factory Trait.Amphib({bool isAux = false}) {
    return Trait(
      name: 'Amphib',
      isAux: isAux,
      description: 'This model may move over water terrain at its full MR.',
    );
  }

  factory Trait.AMS({bool isAux = false}) {
    return Trait(
      name: 'AMS',
      isAux: isAux,
      description: 'This model may reroll defense rolls against all' +
          ' indirect attacks and airstrikes.',
    );
  }

  factory Trait.Apex({bool isAux = false}) {
    return Trait(
      name: 'Apex',
      isAux: isAux,
      description: 'Add +1 to this weapon’s base damage. Multiple sources' +
          ' of Apex are cumulative.',
    );
  }

  factory Trait.AP(int level, {bool isAux = false}) {
    return Trait(
      name: 'AP',
      level: level,
      isAux: isAux,
      description: 'Armor piercing weapons are able to do damage on a' +
          ' successful attack even when the damage does not exceed' +
          ' the enemy’s armor.',
    );
  }

  factory Trait.Auto({bool isAux = false}) {
    return Trait(
      name: 'Auto',
      isAux: isAux,
      description: 'A weapon with this trait may be used for retaliation' +
          ' once per round without spending an action point. If this is a' +
          ' combination weapon, then only one of the weapons may' +
          ' be used in this way per round.',
    );
  }

  factory Trait.Aux() {
    return const Trait(
      name: 'Aux',
      description: 'Weapons and traits with the aux trait may not be used' +
          ' when the model is crippled or haywired',
    );
  }

  factory Trait.B({bool isAux = false}) {
    return Trait(
      name: 'B',
      isAux: isAux,
      description: 'Weapons with this trait can only be fired at targets' +
          ' within this model’s back arc (the back 180 degrees of the' +
          ' model).',
    );
  }

  factory Trait.Blast({bool isAux = false}) {
    return Trait(
      name: 'Blast',
      isAux: isAux,
      description: '* If an attacking model has LOS to a target, indirect' +
          ' attacks with this weapon ignore the bonus defense' +
          ' dice for cover.\n' +
          '* A fire mission may also receive this benefit if the' +
          ' forward observer, or the attacking model has LOS to' +
          ' the target(s).',
    );
  }

  factory Trait.Brace({bool isAux = false}) {
    return Trait(
      name: 'Brace',
      isAux: isAux,
      description: 'This weapon may only be fired if the model is braced.',
    );
  }

  factory Trait.Brawl(int level, {bool isAux = false}) {
    return Trait(
      name: 'Brawl',
      level: level,
      isAux: isAux,
      description: '* A Brawl:X trait on a weapon will modify attack rolls' +
          ' by XD6 when using that weapon.\n' +
          '* A Brawl:X trait on a model will modify all melee rolls' +
          ' that model makes by XD6.',
    );
  }

  factory Trait.Burst(int level, {bool isAux = false}) {
    return Trait(
      name: 'Burst',
      level: level,
      isAux: isAux,
      description: 'Add a +XD6 modifier to any attack roll made with this' +
          ' weapon (generally +1D6 or +2D6).',
    );
  }

  factory Trait.Climber({bool isAux = false}) {
    return Trait(
      name: 'Climber',
      isAux: isAux,
      description: 'This trait allows a model to climb terrain features at' +
          ' its full Movement Rate (MR).',
    );
  }

  factory Trait.CombinationWeapon() {
    return const Trait(
      name: 'Combination Weapon',
      description: 'Weapons separated by a forward slash ( / ) are' +
          ' combination weapons. One example is the LAC/LGL. This would be' +
          ' a light autocannon with a light grenade launcher (usually ' +
          ' underslung). This is there more as a hobby reference. The' +
          ' specific part(s) that represents a combination weapon is' +
          ' different from other weapons. For example, a LAC/LGL is' +
          ' visually distinguishable from a LAC.\n ' +
          'Each weapon belonging to the combination weapon works' +
          ' independently from the other. Firing each weapon requires its' +
          ' own Action and they do not fire together just because they are' +
          ' a combination weapon. However, some upgrades, such as a few' +
          ' found in the duelist upgrade options, do pertain to upgrading' +
          ' combination weapons.',
    );
  }

  factory Trait.Conscript({bool isAux = false}) {
    return Trait(
      name: 'Conscript',
      isAux: isAux,
      description: 'If this model is not in formation with a commander, all' +
          ' of its skills are +1 TN. This model may not be a commander and' +
          ' commanders may never take upgrades that give them the Conscript' +
          ' trait. Models with the Conscript trait may not be upgraded with' +
          ' the Vet trait.',
    );
  }

  factory Trait.CBS({bool isAux = false}) {
    return Trait(
      name: 'CBS',
      isAux: isAux,
      description: 'A model with the CBS trait may use a counterstrike' +
          ' reaction. See Counterstrike (Reaction).',
    );
  }

  factory Trait.Comms({bool isAux = false}) {
    return Trait(
      name: 'Comms',
      isAux: isAux,
      description: 'Commanders with the Comms trait do not need to roll' +
          ' for orders, when all the recipients of the order are in' +
          ' formation with this model. They will still have to roll an' +
          ' opposed roll when there are jamming attempts made against their' +
          ' orders. Also, if a roll is required, due to one of the models' +
          ' being out of formation, and the roll fails, then the order' +
          ' fails for all models in its entirety.\n' +
          'Commanders in formation' +
          ' with a model that has the Comms trait may use the Comms trait' +
          ' of that model and their EW skill in place of their own when' +
          ' issuing orders.',
    );
  }

  factory Trait.Corrosion({bool isAux = false}) {
    return Trait(
      name: 'Corrosion',
      isAux: isAux,
      description: 'When an attack with the Corrosion trait hits a model,' +
          ' apply damage as normal and then place a corrosion token next' +
          ' to the model.\n' +
          'In each cleanup phase, each model with a' +
          ' corrosion token rolls one die. If the roll meets or exceeds a' +
          ' threshold of 4+, the model will take one damage. If not removed' +
          ' by a patch action, a corrosion token will stay on the model' +
          ' until the game ends or the model is destroyed. A model can only' +
          'have one corrosion token at a time.',
    );
  }

  factory Trait.Demo(int level, {bool isAux = false}) {
    return Trait(
      name: 'Demo',
      level: level,
      isAux: isAux,
      description: 'A weapon with the Demo:X trait will allow certain ' +
          ' weapons to damage buildings, terrain and fortifications more' +
          ' efficiently than other weapons.\n' +
          'When attacking a building,' +
          ' terrain feature or fortification, if the margin of success is' +
          ' 0 (MOS:0) or better the weapon will do the amount of damage' +
          ' equal to X. If regular damage calculations would result in more' +
          ' damage, then that may be used instead.',
    );
  }

  factory Trait.Duelist() {
    return const Trait(
      name: 'Duelist',
      description: 'A model with the Duelist trait may purchase veteran and' +
          'duelist upgrades.  Typically only 1 per force.',
    );
  }

  factory Trait.ECM({bool isAux = false}) {
    return Trait(
      name: 'ECM',
      isAux: isAux,
      description: 'This model possesses an electronic counter-measure' +
          ' system. A model with this trait may use the following trait' +
          ' enabled actions and reactions:\n' +
          '* ECM Jam\n' +
          '* ECM Attack\n' +
          '* ECM Defense\n',
    );
  }

  factory Trait.ECMPlus({bool isAux = false}) {
    return Trait(
      name: 'ECM+',
      isAux: isAux,
      description: 'This model has an enhanced electronic counter-measure' +
          ' system. A model with the ECM+ trait performs all functions of' +
          ' the ECM trait, but its ECM defense is always in effect unless' +
          ' it is haywired.',
    );
  }

  factory Trait.ECCM({bool isAux = false}) {
    return Trait(
      name: 'ECCM',
      isAux: isAux,
      description: 'This model is equipped with an electronic' +
          ' counter-countermeasure system. This model and all friendly' +
          ' models within 6 inches gain +1D6 to all EW rolls. This effect' +
          ' is not cumulative with additional ECCM traits.\n' +
          'Models with the ECCM trait can also perform ECCM firewall' +
          ' reactions.',
    );
  }

  factory Trait.FieldArmor({bool isAux = false}) {
    return Trait(
      name: 'Field Armor',
      isAux: isAux,
      description: 'This model suffers one less damage from each attack to' +
          ' a minimum of one damage. Field Armor reduces damage from the' +
          ' Armor Piercing trait, but it does not apply to other effects' +
          ' such as Fire, Corrosion or Haywire.',
    );
  }

  factory Trait.Fire(int level, {bool isAux = false}) {
    return Trait(
      name: 'Fire',
      level: level,
      isAux: isAux,
      description: 'When an attack with the Fire:X trait hits, apply damage' +
          ' as normal, then roll XD6. For each die that meets or exceeds a' +
          ' threshold of 4+, apply one additional damage. After this roll' +
          ' there are no further effects.',
    );
  }

  factory Trait.Flak({bool isAux = false}) {
    return Trait(
      name: 'Flak',
      isAux: isAux,
      description: 'Weapons with the Flak trait add a +2D6 modifier to' +
          ' attack rolls targeting elevated VTOLs and airstrike counters.',
    );
  }

  factory Trait.Frag({bool isAux = false}) {
    return Trait(
      name: 'Frag',
      isAux: isAux,
      description: 'Weapons with the Frag trait will add a +2D6 modifier to' +
          ' its attack rolls.',
    );
  }

  factory Trait.Guided({bool isAux = false}) {
    return Trait(
      name: 'Guided',
      isAux: isAux,
      description: 'This weapon has increased accuracy when used for a fire' +
          ' mission with a target designator. See the Target Designator' +
          ' trait.',
    );
  }

  factory Trait.Hands({bool isAux = false}) {
    return Trait(
      name: 'Hands',
      isAux: isAux,
      description: 'This model has additional upgrade options available and' +
          ' limited climbing ability. See Climbing.',
    );
  }

  factory Trait.Haywire({bool isAux = false}) {
    return Trait(
      name: 'Haywire',
      isAux: isAux,
      description: 'When an attack with the Haywire trait hits, apply' +
          ' damage as normal, then place a haywire token next to the model' +
          ' and roll 1D6. On a result of 4 or better, the model takes one' +
          ' additional damage.\n' +
          'A model with a haywired token counts as' +
          ' being haywired and suffers -1D6 on all PI, GU and EW rolls for' +
          ' the rest of the round. Haywired tokens are removed during the' +
          ' cleanup phase. A Haywired token may not be removed by the patch' +
          ' action.',
    );
  }

  factory Trait.Jetpack(int level, {bool isAux = false}) {
    return Trait(
      name: 'Jetpack',
      level: level,
      isAux: isAux,
      description: 'This model can launch into the air, replacing a normal' +
          'Move with a jetpack move.\n' +
          '* You must move in a straight line horizontally up to X inches.\n' +
          '* You may only turn the model before or after completing a' +
          ' jetpack move.\n' +
          '* You may only perform Actions before or after completing a' +
          ' jetpack move.\n' +
          '* Move over walls, or on to and off of elevations up to X inches' +
          ' in height without climbing.\n' +
          '* Ignore difficult and dangerous ground during the middle of' +
          ' your jetpack move. Difficult or dangerous ground only applies' +
          ' if you finish a jetpack move on such terrain.',
    );
  }

  factory Trait.JumpJets(int level, {bool isAux = false}) {
    return Trait(
      name: 'Jump Jets',
      level: level,
      isAux: isAux,
      description: 'This model can execute a powered jump over obstacles' +
          ' while using another movement type. You may not perform Actions' +
          ' in the middle of a jump.\n' +
          '* Jump over walls, or on to and off of elevations, up to X ' +
          ' inches in height without climbing.',
    );
  }

  factory Trait.L({bool isAux = false}) {
    return Trait(
      name: 'L',
      isAux: isAux,
      description: 'A weapon with this trait can only be fired at targets' +
          ' within this model’s left arc (the left 180 degrees of the' +
          ' model).',
    );
  }

  factory Trait.LA(int level, {bool isAux = false}) {
    return Trait(
      name: 'LA',
      level: level,
      isAux: isAux,
      description: 'Weapons with the LA:X trait may only be fired X times' +
          ' before running out of ammunition. Mark this model with a token' +
          ' to indicate the ammunition remaining.',
    );
  }

  factory Trait.Link({bool isAux = false}) {
    return Trait(
      name: 'Link',
      isAux: isAux,
      description: 'Weapons with the Link trait add a +1D6 modifier to any' +
          ' attack roll made with this weapon.',
    );
  }

  factory Trait.Lumbering({bool isAux = false}) {
    return Trait(
      name: 'Lumbering',
      isAux: isAux,
      description: 'This model does not receive the +1D6 defense roll' +
          ' modifier for being at top speed.',
    );
  }

  factory Trait.Medic({bool isAux = false}) {
    return Trait(
      name: 'Medic',
      isAux: isAux,
      description: 'Medics may use the patch action. A medic may not use an' +
          ' attack action, be a forward observer, use ECM or ECCM traits' +
          ' for ECM attacks, ECM jamming and firewalls, or perform detailed' +
          ' scans. However, they may retaliate if they are fired upon. A' +
          ' medic may not capture objectives, be an objective, or be any' +
          ' type of leader or commander.\nWhen a medic is the primary' +
          ' target of an attack, immediately mark the attacking model with' +
          ' a token. All attacks on this marked model receive a free' +
          ' reroll. Remove this token during the cleanup phase.',
    );
  }

  factory Trait.Mine(int level, {bool isAux = false}) {
    return Trait(
      name: 'Mine',
      level: level,
      isAux: isAux,
      description: 'A model with the Mine:X trait may plant mines on the' +
          ' battlefield. The model has X number of mines. Planted mines use' +
          ' 40mm round markers or bases. See Mines and Minefields for how' +
          ' models take damage from mines and Plant Mine for how carry out' +
          ' the Action of planting mines.',
    );
  }

  factory Trait.Occupancy(int level, String type, {bool isAux = false}) {
    return Trait(
      name: 'Occupancy',
      level: level,
      type: type,
      isAux: isAux,
      description: 'The Occupancy:X trait is used during deployment.' +
          ' Buildings with this trait will specify the type and amount of' +
          ' other models which may be inside it during its deployment. By' +
          ' default, this trait also lets you know how many models can fit' +
          ' inside a building sold by DP9. Squads: This model may hold up' +
          ' to X infantry squads.\n' +
          '* 3 Infantry teams, infantry singles, or drones may be' +
          ' substituted in place of one infantry squad.\n' +
          'Models do not have to spend any actions in order to enter or' +
          ' exit a building.',
    );
  }

  factory Trait.Offroad({bool isAux = false}) {
    return Trait(
      name: 'Offroad',
      isAux: isAux,
      description: 'Models with this trait may travel over difficult' +
          ' surfaces at their full MR. This does not apply to water terrain' +
          ' and does not benefit climbing.',
    );
  }

  factory Trait.Or() {
    return const Trait(
      name: 'Or',
      description: 'This trait is always accompanied by multiple ammunition' +
          ' types or additional firing modes. The player must choose' +
          ' one type to use when attacking.',
    );
  }

  factory Trait.Precise({bool isAux = false}) {
    return Trait(
      name: 'Precise',
      isAux: isAux,
      description: 'Ranged weapons with the Precise trait add +1 to the' +
          ' result rolled (+1 R) when in optimal range.\n' +
          'Melee weapons with the Precise trait add +1 to the result rolled' +
          ' (+1 R).\n' +
          'Multiple sources of Precise are not cumulative.',
    );
  }

  factory Trait.Proximity({bool isAux = false}) {
    return Trait(
      name: 'Proximity',
      isAux: isAux,
      description: 'Weapons with the Prox trait may be used to perform a' +
          ' direct attack against all models around this model, within the' +
          ' weapon’s listed range.\n' +
          '* All possible targets (friend or foe) are considered primary' +
          ' targets.\n' +
          '* This weapon cannot be used to attack elevated VTOLs unless the' +
          ' model using it is also an elevated VTOL.\n' +
          '* Elevated VTOLs cannot use this weapon to attack non-elevated' +
          ' VTOLs.\n' +
          '* This weapon cannot be used to attack buildings, terrain or' +
          ' area terrain.',
    );
  }

  factory Trait.R({bool isAux = false}) {
    return Trait(
      name: 'R',
      isAux: isAux,
      description: 'A weapon with this trait can only be fired at targets' +
          ' within this model’s right arc (the right 180 degrees of the' +
          ' model).',
    );
  }

  factory Trait.Reach(int level, {bool isAux = false}) {
    return Trait(
      name: 'Reach',
      level: level,
      isAux: isAux,
      description: 'This melee weapon can attack a target X inches from' +
          ' its base. This is not a ranged attack',
    );
  }

  factory Trait.React({bool isAux = false}) {
    return Trait(
      name: 'React',
      isAux: isAux,
      description: 'Weapons listed under the React Weapons Column of' +
          ' a model table are considered to have the React trait. A weapon' +
          ' with this trait can be used for retaliations.',
    );
  }

  factory Trait.ReactPlus({bool isAux = false}) {
    return Trait(
      name: 'React+',
      isAux: isAux,
      description: 'This model may perform a Reaction once per round' +
          ' without spending an action point.\n' +
          'You may also use this trait to focus. To focus, spend 1' +
          ' additional action point, or sacrifice your React+ trait for' +
          ' the round to gain a +1D6 modifier to one direct attack or melee' +
          ' attack. This cannot be used for indirect attacks.',
    );
  }

  factory Trait.Repair({bool isAux = false}) {
    return Trait(
      name: 'Repair',
      isAux: isAux,
      description: 'This model may use the patch action.',
    );
  }

  factory Trait.ResistC({bool isAux = false}) {
    return Trait(
      name: 'Resist',
      type: 'C',
      isAux: isAux,
      description: 'This model does not receive the extra damage that comes' +
          ' from the Corrosion trait.',
    );
  }

  factory Trait.ResistF({bool isAux = false}) {
    return Trait(
      name: 'Resist',
      type: 'F',
      isAux: isAux,
      description: 'This model does not receive the extra damage that comes' +
          ' from the Fire trait.',
    );
  }

  factory Trait.ResistH({bool isAux = false}) {
    return Trait(
      name: 'Resist',
      type: 'H',
      isAux: isAux,
      description: 'This model does not roll for additional damage after' +
          ' being haywired. However, it still suffers the haywired status.',
    );
  }

  factory Trait.SatUp({bool isAux = false}) {
    return Trait(
      name: 'SatUp',
      isAux: isAux,
      description: 'Increase this model’s EW skill by one for all independent' +
          ' EW rolls. This is not cumulative with additional SatUps.',
    );
  }

  factory Trait.SensorBoom({bool isAux = false}) {
    return Trait(
      name: 'Sensor Boom',
      isAux: isAux,
      description: 'This model may check LOS and sensor lock from a point up' +
          ' to 1” away from its silhouette. This only applies to indirect' +
          ' attacks, forward observations, ECM attacks, ECM jamming and' +
          ' detailed scan actions.',
    );
  }

  factory Trait.Sensors(int level, {bool isAux = false}) {
    return Trait(
      name: 'Sensors',
      level: level,
      isAux: isAux,
      description: 'This model has two features in addition to the regular' +
          ' sensor rules noted in the Sensor Lock Chapter.\n' +
          '* This model has a sensor range of “X” inches.\n' +
          '* Models in formation may use this model’s sensor locks for ranged' +
          ' attacks.',
    );
  }

  factory Trait.Shield({bool isAux = false}) {
    return Trait(
      name: 'Shield',
      isAux: isAux,
      description: 'This model may reroll defense rolls if the attack' +
          ' originated from within its front arc.',
    );
  }

  factory Trait.ShieldPlus({bool isAux = false}) {
    return Trait(
      name: 'Shield+',
      isAux: isAux,
      description: 'This model may reroll defense rolls if the attack' +
          ' originated from within its front arc. Shield+ also adds +1D6 to' +
          ' defensive rolls from attacks originating from the front arc. The' +
          ' Shield+ trait may not be stacked with cover modifiers.',
    );
  }

  factory Trait.Silent({bool isAux = false}) {
    return Trait(
      name: 'Silent',
      isAux: isAux,
      description: 'Models do not lose the hidden status when attacking with' +
          ' a weapon that has the Silent trait.',
    );
  }

  factory Trait.Smoke({bool isAux = false}) {
    return Trait(
      name: 'Smoke',
      isAux: isAux,
      description: 'A model with the Smoke trait may spend an action point to' +
          ' discharge smoke. See Discharge Smoke.',
    );
  }

  factory Trait.SP(int level, {bool isAux = false}) {
    return Trait(
      name: 'SP',
      level: level,
      isAux: isAux,
      description: 'This model will gain one Skill Point (SP) in addition to' +
          ' any it may have from other sources. If the model is a commander,' +
          ' it will instead gain one Command Point (CP).',
    );
  }

  factory Trait.Split({bool isAux = false}) {
    return Trait(
      name: 'Split',
      isAux: isAux,
      description: 'When attacking with this weapon, this model may target' +
          ' two separate models.\n' +
          '* Treat each target as a primary target.\n' +
          '* Targets must be within 6 inches of each other.\n' +
          '* The attacker suffers -1D6 on each attack roll.',
    );
  }

  factory Trait.Spray({bool isAux = false}) {
    return Trait(
      name: 'Spray',
      isAux: isAux,
      description: 'Models attacked with this weapon do not gain defense' +
          ' modifiers from partial cover. This weapon cannot be fired through' +
          ' full light cover.',
    );
  }

  factory Trait.Stable({bool isAux = false}) {
    return Trait(
      name: 'Stable',
      isAux: isAux,
      description: 'This model receives +1D6 to direct and indirect attack' +
          ' rolls while at combat speed or at top speed.\nMultiple sources of' +
          ' Stable are not cumulative.',
    );
  }

  factory Trait.Stationary({bool isAux = false}) {
    return Trait(
      name: 'Stationary',
      isAux: isAux,
      description: 'This model is always braced, cannot move or turn, and may' +
          ' not perform hide actions or evade reactions.',
    );
  }

  factory Trait.Stealth({bool isAux = false}) {
    return Trait(
      name: 'Stealth',
      isAux: isAux,
      description: 'Enemy models cannot sensor lock this model until it is' +
          ' within half their sensor range. For example, a model with a' +
          ' standard sensor range of 18 inches can only sensor lock a model' +
          ' with the Stealth trait at 9 inches or less.',
    );
  }

  factory Trait.Sub({bool isAux = false}) {
    return Trait(
      name: 'Sub',
      isAux: isAux,
      description: 'This model uses its full MR through water. While in' +
          ' water, this model has partial cover.\n' +
          'Models with the Sub trait may also used the submerged deployment' +
          ' option. See Submerged Deployment.',
    );
  }

  factory Trait.Supply({bool isAux = false}) {
    return Trait(
      name: 'Supply',
      isAux: isAux,
      description: 'Models with this trait may use the reload action to' +
          ' replenish ammunition for a weapon with the LA:X trait. See the' +
          ' Reload action.',
    );
  }

  factory Trait.TD({bool isAux = false}) {
    return Trait(
      name: 'TD',
      isAux: isAux,
      description: 'A target designator is a precision laser marking device' +
          ' which steers guided weapons to a target.\n' +
          'In order to designate a target with the TD trait, a model must' +
          ' successfully perform a forward observation action with LOS and' +
          ' sensor lock.\n' +
          'After the forward observation, fire missions using guided weapons' +
          ' receive +1D6 on the attack roll in addition to the standard +1D6' +
          ' bonus from the forward observation. Both bonuses apply against' +
          ' the primary target only.',
    );
  }

  factory Trait.Towed({bool isAux = false}) {
    return Trait(
      name: 'Towed',
      isAux: isAux,
      description: 'One model with this trait may be towed behind a gear,' +
          ' strider or vehicle with the W or G movement type. Models with' +
          ' the VTOL trait cannot be used to tow. Towing uses all the rules' +
          ' associated with transports with the following exceptions:\n' +
          '* The towing model cannot move more than 6 inches for each move.\n' +
          '* The towed model is placed behind the model towing it, facing' +
          ' aft. It does not go inside a transport.\n' +
          '* The towed model may be attacked normally.\n' +
          '* The towed model cannot perform any Actions while it is being towed.',
    );
  }

  factory Trait.Transport(int level, String type, {bool isAux = false}) {
    return Trait(
      name: 'Transport',
      level: level,
      type: type,
      isAux: isAux,
      description: 'Models with this trait will specify the amount (X) and' +
          ' type of other models which they are able to transport.\n' +
          'Types:\n' +
          '* X Drones: This model may transport X number of universal drones.' +
          '\n* X Squads: This model may transport up to X number of infantry' +
          ' squads.\n' +
          ' > 3 infantry teams, infantry singles, or drones may be' +
          ' transported in place of one infantry squad.\n' +
          '* X Gears: This model may transport X number of gears or X number' +
          ' of infantry squads.\n' +
          ' > 3 infantry teams, infantry singles, or 3 drones may be' +
          ' transported instead of one gear.\n' +
          'Models of the correct type may embark onto or disembark from a' +
          ' transport during the transport’s activation. Individual models' +
          ' cannot embark and disembark on the same round.',
    );
  }

  factory Trait.T({bool isAux = false}) {
    return Trait(
      name: 'T',
      isAux: isAux,
      description: 'A turret mounted weapon has 360 degree rotation and can' +
          ' be used to fire within any arc. Turrets do not remove the back' +
          ' arc modifier when this model is attacked.',
    );
  }

  factory Trait.Vet({bool isAux = false}) {
    return Trait(
      name: 'Vet',
      isAux: isAux,
      description: 'This model is considered a veteran. It has one Skill' +
          ' Point(SP) and may purchase upgrades from the standard and' +
          ' veteran upgrade lists.',
    );
  }

  factory Trait.VTOL({bool isAux = false}) {
    return Trait(
      name: 'VTOL',
      isAux: isAux,
      description: 'VTOLs like helicopters and hoppers can take to the air.' +
          ' Once per Move, models with the VTOL trait may choose whether to' +
          ' be elevated or at Nap Of the Earth (NOE).\n' +
          'NOE: While at NOE a model moves using the hover movement type, or' +
          ' any other movement type that is available to that model.',
    );
  }

  factory Trait.VulnC() {
    return const Trait(
      name: 'Vuln',
      type: 'C',
      description: 'This model automatically suffers damage from the' +
          ' Corrosion trait without a roll.',
    );
  }

  factory Trait.VulnF() {
    return const Trait(
      name: 'Vuln',
      type: 'F',
      description: 'This model automatically suffers damage from the' +
          ' Fire trait without a roll.',
    );
  }

  factory Trait.VulnH() {
    return const Trait(
      name: 'Vuln',
      type: 'H',
      description: 'This model automatically suffers damage from the Haywire' +
          ' trait and ECM attacks without a roll.',
    );
  }
}
