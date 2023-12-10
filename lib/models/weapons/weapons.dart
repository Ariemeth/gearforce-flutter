import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/weapons/range.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';

final weaponMatch =
    RegExp(r'^((?<number>[2-9]) [xX] )?(?<size>[LMH])(?<type>[a-zA-Z]+)');
final comboMatch = RegExp(r'(?<combo>[\/])(?<code>[a-zA-Z]+)');
final traitsMatch = RegExp(r'\((?<traits>[a-zA-Z :0-9]+)\)$');

Weapon? buildWeapon(
  String weaponString, {
  bool hasReact = false,
}) {
  if (!weaponMatch.hasMatch(weaponString)) {
    print('buildWeapon: $weaponString does not match');
    return null;
  }

  final weaponCheck = weaponMatch.firstMatch(weaponString);
  if (weaponCheck == null || weaponCheck.groupCount < 2) {
    print(
        'weapon check failed for $weaponString with ${weaponCheck?.groupCount} groups');
    return null;
  }

  final String size = weaponCheck.namedGroup('size')!;
  final String type = weaponCheck.namedGroup('type')!;
  final String? numberOf = weaponCheck.namedGroup('number');
  final String? bonusString =
      traitsMatch.firstMatch(weaponString)?.namedGroup('traits');
  final List<Trait> bonusTraits = [];
  final bt = bonusString?.split(' ').map((e) => Trait.fromString(e)).toList();
  if (bt != null) {
    bonusTraits.addAll(bt);
  }

  String? comboType;
  String? comboSize;
  final comboName = comboMatch.firstMatch(weaponString)?.namedGroup('code');
  if (comboName != null) {
    final comboWeaponCheck = weaponMatch.firstMatch(comboName);
    comboType = comboWeaponCheck?.namedGroup('type');
    comboSize = comboWeaponCheck?.namedGroup('size');
  }

  final generatedWeapon = _buildWeapon(
    size: size,
    type: type,
    numberOf: numberOf,
    bonusTraits: bonusTraits,
    hasReact: hasReact,
    comboType: comboType,
    comboSize: comboSize,
  );
  if (generatedWeapon == null) {
    print('Unknown weapon [$weaponString], bonusTraits [$bonusTraits]');
  }
  return generatedWeapon;
}

Weapon? _buildWeapon({
  required String size,
  required String type,
  required String? numberOf,
  required List<Trait> bonusTraits,
  String? comboType,
  String? comboSize,
  bool hasReact = false,
}) {
  String name = '';
  List<weaponModes> modes = [];
  int damage = -1;
  Range range = Range(0, 1, 2);
  List<Trait> traits = [];
  List<Trait> alternativeTraits = [];

  assert(size == 'L' || size == 'M' || size == 'H' || size.isEmpty);

  switch (type.toUpperCase()) {
    case 'AAM':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Anti-Air Missile';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(12, 36, 72);
      traits = [
        Trait.Flak(),
        Trait.Guided(),
      ];
      break;
    case 'ABM':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Air Burst Missile';
      modes = [weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(24, 48, 96);
      traits = [
        Trait.AI(),
        Trait.AOE(3),
        Trait.Blast(),
        Trait.Guided(),
      ];
      break;
    case 'AC':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Autocannon';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 18, 36);
      traits = [
        Trait.Burst(1),
        Trait.Split(),
      ];
      alternativeTraits = [Trait.Precise()];
      break;
    case 'AG':
      const damageMap = {'L': 9, 'M': 10, 'H': 11};
      name = 'Artillery Gun';
      modes = [weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(24, 48, 96);
      traits = [
        Trait.AOE(3),
        Trait.Blast(),
        Trait.AP(1),
        Trait.Demo(2),
      ];
      break;
    case 'AM':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Artillery Missile';
      modes = [weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(24, 48, 96);
      traits = [
        Trait.AOE(4),
        Trait.Blast(),
        Trait.AP(1),
        Trait.Guided(),
      ];
      break;
    case 'APGL':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Anti-Per Grenade Launchers';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(0, 3, null);
      traits = [
        Trait.AI(),
        Trait.Frag(),
        Trait.Proximity(),
      ];
      break;
    case 'APR':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Anti-Personnel Rockets';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(6, 18, 36);
      traits = [
        Trait.AI(),
        Trait.AOE(3),
      ];
      break;
    case 'AR':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Artillery Rockets';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(12, 36, 72);
      traits = [
        Trait.AOE(3),
        Trait.Demo(2),
      ];
      break;
    case 'ATM':
      const damageMap = {'L': 8, 'M': 9, 'H': 10};
      const apMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Anti-Tank Missile';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(12, 36, 72);
      traits = [
        Trait.AP(apMap[size]!),
        Trait.Guided(),
      ];
      break;
    case 'AVM':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Anti-Vehicle Missile';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(6, 18, 36);
      traits = [
        Trait.AP(1),
        Trait.Guided(),
      ];
      break;
    case 'B':
      name = 'Bomb';
      modes = [weaponModes.Direct];
      damage = 8;
      range = Range(0, null, null);
      traits = [Trait.AOE(4)];
      break;
    case 'BZ':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      const apMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Bazooka';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 12, 24);
      traits = [
        Trait.AP(apMap[size]!),
      ];
      break;
    case 'CW':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Combat Weapon';
      modes = [weaponModes.Melee];
      damage = damageMap[size]!;
      range = Range(0, null, null, hasReach: true, increasableReach: true);
      traits = [
        Trait.Demo(2),
      ];
      break;
    case 'FC':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      const apMap = {'L': 1, 'M': 2, 'H': 3};
      name = 'Frag Cannon';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(3, 9, 18);
      traits = [
        Trait.Precise(),
        Trait.AP(apMap[size]!),
      ];
      alternativeTraits = [
        Trait.Frag(),
        Trait.AI(),
      ];
      break;
    case 'FG':
      const damageMap = {'L': 9, 'M': 10, 'H': 11};
      const apMap = {'L': 3, 'M': 4, 'H': 5};
      name = 'Field Gun';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(12, 24, 48);
      traits = [
        Trait.AP(apMap[size]!),
      ];
      alternativeTraits = [
        Trait.AOE(3),
        Trait.Blast(),
      ];
      break;
    case 'FL':
      const damageMap = {'L': 3, 'M': 4, 'H': 5};
      const fireMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Flamer';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(0, 9, 18);
      traits = [
        Trait.AI(),
        Trait.Fire(fireMap[size]!),
        Trait.Burst(1),
        Trait.Spray(),
      ];
      break;
    case 'FM':
      const damageMap = {'L': 8, 'M': 9, 'H': 10};
      name = 'Field Mortar';
      modes = [weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(18, 36, 72);
      traits = [
        Trait.AOE(4),
        Trait.Blast(),
      ];
      break;
    case 'GL':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Grenade Launcher';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(6, 12, 24);
      traits = [
        Trait.AOE(3),
        Trait.Blast(),
        Trait.AP(1),
        Trait.Burst(1),
      ];
      break;
    case 'GM':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Guided Mortar';
      modes = [weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(18, 36, 72);
      traits = [
        Trait.AOE(3),
        Trait.Blast(),
        Trait.Guided(),
      ];
      break;
    case 'HG':
      const damageMap = {'L': 8, 'M': 9, 'H': 10};
      name = 'Hand Grenades';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(3, 6, 9);
      traits = [
        Trait.AOE(3),
        Trait.Blast(),
        Trait.AP(1),
      ];
      break;
    case 'ICW':
      const damageMap = {'L': 4, 'M': 5, 'H': 6};
      name = 'Infantry Combat Weapon';
      modes = [weaponModes.Melee];
      damage = damageMap[size]!;
      range = Range(0, null, null, hasReach: true, increasableReach: true);
      traits = [Trait.AI()];
      break;
    case 'IGL':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Infantry Grenade Launcher';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(3, 9, 18);
      traits = [
        Trait.AOE(2),
        Trait.Blast(),
      ];
      alternativeTraits = [
        Trait.AP(1),
      ];
      break;
    case 'IL':
      const damageMap = {'L': 3, 'M': 4, 'H': 5};
      name = 'Infantry Laser';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 18, 36);
      traits = [
        Trait.AI(),
        Trait.Advanced(),
        Trait.Burst(1),
      ];
      break;
    case 'IM':
      const damageMap = {'L': 4, 'M': 5, 'H': 6};
      name = 'Infantry Mortar';
      modes = [weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(12, 24, 48);
      traits = [
        Trait.AOE(2),
        Trait.Blast(),
        Trait.AI(),
      ];
      break;
    case 'IR':
      const damageMap = {'L': 4, 'M': 5, 'H': 6};
      name = 'Infantry Rifle';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 24, 48);
      traits = [
        Trait.Precise(),
        Trait.AI(),
      ];
      break;
    case 'IS':
      const damageMap = {'L': 4, 'M': 5, 'H': 6};
      name = 'Infantry Support Weapon';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 18, 36);
      traits = [];
      break;
    case 'IW':
      const damageMap = {'L': 3, 'M': 4, 'H': 5};
      name = 'Infantry Weapon';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(0, 9, 18);
      traits = [
        Trait.AI(),
        Trait.Burst(1),
      ];
      break;
    case 'LC':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Laser Cannon';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(12, 36, 72);
      traits = [
        Trait.Precise(),
        Trait.Advanced(),
      ];
      break;
    case 'MG':
      const damageMap = {'L': 3, 'M': 4, 'H': 5};
      name = 'Machine Gun';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(3, 9, 18);
      traits = [
        Trait.AI(),
        Trait.Burst(2),
        Trait.Split(),
      ];
      break;
    case 'P':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Pistol';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(0, 12, 24);
      traits = [
        Trait.Precise(),
      ];
      break;
    case 'PA':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Particle Accelerator';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 24, 48);
      traits = [
        Trait.Haywire(),
        Trait.Advanced(),
      ];
      break;
    case 'PL':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      const apMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Pulse Laser';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 24, 48);
      traits = [
        Trait.Burst(1),
        Trait.Advanced(),
      ];
      alternativeTraits = [
        Trait.AP(apMap[size]!),
        Trait.Apex(),
        Trait.Advanced(),
      ];
      break;
    case 'PZ':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      const apMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Panzerfaust';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(3, 6, 9);
      traits = [
        Trait.AP(apMap[size]!),
      ];
      break;
    case 'RC':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Rotary Cannon';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 18, 36);
      traits = [
        Trait.Burst(2),
        Trait.Split(),
      ];
      break;
    case 'RF':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Rifle';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(12, 36, 72);
      traits = [
        Trait.Precise(),
      ];
      break;
    case 'RG':
      const damageMap = {'L': 4, 'M': 5, 'H': 6};
      const apMap = {'L': 4, 'M': 5, 'H': 6};
      name = 'Railgun';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(12, 48, 96);
      traits = [
        Trait.Precise(),
        Trait.Advanced(),
        Trait.AP(apMap[size]!),
      ];
      break;
    case 'RL':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Rotary Laser';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 18, 36);
      traits = [
        Trait.Advanced(),
        Trait.Burst(2),
        Trait.Split(),
      ];
      break;
    case 'RP':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Rocket Pack';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(6, 18, 36);
      traits = [
        Trait.AOE(3),
        Trait.AP(1),
      ];
      break;
    case 'SC':
      const damageMap = {'L': 8, 'M': 9, 'H': 10};
      const apMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Snub Cannon';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(3, 9, 18);
      traits = [
        Trait.AP(apMap[size]!),
        Trait.Demo(3),
      ];
      break;
    case 'SE':
      const damageMap = {'L': 8, 'M': 9, 'H': 10};
      const apMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Shaped Explosives';
      modes = [weaponModes.Melee];
      damage = damageMap[size]!;
      range = Range(0, null, null, hasReach: true);
      traits = [
        Trait.AP(apMap[size]!),
        Trait.Demo(4),
        Trait.Brawl(-1),
      ];
      break;
    case 'SG':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      const apMap = {'L': 3, 'M': 4, 'H': 5};
      name = 'Spike Gun';
      modes = [weaponModes.Melee];
      damage = damageMap[size]!;
      range = Range(0, null, null, hasReach: true, increasableReach: true);
      traits = [
        Trait.AP(apMap[size]!),
      ];
      break;
    case 'SMG':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Submachine Gun';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(0, 9, 18);
      traits = [
        Trait.Burst(2),
      ];
      break;
    case 'TG':
      const damageMap = {'L': 9, 'M': 10, 'H': 11};
      const apMap = {'L': 3, 'M': 4, 'H': 5};
      name = 'Tank Gun';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(12, 36, 72);
      traits = [
        Trait.AP(apMap[size]!),
        Trait.Demo(2),
      ];
      break;
    case 'VB':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      const apMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Vibroblade';
      modes = [weaponModes.Melee];
      damage = damageMap[size]!;
      range = Range(0, null, null, hasReach: true, increasableReach: true);
      traits = [
        Trait.AP(apMap[size]!),
      ];
      break;
    default:
      if (type.trim().toUpperCase().endsWith('S')) {
        final modifiedType = '${type.substring(0, type.length - 1)}';
        return _buildWeapon(
          size: size,
          type: modifiedType,
          numberOf: numberOf,
          bonusTraits: bonusTraits,
          hasReact: hasReact,
          comboType: comboType,
          comboSize: comboSize,
        );
      } else {
        print('Unknown weapon type: $type.');
      }
      return null;
  }

  Weapon? comboWeapon;
  if (comboType != null && comboSize != null) {
    comboWeapon = _buildWeapon(
      size: comboSize,
      type: comboType,
      numberOf: numberOf,
      bonusTraits: bonusTraits,
      hasReact: hasReact,
    );
  }

  return Weapon(
    abbreviation: '$size$type',
    name: name,
    numberOf: numberOf != null ? int.parse(numberOf) : 1,
    modes: modes,
    range: range,
    damage: damage,
    hasReact: hasReact,
    baseTraits: traits,
    baseAlternativeTraits: alternativeTraits,
    combo: comboWeapon,
    bonusTraits: bonusTraits,
  );
}
