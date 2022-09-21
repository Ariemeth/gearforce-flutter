import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/special_unit_filter.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class BlackTalons extends RuleSet {
  const BlackTalons(super.data);

  @override
  List<UnitCore> availableUnits({
    List<RoleType?>? role,
    List<String>? filters,
    SpecialUnitFilter? specialUnitFilter,
  }) {
    return data.getUnits(
      baseFactionFilters: [
        FactionType.BlackTalon,
        FactionType.Airstrike,
        FactionType.Universal,
        FactionType.Universal_TerraNova,
        FactionType.Terrain,
      ],
      roleFilter: role,
      characterFilters: filters,
      unitFilters: specialUnitFilter?.filters,
    );
  }

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster, CombatGroup cg, Unit u) {
    return [];
  }
}
