import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';

const coreName = 'None';
const coreTag = 'none';
const _maxPrimaryActions = 6;
const _minPrimaryActions = 4;
const _maxSecondaryActions = 3;
const _maxNumberModels = 2;
const _maxNumberAirstrikes = 4;

class DefaultRuleSet extends RuleSet {
  DefaultRuleSet(data)
      : super(
          FactionType.Universal,
          data,
          name: 'Default ruleset',
          factionRules: [],
          subFactionRules: [],
        );
}

abstract class RuleSet extends ChangeNotifier {
  final Data data;
  final List<String>? specialRules;
  final FactionType type;
  final String? description;
  final String name;
  final List<Unit> _unitCache = [];
  final List<FactionRule> _factionRules = [];
  final List<FactionRule> _subFactionRules = [];

  RuleSet(
    this.type,
    this.data, {
    required this.name,
    this.description,
    this.specialRules = null,
    required List<FactionRule> factionRules,
    required List<FactionRule> subFactionRules,
  }) {
    factionRules.forEach((fr) {
      fr.addListener(() {
        this.notifyListeners();
      });
    });
    subFactionRules.forEach((fr) {
      fr.addListener(() {
        this.notifyListeners();
      });
    });
    _factionRules.addAll(factionRules);
    _subFactionRules.addAll(subFactionRules);
    _buildCache();
  }

  List<FactionRule> get allFactionRules => [
        ...factionRules,
        ...subFactionRules,
      ];
  List<FactionRule> get factionRules => _factionRules.toList();
  List<FactionRule> get subFactionRules => _subFactionRules.toList();

  int get maxPrimaryActions => _maxPrimaryActions;
  int get minPrimaryActions => _minPrimaryActions;

  int maxSecondaryActions(int primaryActions) =>
      min((primaryActions / 2).ceil(), _maxSecondaryActions);

  bool isRuleEnabled(String ruleName) =>
      FactionRule.isRuleEnabled(allFactionRules, ruleName);

  FactionRule? findFactionRule(String ruleName) =>
      FactionRule.findRule(allFactionRules, ruleName);

  List<FactionRule> allEnabledRules(List<CombatGroupOption>? cgOptions) {
    final enabledAvailableRules =
        FactionRule.enabledRules(allFactionRules).toList();

    if (cgOptions == null || cgOptions.isEmpty) {
      return enabledAvailableRules;
    }
    // only return faction rules that either have no corresponding combatgroup
    // option or have a combatgroup option that is enabled.
    return enabledAvailableRules.where((r) {
      if (cgOptions.any((cgo) => cgo.factionRule.id == r.id)) {
        final matchingOption =
            cgOptions.firstWhere((o) => o.factionRule.id == r.id);
        return matchingOption.isEnabled;
      }
      return true;
    }).toList();
  }

  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u) {
    final availableFactionModRules =
        allEnabledRules(cg.options).where((rule) => rule.factionMod != null);

    final List<FactionModification> availableFactionMods = [];
    availableFactionModRules.forEach((rule) {
      availableFactionMods.add(rule.factionMod!(ur, cg, u));
    });

    return availableFactionMods;
  }

  List<SpecialUnitFilter> availableUnitFilters(
      List<CombatGroupOption>? cgOptions) {
    final availableUnitFilterRules =
        allEnabledRules(cgOptions).where((rule) => rule.unitFilter != null);

    final List<SpecialUnitFilter> availableUnitFilters = [];
    availableUnitFilterRules.forEach((rule) {
      availableUnitFilters.add(rule.unitFilter!());
    });

    return availableUnitFilters;
  }

  List<Unit> availableUnits({
    List<RoleType>? role,
    List<String>? characterFilters,
    required SpecialUnitFilter specialUnitFilter,
  }) {
    List<Unit> results = _unitCache
        .where((unit) => specialUnitFilter.anyMatch(unit.core))
        .toList();
    if (results.isEmpty) {
      _buildCache();
      _unitCache
          .where((unit) => specialUnitFilter.anyMatch(unit.core))
          .toList();
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
    final numIndependentOperator = cg.numUnitsWithMod(independentOperatorId);
    if (!(numIndependentOperator == 0 ||
        (numIndependentOperator == 1 && unit.hasMod(independentOperatorId)))) {
      return false;
    }

    // check to ensure the unit passes at least 1 of the enabled rules
    // SpecialUnitFIlters
    final unitFilters = availableUnitFilters(cg.options);
    if (!unitFilters.any((filter) => filter.anyMatch(unit.core))) {
      return false;
    }

    // Check if any faction rules override the default canBeAddedToGroup check.
    // If any result is false, then the check is failed.  If all results
    // returned are true,return true
    final canBeAddedToGroupOverrides = allEnabledRules(cg.options)
        .where((rule) => rule.canBeAddedToGroup != null);
    final overrideValues = canBeAddedToGroupOverrides
        .map((rule) => rule.canBeAddedToGroup!(unit, group, cg))
        .where((result) => result != null);
    if (overrideValues.isNotEmpty) {
      if (overrideValues.any((status) => status == false)) {
        return false;
      }
      return true;
    }

    final targetRole = group.role();

    // Unit must have the role of the group it is being added.
    if (!(hasGroupRole(unit, targetRole, group) ||
        unit.type == ModelType.AirstrikeCounter)) {
      return false;
    }

    final isUnitAlreadyInGroup = group.allUnits().any((u) => u == unit);
    if (!isUnitAlreadyInGroup) {
      final actions = group.totalActions() + (unit.actions ?? 0);
      final maxAllowedActions = group.groupType == GroupType.Primary
          ? maxPrimaryActions
          : maxSecondaryActions(cg.primary.totalActions());
      if (actions > maxAllowedActions) {
        print(
            'Unit ${unit.name} has ${unit.actions} action and cannot be added as it would increase the number of actions beyond the max allowed of $maxAllowedActions');
        return false;
      }
    }
    // if the unit is unlimited for the groups roletype you can add as many
    // as you want.
    if (isRoleTypeUnlimited(unit, targetRole, group, cg.roster)) {
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

  int commandTVCost(CommandLevel cl) {
    return switch (cl) {
      CommandLevel.none => 0,
      CommandLevel.cgl => 0,
      CommandLevel.secic => 1,
      CommandLevel.xo => 3,
      CommandLevel.co => 3,
      CommandLevel.tfc => 5,
      CommandLevel.bc => 0,
      CommandLevel.po => 0,
    };
  }

  List<CommandLevel> availableCommandLevels(Unit unit) {
    final hasCommandLevelOverrides =
        allEnabledRules(unit.group?.combatGroup?.options)
            .where((rule) => rule.availableCommandLevelOverride != null);
    final overrideValues = hasCommandLevelOverrides
        .map((rule) => rule.availableCommandLevelOverride!(unit))
        .where((result) => result != null)
        .toList();
    if (overrideValues.isNotEmpty) {
      final List<CommandLevel> results = [];
      overrideValues.forEach((r) {
        if (r != null) {
          results.addAll(r);
        }
      });
      return results;
    }

    final results = [CommandLevel.none];
    if (!unit.hasMod(independentOperatorId)) {
      results.addAll([CommandLevel.cgl, CommandLevel.secic]);
    }
    results.addAll([CommandLevel.xo, CommandLevel.co, CommandLevel.tfc]);
    return results;
  }

  List<CombatGroupOption> combatGroupSettings() {
    final availableCombatOptionRules =
        allEnabledRules(null).where((rule) => rule.combatGroupOption != null);

    final List<CombatGroupOption> cgOptions = [];
    availableCombatOptionRules.forEach((rule) {
      cgOptions.add(rule.combatGroupOption!());
    });
    return cgOptions;
  }

  bool duelistCheck(UnitRoster roster, Unit u) {
    // Check if any faction rules override the default duelist check.  If any
    // result is false, then the check is failed.  If all results returned are
    // true, continue the check
    final modelCheckOverrides = allEnabledRules(u.group?.combatGroup?.options)
        .where((rule) => rule.duelistModelCheck != null);
    final overrideValues = modelCheckOverrides
        .map((r) => r.duelistModelCheck!(roster, u))
        .where((result) => result != null);
    if (overrideValues.isNotEmpty) {
      if (overrideValues.any((status) => status == false)) {
        return false;
      }
    } else if (u.type != ModelType.Gear) {
      return false;
    }

    // core rules limit duelist to 1 per force.
    var maxAllowedDuelist = 1;

    final maxDuelistCountOverrides =
        allEnabledRules(u.group?.combatGroup?.options)
            .where((rule) => rule.duelistMaxNumberOverride != null);
    if (maxDuelistCountOverrides.isNotEmpty) {
      final countOverrideValues = maxDuelistCountOverrides
          .map((r) => r.duelistMaxNumberOverride!(u))
          .where((result) => result != null);

      int? maxOverrride;
      countOverrideValues.forEach((v) {
        if (v == null) {
          return;
        }
        if (maxOverrride == null) {
          maxOverrride = v;
        } else {
          maxOverrride = min(maxOverrride!, v);
        }
      });
      if (maxOverrride != null) {
        maxAllowedDuelist = maxOverrride!;
      }
    }
    return roster.duelistCount < maxAllowedDuelist;
  }

  // Ensure the target Roletype is within the Roles
  bool hasGroupRole(Unit unit, RoleType target, Group group) {
    final hasGroupRoleOverrides = allEnabledRules(group.combatGroup?.options)
        .where((rule) => rule.hasGroupRole != null);
    final overrideValues = hasGroupRoleOverrides
        .map((rule) => rule.hasGroupRole!(unit, target, group))
        .where((result) => result != null);
    if (overrideValues.isNotEmpty) {
      if (overrideValues.any((status) => status == false)) {
        return false;
      }
      return true;
    }

    return unit.role == null ? false : unit.role!.includesRole([target]);
  }

  // Check if the role is unlimited
  bool isRoleTypeUnlimited(
    Unit unit,
    RoleType target,
    Group group,
    UnitRoster? ur,
  ) {
    final isRoleTypeUnlimitedOverrides =
        allEnabledRules(group.combatGroup?.options)
            .where((rule) => rule.isRoleTypeUnlimited != null);

    final overrideValues = isRoleTypeUnlimitedOverrides
        .map((r) => r.isRoleTypeUnlimited!(unit, target, group, ur))
        .toList()
        .where((result) => result != null);
    if (overrideValues.isNotEmpty) {
      if (overrideValues.any((status) => status == false)) {
        return false;
      }
      return true;
    }

    if (unit.role == null) {
      return false;
    }

    if (unit.role!.roles.any((r) => r.name == target && r.unlimited)) {
      return true;
    }

    return false;
  }

  bool isUnitCountWithinLimits(CombatGroup cg, Group group, Unit unit) {
    // get the number other instances of this unitcore in the group
    var count = group
        .allUnits()
        .where((u) => u.core.name == unit.core.name && u != unit)
        .length;

    // Check for any faction rules overriding unit counts.  If multiple rules
    // return a value, use the max value returned.
    final unitCountOverrides = allEnabledRules(cg.options).where((rule) =>
        rule.unitCountOverride != null &&
        rule.unitCountOverride!(cg, group, unit) != null);
    if (unitCountOverrides.isNotEmpty) {
      int? overrideCount = 0;
      unitCountOverrides
          .map((r) => r.unitCountOverride!(cg, group, unit))
          .forEach((result) {
        if (result != null) {
          overrideCount =
              max(overrideCount == null ? 0 : overrideCount!, result);
        }
      });
      if (overrideCount != null) {
        count = overrideCount!;
      }
    }

    if (unit.type == ModelType.AirstrikeCounter) {
      count = cg.roster == null
          ? cg.units
              .where((u) => u.type == ModelType.AirstrikeCounter && u != unit)
              .length
          : cg.roster!.totalAirstrikeCounters() -
              group.allUnits().where((u) => u == unit).length;
    }

    // Check if any faction rules override the default unit count check.  If any
    // result is false, then the check is failed.  If all results returned are
    // true, the check is passed.
    final unitCountWithinLimitsOverrides = allEnabledRules(cg.options)
        .where((rule) => rule.isUnitCountWithinLimits != null);
    final overrideValues = unitCountWithinLimitsOverrides
        .map((r) => r.isUnitCountWithinLimits!(cg, group, unit))
        .toList()
        .where((result) => result != null);
    if (overrideValues.isNotEmpty) {
      if (overrideValues.any((status) => status == false)) {
        return false;
      }
      return true;
    }

    return unit.type == ModelType.AirstrikeCounter
        ? count < _maxNumberAirstrikes
        : count < _maxNumberModels;
  }

  int modCostOverride(int baseCost, String modID, Unit u) {
    final modCostOverrides = allEnabledRules(u.group?.combatGroup?.options)
        .where((rule) => rule.modCostOverride != null);
    if (modCostOverrides.isEmpty) {
      return baseCost;
    }

    // check the rule's modCostOverrides function for any override values for
    // this mod.  If multiple functions are found, return the min value from all
    // of them.
    final overrideValues = modCostOverrides
        .map((r) => r.modCostOverride!(baseCost, modID, u))
        .toList();
    var minOverrideValue = baseCost;
    overrideValues.forEach((v) {
      minOverrideValue = min(minOverrideValue, v);
    });
    return minOverrideValue;
  }

  bool vetCheck(CombatGroup cg, Unit u) {
    final vetCheckOverrideRules = allEnabledRules(cg.options)
        .where((rule) => rule.veteranCheckOverride != null);
    if (vetCheckOverrideRules.isNotEmpty) {
      final overrideValues = vetCheckOverrideRules.map((r) {
        final result = r.veteranCheckOverride!(u, cg);
        return result;
      }).where((result) => result != null);

      if (overrideValues.isNotEmpty) {
        if (overrideValues.any((status) => status == false)) {
          return false;
        }
        return true;
      }
    }

    if (u.type == ModelType.Drone ||
        u.type == ModelType.Terrain ||
        u.type == ModelType.AreaTerrain ||
        u.type == ModelType.AirstrikeCounter ||
        u.traits.any((t) => t.name == "Conscript")) {
      return false;
    }

    return cg.isVeteran;
  }

  bool veteranModCheck(Unit u, CombatGroup cg, {required String modID}) {
    final vetModCheckOverrides = allEnabledRules(cg.options).where((rule) =>
        rule.veteranModCheck != null &&
        rule.veteranModCheck!(u, cg, modID: modID) != null);

    final overrideValues = vetModCheckOverrides
        .map((r) => r.veteranModCheck!(u, cg, modID: modID))
        .where((result) => result != null);

    if (overrideValues.isNotEmpty) {
      if (overrideValues.any((status) => status == false)) {
        return false;
      }
      return true;
    }

    return (u.traits.any((trait) => trait.name == 'Vet'));
  }

  void _buildCache() {
    availableUnitFilters(null).forEach((specialUnitFilter) {
      data
          .getUnitsByFilter(
        filters: specialUnitFilter.filters,
        roleFilter: null,
        characterFilters: null,
      )
          .forEach((uc) {
        _unitCache.add(Unit(core: uc));
      });
    });
  }
}
