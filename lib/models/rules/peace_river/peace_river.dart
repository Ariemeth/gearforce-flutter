import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/special_unit_filter.dart';
import 'package:gearforce/models/unit/model_type.dart';

const String _baseRuleId = 'rule::peaceriver';

/*
  All the models in the Peace River Model List can be used in any of the sub-lists below. There are also models in the
  Universal Model List that may be selected as well.
  All Peace River forces have the following rule:
  * E-pex: One Peace River model within each combat group may increase its EW skill by one for 1 TV each.
  * Warrior Elite: Any Warrior IV may be upgraded to a Warrior Elite for 1 TV each. This upgrade gives the Warrior IV a
  H/S of 4/2, an EW skill of 4+, and the Agile trait.
  * Crisis Responders: Any Crusader IV that has been upgraded to a Crusader V may swap their HAC, MSC, MBZ or LFG
  for a MPA (React) and a Shield for 1 TV. This Crisis Responder variant is unlimited for this force.
  * Laser Tech: Veteran universal infantry and veteran Spitz Monowheels may upgrade their IW, IR or IS for 1 TV each.
  These weapons receive the Advanced trait.
  * Architects: The duelist for this force may use a Peace River strider.
*/
class PeaceRiver extends RuleSet {
  PeaceRiver(data, {specialRules})
      : super(FactionType.PeaceRiver, data, specialRules: specialRules) {
    ruleEPex..addListener(() => notifyListeners());
    ruleWarriorElite..addListener(() => notifyListeners());
    ruleCrisisResponders..addListener(() => notifyListeners());
    ruleLaserTech..addListener(() => notifyListeners());
    ruleArchitects..addListener(() => notifyListeners());
  }

  @override
  List<SpecialUnitFilter> availableUnitFilters() {
    return [
      const SpecialUnitFilter(
        text: coreName,
        id: coreTag,
        filters: const [
          const UnitFilter(FactionType.PeaceRiver),
          const UnitFilter(FactionType.Airstrike),
          const UnitFilter(FactionType.Universal),
          const UnitFilter(FactionType.Universal_TerraNova),
          const UnitFilter(FactionType.Terrain),
        ],
      ),
      ...super.availableUnitFilters(),
    ];
  }

  @override
  List<FactionRule> availableFactionRules() => [
        ruleEPex,
        ruleWarriorElite,
        ruleCrisisResponders,
        ruleLaserTech,
        ruleArchitects,
      ];
}

final ruleEPex = FactionRule(
    name: 'E-pex',
    id: '$_baseRuleId::ePex',
    description:
        'One Peace River model within each combat group may increase its EW skill by one for 1 TV each.');
final ruleWarriorElite = FactionRule(
    name: 'Warrior Elite',
    id: '$_baseRuleId::warriorElite',
    description:
        'Any Warrior IV may be upgraded to a Warrior Elite for 1 TV each. This upgrade gives the Warrior IV a H/S of 4/2, an EW skill of 4+, and the Agile trait.');
final ruleCrisisResponders = FactionRule(
    name: 'Crisis Responders',
    id: '$_baseRuleId::crisisResponders',
    description:
        'Any Crusader IV that has been upgraded to a Crusader V may swap their HAC, MSC, MBZ or LFG for a MPA (React) and a Shield for 1 TV. This Crisis Responder variant is unlimited for this force.');
final ruleLaserTech = FactionRule(
    name: 'Laser Tech',
    id: '$_baseRuleId::laserTech',
    description:
        'Veteran universal infantry and veteran Spitz Monowheels may upgrade their IW, IR or IS for 1 TV each. These weapons receive the Advanced trait.');
final ruleArchitects = FactionRule(
    name: 'Architects',
    id: '$_baseRuleId::architects',
    duelistCheck: (roster, u) {
      return (u.type == ModelType.Gear || u.type == ModelType.Strider);
    },
    description: 'The duelist for this force may use a Peace River strider.');
