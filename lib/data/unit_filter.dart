import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class UnitFilter {
  final FactionType faction;
  final FactionType? factionOverride;
  final bool Function(UnitCore uc) matcher;
  const UnitFilter(
    this.faction, {
    this.matcher = matchAll,
    this.factionOverride = null,
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
  return !uc.traits.any((t) => t.name == Trait.Vet().name);
}

/// Match only with units that are [ModelType.Gear]
bool matchOnlyGears(UnitCore uc) {
  return uc.type == ModelType.Gear;
}

/// Match only with units that are [ModelType.Gear]
bool matchPossibleDuelist(UnitCore uc) {
  return uc.type == ModelType.Gear &&
      !uc.traits.any((t) => t.name == Trait.Conscript().name);
}

/// Match all units except GREL
bool matchNoGREL(UnitCore uc) {
  return !uc.name.contains('GREL');
}

/// Match only with Striders
bool matchStriders(UnitCore uc) {
  return uc.type == ModelType.Strider;
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
  return uc.type == ModelType.Infantry;
}
