import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/factions/peace_river.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_core.dart';

abstract class RuleSet {
  final Data data;
  const RuleSet(this.data);

  List<UnitCore> availableUnits({
    List<RoleType?>? role,
    List<String>? filters,
  });

  List<UnitCore> airstrikeCounters();

  List<FactionModification> availableFactionMods(CombatGroup cg);
}
