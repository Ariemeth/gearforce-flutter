import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/mods/unitUpgrades/peace_river.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/peace_river/poc.dart' as poc;
import 'package:gearforce/models/rules/peace_river/pps.dart' as pps;
import 'package:gearforce/models/rules/peace_river/prdf.dart' as prdf;
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';

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
  PeaceRiver(
    Data data, {
    String? description,
    required String name,
    List<String>? specialRules,
    List<FactionRule> subFactionRules = const [],
  }) : super(
          FactionType.PeaceRiver,
          data,
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
  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u) {
    List<FactionModification> results = [
      PeaceRiverFactionMods.e_pex(),
      PeaceRiverFactionMods.warriorElite(),
      PeaceRiverFactionMods.crisisResponders(u),
      PeaceRiverFactionMods.laserTech(u),
    ];

    // PRDF faction rules
    if (isRuleEnabled(prdf.ruleOlTrusty.id)) {
      results.add(PeaceRiverFactionMods.olTrusty());
    }
    if (isRuleEnabled(prdf.ruleThunderFromTheSky.id)) {
      results.add(PeaceRiverFactionMods.thunderFromTheSky());
    }
    if (isRuleEnabled(prdf.ruleEliteElements.id)) {
      results.add(PeaceRiverFactionMods.eliteElements(ur));
    }

    // POC faction rules
    if (isRuleEnabled(poc.ruleECMSpecialist.id)) {
      results.add(PeaceRiverFactionMods.ecmSpecialist());
    }
    if (isRuleEnabled(poc.rulePOCOlTrusty.id)) {
      results.add(PeaceRiverFactionMods.olTrustyPOC());
    }
    if (isRuleEnabled(poc.rulePeaceOfficer.id)) {
      results.add(PeaceRiverFactionMods.peaceOfficers(u));
    }
    if (isRuleEnabled(poc.ruleGSwatSniper.id)) {
      results.add(PeaceRiverFactionMods.gSWATSniper());
    }

    return results;
  }

  @override
  List<SpecialUnitFilter> availableUnitFilters() {
    final filters = [
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
      )
    ];

    if (isRuleEnabled(prdf.ruleBestMenAndWomen.id)) {
      filters.add(prdf.filterBestMenAndWomen);
    }
    if (isRuleEnabled(poc.ruleMercenaryContract.id)) {
      filters.add(poc.filterMercContract);
    }
    if (isRuleEnabled(pps.ruleSubContractors.id)) {
      filters.add(pps.filterSubContractor);
    }

    return filters;
  }

  @override
  List<CombatGroupOption> combatGroupSettings() {
    final List<CombatGroupOption> options = [];

    if (isRuleEnabled(pps.ruleSubContractors.id)) {
      options.add(pps.ruleSubContractors.buidCombatGroupOption());
    }

    if (isRuleEnabled(pps.ruleBadlandsSoup.id)) {
      options.add(pps.ruleBadlandsSoup.buidCombatGroupOption());
    }

    if (isRuleEnabled(poc.ruleMercenaryContract.id)) {
      options.add(poc.ruleMercenaryContract.buidCombatGroupOption());
    }

    if (isRuleEnabled(prdf.ruleBestMenAndWomen.id)) {
      options.add(prdf.ruleBestMenAndWomen.buidCombatGroupOption(
        canBeToggled: false,
        initialState: true,
      ));
    }

    return options;
  }

  factory PeaceRiver.POC(Data data) {
    return poc.POC(data);
  }
  factory PeaceRiver.PPS(Data data) {
    return pps.PPS(data);
  }
  factory PeaceRiver.PRDF(Data data) {
    return prdf.PRDF(data);
  }
}

final ruleArchitects = FactionRule(
    name: 'Architects',
    id: '$_baseRuleId::architects',
    duelistModelCheck: (roster, u) {
      if (u.type == ModelType.Strider) {
        return true;
      }
      return null;
    },
    description: 'The duelist for this force may use a Peace River strider.');

final ruleCrisisResponders = FactionRule(
    name: 'Crisis Responders',
    id: '$_baseRuleId::crisisResponders',
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
    description:
        'Any Crusader IV that has been upgraded to a Crusader V may swap their HAC, MSC, MBZ or LFG for a MPA (React) and a Shield for 1 TV. This Crisis Responder variant is unlimited for this force.');
final ruleEPex = FactionRule(
    name: 'E-pex',
    id: '$_baseRuleId::ePex',
    description:
        'One Peace River model within each combat group may increase its EW skill by one for 1 TV each.');
final ruleLaserTech = FactionRule(
    name: 'Laser Tech',
    id: '$_baseRuleId::laserTech',
    description:
        'Veteran universal infantry and veteran Spitz Monowheels may upgrade their IW, IR or IS for 1 TV each. These weapons receive the Advanced trait.');
final ruleWarriorElite = FactionRule(
    name: 'Warrior Elite',
    id: '$_baseRuleId::warriorElite',
    description:
        'Any Warrior IV may be upgraded to a Warrior Elite for 1 TV each. This upgrade gives the Warrior IV a H/S of 4/2, an EW skill of 4+, and the Agile trait.');
