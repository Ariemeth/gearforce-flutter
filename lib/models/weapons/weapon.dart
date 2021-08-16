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
    this.hasReact = false,
    this.traits = const [],
    this.optionalTraits = const [],
    this.combo,
  });
  final String code;
  final String name;
  final List<weaponModes> modes;
  final Range range;
  final int damage;
  final bool hasReact;
  final List<Trait> traits;
  final List<Trait> optionalTraits;
  final Weapon? combo;
}
