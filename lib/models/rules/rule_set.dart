import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_upgrades.dart';
import 'package:gearforce/models/rules/faction_model_rules.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/validation/validations.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/mods/unitUpgrades/cef.dart' as cef;

const coreTag = 'none';
const _maxPrimaryActions = 6;
const _minPrimaryActions = 4;
const _minMaxSecondaryActions = 2;
const _maxSecondaryActions = 3;
const _maxNumberModels = 2;
const _maxNumberAirstrikes = 4;
const _maxTotalNumberUniversalDrones = 5;

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
  }

  List<FactionRule> allFactionRules({
    Unit? unit = null,
    List<FactionType>? factions = null,
  }) =>
      [
        ...factionRules,
        ...subFactionRules,
        ...GetModelFactionRules(unit, factions),
      ];
  List<FactionRule> get factionRules => _factionRules.toList();
  List<FactionRule> get subFactionRules => _subFactionRules.toList();

  int get maxPrimaryActions => _maxPrimaryActions;
  int get minPrimaryActions => _minPrimaryActions;

  int maxSecondaryActions(int primaryActions) => min(
      max(_minMaxSecondaryActions, (primaryActions / 2).ceil()),
      _maxSecondaryActions);

  bool isRuleEnabled(String ruleName) =>
      FactionRule.isRuleEnabled(allFactionRules(), ruleName);

  FactionRule? findFactionRule(String ruleName) =>
      FactionRule.findRule(allFactionRules(), ruleName);

  List<FactionRule> allEnabledRules(
    List<CombatGroupOption>? cgOptions, {
    bool includeModelRules = true,
    Unit? unit = null,
  }) {
    final enabledAvailableRules =
        FactionRule.enabledRules(allFactionRules(unit: unit)).toList();

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
    final enabledRules = allEnabledRules(cg.options, unit: u).toList();
    final availableFactionModRules =
        enabledRules.where((rule) => rule.factionMods != null).toList();

    final List<FactionModification> availableFactionMods = [];
    availableFactionModRules.forEach((rule) {
      availableFactionMods.addAll(rule.factionMods!(ur, cg, u));
    });

    return availableFactionMods;
  }

  List<SpecialUnitFilter> availableUnitFilters(
    List<CombatGroupOption>? cgOptions,
  ) {
    final List<FactionRule> availableUnitFilterRules = [];

    availableUnitFilterRules.addAll(
        allEnabledRules(cgOptions).where((rule) => rule.unitFilter != null));

    final List<SpecialUnitFilter> availableUnitFilters = [];
    availableUnitFilterRules.forEach((rule) {
      final filter = rule.unitFilter!(cgOptions);
      if (filter != null) {
        availableUnitFilters.add(filter);
      }
    });

    return availableUnitFilters;
  }

  List<Unit> availableUnits({
    List<RoleType>? role,
    List<String>? characterFilters,
    required SpecialUnitFilter specialUnitFilter,
  }) {
    final List<Unit> results = [];
    data
        .getUnitsByFilter(
            filters: specialUnitFilter.filters,
            roleFilter: role,
            characterFilters: characterFilters)
        .forEach((u) {
      results.add(u);
    });

    return results;
  }

  Validations canBeAddedToGroup(Unit unit, Group group, CombatGroup cg) {
    final results = Validations();

    final numIndependentOperator = cg.numUnitsWithMod(independentOperatorId);
    if (!(numIndependentOperator == 0 ||
        (numIndependentOperator == 1 && unit.hasMod(independentOperatorId)))) {
      results.add(Validation(
        false,
        issue: 'An independent Operator is already in the CG',
      ));
      return results;
    }

    // check to ensure the unit passes at least 1 of the enabled rules
    // SpecialUnitFIlters
    final unitFilters = availableUnitFilters(cg.options);
    if (!unitFilters.any((filter) => filter.anyMatch(unit.core))) {
      results.add(Validation(false, issue: 'Unit not allowed'));
      return results;
    }

    // Check if any faction rules override the default canBeAddedToGroup check.
    // If any result is false, then the check is failed.  If all results
    // returned are true,return true
    final canBeAddedToGroupOverrides = allEnabledRules(cg.options)
        .where((rule) => rule.canBeAddedToGroup != null);

    final List<Validation> overrideValues = [];
    canBeAddedToGroupOverrides
        .map((rule) => rule.canBeAddedToGroup!(unit, group, cg))
        .forEach((val) {
      if (val != null) {
        overrideValues.add(val);
      }
    });

    if (overrideValues.isNotEmpty) {
      if (overrideValues.any((val) => val.isNotValid())) {
        overrideValues.forEach((val) {
          if (val.isNotValid()) {
            results.add(val);
          }
        });
        return results;
      }

      results.add(Validation(true));
      return results;
    }

    final targetRole = group.role();

    // Unit must have the role of the group it is being added.
    if (!(hasGroupRole(unit, targetRole, group) ||
        unit.type == ModelType.AirstrikeCounter)) {
      results.add(Validation(
        false,
        issue: 'Unit does not have the ${targetRole.name} role',
      ));
      return results;
    }

    final modelCheckCount = _checkModelRulesCount(unit, group, cg);

    final isUnitAlreadyInGroup = group.allUnits().any((u) => u == unit);
    if (!isUnitAlreadyInGroup) {
      final actions = group.totalActions() + (unit.actions ?? 0);
      final maxAllowedActions = group.groupType == GroupType.Primary
          ? maxPrimaryActions
          : modelCheckCount != null
              ? modelCheckCount
              : maxSecondaryActions(cg.primary.totalActions());
      if (actions > maxAllowedActions) {
        print('Unit ${unit.name} has ${unit.actions} action and cannot be' +
            ' added as it would increase the number of actions beyond the max' +
            ' allowed of $maxAllowedActions');
        results.add(
          Validation(
            false,
            issue: 'This units actions(${unit.actions}) would be over the max' +
                ' of $maxAllowedActions',
          ),
        );
        return results;
      }
    }

    final modelValidation = _checkModelRules(unit, group);
    if (modelValidation != null && modelValidation.isNotValid()) {
      results.add(modelValidation);
      return results;
    }

    if (unit.type == ModelType.Drone &&
        unit.faction == FactionType.Universal_TerraNova) {
      final canBeAdded =
          hasUniversalDroneCapacityAvailable(cg.roster, cg, unit);
      if (!canBeAdded) {
        results.add(Validation(
          canBeAdded,
          issue: 'Max number(${_maxTotalNumberUniversalDrones}) of ' +
              ' ${unit.core.name} have already been added',
        ));
        return results;
      }
    }

    // if the unit is unlimited for the groups roletype you can add as many
    // as you want.
    if (isRoleTypeUnlimited(unit, targetRole, group, cg.roster)) {
      return results;
    }

    final withinCount = isUnitCountWithinLimits(cg, group, unit);

    if (!withinCount) {
      results.add(Validation(
        false,
        issue: 'Max allowed instances of this unit are already added',
      ));
      return results;
    }

    return results;
  }

  bool hasUniversalDroneCapacityAvailable(
      UnitRoster? roster, CombatGroup cg, Unit unit) {
    if (unit.type != ModelType.Drone ||
        unit.faction != FactionType.Universal_TerraNova) {
      return true;
    }

    final dronesInCG = cg.units
        .where((u) =>
            u.type == ModelType.Drone &&
            u.faction == FactionType.Universal_TerraNova &&
            u.core.name == unit.core.name &&
            u != unit)
        .length;
    final HunsInCG =
        cg.units.where((u) => u.core.name.startsWith('Recon Hu')).length;

    final nonFreeDrones = max(dronesInCG - HunsInCG * 2, 0);

    if (nonFreeDrones <= 0) {
      return true;
    }

    if (roster == null) {
      return true;
    }

    final otherDroneCount = numberOfOtherUniversalDrones(roster, cg, unit);
    if ((otherDroneCount + nonFreeDrones) >= _maxTotalNumberUniversalDrones) {
      return false;
    }

    return true;
  }

  int numberOfOtherUniversalDrones(
      UnitRoster roster, CombatGroup combatGroup, Unit unit) {
    var result = 0;

    final allCGs = roster.getCGs().where((cg) => cg != combatGroup);

    if (allCGs.isEmpty) {
      return result;
    }

    allCGs.where((cg) => cg != combatGroup).forEach((cg) {
      final droneCount = cg.units
          .where((u) =>
              u.type == ModelType.Drone &&
              u.faction == FactionType.Universal_TerraNova &&
              u.core.name == unit.core.name)
          .length;
      if (droneCount > 0) {
        final hunCount =
            cg.units.where((u) => u.core.name.startsWith('Recon Hu')).length;
        final allowedByHun = hunCount * 3;
        result += max(droneCount - allowedByHun, 0);
      }
    });

    return result;
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
      cgOptions.addAll(rule.combatGroupOption!());
    });
    return cgOptions;
  }

  bool duelistCheck(UnitRoster roster, CombatGroup cg, Unit u) {
    // Check if any faction rules override the default duelist check.  If any
    // result is false, then the check is failed.  If all results returned are
    // true, continue processing
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
          .map((r) => r.duelistMaxNumberOverride!(roster, cg, u))
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
    if (roster.duelists.where((unit) => unit != u).length >=
        maxAllowedDuelist) {
      return false;
    }
    return true;
  }

  bool duelistModCheck(Unit u, CombatGroup cg, {required String modID}) {
    final duelistModCheckOverrides = allEnabledRules(cg.options).where((rule) =>
        rule.duelistModCheck != null &&
        rule.duelistModCheck!(u, cg, modID: modID) != null);

    final overrideValues = duelistModCheckOverrides
        .map((r) => r.duelistModCheck!(u, cg, modID: modID))
        .where((result) => result != null);

    if (overrideValues.isNotEmpty) {
      if (overrideValues.any((status) => status == false)) {
        return false;
      }
      return true;
    }

    return (u.traits.any((trait) => trait.name == Trait.Duelist().name));
  }

  /// Override a mods requirement check.  Check mod before using to ensure
  /// the mod supports this check.
  bool? modCheck(Unit u, CombatGroup cg, {required String modID}) {
    final modCheckOverrides = allEnabledRules(cg.options)
        .where((rule) => rule.modCheckOverride != null);

    final overrideValues = modCheckOverrides
        .map((r) => r.modCheckOverride!(u, cg, modID: modID))
        .where((result) => result != null);

    if (overrideValues.isNotEmpty) {
      if (overrideValues.any((status) => status == false)) {
        return false;
      }
      return true;
    }

    return null;
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

    if (unit.role == null) {
      return false;
    }

    final hasRole = unit.role!.includesRole([target]);

    if (hasRole) {
      return true;
    }
    // If the unit doesn't have the role, check if there is an upgrade mod that
    // the model has access that could grant access to the role
    final roster = group.combatGroup?.roster;
    if (roster == null) {
      return false;
    }
    final unitMods = getUnitMods(unit.core.frame, unit).where((mod) =>
        mod.hasModOfType(UnitAttribute.roles) &&
        mod.requirementCheck(this, roster, group.combatGroup, unit));
    for (final m in unitMods) {
      final modifiedRoles = m.applyMods(UnitAttribute.roles, unit.core.role);
      if (modifiedRoles!.roles.any((r) => r.name == target)) {
        unit.addUnitMod(m);
        return true;
      }
    }
    final factionMods = availableFactionMods(roster, group.combatGroup!, unit);
    for (final m in factionMods) {
      final modifiedRoles = m.applyMods(UnitAttribute.roles, unit.core.role);
      if (modifiedRoles!.roles.any((r) => r == target)) {
        unit.addUnitMod(m);
        return true;
      }
    }

    return false;
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

    if (unit.type == ModelType.AirstrikeCounter) {
      return count < _maxNumberAirstrikes;
    }

    if (group.groupType == GroupType.Primary) {
      return count < _maxNumberModels;
    }

    return count < 1;
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

  bool vetCheck(
    CombatGroup cg,
    Unit u, {
    List<String> ruleExclusions = const [],
  }) {
    final vetCheckOverrideRules = allEnabledRules(cg.options)
        .where((rule) => rule.veteranCheckOverride != null)
        .where((rule) => !ruleExclusions.any((ruleId) => ruleId == rule.id))
        .toList();
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

  int maxVetGroups(
    UnitRoster ur,
    CombatGroup cg,
  ) {
    var count = 1;
    final vetCGCountOverrideRules = allEnabledRules(cg.options)
        .where((rule) => rule.veteranCGCountOverride != null);
    if (vetCGCountOverrideRules.isNotEmpty) {
      int? overrideCount = 0;
      vetCGCountOverrideRules
          .map((r) => r.veteranCGCountOverride!(ur, cg))
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

    return count;
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

  /// Modifies an existing [Weapon] list based on current [FactionRule]s.
  unitWeaponsModifier(List<Weapon> weapons) {
    final weaponModifierRules =
        allEnabledRules(null).where((rule) => rule.modifyWeapon != null);
    if (weaponModifierRules.isEmpty) {
      return;
    }

    weaponModifierRules.forEach((rule) {
      rule.modifyWeapon!(weapons);
    });
  }

  /// Modifies an existing [Trait] list based on current [FactionRule]s.
  unitTraitsModifier(List<Trait> traits, Unit unit) {
    final traitModifierRules =
        allEnabledRules(null).where((rule) => rule.modifyTraits != null);
    if (traitModifierRules.isEmpty) {
      return;
    }

    traitModifierRules.forEach((rule) {
      rule.modifyTraits!(traits, unit.core);
    });
  }
}

Validation? _checkModelRules(Unit unit, Group group) {
  final frame = unit.core.frame;
  final unitsInGroup = group.allUnits().where((u) => u != unit).toList();

  if (unitsInGroup.isEmpty) {
    return Validation(true);
  }

  // deal with the overlord multi unit model
  if (frame == _overlord) {
    if (group.groupType == GroupType.Secondary) {
      return Validation(false, issue: 'cannot be part of a secondary group');
    }
    if (unitsInGroup
            .where((u) =>
                u.actions != null || (u.actions != null && u.actions! > 0))
            .length >
        1) {
      return Validation(
        false,
        issue: 'already units in the group, will result in to many actions',
      );
    }
    if (unit.name == _overlordBody &&
        unitsInGroup.any((u) =>
            u.name == _overlordTurret ||
            u.actions == null ||
            (u.actions != null && u.actions == 0))) {
      return Validation(true);
    }
    if (unit.name == _overlordTurret &&
        unitsInGroup.any((u) =>
            u.name == _overlordBody ||
            u.actions == null ||
            (u.actions != null && u.actions == 0))) {
      return Validation(true);
    }

    return Validation(false, issue: 'group already contains another unit');
  }

  if (unitsInGroup.any((u) => u.core.frame == _overlord) &&
      (unit.actions != null && unit.actions! > 0)) {
    return Validation(
      false,
      issue:
          'group already contains an Overlord, will result in to many actions',
    );
  }

  // deal with the gilgamesh multi-unit model
  if (frame == _gilgameshFront ||
      frame == _gilgameshBack ||
      frame == _gilgameshTurret) {
    if (group.groupType == GroupType.Secondary) {
      return Validation(false, issue: 'cannot be part of a secondary group');
    }

    // TODO ensure if the front and back parts are the same type, A or B
    // current units in the group need to only be other parts
    if (unitsInGroup.every((u) =>
        u.core.frame != frame &&
        (u.core.frame == _gilgameshFront ||
            u.core.frame == _gilgameshBack ||
            u.core.frame == _gilgameshTurret ||
            (u.actions == null || u.actions! < 1)))) {
      return Validation(true);
    }

    return Validation(
      false,
      issue: 'already units in the group, will result in too many actions',
    );
  }

  if (unitsInGroup.any((u) =>
          u.core.frame == _gilgameshFront ||
          u.core.frame == _gilgameshBack ||
          u.core.frame == _gilgameshTurret) &&
      (unit.actions != null && unit.actions! > 0)) {
    return Validation(
      false,
      issue: 'Gilgamesh already in group, will result in too many actions',
    );
  }

  return null;
}

const _overlord = 'HHT-90 Overlord';
const _overlordBody = 'HHT-90 Overlord Body';
const _overlordTurret = 'HHT-90 Overlord Turret';

const _gilgameshFront = "Gilgamesh Front";
const _gilgameshBack = "Gilgamesh Rear";
const _gilgameshTurret = "Gilgamesh Turret";

int? _checkModelRulesCount(Unit unit, Group group, CombatGroup cg) {
  // handle the extra GREL allowed in a secondary if the primary is the HHT-90
  // Overlord
  if (unit.core.frame == 'GREL' && group.groupType == GroupType.Secondary) {
    if (!group
        .allUnits()
        .every((u) => u.core.frame == 'GREL' && u.hasMod(cef.squad.id))) {
      return null;
    }

    if (cg.primary.allUnits().any((u) => u.core.frame == _overlord) &&
        group.numberOfUnits() >= 3) {
      unit.addUnitMod(cef.squad);
      return 4;
    }
  }

  return null;
}
