import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/weapons/range.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';

class Weapon {
  const Weapon({
    required this.abbreviation,
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
  final String abbreviation;
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

  String get size => abbreviation.substring(0, 1);
  String get code => abbreviation.substring(1);
  bool get isCombo => combo != null;

  @override
  String toString() {
    String result = '';
    if (numberOf > 1) {
      result = '$numberOf X ';
    }

    if (combo != null) {
      result = '$result$abbreviation/${combo!.abbreviation}';
    } else {
      result = '$result$abbreviation';
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
      abbreviation: '',
      name: '',
      modes: [],
      range: Range(0, null, null),
      damage: -1,
    );
  }
}
