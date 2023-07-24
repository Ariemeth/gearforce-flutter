import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/north.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/role.dart';

const String _baseRuleId = 'rule::north';

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
    String? description,
    required String name,
    List<String>? specialRules,
    List<FactionRule> subFactionRules = const [],
  }) : super(
          FactionType.North,
          data,
          name: name,
          description: description,
          factionRules: [
            ruleTaskBuilt,
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
      const SpecialUnitFilter(
        text: coreName,
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
}

final ruleTaskBuilt = FactionRule(
  name: 'Task Built',
  id: '$_baseRuleId::10',
  factionMod: (ur, cg, u) => NorthernFactionMods.taskBuilt(u),
  description:
      'Each Northern gear may swap its rocket pack for a Heavy Machinegun' +
          ' (HMG) for 0 TV. Each Northern gear without a rocket pack may' +
          ' add an HMG for 1 TV. Each Bricklayer, Engineering Grizzly,' +
          ' Camel Truck and Stinger may also add an HMG for 1 TV.',
);

final FactionRule ruleProspectors = FactionRule(
  name: 'Prospectors',
  id: '$_baseRuleId::20',
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
    // share thier role
    final unitsWithoutMatchingGroupRole = unitsWithClimber.where((u) {
      if (u.role == null) {
        return false;
      }
      //unit.role == null ? false : unit.role!.includesRole([target]);
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

    print(
        'number of climbers without matching group role: ${unitsNeedingProspectors.length}');

    return unitsNeedingProspectors.length < 2;
  },
  description: 'Up to two gears with the Climber trait may be placed in GP,' +
      ' SK, FS, RC or SO units.',
);

final ruleHammersOfTheNorth = FactionRule(
  name: 'Hammers of the North',
  id: '$_baseRuleId::30',
  factionMod: (ur, cg, u) => NorthernFactionMods.hammerOfTheNorth(u),
  description: 'Snub cannons may be given the Precise trait for +1 TV each.',
);

final ruleVeteranLeaders = FactionRule(
  name: 'Veteran Leaders',
  id: '$_baseRuleId::40',
  description: 'You may purchase the Vet trait for any commander in the' +
      ' force without counting against the normal veteran limitations',
);

final ruleDragoonSquad = FactionRule(
  name: 'Dragoon Squad',
  id: '$_baseRuleId::50',
  description: 'Models in one SK unit may purchase the Vet trait without' +
      ' counting against the veteran limitations. Any Cheetah variant may be' +
      ' placed in this SK unit.',
);
