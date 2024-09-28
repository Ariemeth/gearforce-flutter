import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/v3/models/mods/unitUpgrades/peace_river.dart';
import 'package:gearforce/v3/models/rules/options/combat_group_options.dart';
import 'package:gearforce/v3/models/rules/rulesets/peace_river/poc.dart' as poc;
import 'package:gearforce/v3/models/rules/rulesets/peace_river/pps.dart' as pps;
import 'package:gearforce/v3/models/rules/rulesets/peace_river/prdf.dart'
    as prdf;
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:gearforce/widgets/settings.dart';

const String _baseRuleId = 'rule::peaceriver::core';
const String _ruleEpexId = '$_baseRuleId::10';
const String _ruleWarriorEliteId = '$_baseRuleId::20';
const String _ruleCrisisRespondersId = '$_baseRuleId::30';
const String _ruleLaserTechId = '$_baseRuleId::40';
const String _ruleArchitectsId = '$_baseRuleId::50';

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
  PeaceRiver(
    DataV3 data,
    Settings settings, {
    String? description,
    required String name,
    List<String>? specialRules,
    List<Rule> subFactionRules = const [],
  }) : super(
          FactionType.PeaceRiver,
          data,
          settings: settings,
          description: description,
          name: name,
          specialRules: specialRules,
          factionRules: [
            ruleEPex,
            ruleWarriorElite,
            ruleCrisisResponders,
            ruleLaserTech,
            ruleArchitects,
          ],
          subFactionRules: subFactionRules,
        );

  @override
  List<SpecialUnitFilter> availableUnitFilters(
    List<CombatGroupOption>? cgOptions,
  ) {
    final filters = [
      SpecialUnitFilter(
        text: type.name,
        id: coreTag,
        filters: const [
          const UnitFilter(FactionType.PeaceRiver),
          const UnitFilter(FactionType.Airstrike),
          const UnitFilter(FactionType.Universal),
          const UnitFilter(FactionType.Universal_TerraNova),
          const UnitFilter(FactionType.Terrain),
        ],
      )
    ];

    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory PeaceRiver.POC(DataV3 data, Settings settings) =>
      poc.POC(data, settings);
  factory PeaceRiver.PPS(DataV3 data, Settings settings) =>
      pps.PPS(data, settings);
  factory PeaceRiver.PRDF(DataV3 data, Settings settings) =>
      prdf.PRDF(data, settings);
}

final Rule ruleArchitects = Rule(
    name: 'Architects',
    id: _ruleArchitectsId,
    duelistModelCheck: (roster, u) {
      if (u.faction == FactionType.PeaceRiver && u.type == ModelType.Strider) {
        return true;
      }
      return null;
    },
    description: 'The duelist for this force may use a Peace River strider.');

final Rule ruleCrisisResponders = Rule(
    name: 'Crisis Responders',
    id: _ruleCrisisRespondersId,
    isRoleTypeUnlimited: (unit, target, group, roster) {
      return unit.hasMod(crusaderVMod) ? true : null;
    },
    unitCountOverride: (cg, group, unit) {
      if (unit.core.name != 'Crusader IV') {
        return null;
      }

      return group
          .allUnits()
          .where((u) =>
              u.core.name == unit.core.name &&
              !u.hasMod(crusaderVMod) &&
              u != unit)
          .length;
    },
    factionMods: (ur, cg, u) => [PeaceRiverFactionMods.crisisResponders(u)],
    description:
        'Any Crusader IV that has been upgraded to a Crusader V may swap their HAC, MSC, MBZ or LFG for a MPA (React) and a Shield for 1 TV. This Crisis Responder variant is unlimited for this force.');

final Rule ruleEPex = Rule(
    name: 'E-pex',
    id: _ruleEpexId,
    factionMods: (ur, cg, u) => [PeaceRiverFactionMods.e_pex()],
    description:
        'One Peace River model within each combat group may increase its EW skill by one for 1 TV each.');

final Rule ruleLaserTech = Rule(
    name: 'Laser Tech',
    id: _ruleLaserTechId,
    factionMods: (ur, cg, u) => [PeaceRiverFactionMods.laserTech(u)],
    description:
        'Veteran universal infantry and veteran Spitz Monowheels may upgrade their IW, IR or IS for 1 TV each. These weapons receive the Advanced trait.');

final Rule ruleWarriorElite = Rule(
    name: 'Warrior Elite',
    id: _ruleWarriorEliteId,
    factionMods: (ur, cg, u) => [PeaceRiverFactionMods.warriorElite()],
    description:
        'Any Warrior IV may be upgraded to a Warrior Elite for 1 TV each. This upgrade gives the Warrior IV a H/S of 4/2, an EW skill of 4+, and the Agile trait.');
