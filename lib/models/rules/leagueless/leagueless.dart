import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/rules/peace_river/prdf.dart' as prdf;

class Leagueless extends RuleSet {
  Leagueless(
    Data data, {
    String? description,
    required String name,
    List<String>? specialRules,
    List<FactionRule> subFactionRules = const [],
  }) : super(
          FactionType.Universal,
          data,
          name: name,
          description: description,
          factionRules: [],
          subFactionRules: subFactionRules,
        );

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u) {
    final List<FactionModification> results = [];
    var rule = findFactionRule(prdf.ruleThunderFromTheSky.id);
    if (rule != null && rule.isEnabled) {
      results.add(PeaceRiverFactionMods.thunderFromTheSky());
    }
    return results;
  }

  @override
  List<SpecialUnitFilter> availableUnitFilters() {
    return [];
  }
}
