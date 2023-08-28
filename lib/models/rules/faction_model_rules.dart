import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/caprice/caprice.dart' as caprice;
import 'package:gearforce/models/rules/cef/cef.dart' as cef;
import 'package:gearforce/models/rules/eden/eden.dart' as eden;
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/rules/north/north.dart' as north;
import 'package:gearforce/models/rules/utopia/utopia.dart' as utopia;
import 'package:gearforce/models/unit/unit.dart';

List<FactionRule> GetModelFactionRules(
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

List<FactionRule> GetModelFactionRulesByFactionList(
  List<FactionType> factions,
) {
  final List<FactionRule> results = [];

  factions.forEach((faction) {
    results.addAll(GetModelFactionRulesByFaction(faction));
  });

  return results;
}

List<FactionRule> GetModelFactionRulesByFaction(FactionType? faction) {
  switch (faction) {
    case FactionType.North:
      return [north.ruleTaskBuilt];
    case FactionType.CEF:
      return [cef.ruleMinvera, cef.ruleAdvancedInterfaceNetwork];
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
      return [caprice.ruleCyberneticUpgrades];
    case null:
      return [
        north.ruleTaskBuilt,
        cef.ruleMinvera,
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
