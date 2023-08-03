final traitNameMatch = RegExp(r'^([a-zA-Z +]+)', caseSensitive: false);
final auxMatch = RegExp(r'(Aux)', caseSensitive: false);
final levelMatch = RegExp(
  r':([+-]?\d+)',
);
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
          ' to the result rolled (+1 R)',
    );
  }

  factory Trait.AOE(int level) {
    return Trait(
      name: 'AOE',
      level: level,
      description: 'Weapons with the AOE:X trait may be used to attack an ' +
          ' area with a radius of X inches around a target point.',
    );
  }

  factory Trait.Agile() {
    return const Trait(
      name: 'Agile',
      description: 'Attacks targeting this model will miss on a margin' +
          ' of success of zero',
    );
  }

  factory Trait.AI() {
    return const Trait(
      name: 'AI',
      description: 'Weapons with the AI trait may deal more than two damage' +
          ' to infantry on a successful attack. These weapons also' +
          ' have a bonus of +1D6 against infantry and cavalry models.',
    );
  }

  factory Trait.Airdrop() {
    return const Trait(
      name: 'Airdrop',
      description: 'Combat groups composed entirely of models with the' +
          ' Airdrop trait may deploy using the airdrop deployment' +
          ' option. See Airdrop Deployment.',
    );
  }

  factory Trait.Amphib() {
    return const Trait(
      name: 'Amphib',
      description: 'This model may move over water terrain at its full MR.',
    );
  }

  factory Trait.AMS() {
    return const Trait(
      name: 'AMS',
      description: 'This model may reroll defense rolls against all' +
          ' indirect attacks and airstrikes.',
    );
  }

  factory Trait.Apex() {
    return const Trait(
      name: 'Apex',
      description: 'Add +1 to this weapon’s base damage. Multiple sources' +
          ' of Apex are cumulative.',
    );
  }

  factory Trait.AP(int level) {
    return Trait(
      name: 'AP',
      level: level,
      description: 'Armor piercing weapons are able to do damage on a' +
          ' successful attack even when the damage does not exceed' +
          ' the enemy’s armor.',
    );
  }

  factory Trait.Auto() {
    return const Trait(
      name: 'Auto',
      description: 'A weapon with this trait may be used for retaliation' +
          ' once per round without spending an action point. If this is a' +
          ' combination weapon, then only one of the weapons may' +
          ' be used in this way per round.',
    );
  }

  factory Trait.B() {
    return const Trait(
      name: 'B',
      description: 'Weapons with this trait can only be fired at targets' +
          ' within this model’s back arc (the back 180 degrees of the' +
          ' model).',
    );
  }

  factory Trait.Blast() {
    return const Trait(
      name: 'Blast',
      description: '* If an attacking model has LOS to a target, indirect' +
          ' attacks with this weapon ignore the bonus defense' +
          ' dice for cover.\n' +
          '* A fire mission may also receive this benefit if the' +
          ' forward observer, or the attacking model has LOS to' +
          ' the target(s).',
    );
  }

  factory Trait.Brace() {
    return const Trait(
      name: 'Brace',
      description: 'This weapon may only be fired if the model is braced.',
    );
  }

  factory Trait.Brawl(int level) {
    return Trait(
      name: 'Brawl',
      level: level,
      description: '* A Brawl:X trait on a weapon will modify attack rolls' +
          ' by XD6 when using that weapon.\n' +
          '* A Brawl:X trait on a model will modify all melee rolls' +
          ' that model makes by XD6.',
    );
  }

  factory Trait.Burst(int level) {
    return Trait(
      name: 'Burst',
      level: level,
      description: 'Add a +XD6 modifier to any attack roll made with this' +
          ' weapon (generally +1D6 or +2D6).',
    );
  }

  factory Trait.Climber() {
    return const Trait(
      name: 'Climber',
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

  factory Trait.Conscript() {
    return const Trait(
      name: 'Conscript',
      description: 'If this model is not in formation with a commander, all' +
          ' of its skills are +1 TN. This model may not be a commander and' +
          ' commanders may never take upgrades that give them the Conscript' +
          ' trait. Models with the Conscript trait may not be upgraded with' +
          ' the Vet trait.',
    );
  }

  factory Trait.CBS() {
    return const Trait(
      name: 'CBS',
      description: 'A model with the CBS trait may use a counterstrike' +
          ' reaction. See Counterstrike (Reaction).',
    );
  }

  factory Trait.Comms() {
    return const Trait(
      name: 'Comms',
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

  factory Trait.Corrosion() {
    return const Trait(
      name: 'Corrosion',
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

  factory Trait.Demo(int level) {
    return Trait(
      name: 'Demo',
      level: level,
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

  factory Trait.ECM() {
    return const Trait(
      name: 'ECM',
      description: 'This model possesses an electronic counter-measure' +
          ' system. A model with this trait may use the following trait' +
          ' enabled actions and reactions:\n' +
          '* ECM Jam\n' +
          '* ECM Attack\n' +
          '* ECM Defense\n',
    );
  }

  factory Trait.ECMPlus() {
    return const Trait(
      name: 'ECM+',
      description: 'This model has an enhanced electronic counter-measure' +
          ' system. A model with the ECM+ trait performs all functions of' +
          ' the ECM trait, but its ECM defense is always in effect unless' +
          ' it is haywired.',
    );
  }

  factory Trait.ECCM() {
    return const Trait(
      name: 'ECCM',
      description: 'This model is equipped with an electronic' +
          ' counter-countermeasure system. This model and all friendly' +
          ' models within 6 inches gain +1D6 to all EW rolls. This effect' +
          ' is not cumulative with additional ECCM traits.\n' +
          'Models with the ECCM trait can also perform ECCM firewall' +
          ' reactions.',
    );
  }

  factory Trait.FieldArmor() {
    return const Trait(
      name: 'Field Armor',
      description: 'This model suffers one less damage from each attack to' +
          ' a minimum of one damage. Field Armor reduces damage from the' +
          ' Armor Piercing trait, but it does not apply to other effects' +
          ' such as Fire, Corrosion or Haywire.',
    );
  }

  factory Trait.Fire(int level) {
    return Trait(
      name: 'Fire',
      level: level,
      description: 'When an attack with the Fire:X trait hits, apply damage' +
          ' as normal, then roll XD6. For each die that meets or exceeds a' +
          ' threshold of 4+, apply one additional damage. After this roll' +
          ' there are no further effects.',
    );
  }

  factory Trait.Flak() {
    return const Trait(
      name: 'Flak',
      description: 'Weapons with the Flak trait add a +2D6 modifier to' +
          ' attack rolls targeting elevated VTOLs and airstrike counters.',
    );
  }

  factory Trait.Frag() {
    return const Trait(
      name: 'Frag',
      description: 'Weapons with the Frag trait will add a +2D6 modifier to' +
          ' its attack rolls.',
    );
  }

  factory Trait.Guided() {
    return const Trait(
      name: 'Guided',
      description: 'This weapon has increased accuracy when used for a fire' +
          ' mission with a target designator. See the Target Designator' +
          ' trait.',
    );
  }

  factory Trait.Hands() {
    return const Trait(
      name: 'Hands',
      description: 'This model has additional upgrade options available and' +
          ' limited climbing ability. See Climbing.',
    );
  }

  factory Trait.Haywire() {
    return const Trait(
      name: 'Haywire',
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

  factory Trait.Jetpack(int level) {
    return Trait(
      name: 'Jetpack',
      level: level,
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

  factory Trait.JumpJets(int level) {
    return Trait(
      name: 'Jump Jets',
      level: level,
      description: 'This model can execute a powered jump over obstacles' +
          ' while using another movement type. You may not perform Actions' +
          ' in the middle of a jump.\n' +
          '* Jump over walls, or on to and off of elevations, up to X ' +
          ' inches in height without climbing.',
    );
  }

  factory Trait.LA(int level) {
    return Trait(
      name: 'LA',
      level: level,
      description: 'Weapons with the LA:X trait may only be fired X times' +
          ' before running out of ammunition. Mark this model with a token' +
          ' to indicate the ammunition remaining.',
    );
  }

  factory Trait.Link() {
    return const Trait(
      name: 'Link',
      description: 'Weapons with the Link trait add a +1D6 modifier to any' +
          ' attack roll made with this weapon.',
    );
  }

  factory Trait.Lumbering() {
    return const Trait(
      name: 'Lumbering',
      description: 'This model does not receive the +1D6 defense roll' +
          ' modifier for being at top speed.',
    );
  }

  factory Trait.Medic() {
    return const Trait(
      name: 'Medic',
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

  factory Trait.Mine(int level) {
    return Trait(
      name: 'Mine',
      level: level,
      description: 'A model with the Mine:X trait may plant mines on the' +
          ' battlefield. The model has X number of mines. Planted mines use' +
          ' 40mm round markers or bases. See Mines and Minefields for how' +
          ' models take damage from mines and Plant Mine for how carry out' +
          ' the Action of planting mines.',
    );
  }

  factory Trait.Occupancy(int level, String type) {
    return Trait(
      name: 'Occupancy',
      level: level,
      type: type,
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

  factory Trait.Offroad() {
    return const Trait(
      name: 'Offroad',
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

  factory Trait.Precise() {
    return const Trait(
      name: 'Precise',
      description: 'Ranged weapons with the Precise trait add +1 to the' +
          ' result rolled (+1 R) when in optimal range.\n' +
          'Melee weapons with the Precise trait add +1 to the result rolled' +
          ' (+1 R).\n' +
          'Multiple sources of Precise are not cumulative.',
    );
  }

  factory Trait.Proximity() {
    return const Trait(
      name: 'Proximity',
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

  factory Trait.R() {
    return const Trait(
      name: 'R',
      description: 'A weapon with this trait can only be fired at targets' +
          ' within this model’s right arc (the right 180 degrees of the' +
          ' model).',
    );
  }

  factory Trait.Reach(int level) {
    return Trait(
      name: 'Reach',
      level: level,
      description: 'This melee weapon can attack a target X inches from' +
          ' its base. This is not a ranged attack',
    );
  }

  factory Trait.React() {
    return const Trait(
      name: 'React',
      description: 'Weapons listed under the React Weapons Column of' +
          ' a model table are considered to have the React trait. A weapon' +
          ' with this trait can be used for retaliations.',
    );
  }

  factory Trait.ReactPlus() {
    return const Trait(
      name: 'React+',
      description: 'This model may perform a Reaction once per round' +
          ' without spending an action point.\n' +
          'You may also use this trait to focus. To focus, spend 1' +
          ' additional action point, or sacrifice your React+ trait for' +
          ' the round to gain a +1D6 modifier to one direct attack or melee' +
          ' attack. This cannot be used for indirect attacks.',
    );
  }

  factory Trait.Repair() {
    return const Trait(
      name: 'Repair',
      description: 'This model may use the patch action.',
    );
  }

  factory Trait.ResistC() {
    return const Trait(
      name: 'Resist',
      type: 'C',
      description: 'This model does not receive the extra damage that comes' +
          ' from the Corrosion trait.',
    );
  }

  factory Trait.ResistF() {
    return const Trait(
      name: 'Resist',
      type: 'F',
      description: 'This model does not receive the extra damage that comes' +
          ' from the Fire trait.',
    );
  }

  factory Trait.ResistH() {
    return const Trait(
      name: 'Resist',
      type: 'H',
      description: 'This model does not roll for additional damage after' +
          ' being haywired. However, it still suffers the haywired status.',
    );
  }

  factory Trait.SatUp() {
    return const Trait(
      name: 'SatUp',
      description: 'Increase this model’s EW skill by one for all independent' +
          ' EW rolls. This is not cumulative with additional SatUps.',
    );
  }

  factory Trait.SensorBoom() {
    return const Trait(
      name: 'Sensor Boom',
      description: 'This model may check LOS and sensor lock from a point up' +
          ' to 1” away from its silhouette. This only applies to indirect' +
          ' attacks, forward observations, ECM attacks, ECM jamming and' +
          ' detailed scan actions.',
    );
  }

  factory Trait.Sensors(int level) {
    return Trait(
      name: 'Sensors',
      level: level,
      description: 'This model has two features in addition to the regular' +
          ' sensor rules noted in the Sensor Lock Chapter.\n' +
          '* This model has a sensor range of “X” inches.\n' +
          '* Models in formation may use this model’s sensor locks for ranged' +
          ' attacks.',
    );
  }

  factory Trait.Shield() {
    return const Trait(
      name: 'Shield',
      description: 'This model may reroll defense rolls if the attack' +
          ' originated from within its front arc.',
    );
  }

  factory Trait.ShieldPlus() {
    return const Trait(
      name: 'Shield+',
      description: 'This model may reroll defense rolls if the attack' +
          ' originated from within its front arc. Shield+ also adds +1D6 to' +
          ' defensive rolls from attacks originating from the front arc. The' +
          ' Shield+ trait may not be stacked with cover modifiers.',
    );
  }

  factory Trait.Silent() {
    return const Trait(
      name: 'Silent',
      description: 'Models do not lose the hidden status when attacking with' +
          ' a weapon that has the Silent trait.',
    );
  }

  factory Trait.Smoke() {
    return const Trait(
      name: 'Smoke',
      description: 'A model with the Smoke trait may spend an action point to' +
          ' discharge smoke. See Discharge Smoke.',
    );
  }

  factory Trait.SP(int level) {
    return Trait(
      name: 'SP',
      level: level,
      description: 'This model will gain one Skill Point (SP) in addition to' +
          ' any it may have from other sources. If the model is a commander,' +
          ' it will instead gain one Command Point (CP).',
    );
  }

  factory Trait.Split() {
    return const Trait(
      name: 'Split',
      description: 'When attacking with this weapon, this model may target' +
          ' two separate models.\n' +
          '* Treat each target as a primary target.\n' +
          '* Targets must be within 6 inches of each other.\n' +
          '* The attacker suffers -1D6 on each attack roll.',
    );
  }

  factory Trait.Spray() {
    return const Trait(
      name: 'Spray',
      description: 'Models attacked with this weapon do not gain defense' +
          ' modifiers from partial cover. This weapon cannot be fired through' +
          ' full light cover.',
    );
  }

  factory Trait.Stable() {
    return const Trait(
      name: 'Stable',
      description: 'This model receives +1D6 to direct and indirect attack' +
          ' rolls while at combat speed or at top speed.\nMultiple sources of' +
          ' Stable are not cumulative.',
    );
  }

  factory Trait.Stationary() {
    return const Trait(
      name: 'Stationary',
      description: 'This model is always braced, cannot move or turn, and may' +
          ' not perform hide actions or evade reactions.',
    );
  }

  factory Trait.Stealth() {
    return const Trait(
      name: 'Stealth',
      description: 'Enemy models cannot sensor lock this model until it is' +
          ' within half their sensor range. For example, a model with a' +
          ' standard sensor range of 18 inches can only sensor lock a model' +
          ' with the Stealth trait at 9 inches or less.',
    );
  }

  factory Trait.Sub() {
    return const Trait(
      name: 'Sub',
      description: 'This model uses its full MR through water. While in' +
          ' water, this model has partial cover.\n' +
          'Models with the Sub trait may also used the submerged deployment' +
          ' option. See Submerged Deployment.',
    );
  }

  factory Trait.Supply() {
    return const Trait(
      name: 'Supply',
      description: 'Models with this trait may use the reload action to' +
          ' replenish ammunition for a weapon with the LA:X trait. See the' +
          ' Reload action.',
    );
  }

  factory Trait.TD() {
    return const Trait(
      name: 'TD',
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

  factory Trait.Towed() {
    return const Trait(
      name: 'Towed',
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

  factory Trait.Transport(int level, String type) {
    return Trait(
      name: 'Transport',
      level: level,
      type: type,
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

  factory Trait.T() {
    return const Trait(
      name: 'T',
      description: 'A turret mounted weapon has 360 degree rotation and can' +
          ' be used to fire within any arc. Turrets do not remove the back' +
          ' arc modifier when this model is attacked.',
    );
  }

  factory Trait.Vet() {
    return const Trait(
      name: 'Vet',
      description: 'This model is considered a veteran. It has one Skill' +
          ' Point(SP) and may purchase upgrades from the standard and' +
          ' veteran upgrade lists.',
    );
  }

  factory Trait.VTOL() {
    return const Trait(
      name: 'VTOL',
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
