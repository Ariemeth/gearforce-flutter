import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/caprice/caprice.dart' as caprice;
import 'package:gearforce/models/rules/cef/cef.dart' as cef;
import 'package:gearforce/models/rules/eden/eden.dart' as eden;
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/rules/north/north.dart' as north;
import 'package:gearforce/models/rules/utopia/utopia.dart' as utopia;

List<FactionRule> GetModelFactionRules(FactionType ft) {
  switch (ft) {
    case FactionType.North:
      return [
        north.ruleTaskBuilt,
      ];
    case FactionType.CEF:
      return [
        cef.ruleMinvera,
        cef.ruleAdvancedInterfaceNetwork,
      ];
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
      return [
        eden.ruleLancers,
        eden.ruleJoustYouSay,
      ];
    default:
  }
  return [];
}
