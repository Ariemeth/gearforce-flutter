import 'package:flutter/widgets.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/combat_group_options.dart';
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

  List<FactionRule> get factionRules => [
        ...availableFactionRules(),
        ...availableSubFactionRules(),
      ];

  int get maxPrimaryActions => _maxPrimaryActions;
  int get minPrimaryActions => _minPrimaryActions;
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

  CombatGroupOption combatGroupSettings() =>
      CombatGroupOption(name: 'Rule Options', options: []);

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
    if (unit.role == null || !unit.role!.roles.any((r) => r.name == target)) {
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
    final count =
        group.allUnits().where((u) => u.core.name == unit.core.name).length;

    // Can only have a max of 2 non-unlimted units in a group.
    return count < 2;
  }

  int maxSecondaryActions(int primaryActions) => (primaryActions / 2).ceil();

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

  bool _isAlwaysAllowedRole(Roles? r) {
    return r == null;
  }
}
