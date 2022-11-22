import 'package:flutter/widgets.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/combat_group_options.dart';
import 'package:gearforce/models/rules/peace_river/peace_river.dart' as pr;
import 'package:gearforce/models/rules/peace_river/poc.dart' as poc;
import 'package:gearforce/models/rules/peace_river/pps.dart' as pps;
import 'package:gearforce/models/rules/peace_river/prdf.dart' as prdf;
import 'package:gearforce/models/rules/special_unit_filter.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';

const coreName = 'None';
const coreTag = 'none';
const _maxPrimaryActions = 6;
const _minPrimaryActions = 4;

class DefaultRuleSet extends RuleSet {
  DefaultRuleSet(data) : super(FactionType.Universal, data);

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u) {
    return [];
  }

  @override
  List<FactionRule> availableFactionRules() => [];

  @override
  List<SpecialUnitFilter> availableUnitFilters() {
    return [];
  }
}

abstract class RuleSet extends ChangeNotifier {
  final Data data;
  final List<String>? specialRules;
  final List<Unit> _units = [];
  final FactionType type;

  RuleSet(
    this.type,
    this.data, {
    this.specialRules = null,
  }) {
    _buildCache();
  }

  List<FactionRule> get factionUprades => [
        ...availableFactionRules(),
        ...availableSubFactionRules(),
      ];

  int get maxPrimaryActions => _maxPrimaryActions;
  int get minPrimaryActions => _minPrimaryActions;
  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u) {
    List<FactionModification> results = [];

    // Peace River faction rules
    var rule = FactionRule.findRule(factionUprades, pr.ruleEPex.id);
    if (rule != null && rule.isEnabled) {
      results.add(PeaceRiverFactionMods.e_pex());
    }
    rule = FactionRule.findRule(factionUprades, pr.ruleWarriorElite.id);
    if (rule != null && rule.isEnabled) {
      results.add(PeaceRiverFactionMods.warriorElite());
    }
    rule = FactionRule.findRule(factionUprades, pr.ruleCrisisResponders.id);
    if (rule != null && rule.isEnabled) {
      results.add(PeaceRiverFactionMods.crisisResponders(u));
    }
    rule = FactionRule.findRule(factionUprades, pr.ruleLaserTech.id);
    if (rule != null && rule.isEnabled) {
      results.add(PeaceRiverFactionMods.laserTech(u));
    }

    // PRDF faction rules
    rule = FactionRule.findRule(factionUprades, prdf.ruleOlTrusty.id);
    if (rule != null && rule.isEnabled) {
      results.add(PeaceRiverFactionMods.olTrusty());
    }
    rule = FactionRule.findRule(factionUprades, prdf.ruleThunderFromTheSky.id);
    if (rule != null && rule.isEnabled) {
      results.add(PeaceRiverFactionMods.thunderFromTheSky());
    }
    rule = FactionRule.findRule(factionUprades, prdf.ruleEliteElements.id);
    if (rule != null && rule.isEnabled) {
      results.add(PeaceRiverFactionMods.eliteElements(ur));
    }

    return results;
  }

  List<FactionRule> availableFactionRules();
  List<FactionRule> availableSubFactionRules() => [];
  List<SpecialUnitFilter> availableUnitFilters() {
    final List<SpecialUnitFilter> results = [];

    var rule =
        FactionRule.findRule(factionUprades, prdf.ruleBestMenAndWomen.id);
    if (rule != null && rule.isEnabled) {
      results.add(prdf.filterBestMenAndWomen);
    }

    rule = FactionRule.findRule(factionUprades, poc.ruleMercenaryContract.id);
    if (rule != null && rule.isEnabled) {
      results.add(poc.filterMercContract);
    }

    rule = FactionRule.findRule(factionUprades, pps.ruleSubContractors.id);
    if (rule != null && rule.isEnabled) {
      results.add(pps.filterSubContractor);
    }

    return results;
  }

  List<Unit> availableUnits({
    List<RoleType>? role,
    List<String>? characterFilters,
    SpecialUnitFilter? specialUnitFilter,
  }) {
    List<Unit> results = [];

    if (specialUnitFilter != null) {
      results = _units.where((u) => u.hasTag(specialUnitFilter.id)).toList();
      if (results.isEmpty) {
        _buildCache();
        results = _units.where((u) => u.hasTag(specialUnitFilter.id)).toList();
      }
    } else {
      results = _units.where((u) => u.hasTag(coreTag)).toList();
    }

    if (role != null && role.isNotEmpty) {
      results = results.where((u) {
        if (u.role != null) {
          return u.role!.includesRole(role);
        }
        return false;
      }).toList();
    }

    if (characterFilters != null) {
      results =
          results.where((u) => u.core.contains(characterFilters)).toList();
    }

    return results;
  }

  bool canBeAddedToGroup(Unit unit, Group group, CombatGroup cg) {
    var rule = FactionRule.findRule(factionUprades, pps.ruleSubContractors.id);
    if (rule != null &&
        rule.isEnabled &&
        rule.canBeAddedToGroup != null &&
        !rule.canBeAddedToGroup!(unit, group, cg)) {
      return false;
    }

    final r = unit.role;
    final targetRole = group.role();

    // having no role or role type upgrade are always allowed
    if (_isAlwaysAllowedRole(r)) {
      return true;
    }

    // if a null role was not accepted in _isAlwaysAllowedRole, then
    // it cannot be added
    if (r == null) {
      return false;
    }

    // Unit must have the role of the group it is being added.
    if (!hasGroupRole(unit, targetRole)) {
      return false;
    }

    // if the unit is unlimited for the groups roletype you can add as many
    // as you want.
    if (isRoleTypeUnlimited(unit, targetRole, group)) {
      return true;
    }

    return isUnitCountWithinLimits(cg, group, unit);
  }

  bool canBeCommand(Unit unit) {
    return unit.core.type != ModelType.AirstrikeCounter &&
        unit.core.type != ModelType.Drone &&
        unit.core.type != ModelType.Building &&
        unit.core.type != ModelType.Terrain &&
        !unit.traits.any((t) => t.name == 'Conscript');
  }

  CombatGroupOption combatGroupSettings() {
    final options = CombatGroupOption(name: 'Rule Options', options: []);

    var rule = FactionRule.findRule(factionUprades, pps.ruleSubContractors.id);
    if (rule != null && rule.isEnabled) {
      options.options.add(Option(
          name: pps.ruleSubContractors.name,
          id: pps.ruleSubContractors.id,
          requirementCheck: onlyOneCG(
            pps.ruleSubContractors.id,
          )));
    }

    rule = FactionRule.findRule(factionUprades, pps.ruleBadlandsSoup.id);
    if (rule != null && rule.isEnabled) {
      options.options.add(Option(
          name: pps.ruleBadlandsSoup.name,
          id: pps.ruleBadlandsSoup.id,
          requirementCheck: onlyOneCG(
            pps.ruleBadlandsSoup.id,
          )));
    }

    rule = FactionRule.findRule(factionUprades, poc.ruleMercenaryContract.id);
    if (rule != null && rule.isEnabled) {
      options.options.add(Option(
        name: poc.ruleMercenaryContract.name,
        id: poc.ruleMercenaryContract.id,
      ));
    }

    return options;
  }

  bool duelistCheck(UnitRoster roster, Unit u) {
    /*
      Architects: The duelist for this force may use a Peace River strider.
    */
    final rule = FactionRule.findRule(
      factionUprades,
      pr.ruleArchitects.id,
    );
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

  // Ensure the target Roletype is within the Roles
  bool hasGroupRole(Unit unit, RoleType target) {
    var rule = FactionRule.findRule(factionUprades, poc.ruleSpecialIssue.id);
    if (rule != null &&
        rule.isEnabled &&
        rule.hasGroupRole != null &&
        rule.hasGroupRole!(unit, target)) {
      return true;
    }

    return unit.role == null ? false : unit.role!.includesRole([target]);
  }

  // Check if the role is unlimited
  bool isRoleTypeUnlimited(Unit unit, RoleType target, Group group) {
    if (unit.role == null || !unit.role!.roles.any((r) => r.name == target)) {
      return false;
    }
    if (unit.role!.roles
        .firstWhere(((role) => role.name == target))
        .unlimited) {
      return true;
    }

    var rule = FactionRule.findRule(factionUprades, prdf.ruleHighTech.id);
    if (rule != null &&
        rule.isEnabled &&
        rule.isRoleTypeUnlimited != null &&
        rule.isRoleTypeUnlimited!(unit, target, group)) {
      return true;
    }

    return false;
  }

  bool isRuleEnabled(String ruleName) =>
      FactionRule.isRuleEnabled(factionUprades, ruleName);

  bool isUnitCountWithinLimits(CombatGroup cg, Group group, Unit unit) {
    /*
       The Best Men and Women for the Job: One model in each combat group may
       be selected from the Black Talon model list.
    */
    if (unit.hasTag(prdf.ruleBestMenAndWomen.id)) {
      final rule = FactionRule.findRule(
        factionUprades,
        prdf.ruleBestMenAndWomen.id,
      )?.isUnitCountWithinLimits;
      if (rule != null) {
        return rule(cg, group, unit);
      }
    }

    // get the number other instances of this unitcore in the group
    final count =
        group.allUnits().where((u) => u.core.name == unit.core.name).length;

    // Can only have a max of 2 non-unlimted units in a group.
    return count < 2;
  }

  int maxSecondaryActions(int primaryActions) => (primaryActions / 2).ceil();

  int modCostOverride(int baseCost, String modID, Unit u) {
    var rule = FactionRule.findRule(factionUprades, poc.ruleGSwatSniper.id);
    if (rule != null && rule.isEnabled && rule.modCostOverride != null) {
      return rule.modCostOverride!(baseCost, modID, u);
    }

    return baseCost;
  }

  bool veteranModCheck(Unit u, CombatGroup cg, {required String modID}) {
    if (cg.hasTag(pps.ruleBadlandsSoup.id)) {
      var rule = FactionRule.findRule(factionUprades, pps.ruleBadlandsSoup.id);
      if (rule != null &&
          rule.isEnabled &&
          rule.veteranModCheck != null &&
          rule.veteranModCheck!(u, cg, modID: modID)) {
        return true;
      }
    }

    var rule = FactionRule.findRule(factionUprades, poc.ruleGSwatSniper.id);
    if (rule != null &&
        rule.isEnabled &&
        rule.veteranModCheck != null &&
        rule.veteranModCheck!(u, cg, modID: modID)) {
      return true;
    }

    return (u.traits.any((trait) => trait.name == 'Vet'));
  }

  void _buildCache() {
    this.availableUnitFilters().forEach((specialUnitFilter) {
      data
          .getUnitsByFilter(
        filters: specialUnitFilter.filters,
        roleFilter: null,
        characterFilters: null,
      )
          .forEach((uc) {
        if (_units.any((u) => u.core.name == uc.name)) {
          _units.firstWhere((u) => u.core.name == uc.name)
            ..addTag(specialUnitFilter.id);
        } else {
          _units.add(Unit(core: uc)..addTag(specialUnitFilter.id));
        }
      });
    });
  }

  bool _isAlwaysAllowedRole(Roles? r) {
    return r == null;
  }
}
