import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/rules/peace_river/prdf.dart' as prdf;

class Leagueless extends RuleSet {
  Leagueless(super.type, super.data);

  @override
  List<FactionRule> availableFactionRules() {
    // TODO: implement availableFactionRules
    throw UnimplementedError();
  }

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u) {
    final results = [
      ...super.availableFactionMods(ur, cg, u),
    ];
    var rule =
        FactionRule.findRule(factionRules, prdf.ruleThunderFromTheSky.id);
    if (rule != null && rule.isEnabled) {
      results.add(PeaceRiverFactionMods.thunderFromTheSky());
    }
    return results;
  }
}
