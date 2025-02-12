import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/combatGroups/group.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/north.dart';
import 'package:gearforce/v3/models/rules/rulesets/north/ng.dart';
import 'package:gearforce/v3/models/rules/rulesets/north/nlc.dart';
import 'package:gearforce/v3/models/rules/rulesets/north/umf.dart';
import 'package:gearforce/v3/models/rules/rulesets/north/wfp.dart';
import 'package:gearforce/v3/models/rules/options/combat_group_options.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/command.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/widgets/settings.dart';

const String _baseRuleId = 'rule::north::core';
const String _ruleTaskBuiltId = '$_baseRuleId::10';
const String _ruleProspectorsId = '$_baseRuleId::20';
const String _ruleHammersOfTheNorthId = '$_baseRuleId::30';
const String _ruleVeteranLeadersId = '$_baseRuleId::40';
const String _ruleDragoonSquadId = '$_baseRuleId::50';

/*
  All Northern models have the following rules:
  * Task Built: Each Northern gear may swap its rocket pack for an Heavy Machinegun (HMG) for 0 TV. Each Northern
  gear without a rocket pack may add an HMG for 1 TV. Each Bricklayer, Engineering Grizzly, Camel Truck and Stinger
  may also add an HMG for 1 TV.
  All Northern forces have the following rules:
  * Prospectors: Up to two gears with the Climber trait may be placed in GP, SK, FS, RC or SO units.
  * Hammers of the North: Snub cannons may be given the Precise trait for +1 TV each.
  * Veteran Leaders: You may purchase the Vet trait for any commander in the force without counting against the
  normal veteran limitations.
  * Dragoon Squad: Models in one SK unit may purchase the Vet trait without counting against the veteran limitations.
  Any Cheetah variant may be placed in this SK unit.
*/

class North extends RuleSet {
  North(
    DataV3 data,
    Settings settings, {
    super.description,
    required super.name,
    List<Rule> subFactionRules = const [],
  }) : super(
          FactionType.north,
          data,
          settings: settings,
          factionRules: [
            ruleProspectors,
            ruleHammersOfTheNorth,
            ruleVeteranLeaders,
            ruleDragoonSquad,
          ],
          subFactionRules: subFactionRules,
        );

  @override
  List<SpecialUnitFilter> availableUnitFilters(
    List<CombatGroupOption>? cgOptions,
  ) {
    final filters = [
      SpecialUnitFilter(
        text: type.name,
        id: coreTag,
        filters: const [
          UnitFilter(FactionType.north),
          UnitFilter(FactionType.airstrike),
          UnitFilter(FactionType.universal),
          UnitFilter(FactionType.universalTerraNova),
          UnitFilter(FactionType.terrain),
        ],
      ),
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory North.ng(DataV3 data, Settings settings) => NG(data, settings);
  factory North.wfp(DataV3 data, Settings settings) => WFP(data, settings);
  factory North.umf(DataV3 data, Settings settings) => UMF(data, settings);
  factory North.nlc(DataV3 data, Settings settings) => NLC(data, settings);
}

final Rule ruleTaskBuilt = Rule(
  name: 'Task Built',
  id: _ruleTaskBuiltId,
  factionMods: (ur, cg, u) {
    final isNorthernGear =
        u.faction == FactionType.north && u.type == ModelType.gear;
    final isOtherAcceptable = u.core.frame == 'Bricklayer' ||
        u.core.frame == 'Engineering Grizzly' ||
        u.core.frame == 'Camel Truck' ||
        u.core.frame == 'Stinger';
    if (isNorthernGear || isOtherAcceptable) {
      return [NorthernFactionMods.taskBuilt(u)];
    }
    return [];
  },
  description:
      'Each Northern gear may swap its rocket pack for a Heavy Machinegun' +
          ' (HMG) for 0 TV. Each Northern gear without a rocket pack may' +
          ' add an HMG for 1 TV. Each Bricklayer, Engineering Grizzly,' +
          ' Camel Truck and Stinger may also add an HMG for 1 TV.',
);

final Rule ruleProspectors = Rule(
  name: 'Prospectors',
  id: _ruleProspectorsId,
  hasGroupRole: (unit, target, group) {
    if (unit.type != ModelType.gear) {
      return null;
    }

    if (unit.role != null && unit.role!.includesRole([target])) {
      return null;
    }

    final targetRoleIsCorrect = target == RoleType.gp ||
        target == RoleType.sk ||
        target == RoleType.fs ||
        target == RoleType.rc ||
        target == RoleType.so;
    if (!targetRoleIsCorrect) {
      return null;
    }

    final hasClimber =
        unit.traits.any((trait) => trait.isSameType(Trait.climber()));
    if (!hasClimber) {
      return null;
    }

    // Get the number of gears with climber in the entire force
    final unitsWithClimber = group.combatGroup?.roster
        ?.unitsWithTrait(Trait.climber())
        .where((u) => u != unit);

    // If there are less then 2 climbers already in the force, no need to check
    // if they are using this rule or not
    if (unitsWithClimber == null || unitsWithClimber.length < 2) {
      return true;
    }

    // Check how many of the gears with climbing are in a group that does not
    // share their role
    final unitsWithoutMatchingGroupRole = unitsWithClimber.where((u) {
      if (u.role == null) {
        return false;
      }
      return !u.role!.includesRole([u.group?.role()]);
    });

    // If there are less then 2 climbers without matching group roles, no need
    // to check if they are using this rule or not
    if (unitsWithoutMatchingGroupRole.length < 2) {
      return true;
    }
    // check how many of the remaining units can be satisfied by another rule
    final unitsNeedingProspectors = unitsWithoutMatchingGroupRole.where((u) {
      final g = u.group;
      if (g == null) {
        return false;
      }
      final hasGroupRoleOverrideRules = g
          .combatGroup?.roster?.rulesetNotifer.value
          .allEnabledRules(g.combatGroup?.options)
          .where((rule) =>
              rule.hasGroupRole != null && rule.id != ruleProspectors.id);
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

    if (unitsNeedingProspectors.length < 2) {
      return true;
    }
    return null;
  },
  description: 'Up to two gears with the Climber trait may be placed in GP,' +
      ' SK, FS, RC or SO units.',
);

final Rule ruleHammersOfTheNorth = Rule(
  name: 'Hammers of the North',
  id: _ruleHammersOfTheNorthId,
  factionMods: (ur, cg, u) => [NorthernFactionMods.hammerOfTheNorth(u)],
  description: 'Snub cannons may be given the Precise trait for +1 TV each.',
);

final Rule ruleVeteranLeaders = Rule(
  name: 'Veteran Leaders',
  id: _ruleVeteranLeadersId,
  veteranCheckOverride: (u, cg) {
    if (u.commandLevel != CommandLevel.none) {
      return true;
    }
    return null;
  },
  description: 'You may purchase the Vet trait for any commander in the' +
      ' force without counting against the normal veteran limitations',
);

final Rule ruleDragoonSquad = Rule(
  name: 'Dragoon Squad',
  id: _ruleDragoonSquadId,
  cgCheck: (cg, roster) {
    if (cg?.primary.role() != RoleType.sk &&
        cg?.secondary.role() != RoleType.sk) {
      return false;
    }

    if (!onlyOneCG(ruleDragoonSquad.id)(cg, roster)) {
      return false;
    }

    return true;
  },
  combatGroupOption: () => [ruleDragoonSquad.buidCombatGroupOption()],
  veteranCheckOverride: (u, cg) {
    if (u.group?.role() != RoleType.sk) {
      return null;
    }

    // If this is a vet group no need to check
    if (cg.isVeteran) {
      return null;
    }

    // Getting the other group in the cg
    final otherGroup =
        u.group?.groupType == GroupType.primary ? cg.secondary : cg.primary;

    // If the other group is empty no additional checks are needed
    if (otherGroup.allUnits().isEmpty) {
      return true;
    }

    // Check if the other group in the cg is also sk
    if (otherGroup.role() != RoleType.sk) {
      return true;
    }

    final vetsInOtherUnit =
        otherGroup.allUnits().where((unit) => unit.isVeteran);
    if (vetsInOtherUnit.isNotEmpty) {
      // check how many of the remaining units can be satisfied by another rule
      final unitsNeedingDragoonSquad = vetsInOtherUnit.where((u) {
        final g = u.group;
        if (g == null) {
          return false;
        }
        final hasVeteranCheckOverrideRules = g
            .combatGroup?.roster?.rulesetNotifer.value
            .allEnabledRules(g.combatGroup?.options)
            .where((rule) =>
                rule.veteranCheckOverride != null &&
                rule.id != ruleDragoonSquad.id);
        if (hasVeteranCheckOverrideRules == null) {
          return false;
        }
        final overrideValues = hasVeteranCheckOverrideRules
            .map((rule) => rule.veteranCheckOverride!(u, cg))
            .where((result) => result != null);
        if (overrideValues.isNotEmpty) {
          if (overrideValues.any((status) => status == false)) {
            return true;
          }
          return false;
        }
        return true;
      });

      if (unitsNeedingDragoonSquad.isNotEmpty) {
        return null;
      }
    }

    // if cheetahs that could only be there because of this rule it can't be
    // used here
    final cheetahsInOtherUnit =
        otherGroup.allUnits().where((unit) => unit.core.frame == 'Cheetah');
    if (cheetahsInOtherUnit.isEmpty) {
      return true;
    }

    // check how many of the remaining units can be satisfied by another rule
    final cheetahsNeedingDragoonSquad = cheetahsInOtherUnit.where((u) {
      final g = u.group;
      if (g == null) {
        return false;
      }
      final hasGroupRoleOverrideRules = g
          .combatGroup?.roster?.rulesetNotifer.value
          .allEnabledRules(g.combatGroup?.options)
          .where((rule) =>
              rule.hasGroupRole != null && rule.id != ruleDragoonSquad.id);
      if (hasGroupRoleOverrideRules == null) {
        return false;
      }
      final overrideValues = hasGroupRoleOverrideRules
          .map((rule) => rule.hasGroupRole!(u, u.group!.role(), u.group!))
          .where((result) => result != null);
      if (overrideValues.isNotEmpty) {
        if (overrideValues.any((status) => status == false)) {
          return true;
        }
        return false;
      }
      return true;
    });

    if (cheetahsNeedingDragoonSquad.isEmpty) {
      return true;
    }

    return null;
  },
  hasGroupRole: (unit, target, group) {
    if (group.role() != RoleType.sk) {
      return null;
    }

    if (unit.core.frame != 'Cheetah') {
      return null;
    }

    // Getting the other group in the cg
    final otherGroup = group.groupType == GroupType.primary
        ? group.combatGroup?.secondary
        : group.combatGroup?.primary;

    // If the other group is empty no additional checks are needed
    if (otherGroup == null || otherGroup.isEmpty()) {
      return true;
    }

    // Check if the other group in the cg is also sk
    if (otherGroup.role() != RoleType.sk) {
      return true;
    }

    // check if the other unit in the combatgroup is already using the rule
    final vetsInOtherUnit =
        otherGroup.allUnits().where((unit) => unit.isVeteran);
    if (vetsInOtherUnit.isNotEmpty) {
      // check how many of the remaining units can be satisfied by another rule
      final unitsNeedingDragoonSquad = vetsInOtherUnit.where((u) {
        final g = u.group;
        if (g == null || g.combatGroup == null) {
          return false;
        }
        final hasVeteranCheckOverrideRules = g
            .combatGroup?.roster?.rulesetNotifer.value
            .allEnabledRules(g.combatGroup?.options)
            .where((rule) =>
                rule.veteranCheckOverride != null &&
                rule.id != ruleDragoonSquad.id);
        if (hasVeteranCheckOverrideRules == null) {
          return false;
        }
        final overrideValues = hasVeteranCheckOverrideRules
            .map((rule) => rule.veteranCheckOverride!(u, g.combatGroup!))
            .where((result) => result != null);
        if (overrideValues.isNotEmpty) {
          if (overrideValues.any((status) => status == false)) {
            return true;
          }
          return false;
        }
        return true;
      });

      if (unitsNeedingDragoonSquad.isNotEmpty) {
        return null;
      }
    }

    // if cheetahs that could only be there because of this rule it can't be
    // used here
    final cheetahsInOtherUnit =
        otherGroup.allUnits().where((unit) => unit.core.frame == 'Cheetah');
    if (cheetahsInOtherUnit.isEmpty) {
      return true;
    }

    // check how many of the remaining units can be satisfied by another rule
    final cheetahsNeedingDragoonSquad = cheetahsInOtherUnit.where((u) {
      final g = u.group;
      if (g == null) {
        return false;
      }
      final hasGroupRoleOverrideRules = g
          .combatGroup?.roster?.rulesetNotifer.value
          .allEnabledRules(g.combatGroup?.options)
          .where((rule) =>
              rule.hasGroupRole != null && rule.id != ruleDragoonSquad.id);
      if (hasGroupRoleOverrideRules == null) {
        return false;
      }
      final overrideValues = hasGroupRoleOverrideRules
          .map((rule) => rule.hasGroupRole!(u, u.group!.role(), u.group!))
          .where((result) => result != null);
      if (overrideValues.isNotEmpty) {
        if (overrideValues.any((status) => status == false)) {
          return true;
        }
        return false;
      }
      return true;
    });

    if (cheetahsNeedingDragoonSquad.isEmpty) {
      return true;
    }

    return null;
  },
  description: 'Models in one SK unit may purchase the Vet trait without' +
      ' counting against the veteran limitations. Any Cheetah variant may be' +
      ' placed in this SK unit.',
);
