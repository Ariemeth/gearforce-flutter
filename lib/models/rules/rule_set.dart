import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_core.dart';

abstract class RuleSet {
  final Data data;
  const RuleSet(this.data);

  List<UnitCore> availableUnits({
    List<RoleType?>? role,
    List<String>? filters,
  });

  List<UnitCore> airstrikeCounters() {
    return data.unitList(FactionType.Airstrike, includeTerrain: false);
  }

  List<FactionModification> availableFactionMods(CombatGroup cg, Unit u);

  bool duelistCheck(UnitRoster roster, Unit u) {
    if (u.type != 'Gear') {
      return false;
    }

    // only 1 duelist is allowed.
    return !roster.hasDuelist();
  }

  bool canBeCommand(Unit unit) {
    return unit.core.type != 'Airstrike Counter' &&
        unit.core.type != 'Drone' &&
        unit.core.type != 'Building' &&
        unit.core.type != 'Terrain' &&
        !unit.traits.any((t) => t.name == 'Conscript');
  }

  bool canBeAddedToGroup(UnitCore? uc, Group group) {
    var r = uc!.role;

    // having no role or role type upgrade are always allowed
    if (r == null || r.includesRole([RoleType.Upgrade])) {
      return true;
    }

    if (!r.includesRole([group.role()])) {
      return false;
    }

    var count = group
        .allUnits()
        .where((element) => element.core.name == uc.name)
        .length;

    var maxCountAllowed = r.roles
            .firstWhere(((element) => element.name == group.role()))
            .unlimited
        ? 20
        : 2;
    return count < maxCountAllowed;
  }
}

class DefaultRuleSet extends RuleSet {
  const DefaultRuleSet(super.data);

  @override
  List<FactionModification> availableFactionMods(CombatGroup cg, Unit u) {
    return [];
  }

  @override
  List<UnitCore> availableUnits(
      {List<RoleType?>? role, List<String>? filters}) {
    return [];
  }
}
