import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factions/peace_river.dart';
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
}

class DefaultRuleSet extends RuleSet {
  DefaultRuleSet(super.data);

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
