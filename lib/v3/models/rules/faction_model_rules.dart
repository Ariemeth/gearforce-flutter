import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/rules/rulesets/caprice/caprice.dart'
    as caprice;
import 'package:gearforce/v3/models/rules/rulesets/cef/cef.dart' as cef;
import 'package:gearforce/v3/models/rules/rulesets/eden/eden.dart' as eden;
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/rules/rulesets/north/north.dart' as north;
import 'package:gearforce/v3/models/rules/rulesets/utopia/utopia.dart'
    as utopia;
import 'package:gearforce/v3/models/unit/unit.dart';

List<Rule> getModelFactionRules(
  Unit? unit,
  List<FactionType>? factions,
) {
  if (unit == null && factions == null) {
    return getModelFactionRulesByFaction(null);
  }
  if (factions == null) {
    return getModelFactionRulesByFaction(unit?.faction);
  }

  return getModelFactionRulesByFactionList(factions);
}

List<Rule> getModelFactionRulesByFactionList(
  List<FactionType> factions,
) {
  final List<Rule> results = [];

  for (var faction in factions) {
    results.addAll(getModelFactionRulesByFaction(faction));
  }

  return results;
}

List<Rule> getModelFactionRulesByFaction(FactionType? faction) {
  switch (faction) {
    case FactionType.north:
      return [north.ruleTaskBuilt];
    case FactionType.cef:
      return [cef.ruleMinerva, cef.ruleAdvancedInterfaceNetwork];
    case FactionType.caprice:
      return [
        caprice.ruleDuelingMounts,
        caprice.ruleAdvancedInterfaceNetworks,
        caprice.ruleCyberneticUpgrades,
      ];
    case FactionType.utopia:
      return [
        utopia.ruleDroneMatrix,
        utopia.ruleManualControl,
        utopia.ruleDroneHacking,
        utopia.ruleExpendable,
      ];
    case FactionType.eden:
      return [eden.ruleLancers, eden.ruleJoustYouSay];
    case FactionType.universal:
      return [north.ruleTaskBuilt, caprice.ruleCyberneticUpgrades];
    case FactionType.universalTerraNova:
      return [north.ruleTaskBuilt];
    case FactionType.universalNonTerraNova:
      return [eden.ruleLancers, eden.ruleJoustYouSay];
    case null:
      return [
        north.ruleTaskBuilt,
        cef.ruleMinerva,
        cef.ruleAdvancedInterfaceNetwork,
        caprice.ruleDuelingMounts,
        caprice.ruleAdvancedInterfaceNetworks,
        caprice.ruleCyberneticUpgrades,
        utopia.ruleDroneMatrix,
        utopia.ruleManualControl,
        utopia.ruleDroneHacking,
        utopia.ruleExpendable,
        eden.ruleLancers,
        eden.ruleJoustYouSay,
      ];
    default:
  }
  return [];
}
