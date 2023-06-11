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

class DefaultRuleSet extends RuleSet {
  DefaultRuleSet(data)
      : super(
          FactionType.Universal,
          data,
          name: 'Default ruleset',
        );

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
  final String? description;
  final String name;

  RuleSet(
    this.type,
    this.data, {
    required this.name,
    this.description,
    this.specialRules = null,
  }) {
    _buildCache();
  }

  List<FactionRule> get factionRules => [
        ...availableFactionRules(),
        ...availableSubFactionRules(),
      ];

  int get maxPrimaryActions => _maxPrimaryActions;
  int get minPrimaryActions => _minPrimaryActions;

  int maxSecondaryActions(int primaryActions) =>
      min((primaryActions / 2).ceil(), _maxSecondaryActions);

  List<FactionModification> availableFactionMods(
          UnitRoster ur, CombatGroup cg, Unit u) =>
      [];

  List<FactionRule> availableFactionRules();
  List<FactionRule> availableSubFactionRules() => [];
  List<SpecialUnitFilter> availableUnitFilters() => [];

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
    if (u.type != ModelType.Gear) {
      return false;
    }

    // only 1 duelist is allowed.
    return !roster.hasDuelist();
  }

  // Ensure the target Roletype is within the Roles
  bool hasGroupRole(Unit unit, RoleType target) {
    return unit.role == null ? false : unit.role!.includesRole([target]);
  }

  // Check if the role is unlimited
  bool isRoleTypeUnlimited(
      Unit unit, RoleType target, Group group, UnitRoster? ur) {
    if (unit.role == null) {
      return false;
    }

    if (unit.role!.roles
        .firstWhere(((role) => role.name == target))
        .unlimited) {
      return true;
    }

    return false;
  }

  bool isRuleEnabled(String ruleName) =>
      FactionRule.isRuleEnabled(factionRules, ruleName);

  bool isUnitCountWithinLimits(CombatGroup cg, Group group, Unit unit) {
    // get the number other instances of this unitcore in the group
    var count = 0;
    var maxCount = 2;
    if (unit.type == ModelType.AirstrikeCounter) {
      count = cg.roster == null
          ? cg.units.where((u) => u.type == ModelType.AirstrikeCounter).length
          : cg.roster!.totalAirstrikeCounters();
      maxCount = group.allUnits().contains(unit) ? 5 : 4;
    } else {
      count =
          group.allUnits().where((u) => u.core.name == unit.core.name).length;
      maxCount = group.allUnits().contains(unit) ? 3 : 2;
    }

    // Can only have a max of 2 non-unlimted units in a group.
    return count < maxCount;
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
