import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/weapons/range.dart';
import 'package:gearforce/v3/models/weapons/weapon_modes.dart';

class Weapon {
  const Weapon({
    required this.abbreviation,
    required this.name,
    required this.modes,
    required this.range,
    required this.damage,
    this.numberOf = 1,
    this.hasReact = false,
    this.baseTraits = const [],
    this.baseAlternativeTraits = const [],
    this.bonusTraits = const [],
    this.combo,
  })  : assert(
          abbreviation.length >= 2,
          'abbreviation is to short, must be >=2: $abbreviation',
        ),
        assert(name != '', 'name cannot be empty'),
        assert(numberOf > 0);
  final String abbreviation;
  final String name;
  final int numberOf;
  final List<WeaponModes> modes;
  final Range range;
  final int damage;
  final bool hasReact;
  final List<Trait> baseTraits;
  final List<Trait> baseAlternativeTraits;
  final List<Trait> bonusTraits;
  final Weapon? combo;

  /// Return the weapons size S, M, L
  String get size => abbreviation.substring(0, 1);

  /// Return the weapons identify code SE, MG or AC
  String get code => abbreviation.substring(1);
  bool get isCombo => combo != null;
  List<Trait> get traits {
    final List<Trait> result =
        baseTraits.map<Trait>((trait) => Trait.fromTrait(trait)).toList();

    final List<Trait> bonuses =
        bonusTraits.map((trait) => Trait.fromTrait(trait)).toList();
    // add the bonus traits to the result list to return
    for (var bonusTrait in bonuses) {
      // if a bonus trait already has a version as part of the base traits,
      // update the existing trait to the bonus level
      if (result.any((trait) => trait.name == bonusTrait.name)) {
        if (bonusTrait.isSameType(Trait.apex())) {
          result.add(bonusTrait);
        } else {
          final index =
              result.indexWhere((trait) => trait.name == bonusTrait.name);
          if (index >= 0) {
            result[index] = bonusTrait;
          }
        }
      } else {
        result.add(bonusTrait);
      }
    }

    return result;
  }

  List<Trait> get alternativeTraits {
    final List<Trait> result = baseAlternativeTraits
        .map<Trait>((trait) => Trait.fromTrait(trait))
        .toList();

    if (result.isEmpty) {
      return [];
    }

    final List<Trait> bonuses =
        bonusTraits.map((trait) => Trait.fromTrait(trait)).toList();
    // add the bonus traits to the result list to return
    for (var bonusTrait in bonuses) {
      // if a bonus trait already has a version as part of the base traits,
      // update the existing trait to the bonus level
      if (result.any((trait) => trait.name == bonusTrait.name)) {
        if (bonusTrait.isSameType(Trait.apex())) {
          result.add(bonusTrait);
        } else {
          final index =
              result.indexWhere((trait) => trait.name == bonusTrait.name);
          if (index >= 0) {
            result.removeAt(index);
            result.insert(index, bonusTrait);
          }
        }
      } else {
        result.add(bonusTrait);
      }
    }

    return result;
  }

  String get bonusString {
    if (bonusTraits.isEmpty) {
      return '';
    }
    return bonusTraits
        .toString()
        .replaceAll(RegExp(r','), '')
        .replaceAll(RegExp(r'\['), '(')
        .replaceAll(RegExp(r'\]'), ')');
  }

  @override
  String toString() {
    String result = '';
    if (numberOf > 1) {
      result = '$numberOf X ';
    }

    result = '$result$abbreviation';

    if (bonusTraits.isNotEmpty) {
      result =
          '$result (${bonusTraits.toString().replaceAll(RegExp(r'\[|\]|,'), '')})';
    }

    if (combo != null) {
      result = '$result/${combo!.toString()}';
    }

    return result;
  }

  factory Weapon.fromWeapon(
    Weapon original, {
    String? name,
    Range? range,
    int? numberOf,
    List<Trait>? addTraits,
    List<Trait>? traitsToRemove,
    bool? hasReact,
  }) {
    final bonusTraits =
        original.bonusTraits.map((trait) => Trait.fromTrait(trait)).toList();

    final baseTraits =
        original.baseTraits.map((trait) => Trait.fromTrait(trait)).toList();

    final baseAlternativeTraits = original.baseAlternativeTraits
        .map((trait) => Trait.fromTrait(trait))
        .toList();

    if (traitsToRemove != null) {
      for (var t in traitsToRemove) {
        bonusTraits.removeWhere((trait) => trait.isSameType(t));
        baseTraits.removeWhere((trait) => trait.isSameType(t));
        baseAlternativeTraits.removeWhere((trait) => trait.isSameType(t));
      }
    }

    if (addTraits != null) {
      for (var t in addTraits) {
        bonusTraits.add(t);
      }
    }

    return Weapon(
      abbreviation: original.abbreviation,
      name: name ?? original.name,
      numberOf: numberOf ?? original.numberOf,
      modes: original.modes,
      range: range ?? original.range,
      damage: original.damage,
      hasReact: hasReact ?? original.hasReact,
      baseTraits: baseTraits,
      baseAlternativeTraits: baseAlternativeTraits,
      bonusTraits: bonusTraits,
      combo: original.combo != null ? Weapon.fromWeapon(original.combo!) : null,
    );
  }
}
