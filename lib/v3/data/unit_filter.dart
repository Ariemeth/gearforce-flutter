import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:gearforce/v3/models/unit/unit_core.dart';

class UnitFilter {
  final FactionType faction;
  final FactionType? factionOverride;
  final bool Function(UnitCore uc) matcher;
  const UnitFilter(
    this.faction, {
    this.matcher = matchAll,
    this.factionOverride,
  });
  bool isMatch(UnitCore uc) => uc.faction == faction && matcher(uc);
}

/// Match all units
bool matchAll(UnitCore uc) => true;

/// Match units of armor 8 or lower
bool matchArmor8(UnitCore uc) {
  return uc.armor != null && uc.armor! <= 8;
}

/// Match units of armor 8 or lower
bool matchArmor9(UnitCore uc) {
  return uc.armor != null && uc.armor! <= 9;
}

/// Match units only if they are not already a Vet
bool matchNotAVet(UnitCore uc) {
  return !uc.traits.any((t) => t.name == Trait.vet().name);
}

/// Match units only if they are not already a Vet and a Gear
bool matchNonVetGears(UnitCore uc) {
  return uc.type == ModelType.gear &&
      !uc.traits.any((t) => t.name == Trait.vet().name);
}

/// Match only with units that are [ModelType.gear]
bool matchOnlyGears(UnitCore uc) {
  return uc.type == ModelType.gear;
}

/// Match only with units that are [ModelType.gear]
bool matchPossibleDuelist(UnitCore uc) {
  return uc.type == ModelType.gear &&
      !uc.traits.any((t) => t.name == Trait.conscript().name);
}

/// Match all units except GREL
bool matchNoGREL(UnitCore uc) {
  return !uc.name.contains('GREL');
}

/// Match only with Striders
bool matchStriders(UnitCore uc) {
  return uc.type == ModelType.strider;
}

/// Match only FLAIL units
bool matchOnlyFlails(UnitCore uc) {
  return uc.name.contains('FLAIL');
}

/// Match Stripped-Down units
bool matchStripped(UnitCore uc) {
  return uc.frame.startsWith('Stripped-Down');
}

/// Match Infantry units
bool matchInfantry(UnitCore uc) {
  return uc.type == ModelType.infantry;
}
