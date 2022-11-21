import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';

class FactionRule {
  FactionRule({
    required this.name,
    required this.id,
    this.options = null,
    this.description = '',
    isEnabled = true,
    this.canBeToggled = false,
    this.requirementCheck = ruleAlwaysAvailable,
    this.duelistCheck,
    this.veteranModCheck,
    this.modCostOverride,
    this.canBeCommand,
    this.canBeAddedToGroup,
    this.hasGroupRole,
    this.isRoleTypeUnlimited,
    this.isUnitCountWithinLimits,
  }) {
    _isEnabled = isEnabled;
  }

  final String name;
  final String id;
  final List<FactionRule>? options;
  final String description;
  late bool _isEnabled;
  final bool canBeToggled;
  final bool Function(List<FactionRule>) requirementCheck;

  final bool Function(UnitRoster roster, Unit u)? duelistCheck;
  final bool Function(Unit u, CombatGroup cg, {required String modID})?
      veteranModCheck;
  final int Function(int baseCost, String modID, Unit u)? modCostOverride;
  final bool Function(Unit unit)? canBeCommand;
  final bool Function(Unit unit, Group group, CombatGroup cg)?
      canBeAddedToGroup;
  final bool Function(Unit unit, RoleType target)? hasGroupRole;
  final bool Function(Unit unit, RoleType target, Group group)?
      isRoleTypeUnlimited;
  final bool Function(CombatGroup cg, Group group, Unit unit)?
      isUnitCountWithinLimits;

  bool get isEnabled => _isEnabled;
  void toggleIsEnabled(List<FactionRule> rules) {
    if (canBeToggled && this.requirementCheck(rules)) {
      _isEnabled = !_isEnabled;
    }
  }

  static bool isRuleEnabled(List<FactionRule> rules, String ruleID) {
    for (final r in rules) {
      if (r.id == ruleID) {
        return r.isEnabled;
      }
      if (r.options != null) {
        final isFound = isRuleEnabled(r.options!, ruleID);
        if (isFound) {
          return true;
        }
      }
    }
    return false;
  }

  static FactionRule? findRule(List<FactionRule> rules, String ruleID) {
    for (final r in rules) {
      if (r.id == ruleID) {
        return r;
      }
      if (r.options != null) {
        final rule = findRule(r.options!, ruleID);
        if (rule != null) {
          return rule;
        }
      }
    }
    return null;
  }

  static bool ruleAlwaysAvailable(List<FactionRule> rules) => true;

  static bool Function(List<FactionRule> rules) thereCanBeOnlyOne(
      List<String> excludedIDs) {
    return (List<FactionRule> rules) {
      for (final ID in excludedIDs) {
        // if a rule that is on the exclude list is already enabled
        // this rule cannot be.
        if (isRuleEnabled(rules, ID)) {
          return false;
        }
      }
      return true;
    };
  }

  factory FactionRule.from(
    FactionRule original, {
    List<FactionRule>? options,
    bool? isEnabled,
    bool? canBeToggled,
    bool Function(List<FactionRule>)? requirementCheck,
  }) {
    return FactionRule(
      name: original.name,
      id: original.id,
      options: options != null ? options : original.options?.toList(),
      isEnabled: isEnabled != null ? isEnabled : original.isEnabled,
      canBeToggled: canBeToggled != null ? canBeToggled : original.canBeToggled,
      description: original.description,
      requirementCheck: requirementCheck != null
          ? requirementCheck
          : original.requirementCheck,
      duelistCheck: original.duelistCheck,
      veteranModCheck: original.veteranModCheck,
      modCostOverride: original.modCostOverride,
      canBeCommand: original.canBeCommand,
      canBeAddedToGroup: original.canBeAddedToGroup,
      hasGroupRole: original.hasGroupRole,
      isRoleTypeUnlimited: original.isRoleTypeUnlimited,
      isUnitCountWithinLimits: original.isUnitCountWithinLimits,
    );
  }
}
