import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/weapons/range.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';

class Weapon {
  const Weapon({
    required this.code,
    required this.name,
    required this.modes,
    required this.range,
    required this.damage,
    this.numberOf = 1,
    this.hasReact = false,
    this.traits = const [],
    this.optionalTraits = const [],
    this.bonusTraits,
    this.combo,
  });
  final String code;
  final String name;
  final int numberOf;
  final List<weaponModes> modes;
  final Range range;
  final int damage;
  final bool hasReact;
  final List<Trait> traits;
  final List<Trait> optionalTraits;
  final List<Trait>? bonusTraits;
  final Weapon? combo;

  @override
  String toString() {
    String result = '';
    if (numberOf > 1) {
      result = '$numberOf X ';
    }

    if (combo != null) {
      result = '$result$code/${combo!.code}';
    } else {
      result = '$result$code';
    }

    if (bonusTraits != null) {
      result =
          '$result (${bonusTraits.toString().replaceAll(RegExp(r'\[|\]|,'), '')})';
    }
    return result;
  }

  factory Weapon.fromString(String str) {
    /*
    Examples:
    BB (AP:2 Guided)
    LATM (LA:2)
    LBZ (AP:1 Burst:1)
    LAC (Precise Silent)
    LAC(Precise Silent)
    */
    return Weapon(
      code: '',
      name: '',
      modes: [],
      range: Range(0, null, null),
      damage: -1,
    );
  }
}
