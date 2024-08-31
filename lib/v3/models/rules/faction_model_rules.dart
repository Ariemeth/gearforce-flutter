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

List<Rule> GetModelFactionRules(
  Unit? unit,
  List<FactionType>? factions,
) {
  if (unit == null && factions == null) {
    return GetModelFactionRulesByFaction(null);
  }
  if (factions == null) {
    return GetModelFactionRulesByFaction(unit?.faction);
  }

  return GetModelFactionRulesByFactionList(factions);
}

List<Rule> GetModelFactionRulesByFactionList(
  List<FactionType> factions,
) {
  final List<Rule> results = [];

  factions.forEach((faction) {
    results.addAll(GetModelFactionRulesByFaction(faction));
  });

  return results;
}

List<Rule> GetModelFactionRulesByFaction(FactionType? faction) {
  switch (faction) {
    case FactionType.North:
      return [north.ruleTaskBuilt];
    case FactionType.CEF:
      return [cef.ruleMinerva, cef.ruleAdvancedInterfaceNetwork];
    case FactionType.Caprice:
      return [
        caprice.ruleDuelingMounts,
        caprice.ruleAdvancedInterfaceNetworks,
        caprice.ruleCyberneticUpgrades,
      ];
    case FactionType.Utopia:
      return [
        utopia.ruleDroneMatrix,
        utopia.ruleManualControl,
        utopia.ruleDroneHacking,
        utopia.ruleExpendable,
      ];
    case FactionType.Eden:
      return [eden.ruleLancers, eden.ruleJoustYouSay];
    case FactionType.Universal:
      return [north.ruleTaskBuilt, caprice.ruleCyberneticUpgrades];
    case FactionType.Universal_TerraNova:
      return [north.ruleTaskBuilt];
    case FactionType.Universal_Non_TerraNova:
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
