import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/north.dart';
import 'package:gearforce/models/rules/north/ng.dart';
import 'package:gearforce/models/rules/north/nlc.dart';
import 'package:gearforce/models/rules/north/umf.dart';
import 'package:gearforce/models/rules/north/wfp.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/role.dart';

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
    Data data, {
    super.description,
    required super.name,
    List<Rule> subFactionRules = const [],
  }) : super(
          FactionType.North,
          data,
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
          const UnitFilter(FactionType.North),
          const UnitFilter(FactionType.Airstrike),
          const UnitFilter(FactionType.Universal),
          const UnitFilter(FactionType.Universal_TerraNova),
          const UnitFilter(FactionType.Terrain),
        ],
      ),
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory North.NG(Data data) => NG(data);
  factory North.WFP(Data data) => WFP(data);
  factory North.UMF(Data data) => UMF(data);
  factory North.NLC(Data data) => NLC(data);
}

final ruleTaskBuilt = Rule(
  name: 'Task Built',
  id: _ruleTaskBuiltId,
  factionMods: (ur, cg, u) {
    final isNorthernGear =
        u.faction == FactionType.North && u.type == ModelType.Gear;
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
    if (unit.type != ModelType.Gear) {
      return null;
    }

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

    final hasClimber = unit.traits.any((trait) => trait.name == 'Climber');
    if (!hasClimber) {
      return null;
    }

    // Get the number of gears with climber in the entire force
    final unitsWithClimber = group.combatGroup?.roster
        ?.unitsWithTrait(Trait(name: 'Climber'))
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

final ruleHammersOfTheNorth = Rule(
  name: 'Hammers of the North',
  id: _ruleHammersOfTheNorthId,
  factionMods: (ur, cg, u) => [NorthernFactionMods.hammerOfTheNorth(u)],
  description: 'Snub cannons may be given the Precise trait for +1 TV each.',
);

final ruleVeteranLeaders = Rule(
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
    if (cg?.primary.role() != RoleType.SK &&
        cg?.secondary.role() != RoleType.SK) {
      return false;
    }

    if (!onlyOneCG(ruleDragoonSquad.id)(cg, roster)) {
      return false;
    }

    return true;
  },
  combatGroupOption: () => [ruleDragoonSquad.buidCombatGroupOption()],
  veteranCheckOverride: (u, cg) {
    if (u.group?.role() != RoleType.SK) {
      return null;
    }

    // If this is a vet group no need to check
    if (cg.isVeteran) {
      return null;
    }

    // Getting the other group in the cg
    final otherGroup =
        u.group?.groupType == GroupType.Primary ? cg.secondary : cg.primary;

    // If the other group is empty no additional checks are needed
    if (otherGroup.allUnits().isEmpty) {
      return true;
    }

    // Check if the other group in the cg is also sk
    if (otherGroup.role() != RoleType.SK) {
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
    if (group.role() != RoleType.SK) {
      return null;
    }

    if (unit.core.frame != 'Cheetah') {
      return null;
    }

    // Getting the other group in the cg
    final otherGroup = group.groupType == GroupType.Primary
        ? group.combatGroup?.secondary
        : group.combatGroup?.primary;

    // If the other group is empty no additional checks are needed
    if (otherGroup == null || otherGroup.isEmpty()) {
      return true;
    }

    // Check if the other group in the cg is also sk
    if (otherGroup.role() != RoleType.SK) {
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
