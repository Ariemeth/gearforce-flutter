import 'package:flutter/widgets.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';

class FactionRule extends ChangeNotifier {
  FactionRule({
    required this.name,
    required this.id,
    List<FactionRule>? options = null,
    this.description = '',
    bool isEnabled = true,
    this.canBeToggled = false,
    this.requirementCheck = ruleAlwaysAvailable,
    this.cgCheck = alwaysTrueCG,
    this.duelistModelCheck,
    this.duelistMaxNumberOverride,
    this.availableCommandLevelOverride,
    this.veteranModCheck,
    this.veteranCheckOverride,
    this.modCostOverride,
    this.canBeAddedToGroup,
    this.hasGroupRole,
    this.isRoleTypeUnlimited,
    this.isUnitCountWithinLimits,
    this.unitCountOverride,
    this.combatGroupOption,
    this.factionMod,
    this.unitFilter,
    this.onModAdded,
    this.onModRemoved,
  }) {
    _isEnabled = isEnabled;
    _options = options;
    if (options != null) {
      for (final o in options) {
        o.addListener(() {
          this.notifyListeners();
        });
      }
    }
  }

  final String name;
  final String id;
  List<FactionRule>? get options =>
      _options == null ? null : _options!.toList();
  late final List<FactionRule>? _options;
  final String description;
  late bool _isEnabled;
  final bool canBeToggled;
  final bool Function(List<FactionRule>) requirementCheck;
  final bool Function(CombatGroup?, UnitRoster?) cgCheck;

  final bool? Function(UnitRoster roster, Unit u)? duelistModelCheck;
  final int? Function(UnitRoster roster, CombatGroup cg, Unit u)?
      duelistMaxNumberOverride;

  final List<CommandLevel>? Function(Unit u)? availableCommandLevelOverride;

  /// Overrides the requirement to be a veteran add a specific veteran upgrade.
  /// Return true if the veteran upgrade can be acquired.  False if this model
  /// absolutely should not have the upgrade (rare), or null if this rule does
  /// not apply.
  final bool? Function(Unit u, CombatGroup cg, {required String modID})?
      veteranModCheck;
  final bool? Function(Unit u, CombatGroup cg)? veteranCheckOverride;
  final int Function(int baseCost, String modID, Unit u)? modCostOverride;

  final bool? Function(Unit unit, Group group, CombatGroup cg)?
      canBeAddedToGroup;
  final bool? Function(Unit unit, RoleType target, Group group)? hasGroupRole;
  final bool? Function(Unit unit, RoleType target, Group group, UnitRoster? ur)?
      isRoleTypeUnlimited;
  final bool? Function(CombatGroup cg, Group group, Unit unit)?
      isUnitCountWithinLimits;
  final int? Function(CombatGroup cg, Group group, Unit unit)?
      unitCountOverride;
  final CombatGroupOption Function()? combatGroupOption;
  final FactionModification Function(UnitRoster ur, CombatGroup cg, Unit u)?
      factionMod;
  final SpecialUnitFilter Function()? unitFilter;

  final Function(Unit unit, String modId)? onModAdded;
  final Function(Unit unit, String modId)? onModRemoved;

  bool get isEnabled => _isEnabled;

  void setIsEnabled(bool value, List<FactionRule> rules) {
    // If the value isn't being changed or the value cannot be changed do nothing
    if (value == _isEnabled || !canBeToggled) {
      return;
    }

    // If trying to enable the rule the the requirement check must succeed, else
    // do nothing
    if (value && !this.requirementCheck(rules)) {
      return;
    }

    _isEnabled = value;

    notifyListeners();
  }

  CombatGroupOption buidCombatGroupOption({
    bool canBeToggled = true,
    bool initialState = false,
    bool Function(CombatGroup?, UnitRoster?)? cgCheck,
    Function()? listener,
  }) {
    final cgOption = CombatGroupOption(
      this,
      name: name,
      id: id,
      requirementCheck: cgCheck != null ? cgCheck : this.cgCheck,
      canBeToggled: canBeToggled,
      initialState: initialState,
      description: description,
    );
    if (listener == null) {
      cgOption.addListener(() {
        this.notifyListeners();
      });
    } else {
      cgOption.addListener(listener);
    }
    return cgOption;
  }

  static bool isRuleEnabled(List<FactionRule> rules, String ruleID) {
    for (final r in rules) {
      if (r.id == ruleID) {
        return r.isEnabled;
      }
      if (r._options != null) {
        final isFound = isRuleEnabled(r._options!, ruleID);
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
      if (r._options != null) {
        final rule = findRule(r._options!, ruleID);
        if (rule != null) {
          return rule;
        }
      }
    }
    return null;
  }

  static List<FactionRule> enabledRules(List<FactionRule> rules) {
    final List<FactionRule> results = [];
    rules.forEach((rule) {
      if (rule.isEnabled) {
        results.add(rule);
        if (rule.options != null) {
          results.addAll(enabledRules(rule.options!));
        }
      }
    });

    return results;
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
    String? id,
    List<FactionRule>? options,
    bool? isEnabled,
    bool? canBeToggled,
    bool Function(List<FactionRule>)? requirementCheck,
    bool Function(CombatGroup?, UnitRoster?)? cgCheck,
    CombatGroupOption Function()? combatGroupOption,
  }) {
    return FactionRule(
      name: original.name,
      id: id != null ? id : original.id,
      options: options != null ? options : original._options?.toList(),
      isEnabled: isEnabled != null ? isEnabled : original.isEnabled,
      canBeToggled: canBeToggled != null ? canBeToggled : original.canBeToggled,
      description: original.description,
      requirementCheck: requirementCheck != null
          ? requirementCheck
          : original.requirementCheck,
      duelistModelCheck: original.duelistModelCheck,
      duelistMaxNumberOverride: original.duelistMaxNumberOverride,
      availableCommandLevelOverride: original.availableCommandLevelOverride,
      veteranModCheck: original.veteranModCheck,
      veteranCheckOverride: original.veteranCheckOverride,
      modCostOverride: original.modCostOverride,
      canBeAddedToGroup: original.canBeAddedToGroup,
      hasGroupRole: original.hasGroupRole,
      isRoleTypeUnlimited: original.isRoleTypeUnlimited,
      isUnitCountWithinLimits: original.isUnitCountWithinLimits,
      unitCountOverride: original.unitCountOverride,
      combatGroupOption: combatGroupOption != null
          ? combatGroupOption
          : original.combatGroupOption,
      factionMod: original.factionMod,
      unitFilter: original.unitFilter,
      onModAdded: original.onModAdded,
      onModRemoved: original.onModRemoved,
      cgCheck: cgCheck != null ? cgCheck : original.cgCheck,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'enabled': this._isEnabled,
      'options': this.options == null
          ? null
          : this.options!.map((o) => o.toJson()).toList(),
    };
  }
}
