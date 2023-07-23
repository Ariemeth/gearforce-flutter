import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class UnitFilter {
  final FactionType faction;
  final bool Function(UnitCore uc) matcher;
  const UnitFilter(this.faction, {this.matcher = matchAll});
  bool isMatch(UnitCore uc) => uc.faction == faction && matcher(uc);
}

// Match all units
bool matchAll(UnitCore uc) => true;

// Match units of armor 8 or lower
bool matchArmor8(UnitCore uc) {
  return uc.armor != null && uc.armor! <= 8;
}
