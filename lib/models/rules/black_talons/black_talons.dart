import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/special_unit_filter.dart';
import 'package:gearforce/models/unit/unit.dart';

class BlackTalons extends RuleSet {
  BlackTalons(super.data);

  @override
  List<SpecialUnitFilter> availableUnitFilters() {
    return [
      const SpecialUnitFilter(
        text: tagCore,
        filters: const [
          const UnitFilter(FactionType.BlackTalon),
          const UnitFilter(FactionType.Airstrike),
          const UnitFilter(FactionType.Universal),
          const UnitFilter(FactionType.Universal_TerraNova),
          const UnitFilter(FactionType.Terrain),
        ],
      )
    ];
  }

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster, CombatGroup cg, Unit u) {
    return [];
  }

  @override
  List<FactionRule> availableFactionUpgrades() => [];
}
