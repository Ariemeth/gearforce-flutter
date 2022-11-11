import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/special_unit_filter.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';

class Eden extends RuleSet {
  const Eden(super.data);

  @override
  List<Unit> availableUnits({
    List<RoleType?>? role,
    List<String>? characterFilters,
    SpecialUnitFilter? specialUnitFilter,
  }) {
    return data
        .getUnits(
          baseFactionFilters: [
            FactionType.Eden,
            FactionType.Airstrike,
            FactionType.Universal,
            FactionType.Universal_Non_TerraNova,
            FactionType.Terrain,
          ],
          roleFilter: role,
          characterFilters: characterFilters,
        )
        .map((uc) => Unit(core: uc))
        .toList();
  }

  @override
  List<SpecialUnitFilter> availableSpecialFilters() {
    return [
      const SpecialUnitFilter(
        text: 'None',
        filters: [],
      )
    ];
  }

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u) {
    return [];
  }
}
