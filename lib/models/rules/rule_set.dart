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

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u) {
    return [];
  }

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
  final String? description;
  final String name;
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

  List<FactionRule> allEnabledRules() =>
      FactionRule.enabledRules(allFactionRules);

  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u);

  List<SpecialUnitFilter> availableUnitFilters();

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
    final numIndependentOperator = cg.numUnitsWithMod(independentOperatorId);
    if (!(numIndependentOperator == 0 ||
        (numIndependentOperator == 1 && unit.hasMod(independentOperatorId)))) {
      return false;
    }

    final enabledCGOptions = cg.options.where((o) => o.isEnabled);
    for (var option in enabledCGOptions) {
      if (option.factionRule.canBeAddedToGroup != null &&
          !option.factionRule.canBeAddedToGroup!(unit, group, cg)) {
        return false;
      }
    }

    if (!unit.tags.any((t) => t == coreTag)) {
      if (!enabledCGOptions.any((o) => unit.tags.any((t) => t == o.id))) {
        return false;
      }
    }

    final targetRole = group.role();

    // Unit must have the role of the group it is being added.
    if (!(hasGroupRole(unit, targetRole) ||
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
    switch (cl) {
      case CommandLevel.none:
        return 0;
      case CommandLevel.cgl:
        return 0;
      case CommandLevel.secic:
        return 1;
      case CommandLevel.xo:
        return 3;
      case CommandLevel.co:
        return 3;
      case CommandLevel.tfc:
        return 5;
    }
  }

  int commandCPs(CommandLevel cl) {
    switch (cl) {
      case CommandLevel.none:
        return 0;
      case CommandLevel.cgl:
        return 1;
      case CommandLevel.secic:
        return 1;
      case CommandLevel.xo:
        return 1;
      case CommandLevel.co:
        return 1;
      case CommandLevel.tfc:
        return 1;
    }
  }

  List<CommandLevel> availableCommandLevels(Unit unit) {
    final results = [CommandLevel.none];
    if (!unit.hasMod(independentOperatorId)) {
      results.addAll([CommandLevel.cgl, CommandLevel.secic]);
    }
    results.addAll([CommandLevel.xo, CommandLevel.co, CommandLevel.tfc]);
    return results;
  }

  List<CombatGroupOption> combatGroupSettings() => [];

  bool duelistCheck(UnitRoster roster, Unit u) {
    final modelCheckOverrides =
        allEnabledRules().where((rule) => rule.duelistModelCheck != null);
    if (modelCheckOverrides.isNotEmpty) {
      if (modelCheckOverrides
          .any((rule) => !rule.duelistModelCheck!(roster, u))) {
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
    final hasGroupRoleOverride =
        allEnabledRules().where((rule) => rule.hasGroupRole != null);
    if (hasGroupRoleOverride.isNotEmpty) {
      if (hasGroupRoleOverride
          .any((rule) => rule.hasGroupRole!(unit, target))) {
        return true;
      }
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
        allEnabledRules().where((rule) => rule.isRoleTypeUnlimited != null);

    final overrideValues = isRoleTypeUnlimitedOverrides
        .map((r) => r.isRoleTypeUnlimited!(unit, target, group, ur))
        .toList()
        .where((result) => result != null);
    if (overrideValues.length > 0) {
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
    final unitCountOverrides = allEnabledRules().where((rule) =>
        rule.unitCountOverride != null &&
        rule.unitCountOverride!(cg, group, unit) != null);
    if (unitCountOverrides.length > 0) {
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
    final unitCountWithinLimitsOverrides =
        allEnabledRules().where((rule) => rule.isUnitCountWithinLimits != null);
    final overrideValues = unitCountWithinLimitsOverrides
        .map((r) => r.isUnitCountWithinLimits!(cg, group, unit))
        .toList()
        .where((result) => result != null);
    if (overrideValues.length > 0) {
      if (overrideValues.any((status) => status == false)) {
        return false;
      }
      return true;
    }

    return unit.type == ModelType.AirstrikeCounter
        ? count < _maxNumberAirstrikes
        : count < _maxNumberModels;
  }

  int modCostOverride(int baseCost, String modID, Unit u) => baseCost;

  bool vetCheck(CombatGroup cg, Unit u) {
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
}
