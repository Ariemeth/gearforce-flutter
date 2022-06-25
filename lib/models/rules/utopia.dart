import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class Utopia extends RuleSet {
  const Utopia(super.data);

  @override
  List<UnitCore> availableUnits({
    List<RoleType?>? role,
    List<String>? filters,
  }) {
    return data.unitList(FactionType.Utopia, role: role, filters: filters);
  }

  @override
  List<FactionModification> availableFactionMods(CombatGroup cg, Unit u) {
    return [];
  }
}
