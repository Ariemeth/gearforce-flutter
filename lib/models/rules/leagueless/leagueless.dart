import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';

const String _baseRuleId = 'rule::leagueless::core';
const String _ruleJudiciousId = '$_baseRuleId::10';
const String _ruleTheSourceId = '$_baseRuleId::20';
const String _ruleTheSourceNorthId = '$_baseRuleId::30';
const String _ruleTheSourceSouthId = '$_baseRuleId::40';
const String _ruleTheSourcePeaceRiverId = '$_baseRuleId::50';
const String _ruleTheSourceNuCoalId = '$_baseRuleId::60';

/*
  Leagueless Sub-Lists
  All the models in the North, South, Peace River and NuCoal can be used in Leagueless forces. Different options below
  will limit selection to specific factions. There are also models in the Universal Model List that may be selected as well.
  L - Leagueless
  The Badlands are home to many types of would-be nations, city-states, villages, hardy homesteaders, nomadic
  communities and even a few things that there may not be a name for. These fringes of civilization are dangerous places.
  Even the most meager pack something for protection. Some of the more successful homesteaders have organized
  militias, while others are forced to pay rovers for protection. Many mercenary units started out in the Badlands, and not
  always intending to become mercenaries. Some militias even negotiate contracts with the collocated powers that be.
  While the people in the Badlands probably don’t have the most spit-shined boots, they can fight just the same.
  All Leagueless forces have the following rules:
  * Judicious: Non-duelist models that come with the Vet trait on their profile may only be placed in veteran combat
  groups. This also applies to any and all upgrade options below.
  * The Source: Select models from the North, South, Peace River or NuCoal (pick one).
  Select three upgrade options from below.
  * Additional Source: Select one more faction, from those listed above, as an additional Source. This option may be
  selected up to three times.
  * Northern Influence: Requires the North as a Source. If selected, Southern Influence and Protectorate Sponsored
  cannot be selected. Select one faction upgrade from the North’s faction upgrades. This option may be selected twice
  in order to gain a second option from the North.
  * Southern Influence: Requires the South as a Source. If selected, Northern Influence and Protectorate Sponsored
  cannot be selected. Select one faction upgrade from the South’s faction upgrades. This option may be selected twice
  in order to gain a second option from the South.
  * Protectorate Sponsored: Requires Peace River as a Source. If selected, Northern Influence and Southern Influence
  cannot be selected. Select one faction upgrade from Peace River’s faction upgrades. This option may be selected
  twice in order to gain a second option from Peace River.
  * Expert Salvagers: Secondary units may have a mix of models from the North, South, Peace River and NuCoal.
  * Stripped: Stripped-Down Hunters and Jagers may be included in this force and placed in GP, SK, FS, RC or SO units.
  * We Came From the Desert: En Koreshi and Sandriders may be included in this force.
  * Purple Powered: GREL infantry and Hoverbike GREL may be included in this force. GREL infantry may increase their
  GU skill by one for 1 TV each.
  * Veteran Leaders: You may purchase the Vet trait for any commander in the force without counting against the
  veteran limitations.
  * Badland’s Soup: One combat group may purchase the following veteran upgrades for their models without being
  veterans; Improved Gunnery, Dual Guns, Brawler, Veteran Melee upgrade, or ECCM.
  * Personal Equipment: Two models in one combat group may purchase two veteran upgrades without being veterans.
  * Thunder from the Sky: Airstrike counters may increase their GU skill to 3+ instead of 4+, for 1 TV each.
  * Conscription: You may add the Conscript trait to any non-commander, non-veteran and non-duelist in the force if
  they do not already possess the trait. Reduce the TV of these models by 1 TV per action.
  * Local Hero: For 1 TV, upgrade one infantry, cavalry or gear with the following ability: Models with the Conscript trait
  that are in formation with this model are considered to be in formation with a commander. This model also uses the
  Lead by Example duelist rule without being a duelist.
  * Ol’ Rusty: Reduce the cost of any gear or strider in one combat group by -1 TV each (to a minimum of 2 TV). But their
  Hull (H) is reduced by -1 and their Structure (S) is increased by +1. I.e., a H/S of 4/2 will become a 3/3.
  * Discounts: Vehicles with an LLC may replace the LLC with a HAC for -1 TV each.
  * Local Knowledge: One combat group may use the recon special deployment option.
  * Shadow Warriors: Models that start the game in area terrain gain a hidden token at the start of the first round.
  * Operators: You may select 2 gears in this force to become duelists.
  * Jannite Pilots: Veteran gears in this force with 1 action may upgrade to 2 actions for +2 TV each.
*/
class Leagueless extends RuleSet {
  Leagueless(
    Data data, {
    super.description,
    required super.name,
    required List<FactionRule> factionRules,
    List<String>? specialRules,
    super.subFactionRules = const [],
  }) : super(
          FactionType.Leagueless,
          data,
          factionRules: [ruleJudicious, ...factionRules],
        );

  @override
  List<SpecialUnitFilter> availableUnitFilters(
    List<CombatGroupOption>? cgOptions,
  ) {
    return [...super.availableUnitFilters(cgOptions)];
  }

  factory Leagueless.North(Data data) => SourceNorth(data);
  factory Leagueless.South(Data data) => SourceSouth(data);
  factory Leagueless.PeaceRiver(Data data) => SourcePeaceRiver(data);
  factory Leagueless.NuCoal(Data data) => SourceNuCoal(data);
}

const _baseFilters = const [
  const UnitFilter(FactionType.Universal),
  const UnitFilter(FactionType.Universal_TerraNova),
  const UnitFilter(FactionType.Terrain),
  const UnitFilter(FactionType.Airstrike),
];

class SourceNorth extends Leagueless {
  SourceNorth(super.data)
      : super(
          name: 'Source: North',
          factionRules: [
            FactionRule.from(
              ruleTheSourceNorth,
              isEnabled: true,
              canBeToggled: false,
              unitFilter: (cgOptions) => null,
            )
          ],
          subFactionRules: [buildTheSource(FactionType.North)],
        );
  @override
  List<SpecialUnitFilter> availableUnitFilters(
    List<CombatGroupOption>? cgOptions,
  ) {
    final filter = SpecialUnitFilter(
      text: 'Source: North',
      id: coreTag,
      filters: const [
        const UnitFilter(FactionType.North),
        ..._baseFilters,
      ],
    );
    return [filter, ...super.availableUnitFilters(cgOptions)];
  }
}

class SourceSouth extends Leagueless {
  SourceSouth(super.data)
      : super(
          name: 'Source: South',
          factionRules: [
            FactionRule.from(
              ruleTheSourceSouth,
              isEnabled: true,
              canBeToggled: false,
              unitFilter: (cgOptions) => null,
            )
          ],
          subFactionRules: [buildTheSource(FactionType.South)],
        );

  @override
  List<SpecialUnitFilter> availableUnitFilters(
    List<CombatGroupOption>? cgOptions,
  ) {
    final filter = SpecialUnitFilter(
      text: 'Source: South',
      id: coreTag,
      filters: const [
        const UnitFilter(FactionType.South),
        ..._baseFilters,
      ],
    );
    return [filter, ...super.availableUnitFilters(cgOptions)];
  }
}

class SourcePeaceRiver extends Leagueless {
  SourcePeaceRiver(super.data)
      : super(
          name: 'Source: Peace River',
          factionRules: [
            FactionRule.from(
              ruleTheSourcePeaceRiver,
              isEnabled: true,
              canBeToggled: false,
              unitFilter: (cgOptions) => null,
            )
          ],
          subFactionRules: [buildTheSource(FactionType.PeaceRiver)],
        );

  @override
  List<SpecialUnitFilter> availableUnitFilters(
    List<CombatGroupOption>? cgOptions,
  ) {
    final filter = SpecialUnitFilter(
      text: 'Source: Peace River',
      id: coreTag,
      filters: const [
        const UnitFilter(FactionType.PeaceRiver),
        ..._baseFilters,
      ],
    );
    return [filter, ...super.availableUnitFilters(cgOptions)];
  }
}

class SourceNuCoal extends Leagueless {
  SourceNuCoal(super.data)
      : super(
          name: 'Source: NuCoal',
          factionRules: [
            FactionRule.from(
              ruleTheSourceNuCoal,
              isEnabled: true,
              canBeToggled: false,
              unitFilter: (cgOptions) => null,
            )
          ],
          subFactionRules: [buildTheSource(FactionType.NuCoal)],
        );

  @override
  List<SpecialUnitFilter> availableUnitFilters(
    List<CombatGroupOption>? cgOptions,
  ) {
    final filter = SpecialUnitFilter(
      text: 'Source: NuCoal',
      id: coreTag,
      filters: const [
        const UnitFilter(FactionType.NuCoal),
        ..._baseFilters,
      ],
    );
    return [filter, ...super.availableUnitFilters(cgOptions)];
  }
}

final ruleJudicious = FactionRule(
  name: 'Judicious',
  id: _ruleJudiciousId,
  canBeAddedToGroup: (unit, group, cg) {
    if (unit.isDuelist) {
      return null;
    }
    if (unit.core.traits.any((t) => Trait.Vet().isSameType(t))) {
      return cg.isVeteran;
    }
    return null;
  },
  description: 'Non-duelist models that come with the Vet trait on their' +
      ' profile may only be placed in veteran combat groups. This also' +
      ' applies to any and all upgrade options.',
);

FactionRule buildTheSource(FactionType sourceFaction) {
  final rules = [
    ruleTheSourceNorth,
    ruleTheSourceSouth,
    ruleTheSourcePeaceRiver,
    ruleTheSourceNuCoal,
  ];
  switch (sourceFaction) {
    case FactionType.North:
      rules.remove(ruleTheSourceNorth);
      break;
    case FactionType.South:
      rules.remove(ruleTheSourceSouth);
      break;
    case FactionType.PeaceRiver:
      rules.remove(ruleTheSourcePeaceRiver);
      break;
    case FactionType.NuCoal:
      rules.remove(ruleTheSourceNuCoal);
      break;
    default:
  }

  return FactionRule(
      name: 'Additional Source',
      id: _ruleTheSourceId,
      options: rules,
      description: 'Select an additional source faction');
}

final ruleTheSourceNorth = FactionRule(
  name: 'Source: North',
  id: _ruleTheSourceNorthId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: _onlyThreeUpgrades(_ruleTheSourceNorthId),
  unitFilter: (cgOptions) => const SpecialUnitFilter(
    text: 'Source: North',
    id: _ruleTheSourceNorthId,
    filters: const [const UnitFilter(FactionType.North)],
  ),
  description: 'Select models from the North',
);

final ruleTheSourceSouth = FactionRule(
  name: 'Source: South',
  id: _ruleTheSourceSouthId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: _onlyThreeUpgrades(_ruleTheSourceSouthId),
  unitFilter: (cgOptions) => const SpecialUnitFilter(
    text: 'Source: South',
    id: _ruleTheSourceSouthId,
    filters: const [const UnitFilter(FactionType.South)],
  ),
  description: 'Select models from the South',
);

final ruleTheSourcePeaceRiver = FactionRule(
  name: 'Source: Peace River',
  id: _ruleTheSourcePeaceRiverId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: _onlyThreeUpgrades(_ruleTheSourcePeaceRiverId),
  unitFilter: (cgOptions) => const SpecialUnitFilter(
    text: 'Source: Peace River',
    id: _ruleTheSourcePeaceRiverId,
    filters: const [const UnitFilter(FactionType.PeaceRiver)],
  ),
  description: 'Select models from Peace River',
);

final ruleTheSourceNuCoal = FactionRule(
  name: 'Source: NuCoal',
  id: _ruleTheSourceNuCoalId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: _onlyThreeUpgrades(_ruleTheSourceNuCoalId),
  unitFilter: (cgOptions) => const SpecialUnitFilter(
    text: 'Source: NuCoal',
    id: _ruleTheSourceNuCoalId,
    filters: const [const UnitFilter(FactionType.NuCoal)],
  ),
  description: 'Select models from NuCoal',
);

bool Function(List<FactionRule> rules) _onlyThreeUpgrades(String excludedId) {
  return (List<FactionRule> rules) {
    return _numberOfEnabledRules(excludedId) < 3;
  };
}

int _numberOfEnabledRules(String excludedId) {
  int count = 0;

  count += _ruleCount(ruleTheSourceNorth, excludedId);
  count += _ruleCount(ruleTheSourceSouth, excludedId);
  count += _ruleCount(ruleTheSourcePeaceRiver, excludedId);
  count += _ruleCount(ruleTheSourceNuCoal, excludedId);

  // one source is free, so remove 1 from the count if multiple are enabled
  if (count > 1) {
    count = count - 1;
  }

  return count;
}

int _ruleCount(FactionRule rule, String excludedId) {
  return rule.isEnabled && rule.id != excludedId ? 1 : 0;
}
