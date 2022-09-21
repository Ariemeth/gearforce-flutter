import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/special_unit_filter.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_core.dart';

abstract class RuleSet {
  final Data data;
  final List<String>? specialRules;

  const RuleSet(
    this.data, {
    this.specialRules = null,
  });

  List<UnitCore> availableUnits({
    List<RoleType?>? role,
    List<String>? filters,
    SpecialUnitFilter? specialUnitFilter,
  });

  List<SpecialUnitFilter> availableSpecials() {
    return [
      const SpecialUnitFilter(
        text: 'None',
        filters: [],
      )
    ];
  }

  List<UnitCore> airstrikeCounters() {
    return data.unitList(
      FactionType.Airstrike,
      includeTerrain: false,
      includeUniversal: false,
    );
  }

  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u);

  bool duelistCheck(UnitRoster roster, Unit u) {
    if (u.type != ModelType.Gear) {
      return false;
    }

    // only 1 duelist is allowed.
    return !roster.hasDuelist();
  }

  bool veteranModCheck(Unit u, {String? modID}) {
    return (u.traits.any((trait) => trait.name == 'Vet'));
  }

  int modCostOverride(int baseCost, String modID, Unit u) {
    return baseCost;
  }

  bool canBeCommand(Unit unit) {
    return unit.core.type != ModelType.AirstrikeCounter &&
        unit.core.type != ModelType.Drone &&
        unit.core.type != ModelType.Building &&
        unit.core.type != ModelType.Terrain &&
        !unit.traits.any((t) => t.name == 'Conscript');
  }

  bool canBeAddedToGroup(UnitCore uc, Group group) {
    final r = uc.role;
    final targetRole = group.role();

    // having no role or role type upgrade are always allowed
    if (_isAlwaysAllowedRole(r)) {
      return true;
    }

    // if a null roll was not accepted in _isAlwaysAllowedRole, then
    // it cannot be added
    if (r == null) {
      return false;
    }

    // Unit must have the role of the group it is being added.
    if (!hasGroupRole(uc, targetRole)) {
      return false;
    }

    // if the unit is unlimited for the groups roletype you can add as many
    // as you want.
    if (isRoleTypeUnlimited(uc, targetRole, group)) {
      return true;
    }

    return _isUnitCountWithinLimits(group, uc);
  }

  bool _isAlwaysAllowedRole(Roles? r) {
    return r == null;
  }

  // Ensure the target Roletype is within the Roles
  bool hasGroupRole(UnitCore uc, RoleType target) {
    return uc.role == null ? false : uc.role!.includesRole([target]);
  }

  // Check if the role is unlimited
  bool isRoleTypeUnlimited(UnitCore uc, RoleType target, Group group) {
    if (uc.role == null || uc.role!.roles.any((r) => r.name == target)) {
      return false;
    }
    return uc.role!.roles.firstWhere(((role) => role.name == target)).unlimited;
  }

  bool _isUnitCountWithinLimits(Group group, UnitCore uc) {
    // get the number other instances of this unitcore in the group
    final count =
        group.allUnits().where((unit) => unit.core.name == uc.name).length;

    // Can only have a max of 2 non-unlimted units in a group.
    return count < 2;
  }
}

class DefaultRuleSet extends RuleSet {
  const DefaultRuleSet(super.data);

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u) {
    return [];
  }

  @override
  List<UnitCore> availableUnits({
    List<RoleType?>? role,
    List<String>? filters,
    SpecialUnitFilter? specialUnitFilter,
  }) {
    return [];
  }
}
