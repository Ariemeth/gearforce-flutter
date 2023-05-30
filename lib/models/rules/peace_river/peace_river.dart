import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/peace_river/poc.dart' as poc;
import 'package:gearforce/models/rules/peace_river/pps.dart' as pps;
import 'package:gearforce/models/rules/peace_river/prdf.dart' as prdf;
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/role.dart';
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
  PeaceRiver(data, {specialRules})
      : super(FactionType.PeaceRiver, data, specialRules: specialRules) {
    ruleEPex..addListener(() => notifyListeners());
    ruleWarriorElite..addListener(() => notifyListeners());
    ruleCrisisResponders..addListener(() => notifyListeners());
    ruleLaserTech..addListener(() => notifyListeners());
    ruleArchitects..addListener(() => notifyListeners());
  }

  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u) {
    List<FactionModification> results = [
      PeaceRiverFactionMods.e_pex(),
      PeaceRiverFactionMods.warriorElite(),
      PeaceRiverFactionMods.crisisResponders(u),
      PeaceRiverFactionMods.laserTech(u),
    ];

    // PRDF faction rules
    if (FactionRule.isRuleEnabled(factionRules, prdf.ruleOlTrusty.id)) {
      results.add(PeaceRiverFactionMods.olTrusty());
    }
    if (FactionRule.isRuleEnabled(
        factionRules, prdf.ruleThunderFromTheSky.id)) {
      results.add(PeaceRiverFactionMods.thunderFromTheSky());
    }
    if (FactionRule.isRuleEnabled(factionRules, prdf.ruleEliteElements.id)) {
      results.add(PeaceRiverFactionMods.eliteElements(ur));
    }

    // POC faction rules
    if (FactionRule.isRuleEnabled(factionRules, poc.ruleECMSpecialist.id)) {
      results.add(PeaceRiverFactionMods.ecmSpecialist());
    }
    if (FactionRule.isRuleEnabled(factionRules, poc.rulePOCOlTrusty.id)) {
      results.add(PeaceRiverFactionMods.olTrustyPOC());
    }
    if (FactionRule.isRuleEnabled(factionRules, poc.rulePeaceOfficer.id)) {
      results.add(PeaceRiverFactionMods.peaceOfficers(u));
    }
    if (FactionRule.isRuleEnabled(factionRules, poc.ruleGSwatSniper.id)) {
      results.add(PeaceRiverFactionMods.gSWATSniper());
    }

    return [...results, ...super.availableFactionMods(ur, cg, u)];
  }

  @override
  List<FactionRule> availableFactionRules() => [
        ruleEPex,
        ruleWarriorElite,
        ruleCrisisResponders,
        ruleLaserTech,
        ruleArchitects,
      ];

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

    if (FactionRule.isRuleEnabled(factionRules, prdf.ruleBestMenAndWomen.id)) {
      filters.add(prdf.filterBestMenAndWomen);
    }
    if (FactionRule.isRuleEnabled(factionRules, poc.ruleMercenaryContract.id)) {
      filters.add(poc.filterMercContract);
    }
    if (FactionRule.isRuleEnabled(factionRules, pps.ruleSubContractors.id)) {
      filters.add(pps.filterSubContractor);
    }

    return [...filters, ...super.availableUnitFilters()];
  }

  @override
  List<CombatGroupOption> combatGroupSettings() {
    final List<CombatGroupOption> options = [];

    if (FactionRule.isRuleEnabled(factionRules, pps.ruleSubContractors.id)) {
      options.add(pps.ruleSubContractors.buidCombatGroupOption());
    }

    if (FactionRule.isRuleEnabled(factionRules, pps.ruleBadlandsSoup.id)) {
      options.add(pps.ruleBadlandsSoup.buidCombatGroupOption());
    }

    if (FactionRule.isRuleEnabled(factionRules, poc.ruleMercenaryContract.id)) {
      options.add(poc.ruleMercenaryContract.buidCombatGroupOption());
    }

    if (FactionRule.isRuleEnabled(factionRules, prdf.ruleBestMenAndWomen.id)) {
      options.add(prdf.ruleBestMenAndWomen.buidCombatGroupOption(
        canBeToggled: false,
        initialState: true,
      ));
    }

    return options;
  }

  @override
  bool duelistCheck(UnitRoster roster, Unit u) {
    final rule = FactionRule.findRule(factionRules, ruleArchitects.id);
    if (rule != null && rule.isEnabled) {
      if (!rule.duelistCheck!(roster, u)) {
        return false;
      }
    } else if (u.type != ModelType.Gear) {
      return false;
    }

    // only 1 duelist is allowed.
    return !roster.hasDuelist();
  }

  @override
  bool hasGroupRole(Unit unit, RoleType target) {
    var rule = FactionRule.findRule(factionRules, poc.ruleSpecialIssue.id);
    if (rule != null &&
        rule.isEnabled &&
        rule.hasGroupRole != null &&
        rule.hasGroupRole!(unit, target)) {
      return true;
    }

    return super.hasGroupRole(unit, target);
  }

  @override
  bool isRoleTypeUnlimited(
      Unit unit, RoleType target, Group group, UnitRoster? ur) {
    var rule = FactionRule.findRule(factionRules, prdf.ruleHighTech.id);
    if (rule != null &&
        rule.isEnabled &&
        rule.isRoleTypeUnlimited != null &&
        rule.isRoleTypeUnlimited!(unit, target, group, ur)) {
      return true;
    }

    rule = FactionRule.findRule(factionRules, ruleCrisisResponders.id);
    if (rule != null &&
        rule.isEnabled &&
        rule.isRoleTypeUnlimited != null &&
        rule.isRoleTypeUnlimited!(unit, target, group, ur)) {
      return true;
    }

    return super.isRoleTypeUnlimited(unit, target, group, ur);
  }

  @override
  bool isUnitCountWithinLimits(CombatGroup cg, Group group, Unit unit) {
    if (unit.hasTag(prdf.ruleBestMenAndWomen.id)) {
      final rule = FactionRule.findRule(
        factionRules,
        prdf.ruleBestMenAndWomen.id,
      )?.isUnitCountWithinLimits;
      if (rule != null) {
        return rule(cg, group, unit);
      }
    }

    return super.isUnitCountWithinLimits(cg, group, unit);
  }

  @override
  int modCostOverride(int baseCost, String modID, Unit u) {
    var rule = FactionRule.findRule(factionRules, poc.ruleGSwatSniper.id);
    if (rule != null && rule.isEnabled && rule.modCostOverride != null) {
      return rule.modCostOverride!(baseCost, modID, u);
    }

    return super.modCostOverride(baseCost, modID, u);
  }

  @override
  bool veteranModCheck(Unit u, CombatGroup cg, {required String modID}) {
    if (cg.isOptionEnabled(pps.ruleBadlandsSoup.id)) {
      var rule = FactionRule.findRule(factionRules, pps.ruleBadlandsSoup.id);
      if (rule != null &&
          rule.isEnabled &&
          rule.veteranModCheck != null &&
          rule.veteranModCheck!(u, cg, modID: modID)) {
        return true;
      }
    }

    var rule = FactionRule.findRule(factionRules, poc.ruleGSwatSniper.id);
    if (rule != null &&
        rule.isEnabled &&
        rule.veteranModCheck != null &&
        rule.veteranModCheck!(u, cg, modID: modID)) {
      return true;
    }

    return super.veteranModCheck(u, cg, modID: modID);
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
    duelistCheck: (roster, u) {
      return (u.type == ModelType.Gear || u.type == ModelType.Strider);
    },
    description: 'The duelist for this force may use a Peace River strider.');

final ruleCrisisResponders = FactionRule(
    name: 'Crisis Responders',
    id: '$_baseRuleId::crisisResponders',
    isRoleTypeUnlimited: (unit, target, group, roster) {
      assert(roster != null);

      return roster!.getCGs().any(
            (cg) => cg.units.any(
              (u) => u.core == unit.core && u.hasMod(crisisRespondersID),
            ),
          );
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
