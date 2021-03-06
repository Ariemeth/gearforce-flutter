import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/weapons/range.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';

final weaponMatch =
    RegExp(r'^((?<number>[2-9]) [xX] )?(?<size>[BLMH])(?<type>[a-zA-Z]+)');
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

  switch (type.toUpperCase()) {
    case 'AAM':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Anti-Air Missile';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(12, 36, 72);
      traits = [
        const Trait(name: 'Flak'),
        const Trait(name: 'Guided'),
      ];
      break;
    case 'ABM':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Air Burst Missile';
      modes = [weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(24, 48, 96);
      traits = [
        const Trait(name: 'AI'),
        const Trait(name: 'AOE', level: 3),
        const Trait(name: 'Blast'),
        const Trait(name: 'Guided'),
      ];
      break;
    case 'AC':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Autocannon';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 18, 36);
      traits = [
        const Trait(name: 'Burst', level: 1),
        const Trait(name: 'Split'),
      ];
      alternativeTraits = [const Trait(name: 'Precise')];
      break;
    case 'AG':
      const damageMap = {'L': 9, 'M': 10, 'H': 11};
      name = 'Artillery Gun';
      modes = [weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(24, 48, 96);
      traits = [
        const Trait(name: 'AOE', level: 3),
        const Trait(name: 'Blast'),
        const Trait(name: 'AP', level: 1),
        const Trait(name: 'Demo', level: 2),
      ];
      break;
    case 'AM':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Artillery Missile';
      modes = [weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(24, 48, 96);
      traits = [
        const Trait(name: 'AOE', level: 4),
        const Trait(name: 'Blast'),
        const Trait(name: 'AP', level: 1),
        const Trait(name: 'Guided'),
      ];
      break;
    case 'APGL':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Anti-Per Grenade Launchers';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(0, 3, null);
      traits = [
        const Trait(name: 'AI'),
        const Trait(name: 'Frag'),
        const Trait(name: 'Prox'),
      ];
      break;
    case 'APR':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Anti-Personnel Rockets';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(6, 18, 36);
      traits = [
        const Trait(name: 'AI'),
        const Trait(name: 'AOE', level: 3),
      ];
      break;
    case 'AR':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Artillery Rockets';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(12, 36, 72);
      traits = [
        const Trait(name: 'AOE', level: 3),
        const Trait(name: 'Demo', level: 2),
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
        Trait(name: 'AP', level: apMap[size]),
        const Trait(name: 'Guided'),
      ];
      break;
    case 'AVM':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Anti-Vehicle Missile';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(6, 18, 36);
      traits = [
        const Trait(name: 'AP', level: 1),
        const Trait(name: 'Guided'),
      ];
      break;
    case 'B':
      name = 'Bomb';
      modes = [weaponModes.Direct];
      damage = 8;
      range = Range(0, null, null);
      traits = [const Trait(name: 'AOE', level: 4)];
      break;
    case 'BZ':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      const apMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Bazooka';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 12, 24);
      traits = [
        Trait(name: 'AP', level: apMap[size]),
      ];
      break;
    case 'CW':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Combat Weapon';
      modes = [weaponModes.Melee];
      damage = damageMap[size]!;
      range = Range(0, null, null, hasReach: true, increasableReach: true);
      traits = [
        const Trait(name: 'Demo', level: 2),
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
        const Trait(name: 'Precise'),
        Trait(name: 'AP', level: apMap[size]),
      ];
      alternativeTraits = [
        const Trait(name: 'Frag'),
        const Trait(name: 'AI'),
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
        Trait(name: 'AP', level: apMap[size]),
      ];
      alternativeTraits = [
        const Trait(name: 'AOE', level: 3),
        const Trait(name: 'Blast'),
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
        const Trait(name: 'AI'),
        Trait(name: 'Fire', level: fireMap[size]),
        const Trait(name: 'Burst', level: 1),
        const Trait(name: 'Spray'),
      ];
      break;
    case 'FM':
      const damageMap = {'L': 8, 'M': 9, 'H': 10};
      name = 'Field Mortar';
      modes = [weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(18, 36, 72);
      traits = [
        const Trait(name: 'AOE', level: 4),
        const Trait(name: 'Blast'),
      ];
      break;
    case 'GL':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Grenade Launcher';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(6, 12, 24);
      traits = [
        const Trait(name: 'AOE', level: 3),
        const Trait(name: 'Blast'),
        const Trait(name: 'AP', level: 1),
        const Trait(name: 'Burst', level: 1),
      ];
      break;
    case 'GM':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Guided Mortar';
      modes = [weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(18, 36, 72);
      traits = [
        const Trait(name: 'AOE', level: 3),
        const Trait(name: 'Blast'),
        const Trait(name: 'Guided'),
      ];
      break;
    case 'HG':
      const damageMap = {'L': 8, 'M': 9, 'H': 10};
      name = 'Hand Grenades';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(3, 6, 9);
      traits = [
        const Trait(name: 'AOE', level: 3),
        const Trait(name: 'Blast'),
        const Trait(name: 'AP', level: 1),
      ];
      break;
    case 'ICW':
      const damageMap = {'L': 4, 'M': 5, 'H': 6};
      name = 'Infantry Combat Weapon';
      modes = [weaponModes.Melee];
      damage = damageMap[size]!;
      range = Range(0, null, null, hasReach: true, increasableReach: true);
      traits = [const Trait(name: 'AI')];
      break;
    case 'IGL':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Infantry Grenade Launcher';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(3, 9, 18);
      traits = [
        const Trait(name: 'AOE', level: 2),
        const Trait(name: 'Blast'),
      ];
      alternativeTraits = [
        const Trait(name: 'AP', level: 1),
      ];
      break;
    case 'IL':
      const damageMap = {'L': 3, 'M': 4, 'H': 5};
      name = 'Infantry Laser';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 18, 36);
      traits = [
        const Trait(name: 'AI'),
        const Trait(name: 'Advanced'),
        const Trait(name: 'Burst', level: 1),
      ];
      break;
    case 'IM':
      const damageMap = {'L': 4, 'M': 5, 'H': 6};
      name = 'Infantry Mortar';
      modes = [weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(12, 24, 48);
      traits = [
        const Trait(name: 'AOE', level: 2),
        const Trait(name: 'Blast'),
        const Trait(name: 'AI'),
      ];
      break;
    case 'IR':
      const damageMap = {'L': 4, 'M': 5, 'H': 6};
      name = 'Infantry Rifle';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 24, 48);
      traits = [
        const Trait(name: 'Precise'),
        const Trait(name: 'AI'),
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
        const Trait(name: 'AI'),
        const Trait(name: 'Burst', level: 1),
      ];
      break;
    case 'LC':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Laser Cannon';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(12, 36, 72);
      traits = [
        const Trait(name: 'Precise'),
        const Trait(name: 'Advanced'),
      ];
      break;
    case 'MG':
      const damageMap = {'L': 3, 'M': 4, 'H': 5};
      name = 'Machine Gun';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(3, 9, 18);
      traits = [
        const Trait(name: 'AI'),
        const Trait(name: 'Burst', level: 2),
        const Trait(name: 'Split'),
      ];
      break;
    case 'P':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Pistol';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(0, 12, 24);
      traits = [
        const Trait(name: 'Precise'),
      ];
      break;
    case 'PA':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Particle Accelerator';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 24, 48);
      traits = [
        const Trait(name: 'Haywire'),
        const Trait(name: 'Advanced'),
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
        const Trait(name: 'Burst', level: 1),
        const Trait(name: 'Advanced'),
      ];
      alternativeTraits = [
        Trait(name: 'AP', level: apMap[size]),
        const Trait(name: 'Apex'),
        const Trait(name: 'Advanced'),
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
        Trait(name: 'AP', level: apMap[size]),
      ];
      break;
    case 'RC':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Rotary Cannon';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 18, 36);
      traits = [
        const Trait(name: 'Burst', level: 2),
        const Trait(name: 'Split'),
      ];
      break;
    case 'RF':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Rifle';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(12, 36, 72);
      traits = [
        const Trait(name: 'Precise'),
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
        const Trait(name: 'Precise'),
        const Trait(name: 'Advanced'),
        Trait(name: 'AP', level: apMap[size]),
      ];
      break;
    case 'RL':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Rotary Laser';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(6, 18, 36);
      traits = [
        const Trait(name: 'Advanced'),
        const Trait(name: 'Burst', level: 2),
        const Trait(name: 'Split'),
      ];
      break;
    case 'RP':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Rocket Pack';
      modes = [weaponModes.Direct, weaponModes.Indirect];
      damage = damageMap[size]!;
      range = Range(6, 18, 36);
      traits = [
        const Trait(name: 'AOE', level: 3),
        const Trait(name: 'AP', level: 1),
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
        Trait(name: 'AP', level: apMap[size]),
        const Trait(name: 'Demo', level: 3),
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
        Trait(name: 'AP', level: apMap[size]),
        const Trait(name: 'Demo', level: 4),
        const Trait(name: 'Brawl', level: -1),
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
        Trait(name: 'AP', level: apMap[size]),
      ];
      break;
    case 'SMG':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Submachine Gun';
      modes = [weaponModes.Direct];
      damage = damageMap[size]!;
      range = Range(0, 9, 18);
      traits = [
        const Trait(name: 'Burst', level: 2),
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
        Trait(name: 'AP', level: apMap[size]),
        const Trait(name: 'Demo', level: 2),
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
        Trait(name: 'AP', level: apMap[size]),
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
