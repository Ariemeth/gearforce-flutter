import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/north.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';

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

final ruleProspectors = FactionRule(
  name: 'Prospectors',
  id: '$_baseRuleId::20',
  description: 'Up to two gears with the Climber trait may be placed in GP,' +
      ' SK, FS, RC or SO units.',
);

final ruleHammersOfTheNorth = FactionRule(
  name: 'Hammers of the North',
  id: '$_baseRuleId::30',
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
