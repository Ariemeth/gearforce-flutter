import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/weapons/range.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';

final weaponMatch = RegExp(r'^(?<size>[BLMH])(?<type>[a-zA-Z]+)');
final comboMatch = RegExp(r'(?<combo>[\/])(?<code>[a-zA-Z]+)');

Weapon? buildWeapon({
  required String code,
  int? damageOverride,
  List<Trait>? bonusTraits,
}) {
  if (!weaponMatch.hasMatch(code)) {
    return null;
  }

  final weaponCheck = weaponMatch.firstMatch(code);
  if (weaponCheck == null || weaponCheck.groupCount != 2) {
    return null;
  }

  final String size = weaponCheck.namedGroup('size')!;
  final String type = weaponCheck.namedGroup('type')!;

  String name = '';
  List<weaponModes> modes = [];
  int damage = -1;
  bool hasReact = false;
  Range range = Range(0, 1, 2);
  List<Trait> traits = [];
  List<Trait> optionalTraits = [];
  bool isCombo = comboMatch.hasMatch(code);

  switch (type.toUpperCase()) {
    case 'AAM':
    case 'ABM':
    case 'AC':
    case 'AG':
    case 'AM':
    case 'APGL':
    case 'APR':
    case 'AR':
    case 'ATM':
    case 'AVM':
    case 'B':
    case 'BZ':
    case 'CW':
    case 'FC':
    case 'FG':
    case 'FL':
    case 'FM':
    case 'GL':
    case 'GM':
    case 'HG':
    case 'ICW':
    case 'IGL':
    case 'IL':
    case 'IM':
    case 'IR':
    case 'IS':
    case 'IW':
    case 'LC':
    case 'MG':
    case 'P':
    case 'PA':
    case 'PL':
    case 'PZ':
    case 'RC':
    case 'RF':
    case 'RG':
    case 'RP':
    case 'SC':
    case 'SE':
    case 'SG':
    case 'SMG':
    case 'TG':
    case 'VB':
      break;
    default:
      print('Unknown weapon code [$code], damage override [$damageOverride],' +
          ' bonusTraits [$bonusTraits]');
      return null;
  }

  return Weapon(
    code: '$size$type',
    name: name,
    modes: modes,
    range: range,
    damage: damage,
    hasReact: hasReact,
    traits: traits,
    optionalTraits: optionalTraits,
  );
}
