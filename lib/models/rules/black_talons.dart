import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class BlackTalons extends RuleSet {
  const BlackTalons(super.data);

  @override
  List<UnitCore> availableUnits({
    List<RoleType?>? role,
    List<String>? filters,
  }) {
    return data.unitList(FactionType.BlackTalon,
        role: role, characterFilter: filters);
  }

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster, CombatGroup cg, Unit u) {
    return [];
  }
}
