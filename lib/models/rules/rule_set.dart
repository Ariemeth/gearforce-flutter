import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/roster/roster.dart';
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
  });

  List<UnitCore> airstrikeCounters() {
    return data.unitList(FactionType.Airstrike, includeTerrain: false);
  }

  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u);

  bool duelistCheck(UnitRoster roster, Unit u) {
    if (u.type != 'Gear') {
      return false;
    }

    // only 1 duelist is allowed.
    return !roster.hasDuelist();
  }

  bool canBeCommand(Unit unit) {
    return unit.core.type != 'Airstrike Counter' &&
        unit.core.type != 'Drone' &&
        unit.core.type != 'Building' &&
        unit.core.type != 'Terrain' &&
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
    if (!_hasGroupRole(r, targetRole)) {
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
    return r == null || r.includesRole([RoleType.Upgrade]);
  }

  // Ensure the target Roletype is within the Roles
  bool _hasGroupRole(Roles r, RoleType target) {
    return r.includesRole([target]);
  }

  // Check if the role is unlimited
  bool isRoleTypeUnlimited(UnitCore uc, RoleType target, Group group) {
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
  List<UnitCore> availableUnits(
      {List<RoleType?>? role, List<String>? filters}) {
    return [];
  }
}
