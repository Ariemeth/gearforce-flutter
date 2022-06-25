import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factions/peace_river.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class PeaceRiver extends RuleSet {
  const PeaceRiver(super.data);

  @override
  List<UnitCore> availableUnits({
    List<RoleType?>? role,
    List<String>? filters,
  }) {
    return data.unitList(FactionType.PeaceRiver)
      ..addAll(data.unitList(FactionType.Airstrike, includeTerrain: false));
  }

  @override
  List<FactionModification> availableFactionMods(CombatGroup cg) {
    return [
      FactionModification.e_pex(cg),
    ];
  }

  @override
  List<UnitCore> airstrikeCounters() {
    return data.unitList(FactionType.Airstrike, includeTerrain: false);
  }
}
