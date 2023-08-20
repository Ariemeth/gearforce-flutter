import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/north/north.dart' as north;
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
const String _ruleNorthernInfluenceId = '$_baseRuleId::70';
const String _ruleSouthernInfluenceId = '$_baseRuleId::80';
const String _ruleProtectorateSponsoredId = '$_baseRuleId::90';

final List<FactionRule> _rules = [rulesNorthernInfluence];
final List<FactionRule> _onlyThreeAllowedRules = [
  buildTheSource(FactionType.None),
  ..._northerInfluenceRules,
];

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
    List<FactionRule> subFactionRules = const [],
  }) : super(
          FactionType.Leagueless,
          data,
          factionRules: [ruleJudicious, ...factionRules],
          subFactionRules: [...subFactionRules, ..._rules],
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
          subFactionRules: [_northernSourcesRules],
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

final _northernSourcesRules = buildTheSource(FactionType.North);

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
          subFactionRules: [_southernSourcesRules],
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

final _southernSourcesRules = buildTheSource(FactionType.South);

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
          subFactionRules: [_peaceRiverSourcesRules],
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

final _peaceRiverSourcesRules = buildTheSource(FactionType.PeaceRiver);

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
          subFactionRules: [_nuCoalSourcesRules],
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

final _nuCoalSourcesRules = buildTheSource(FactionType.NuCoal);

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
      isEnabled: false,
      canBeToggled: true,
      id: _ruleTheSourceId,
      options: rules,
      onEnabled: () {
        rules.forEach((rule) {
          rule.canBeToggled = true;
        });
      },
      onDisabled: () {
        rules.forEach((rule) {
          rule.disable();
          rule.canBeToggled = false;
        });
      },
      description: 'Select an additional source faction');
}

final ruleTheSourceNorth = FactionRule(
  name: 'Source: North',
  id: _ruleTheSourceNorthId,
  isEnabled: false,
  canBeToggled: false,
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
  canBeToggled: false,
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
  canBeToggled: false,
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
  canBeToggled: false,
  requirementCheck: _onlyThreeUpgrades(_ruleTheSourceNuCoalId),
  unitFilter: (cgOptions) => const SpecialUnitFilter(
    text: 'Source: NuCoal',
    id: _ruleTheSourceNuCoalId,
    filters: const [const UnitFilter(FactionType.NuCoal)],
  ),
  description: 'Select models from NuCoal',
);

final rulesNorthernInfluence = FactionRule(
  name: 'Northern Influence',
  id: _ruleNorthernInfluenceId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: _onlyThreeUpgrades(_ruleNorthernInfluenceId),
  options: _northerInfluenceRules,
  onEnabled: () {
    _northerInfluenceRules.forEach((rule) {
      rule.canBeToggled = true;
    });
  },
  onDisabled: () {
    _northerInfluenceRules.forEach((rule) {
      rule.disable();
      rule.canBeToggled = false;
    });
  },
  description: 'Requires the North as a Source. If selected, Southern' +
      ' Influence and Protectorate Sponsored cannot be selected. Select one' +
      ' faction upgrade from the North’s faction upgrades. This option may be' +
      ' selected twice in order to gain a second option from the North.',
);

final List<FactionRule> _northerInfluenceRules = [
  FactionRule.from(
    north.ruleProspectors,
    isEnabled: false,
    canBeToggled: false,
    requirementCheck: (factionRules) =>
        _onlyOne(_northerInfluenceRules, north.ruleProspectors.id) &&
        _onlyThreeUpgrades(north.ruleProspectors.id)(factionRules) &&
        north.ruleProspectors.requirementCheck(factionRules),
  ),
  FactionRule.from(
    north.ruleHammersOfTheNorth,
    isEnabled: false,
    canBeToggled: false,
    requirementCheck: (factionRules) =>
        _onlyOne(_northerInfluenceRules, north.ruleHammersOfTheNorth.id) &&
        _onlyThreeUpgrades(north.ruleHammersOfTheNorth.id)(factionRules) &&
        north.ruleHammersOfTheNorth.requirementCheck(factionRules),
  ),
  FactionRule.from(
    north.ruleVeteranLeaders,
    isEnabled: false,
    canBeToggled: false,
    requirementCheck: (factionRules) =>
        _onlyOne(_northerInfluenceRules, north.ruleVeteranLeaders.id) &&
        _onlyThreeUpgrades(north.ruleVeteranLeaders.id)(factionRules) &&
        north.ruleVeteranLeaders.requirementCheck(factionRules),
  ),
  FactionRule.from(
    north.ruleDragoonSquad,
    isEnabled: false,
    canBeToggled: false,
    requirementCheck: (factionRules) =>
        _onlyOne(_northerInfluenceRules, north.ruleDragoonSquad.id) &&
        _onlyThreeUpgrades(north.ruleDragoonSquad.id)(factionRules) &&
        north.ruleDragoonSquad.requirementCheck(factionRules),
  ),
];

bool _onlyOne(List<FactionRule> rules, String excludeId) {
  int count = 0;
  rules.forEach((rule) {
    if (rule.isEnabled && rule.id != excludeId) {
      count++;
    }
  });
  return count < 2;
}

bool Function(List<FactionRule> rules) _onlyThreeUpgrades(String excludedId) {
  return (List<FactionRule> rules) {
    final ruleCount = (FactionRule rule, String excludedId) {
      return rule.isEnabled && rule.id != excludedId ? 1 : 0;
    };

    int count = 0;

    count += ruleCount(ruleTheSourceNorth, excludedId);
    count += ruleCount(ruleTheSourceSouth, excludedId);
    count += ruleCount(ruleTheSourcePeaceRiver, excludedId);
    count += ruleCount(ruleTheSourceNuCoal, excludedId);

    _onlyThreeAllowedRules.forEach((rule) {
      count += ruleCount(rule, excludedId);
    });

    return count < 3;
  };
}
