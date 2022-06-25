import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class PeaceRiver extends RuleSet {
  const PeaceRiver(super.data);

  @override
  List<UnitCore> availableUnits({
    List<RoleType?>? role,
    List<String>? filters,
  }) {
    return data.unitList(FactionType.PeaceRiver, role: role, filters: filters);
  }

  @override
  List<PeaceRiverFactionMods> availableFactionMods(CombatGroup cg, Unit u) {
    return [
      PeaceRiverFactionMods.e_pex(),
      PeaceRiverFactionMods.warriorElite(),
      PeaceRiverFactionMods.crisisResponders(u),
      PeaceRiverFactionMods.laserTech(u),
    ];
  }

  @override
  bool duelistCheck(UnitRoster roster, Unit u) {
    // Peace river duelist can be in a strider Rule: Architects
    if (!(u.type == 'Gear' || u.type == 'Strider')) {
      return false;
    }

    // only 1 duelist is allowed.
    return !roster.hasDuelist();
  }
}
