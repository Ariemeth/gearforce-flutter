import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/south.dart';
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/rules/options/combat_group_options.dart';
import 'package:gearforce/v3/models/rules/rule_types.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/rules/rulesets/south/ese.dart';
import 'package:gearforce/v3/models/rules/rulesets/south/fha.dart';
import 'package:gearforce/v3/models/rules/rulesets/south/md.dart';
import 'package:gearforce/v3/models/rules/rulesets/south/milicia.dart';
import 'package:gearforce/v3/models/rules/rulesets/south/sra.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/widgets/settings.dart';

const _baseRuleId = 'rule::south::core';
const _rulePoliceStateId = '$_baseRuleId::10';
const _ruleAmphibiansId = '$_baseRuleId::20';
const ruleLionHuntersId = '$_baseRuleId::30';

/*
  All the models in the Southern Model List can be used in any of the sub-lists below. There are also models in the Universal
  Model List that may be selected as well.
  All Southern forces have the following rules:
  * Police State: Southern MP models may be placed in GP, SK, FS or SO units.
  * Amphibians: Up to 2 Water Vipers, or up to 2 Caimans (Caiman variants or the Crocodile variant), may be placed in
  GP, SK, FS, RC or SO units.
*/
class South extends RuleSet {
  South(
    DataV3 data,
    Settings settings, {
    super.description,
    required super.name,
    List<Rule> subFactionRules = const [],
  }) : super(
          FactionType.South,
          data,
          settings: settings,
          factionRules: [rulePoliceState, ruleAmphibians],
          subFactionRules: subFactionRules,
        );

  @override
  List<SpecialUnitFilter> availableUnitFilters(
    List<CombatGroupOption>? cgOptions,
  ) {
    final coreFilter = SpecialUnitFilter(
      text: type.name,
      id: coreTag,
      filters: SouthFilters,
    );
    return [coreFilter, ...super.availableUnitFilters(cgOptions)];
  }

  factory South.SRA(DataV3 data, Settings settings) => SRA(data, settings);
  factory South.MILICIA(DataV3 data, Settings settings) =>
      MILICIA(data, settings);
  factory South.MD(DataV3 data, Settings settings) => MD(data, settings);
  factory South.ESE(DataV3 data, Settings settings) => ESE(data, settings);
  factory South.FHA(DataV3 data, Settings settings) => FHA(data, settings);
}

const SouthFilters = const [
  const UnitFilter(FactionType.South),
  const UnitFilter(FactionType.Airstrike),
  const UnitFilter(FactionType.Universal),
  const UnitFilter(FactionType.Universal_TerraNova),
  const UnitFilter(FactionType.Terrain),
];

final Rule rulePoliceState = Rule(
  name: 'Police State',
  id: _rulePoliceStateId,
  hasGroupRole: (unit, target, group) {
    final isAllowedUnit =
        unit.core.frame.contains('MP') && unit.faction == FactionType.South;
    final isAllowedRole = target == RoleType.GP ||
        target == RoleType.SK ||
        target == RoleType.FS ||
        target == RoleType.SO;

    return isAllowedUnit && isAllowedRole ? true : null;
  },
  description: 'Southern MP models may be placed in GP, SK, FS or SO units.',
);

final Rule ruleAmphibians = Rule(
  name: 'Amphibians',
  id: _ruleAmphibiansId,
  hasGroupRole: (unit, target, group) {
    if (unit.role != null && unit.role!.includesRole([target])) {
      return null;
    }

    final targetRoleIsCorrect = target == RoleType.GP ||
        target == RoleType.SK ||
        target == RoleType.FS ||
        target == RoleType.RC ||
        target == RoleType.SO;
    if (!targetRoleIsCorrect) {
      return null;
    }

    final frame = unit.core.frame;
    if (!(frame == 'Water Viper' ||
        (frame == 'Caiman' &&
            (unit.name == 'Caiman' || unit.name == 'Crocodile')))) {
      return null;
    }

    // Get the number of Water Vipers or Caimans (Caiman and Crocodile variants) entire force
    final eligibleUnits = group.combatGroup?.roster
        ?.getAllUnits()
        .where((u) =>
            u.core.frame == 'Water Viper' ||
            (u.core.frame == 'Caiman' &&
                (u.name == 'Caiman' || u.name == 'Crocodile')))
        .where((u) => u != unit);

    // If there are less then 2 already in the force, no need to check
    // if they are using this rule or not
    if (eligibleUnits == null || eligibleUnits.length < 2) {
      return true;
    }

    // Check how many of the gears are in a group that does not
    // share their role
    final unitsWithoutMatchingGroupRole = eligibleUnits.where((u) {
      if (u.role == null) {
        return false;
      }
      return !u.role!.includesRole([u.group?.role()]);
    });

    // If there are less then 2 without matching group roles, no need
    // to check if they are using this rule or not
    if (unitsWithoutMatchingGroupRole.length < 2) {
      return true;
    }
    // check how many of the remaining units can be satisfied by another rule
    final unitsNeedingThisRule = unitsWithoutMatchingGroupRole.where((u) {
      final g = u.group;
      if (g == null) {
        return false;
      }
      final hasGroupRoleOverrideRules = g
          .combatGroup?.roster?.rulesetNotifer.value
          .allEnabledRules(g.combatGroup?.options)
          .where((rule) =>
              rule.hasGroupRole != null && rule.id != ruleAmphibians.id);
      if (hasGroupRoleOverrideRules == null) {
        return false;
      }
      final overrideValues = hasGroupRoleOverrideRules
          .map((rule) => rule.hasGroupRole!(unit, target, group))
          .where((result) => result != null);
      if (overrideValues.isNotEmpty) {
        if (overrideValues.any((status) => status == false)) {
          return true;
        }
        return false;
      }
      return true;
    });

    if (unitsNeedingThisRule.length < 2) {
      return true;
    }
    return null;
  },
  description: 'Up to 2 Water Vipers, or up to 2 Caimans (Caiman variants or' +
      ' the Crocodile variant), may be placed in GP, SK, FS, RC or SO units.',
);

final Rule ruleLionHunters = Rule(
  name: 'Lion Hunters',
  id: ruleLionHuntersId,
  ruleType: RuleType.AlphaBeta,
  factionMods: (ur, cg, u) => [SouthernFactionMods.lionHunters(u)],
  description: 'Bazookas may be given the Precise+ trait for +1 TV each.',
);
