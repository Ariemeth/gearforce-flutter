import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/rules/north/nlc.dart' as nlc;
import 'package:gearforce/models/rules/north/north.dart';
import 'package:gearforce/models/rules/north/umf.dart' as umf;
import 'package:gearforce/models/rules/north/wfp.dart' as wfp;
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/peace_river/poc.dart' as poc;
import 'package:gearforce/models/unit/role.dart';

const String _baseRuleId = 'rule::north::ng';
const String _rulePanNorthernId = '$_baseRuleId::10';
const String _ruleSurplusHuntersId = '$_baseRuleId::20';
const String _ruleSurplusJaguarsId = '$_baseRuleId::30';

/*
NG - Norguard
Norguard is tasked with the overall defense of all Northern territories. Not very
numerous on their own, they have excellent equipment and training, and are
considered the masters of combined arms warfare. Each league’s army normally
operates independently. But when the CNCS faces a threat which any of the three
league’s armies can not handle on their own, Norguard becomes the unified
command to lead them all.
* Pan-Northern: Each combat group may use one upgrade option from WFP, UMF
or NLC. Live Free Die Hard, The Pride and Devoted may not be selected.
* Surplus Hunters: Hunters may be placed in GP, SK, FS or RC units. Hunter
and Stripped-Down Hunter variants are not limited to 1-2 models and may be
selected an unlimited number of times.
* Surplus Jaguars: Jaguars may be placed in GP, SK, FS, RC or SO units.
*/
class NG extends North {
  NG(super.data)
      : super(
          name: 'Norguard',
          subFactionRules: [
            rulePanNorthern,
            ruleSurplusHunters,
            ruleSurplusJaguars,
          ],
        );
}

final FactionRule rulePanNorthern = FactionRule(
  name: 'Pan-Northern',
  id: _rulePanNorthernId,
  options: [
    _ngPristineAntiques,
    _ngOlTrusty,
    _ngDropBears,
    _ngLocalManufacturing,
    _ngEwSpecialist,
    _ngWellFunded,
    _ngMercContract,
    _ngChaplain,
    _ngWarriorMonks,
  ],
  description: 'Each combat group may use one upgrade option from WFP, UMF' +
      'or NLC. Live Free Die Hard, The Pride and Devoted may not be selected.',
);

final FactionRule ruleSurplusHunters = FactionRule(
  name: 'Surplus Hunters',
  id: _ruleSurplusHuntersId,
  hasGroupRole: (unit, target, group) {
    final frameName = unit.core.frame;
    final isAllowedUnit = frameName.toLowerCase().contains('hunter');
    final isAllowedRole = target == RoleType.GP ||
        target == RoleType.SK ||
        target == RoleType.FS ||
        target == RoleType.RC;

    return isAllowedUnit && isAllowedRole ? true : null;
  },
  isRoleTypeUnlimited: (unit, target, group, ur) {
    final frameName = unit.core.frame;
    if (frameName == 'Hunter' || frameName == 'Stripped-Down Hunter') {
      return true;
    }
    return null;
  },
  description: 'Hunters may be placed in GP, SK, FS or RC units. Hunter and' +
      ' Stripped-Down Hunter variants are not limited to 1-2 models and may' +
      ' be selected an unlimited number of times.',
);

final FactionRule ruleSurplusJaguars = FactionRule(
  name: 'Surplus Jaguars',
  id: _ruleSurplusJaguarsId,
  hasGroupRole: (unit, target, group) {
    final frameName = unit.core.frame;
    final isAllowedUnit = frameName.toLowerCase().contains('jaguar');
    final isAllowedRole = target == RoleType.GP ||
        target == RoleType.SK ||
        target == RoleType.FS ||
        target == RoleType.RC ||
        target == RoleType.SO;

    return isAllowedUnit && isAllowedRole ? true : null;
  },
  description: 'Jaguars may be placed in GP, SK, FS, RC or SO units.',
);

List<String> _getPanNorthernRuleIds(String id) {
  final ids = [
    wfp.rulePristineAntiques.id,
    wfp.ruleOlTrustyWFP.id,
    wfp.ruleDropBears.id,
    umf.ruleLocalManufacturing.id,
    umf.ruleEWSpecialist.id,
    umf.ruleWellFunded.id,
    poc.ruleMercenaryContract.id,
    nlc.ruleChaplain.id,
    nlc.ruleWarriorMonks.id,
  ];
  ids.remove(id);
  return ids;
}

final FactionRule _ngPristineAntiques = FactionRule.from(
  wfp.rulePristineAntiques,
  isEnabled: true,
  canBeToggled: false,
  cgCheck: onlyOnePerCG(_getPanNorthernRuleIds(wfp.rulePristineAntiques.id)),
  combatGroupOption: () => [_ngPristineAntiques.buidCombatGroupOption()],
);

final FactionRule _ngOlTrusty = FactionRule.from(
  wfp.ruleOlTrustyWFP,
  isEnabled: true,
  canBeToggled: false,
  cgCheck: onlyOnePerCG(_getPanNorthernRuleIds(wfp.ruleOlTrustyWFP.id)),
  combatGroupOption: () => [_ngOlTrusty.buidCombatGroupOption()],
);

final FactionRule _ngDropBears = FactionRule.from(
  wfp.ruleDropBears,
  isEnabled: true,
  canBeToggled: false,
  cgCheck: onlyOnePerCG(_getPanNorthernRuleIds(wfp.ruleDropBears.id)),
  combatGroupOption: () => [_ngDropBears.buidCombatGroupOption()],
);

final FactionRule _ngLocalManufacturing = FactionRule.from(
  umf.ruleLocalManufacturing,
  isEnabled: true,
  canBeToggled: false,
  cgCheck: onlyOnePerCG(_getPanNorthernRuleIds(umf.ruleLocalManufacturing.id)),
  combatGroupOption: () => [_ngLocalManufacturing.buidCombatGroupOption()],
);

final FactionRule _ngEwSpecialist = FactionRule.from(
  umf.ruleEWSpecialist,
  isEnabled: true,
  canBeToggled: false,
  cgCheck: onlyOnePerCG(_getPanNorthernRuleIds(umf.ruleEWSpecialist.id)),
  combatGroupOption: () => [_ngEwSpecialist.buidCombatGroupOption()],
);

final FactionRule _ngWellFunded = FactionRule.from(
  umf.ruleWellFunded,
  isEnabled: true,
  canBeToggled: false,
  cgCheck: onlyOnePerCG(_getPanNorthernRuleIds(umf.ruleWellFunded.id)),
  combatGroupOption: () => [_ngWellFunded.buidCombatGroupOption()],
);

final FactionRule _ngMercContract = FactionRule.from(
  poc.ruleMercenaryContract,
  isEnabled: true,
  canBeToggled: false,
  cgCheck: onlyOnePerCG(_getPanNorthernRuleIds(poc.ruleMercenaryContract.id)),
  combatGroupOption: () => [_ngMercContract.buidCombatGroupOption()],
);

final FactionRule _ngChaplain = FactionRule.from(
  nlc.ruleChaplain,
  isEnabled: true,
  canBeToggled: false,
  cgCheck: onlyOnePerCG(_getPanNorthernRuleIds(nlc.ruleChaplain.id)),
  combatGroupOption: () => [_ngChaplain.buidCombatGroupOption()],
);

final FactionRule _ngWarriorMonks = FactionRule.from(
  nlc.ruleWarriorMonks,
  isEnabled: true,
  canBeToggled: false,
  cgCheck: onlyOnePerCG(_getPanNorthernRuleIds(nlc.ruleWarriorMonks.id)),
  combatGroupOption: () => [_ngWarriorMonks.buidCombatGroupOption()],
);
