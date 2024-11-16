import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/weapons/range.dart';
import 'package:gearforce/v3/models/weapons/weapon.dart';
import 'package:gearforce/v3/models/weapons/weapon_modes.dart';

final weaponMatch =
    RegExp(r'^((?<number>[2-9])\s?[xX]\s?)?(?<size>[BLMH])(?<type>[a-zA-Z]+)');
final traitsMatch = RegExp(r'\((?<traits>[a-zA-Z :0-9]+)\)\/?.*$');

Weapon? buildWeapon(
  String fullWeaponString, {
  bool hasReact = false,
}) {
  final weaponsplit = fullWeaponString.split(RegExp(r'\s?\/\s?'));
  final weaponString = weaponsplit.first;

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

  Weapon? comboWeapon;
  if (weaponsplit.length > 1) {
    comboWeapon = buildWeapon(weaponsplit.last, hasReact: hasReact);
    if (comboWeapon == null) {
      print('Unknown combo weapon [$weaponString], bonusTraits [$bonusTraits]');
    }
  }

  final generatedWeapon = _buildWeapon(
    size: size,
    type: type,
    numberOf: numberOf,
    bonusTraits: bonusTraits,
    hasReact: hasReact,
    comboWeapon: comboWeapon,
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
  bool hasReact = false,
  Weapon? comboWeapon,
}) {
  String name = '';
  List<WeaponModes> modes = [];
  int damage = -1;
  Range range = const Range(0, 1, 2);
  List<Trait> traits = [];
  List<Trait> alternativeTraits = [];

  assert(
      size == 'L' || size == 'M' || size == 'H' || size.isEmpty || size == 'B');

  switch (type.toUpperCase()) {
    case 'AAM':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Anti-Air Missile';
      modes = [WeaponModes.direct, WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(12, 36, 72);
      traits = [
        Trait.flak(),
        Trait.guided(),
      ];
      break;
    case 'ABM':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Air Burst Missile';
      modes = [WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(24, 48, 96);
      traits = [
        Trait.ai(),
        Trait.aoe(3),
        Trait.blast(),
        Trait.guided(),
      ];
      break;
    case 'AC':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Autocannon';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(6, 18, 36);
      traits = [
        Trait.burst(1),
        Trait.split(),
      ];
      alternativeTraits = [Trait.precise()];
      break;
    case 'AG':
      const damageMap = {'L': 9, 'M': 10, 'H': 11};
      name = 'Artillery Gun';
      modes = [WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(24, 48, 96);
      traits = [
        Trait.aoe(3),
        Trait.blast(),
        Trait.ap(1),
        Trait.demo(2),
      ];
      break;
    case 'AM':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Artillery Missile';
      modes = [WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(24, 48, 96);
      traits = [
        Trait.aoe(3),
        Trait.blast(),
        Trait.ap(1),
        Trait.guided(),
      ];
      break;
    case 'APGL':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Anti-Per Grenade Launcher';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(0, 3, null);
      traits = [
        Trait.ai(),
        Trait.frag(),
        Trait.proximity(),
      ];
      break;
    case 'APR':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Anti-Personnel Rockets';
      modes = [WeaponModes.direct, WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(6, 18, 36);
      traits = [
        Trait.ai(),
        Trait.aoe(3),
      ];
      break;
    case 'AR':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Artillery Rockets';
      modes = [WeaponModes.direct, WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(12, 36, 72);
      traits = [
        Trait.aoe(3),
        Trait.demo(2),
      ];
      break;
    case 'ATM':
      const damageMap = {'L': 8, 'M': 9, 'H': 10};
      const apMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Anti-Tank Missile';
      modes = [WeaponModes.direct, WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(12, 36, 72);
      traits = [
        Trait.ap(apMap[size]!),
        Trait.guided(),
      ];
      break;
    case 'AVM':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Anti-Vehicle Missile';
      modes = [WeaponModes.direct, WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(6, 18, 36);
      traits = [
        Trait.ap(1),
        Trait.guided(),
      ];
      break;
    case 'B':
      name = 'Bomb';
      modes = [WeaponModes.direct];
      damage = 8;
      range = const Range(0, null, null);
      traits = [Trait.aoe(4)];
      break;
    case 'BZ':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      const apMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Bazooka';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(6, 12, 24);
      traits = [
        Trait.ap(apMap[size]!),
      ];
      break;
    case 'CW':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Combat Weapon';
      modes = [WeaponModes.melee];
      damage = damageMap[size]!;
      range =
          const Range(0, null, null, hasReach: true, increasableReach: true);
      traits = [
        Trait.demo(2),
      ];
      break;
    case 'FC':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      const apMap = {'L': 1, 'M': 2, 'H': 3};
      name = 'Frag Cannon';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(3, 9, 18);
      traits = [
        Trait.precise(),
        Trait.ap(apMap[size]!),
      ];
      alternativeTraits = [
        Trait.frag(),
        Trait.ai(),
      ];
      break;
    case 'FG':
      const damageMap = {'L': 9, 'M': 10, 'H': 11};
      const apMap = {'L': 3, 'M': 4, 'H': 5};
      name = 'Field Gun';
      modes = [WeaponModes.direct, WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(12, 24, 48);
      traits = [
        Trait.ap(apMap[size]!),
      ];
      alternativeTraits = [
        Trait.aoe(3),
        Trait.blast(),
      ];
      break;
    case 'FL':
      const damageMap = {'L': 3, 'M': 4, 'H': 5};
      const fireMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Flamer';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(0, 9, 18);
      traits = [
        Trait.ai(),
        Trait.fire(fireMap[size]!),
        Trait.burst(1),
        Trait.spray(),
      ];
      break;
    case 'FM':
      const damageMap = {'L': 8, 'M': 9, 'H': 10};
      name = 'Field Mortar';
      modes = [WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(18, 36, 72);
      traits = [
        Trait.aoe(4),
        Trait.blast(),
      ];
      break;
    case 'GL':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Grenade Launcher';
      modes = [WeaponModes.direct, WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(6, 12, 24);
      traits = [
        Trait.aoe(3),
        Trait.blast(),
        Trait.ap(1),
        Trait.burst(1),
      ];
      break;
    case 'GM':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Guided Mortar';
      modes = [WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(18, 36, 72);
      traits = [
        Trait.aoe(3),
        Trait.blast(),
        Trait.guided(),
      ];
      break;
    case 'HG':
      const damageMap = {'L': 8, 'M': 9, 'H': 10};
      name = 'Hand Grenade';
      modes = [WeaponModes.direct, WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(3, 6, 9);
      traits = [
        Trait.aoe(3),
        Trait.blast(),
        Trait.ap(1),
      ];
      break;
    case 'ICW':
      const damageMap = {'L': 4, 'M': 5, 'H': 6};
      name = 'Infantry Combat Weapon';
      modes = [WeaponModes.melee];
      damage = damageMap[size]!;
      range =
          const Range(0, null, null, hasReach: true, increasableReach: true);
      traits = [Trait.ai()];
      break;
    case 'IGL':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Infantry Grenade Launcher';
      modes = [WeaponModes.direct, WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(3, 9, 18);
      traits = [
        Trait.aoe(2),
        Trait.blast(),
      ];
      alternativeTraits = [
        Trait.ap(1),
      ];
      break;
    case 'IL':
      const damageMap = {'L': 3, 'M': 4, 'H': 5};
      name = 'Infantry Laser';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(6, 18, 36);
      traits = [
        Trait.ai(),
        Trait.advanced(),
        Trait.burst(1),
      ];
      break;
    case 'IM':
      const damageMap = {'L': 4, 'M': 5, 'H': 6};
      name = 'Infantry Mortar';
      modes = [WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(12, 24, 48);
      traits = [
        Trait.aoe(2),
        Trait.blast(),
        Trait.ai(),
      ];
      break;
    case 'IR':
      const damageMap = {'L': 4, 'M': 5, 'H': 6};
      name = 'Infantry Rifle';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(6, 24, 48);
      traits = [
        Trait.precise(),
        Trait.ai(),
      ];
      break;
    case 'IS':
      const damageMap = {'L': 4, 'M': 5, 'H': 6};
      name = 'Infantry Support Weapon';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(6, 18, 36);
      traits = [];
      break;
    case 'IW':
      const damageMap = {'L': 3, 'M': 4, 'H': 5};
      name = 'Infantry Weapon';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(0, 9, 18);
      traits = [
        Trait.ai(),
        Trait.burst(1),
      ];
      break;
    case 'LC':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Laser Cannon';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(12, 36, 72);
      traits = [
        Trait.precise(),
        Trait.advanced(),
      ];
      break;
    case 'MG':
      const damageMap = {'L': 3, 'M': 4, 'H': 5};
      name = 'Machine Gun';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(3, 9, 18);
      traits = [
        Trait.ai(),
        Trait.burst(2),
        Trait.split(),
      ];
      break;
    case 'P':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Pistol';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(0, 12, 24);
      traits = [
        Trait.precise(),
      ];
      break;
    case 'PA':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Particle Accelerator';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(6, 24, 48);
      traits = [
        Trait.haywire(),
        Trait.advanced(),
      ];
      break;
    case 'PL':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      const apMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Pulse Laser';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(6, 24, 48);
      traits = [
        Trait.burst(1),
        Trait.advanced(),
      ];
      alternativeTraits = [
        Trait.ap(apMap[size]!),
        Trait.apex(),
        Trait.advanced(),
      ];
      break;
    case 'PZ':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      const apMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Panzerfaust';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(3, 6, 9);
      traits = [
        Trait.ap(apMap[size]!),
      ];
      break;
    case 'RC':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Rotary Cannon';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(6, 18, 36);
      traits = [
        Trait.burst(2),
        Trait.split(),
      ];
      break;
    case 'RF':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      name = 'Rifle';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(12, 36, 72);
      traits = [
        Trait.precise(),
      ];
      break;
    case 'RG':
      const damageMap = {'L': 4, 'M': 5, 'H': 6};
      const apMap = {'L': 4, 'M': 5, 'H': 6};
      name = 'Railgun';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(12, 48, 96);
      traits = [
        Trait.precise(),
        Trait.advanced(),
        Trait.ap(apMap[size]!),
      ];
      break;
    case 'RL':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Rotary Laser';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(6, 18, 36);
      traits = [
        Trait.advanced(),
        Trait.burst(2),
        Trait.split(),
      ];
      break;
    case 'RP':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      name = 'Rocket Pack';
      modes = [WeaponModes.direct, WeaponModes.indirect];
      damage = damageMap[size]!;
      range = const Range(6, 18, 36);
      traits = [
        Trait.aoe(3),
        Trait.ap(1),
      ];
      break;
    case 'SC':
      const damageMap = {'L': 8, 'M': 9, 'H': 10};
      const apMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Snub Cannon';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(3, 9, 18);
      traits = [
        Trait.ap(apMap[size]!),
        Trait.demo(3),
      ];
      break;
    case 'SE':
      const damageMap = {'L': 8, 'M': 9, 'H': 10};
      const apMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Shaped Explosives';
      modes = [WeaponModes.melee];
      damage = damageMap[size]!;
      range = const Range(0, null, null, hasReach: true);
      traits = [
        Trait.ap(apMap[size]!),
        Trait.demo(4),
        Trait.brawl(-1),
      ];
      break;
    case 'SG':
      const damageMap = {'L': 6, 'M': 7, 'H': 8};
      const apMap = {'L': 3, 'M': 4, 'H': 5};
      name = 'Spike Gun';
      modes = [WeaponModes.melee];
      damage = damageMap[size]!;
      range =
          const Range(0, null, null, hasReach: true, increasableReach: true);
      traits = [
        Trait.ap(apMap[size]!),
      ];
      break;
    case 'SMG':
      const damageMap = {'L': 5, 'M': 6, 'H': 7};
      name = 'Submachine Gun';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(0, 9, 18);
      traits = [
        Trait.burst(2),
      ];
      break;
    case 'TG':
      const damageMap = {'L': 9, 'M': 10, 'H': 11};
      const apMap = {'L': 3, 'M': 4, 'H': 5};
      name = 'Tank Gun';
      modes = [WeaponModes.direct];
      damage = damageMap[size]!;
      range = const Range(12, 36, 72);
      traits = [
        Trait.ap(apMap[size]!),
        Trait.demo(2),
      ];
      break;
    case 'VB':
      const damageMap = {'L': 7, 'M': 8, 'H': 9};
      const apMap = {'L': 2, 'M': 3, 'H': 4};
      name = 'Vibroblade';
      modes = [WeaponModes.melee];
      damage = damageMap[size]!;
      range =
          const Range(0, null, null, hasReach: true, increasableReach: true);
      traits = [
        Trait.ap(apMap[size]!),
      ];
      break;
    default:
      if (type.trim().toUpperCase().endsWith('S')) {
        final modifiedType = type.substring(0, type.length - 1);
        return _buildWeapon(
          size: size,
          type: modifiedType,
          numberOf: numberOf,
          bonusTraits: bonusTraits,
          hasReact: hasReact,
        );
      } else {
        print('Unknown weapon type: $type.');
      }
      return null;
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
