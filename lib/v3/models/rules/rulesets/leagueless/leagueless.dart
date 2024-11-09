import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/combatGroups/group.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/leagueless.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/nucoal.dart';
import 'package:gearforce/v3/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/v3/models/rules/rulesets/black_talons/btrt.dart'
    as btrt;
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/rules/rulesets/north/north.dart' as north;
import 'package:gearforce/v3/models/rules/rulesets/nucoal/th.dart' as th;
import 'package:gearforce/v3/models/rules/options/combat_group_options.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/rules/rulesets/peace_river/peace_river.dart'
    as peaceRiver;
import 'package:gearforce/v3/models/rules/rulesets/peace_river/pps.dart' as pps;
import 'package:gearforce/v3/models/rules/rulesets/peace_river/prdf.dart'
    as prdf;
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/rules/rulesets/south/milicia.dart'
    as milicia;
import 'package:gearforce/v3/models/rules/rulesets/south/south.dart' as south;
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/v3/models/unit/unit_core.dart';
import 'package:gearforce/v3/models/validation/validations.dart';
import 'package:gearforce/widgets/settings.dart';

const String _baseRuleId = 'rule::leagueless::core';
const String _ruleJudiciousId = '$_baseRuleId::10';
const String _ruleTheSourceId = '$_baseRuleId::20';
const String _ruleTheSourceNorthId = '$_baseRuleId::30';
const String _rulePrimarySourceNorthId = '$_baseRuleId::35';
const String _ruleTheSourceSouthId = '$_baseRuleId::40';
const String _rulePrimarySourceSouthId = '$_baseRuleId::45';
const String _ruleTheSourcePeaceRiverId = '$_baseRuleId::50';
const String _rulePrimarySourcePeaceRiverId = '$_baseRuleId::55';
const String _ruleTheSourceNuCoalId = '$_baseRuleId::60';
const String _rulePrimarySourceNuCoalId = '$_baseRuleId::65';
const String _ruleNorthernInfluenceId = '$_baseRuleId::70';
const String _ruleSouthernInfluenceId = '$_baseRuleId::80';
const String _ruleProtectorateSponsoredId = '$_baseRuleId::90';
const String _ruleExpertSalvagersId = '$_baseRuleId::100';
const String _ruleStrippedId = '$_baseRuleId::110';
const String _ruleWeCameFromTheDesertId = '$_baseRuleId::120';
const String _rulePurplePowerId = '$_baseRuleId::130';
const String _rulePersonalEquipmentId = '$_baseRuleId::140';
const String _ruleLocalHeroId = '$_baseRuleId::150';
const String _ruleOlRustyId = '$_baseRuleId::160';
const String _ruleDiscountsId = '$_baseRuleId::170';
const String _ruleLocalKnowledgeId = '$_baseRuleId::180';
const String _ruleShadowWarriorsId = '$_baseRuleId::190';

final List<Rule> _rules = [
  rulesNorthernInfluence,
  rulesSouthernInfluence,
  rulesProtectorateSponsoredInfluence,
  ruleExpertSalvagers,
  ruleStripped,
  ruleWeCameFromTheDesert,
  rulePurplePowered,
  _ruleVetLeaders,
  _ruleBadlandsSoup,
  _rulePersonalEquipment,
  _ruleThunderFromTheSky,
  _ruleConscription,
  ruleLocalHero,
  ruleOlRusty,
  ruleDiscounts,
  _ruleLocalKnowledge,
  _ruleShadowWarriors,
  _ruleOperators,
  _ruleJannitePilots,
];
final List<Rule> _onlyThreeAllowedRules = [
  buildTheSource(FactionType.None),
  ..._northernInfluenceRules,
  ..._southernInfluenceRules,
  ..._protectorateSponsoredRules,
  ruleExpertSalvagers,
  ruleStripped,
  ruleWeCameFromTheDesert,
  rulePurplePowered,
  _ruleVetLeaders,
  _ruleBadlandsSoup,
  _rulePersonalEquipment,
  _ruleThunderFromTheSky,
  _ruleConscription,
  ruleLocalHero,
  ruleOlRusty,
  ruleDiscounts,
  _ruleLocalKnowledge,
  _ruleShadowWarriors,
  _ruleOperators,
  _ruleJannitePilots,
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
    DataV3 data,
    Settings settings, {
    super.description,
    required super.name,
    required List<Rule> factionRules,
    List<String>? specialRules,
    List<Rule> subFactionRules = const [],
  }) : super(
          FactionType.Leagueless,
          data,
          settings: settings,
          factionRules: [ruleJudicious, ...factionRules],
          subFactionRules: [...subFactionRules, ..._rules],
        );

  @override
  List<SpecialUnitFilter> availableUnitFilters(
    List<CombatGroupOption>? cgOptions,
  ) {
    return [...super.availableUnitFilters(cgOptions)];
  }

  factory Leagueless.North(DataV3 data, Settings settings) =>
      SourceNorth(data, settings);
  factory Leagueless.South(DataV3 data, Settings settings) =>
      SourceSouth(data, settings);
  factory Leagueless.PeaceRiver(DataV3 data, Settings settings) =>
      SourcePeaceRiver(data, settings);
  factory Leagueless.NuCoal(DataV3 data, Settings settings) =>
      SourceNuCoal(data, settings);
}

const _baseFilters = const [
  const UnitFilter(FactionType.Universal),
  const UnitFilter(FactionType.Universal_TerraNova),
  const UnitFilter(FactionType.Terrain),
  const UnitFilter(FactionType.Airstrike),
];

class SourceNorth extends Leagueless {
  SourceNorth(super.data, super.settings)
      : super(
          name: 'Source: North',
          factionRules: [],
          subFactionRules: [
            Rule.from(rulePrimarySourceNorth, isEnabled: true),
            _northernSourcesRules,
          ],
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
  SourceSouth(super.data, super.settings)
      : super(
          name: 'Source: South',
          factionRules: [],
          subFactionRules: [
            Rule.from(rulePrimarySourceSouth, isEnabled: true),
            _southernSourcesRules,
          ],
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
  SourcePeaceRiver(super.data, super.settings)
      : super(
          name: 'Source: Peace River',
          factionRules: [],
          subFactionRules: [
            Rule.from(rulePrimarySourcePeaceRiver, isEnabled: true),
            _peaceRiverSourcesRules,
          ],
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
  SourceNuCoal(super.data, super.settings)
      : super(
          name: 'Source: NuCoal',
          factionRules: [],
          subFactionRules: [
            Rule.from(rulePrimarySourceNuCoal, isEnabled: true),
            _nuCoalSourcesRules,
          ],
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

final Rule ruleJudicious = Rule(
  name: 'Judicious',
  id: _ruleJudiciousId,
  canBeAddedToGroup: (unit, group, cg) {
    if (unit.isDuelist) {
      return null;
    }
    if (unit.core.traits.any((t) => Trait.Vet().isSameType(t))) {
      return Validation(
        cg.isVeteran,
        issue: 'Unit must be placed in a veteran CG; See Judicious rule.',
      );
    }
    return null;
  },
  description: 'Non-duelist models that come with the Vet trait on their' +
      ' profile may only be placed in veteran combat groups. This also' +
      ' applies to any and all upgrade options.',
);

Rule buildTheSource(FactionType sourceFaction) {
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

  return Rule(
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

final Rule ruleTheSourceNorth = Rule(
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
  onDisabled: () {
    rulesNorthernInfluence.disable();
  },
  description: 'Select models from the North',
);

final Rule ruleTheSourceSouth = Rule(
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
  onDisabled: () {
    rulesSouthernInfluence.disable();
  },
  description: 'Select models from the South',
);

final Rule ruleTheSourcePeaceRiver = Rule(
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
  onDisabled: () {
    rulesProtectorateSponsoredInfluence.disable();
  },
  description: 'Select models from Peace River',
);

final Rule ruleTheSourceNuCoal = Rule(
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

final Rule rulePrimarySourceNorth = Rule(
  name: 'Primary Source: North',
  id: _rulePrimarySourceNorthId,
  isEnabled: false,
  canBeToggled: false,
  onDisabled: () {
    rulesNorthernInfluence.disable();
  },
  description: 'Select models from the North',
);

final Rule rulePrimarySourceSouth = Rule(
  name: 'Primary Source: South',
  id: _rulePrimarySourceSouthId,
  isEnabled: false,
  canBeToggled: false,
  onDisabled: () {
    rulesSouthernInfluence.disable();
  },
  description: 'Select models from the South',
);

final Rule rulePrimarySourcePeaceRiver = Rule(
  name: 'Primary Source: Peace River',
  id: _rulePrimarySourcePeaceRiverId,
  isEnabled: false,
  canBeToggled: false,
  onDisabled: () {
    rulesProtectorateSponsoredInfluence.disable();
  },
  description: 'Select models from Peace River',
);

final Rule rulePrimarySourceNuCoal = Rule(
  name: 'Primary Source: NuCoal',
  id: _rulePrimarySourceNuCoalId,
  isEnabled: false,
  canBeToggled: false,
  description: 'Select models from NuCoal',
);

final Rule rulesNorthernInfluence = Rule(
  name: 'Northern Influence',
  id: _ruleNorthernInfluenceId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: (factionRules) {
    final isValid =
        Rule.isRuleEnabled(factionRules, rulePrimarySourceNorth.id) ||
            Rule.isRuleEnabled(factionRules, ruleTheSourceNorth.id) &&
                !rulesSouthernInfluence.isEnabled &&
                !rulesProtectorateSponsoredInfluence.isEnabled &&
                (_onlyThreeUpgrades(_ruleNorthernInfluenceId)(factionRules) ||
                    _northernInfluenceRules.any((rule) => rule.isEnabled));

    if (!isValid) {
      rulesNorthernInfluence.disable();
    }
    return isValid;
  },
  options: _northernInfluenceRules,
  onEnabled: () {
    _northernInfluenceRules.forEach((rule) {
      rule.canBeToggled = true;
    });
  },
  onDisabled: () {
    _northernInfluenceRules.forEach((rule) {
      rule.disable();
      rule.canBeToggled = false;
    });
  },
  description: 'Requires the North as a Source. If selected, Southern' +
      ' Influence and Protectorate Sponsored cannot be selected. Select one' +
      ' faction upgrade from the North’s faction upgrades. This option may be' +
      ' selected twice in order to gain a second option from the North.',
);

final List<Rule> _northernInfluenceRules = [
  Rule.from(
    north.ruleProspectors,
    isEnabled: false,
    canBeToggled: false,
    requirementCheck: (factionRules) =>
        _onlyOne(_northernInfluenceRules, north.ruleProspectors.id) &&
        _onlyThreeUpgrades(north.ruleProspectors.id)(factionRules) &&
        north.ruleProspectors.requirementCheck(factionRules),
  ),
  Rule.from(
    north.ruleHammersOfTheNorth,
    isEnabled: false,
    canBeToggled: false,
    requirementCheck: (factionRules) =>
        _onlyOne(_northernInfluenceRules, north.ruleHammersOfTheNorth.id) &&
        _onlyThreeUpgrades(north.ruleHammersOfTheNorth.id)(factionRules) &&
        north.ruleHammersOfTheNorth.requirementCheck(factionRules),
  ),
  Rule.from(
    north.ruleVeteranLeaders,
    isEnabled: false,
    canBeToggled: false,
    requirementCheck: (factionRules) =>
        _onlyOne(_northernInfluenceRules, north.ruleVeteranLeaders.id) &&
        _onlyThreeUpgrades(north.ruleVeteranLeaders.id)(factionRules) &&
        north.ruleVeteranLeaders.requirementCheck(factionRules),
  ),
  Rule.from(
    north.ruleDragoonSquad,
    isEnabled: false,
    canBeToggled: false,
    requirementCheck: (factionRules) =>
        _onlyOne(_northernInfluenceRules, north.ruleDragoonSquad.id) &&
        _onlyThreeUpgrades(north.ruleDragoonSquad.id)(factionRules) &&
        north.ruleDragoonSquad.requirementCheck(factionRules),
  ),
];

final Rule rulesSouthernInfluence = Rule(
  name: 'Southern Influence',
  id: _ruleSouthernInfluenceId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: (factionRules) {
    final isValid =
        Rule.isRuleEnabled(factionRules, rulePrimarySourceSouth.id) ||
            Rule.isRuleEnabled(factionRules, ruleTheSourceSouth.id) &&
                !rulesNorthernInfluence.isEnabled &&
                !rulesProtectorateSponsoredInfluence.isEnabled &&
                (_onlyThreeUpgrades(_ruleSouthernInfluenceId)(factionRules) ||
                    _southernInfluenceRules.any((rule) => rule.isEnabled));

    if (!isValid) {
      rulesSouthernInfluence.disable();
    }
    return isValid;
  },
  options: _southernInfluenceRules,
  onEnabled: () {
    _southernInfluenceRules.forEach((rule) {
      rule.canBeToggled = true;
    });
  },
  onDisabled: () {
    _southernInfluenceRules.forEach((rule) {
      rule.disable();
      rule.canBeToggled = false;
    });
  },
  description: 'Requires the South as a Source. If selected, Northern' +
      ' Influence and Protectorate Sponsored cannot be selected. Select one' +
      ' faction upgrade from the South’s faction upgrades. This option may be' +
      ' selected twice in order to gain a second option from the South.',
);

final List<Rule> _southernInfluenceRules = [
  Rule.from(
    south.rulePoliceState,
    isEnabled: false,
    canBeToggled: false,
    requirementCheck: (factionRules) =>
        _onlyOne(_southernInfluenceRules, south.rulePoliceState.id) &&
        _onlyThreeUpgrades(south.rulePoliceState.id)(factionRules) &&
        south.rulePoliceState.requirementCheck(factionRules),
  ),
  Rule.from(
    south.ruleAmphibians,
    isEnabled: false,
    canBeToggled: false,
    requirementCheck: (factionRules) =>
        _onlyOne(_southernInfluenceRules, south.ruleAmphibians.id) &&
        _onlyThreeUpgrades(south.ruleAmphibians.id)(factionRules) &&
        south.ruleAmphibians.requirementCheck(factionRules),
  ),
];

final Rule rulesProtectorateSponsoredInfluence = Rule(
  name: 'Protectorate Sponsored',
  id: _ruleProtectorateSponsoredId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: (factionRules) {
    final isValid = Rule.isRuleEnabled(
            factionRules, rulePrimarySourcePeaceRiver.id) ||
        Rule.isRuleEnabled(factionRules, ruleTheSourcePeaceRiver.id) &&
            !rulesNorthernInfluence.isEnabled &&
            !rulesSouthernInfluence.isEnabled &&
            (_onlyThreeUpgrades(_ruleProtectorateSponsoredId)(factionRules) ||
                _protectorateSponsoredRules.any((rule) => rule.isEnabled));

    if (!isValid) {
      rulesProtectorateSponsoredInfluence.disable();
    }
    return isValid;
  },
  options: _protectorateSponsoredRules,
  onEnabled: () {
    _protectorateSponsoredRules.forEach((rule) {
      rule.canBeToggled = true;
    });
  },
  onDisabled: () {
    _protectorateSponsoredRules.forEach((rule) {
      rule.disable();
      rule.canBeToggled = false;
    });
  },
  description: 'Requires Peace River as a Source. If selected, Northern' +
      ' Influence and Southern Influence cannot be selected. Select one' +
      ' faction upgrade from Peace River’s faction upgrades. This option may' +
      ' be selected twice in order to gain a second option from Peace River.',
);

final List<Rule> _protectorateSponsoredRules = [
  Rule.from(
    peaceRiver.ruleEPex,
    isEnabled: false,
    canBeToggled: false,
    requirementCheck: (factionRules) =>
        _onlyOne(_protectorateSponsoredRules, peaceRiver.ruleEPex.id) &&
        _onlyThreeUpgrades(peaceRiver.ruleEPex.id)(factionRules) &&
        peaceRiver.ruleEPex.requirementCheck(factionRules),
  ),
  Rule.from(
    peaceRiver.ruleWarriorElite,
    isEnabled: false,
    canBeToggled: false,
    requirementCheck: (factionRules) =>
        _onlyOne(_protectorateSponsoredRules, peaceRiver.ruleWarriorElite.id) &&
        _onlyThreeUpgrades(peaceRiver.ruleWarriorElite.id)(factionRules) &&
        peaceRiver.ruleWarriorElite.requirementCheck(factionRules),
  ),
  Rule.from(
    peaceRiver.ruleCrisisResponders,
    isEnabled: false,
    canBeToggled: false,
    requirementCheck: (factionRules) =>
        _onlyOne(
            _protectorateSponsoredRules, peaceRiver.ruleCrisisResponders.id) &&
        _onlyThreeUpgrades(peaceRiver.ruleCrisisResponders.id)(factionRules) &&
        peaceRiver.ruleCrisisResponders.requirementCheck(factionRules),
  ),
  Rule.from(
    peaceRiver.ruleLaserTech,
    isEnabled: false,
    canBeToggled: false,
    requirementCheck: (factionRules) =>
        _onlyOne(_protectorateSponsoredRules, peaceRiver.ruleLaserTech.id) &&
        _onlyThreeUpgrades(peaceRiver.ruleLaserTech.id)(factionRules) &&
        peaceRiver.ruleLaserTech.requirementCheck(factionRules),
  ),
  Rule.from(
    peaceRiver.ruleArchitects,
    isEnabled: false,
    canBeToggled: false,
    requirementCheck: (factionRules) =>
        _onlyOne(_protectorateSponsoredRules, peaceRiver.ruleArchitects.id) &&
        _onlyThreeUpgrades(peaceRiver.ruleArchitects.id)(factionRules) &&
        peaceRiver.ruleArchitects.requirementCheck(factionRules),
  ),
];

final Rule ruleExpertSalvagers = Rule(
  name: 'Expert Salvagers',
  id: _ruleExpertSalvagersId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: _onlyThreeUpgrades(_ruleExpertSalvagersId),
  canBeAddedToGroup: (unit, group, cg) {
    final rs = cg.roster?.rulesetNotifer.value;
    if (rs == null) {
      return null;
    }

    // Ignore models from the rule Stripped
    if (ruleStripped.isEnabled && matchStripped(unit.core)) {
      return null;
    }

    // Ignore models from the rule We Came From The Desert
    if (ruleWeCameFromTheDesert.isEnabled &&
        matchWeCameFromTheDesert(unit.core)) {
      return null;
    }

    // Ignore models from the rule Purple Powered
    if (rulePurplePowered.isEnabled && matchPurplePowered(unit.core)) {
      return null;
    }

    final gt = group.groupType;
    switch (unit.faction) {
      case FactionType.North:
        if (!rs.isRuleEnabled(ruleTheSourceNorth.id) &&
            gt == GroupType.primary) {
          return Validation(
            false,
            issue: 'North units must be placed in secondary units; See Expert' +
                ' Salvagers.',
          );
        }
        break;
      case FactionType.South:
        if (!rs.isRuleEnabled(ruleTheSourceSouth.id) &&
            gt == GroupType.primary) {
          return Validation(
            false,
            issue: 'South units must be placed in secondary units; See Expert' +
                ' Salvagers.',
          );
        }
        break;
      case FactionType.PeaceRiver:
        if (!rs.isRuleEnabled(ruleTheSourcePeaceRiver.id) &&
            gt == GroupType.primary) {
          return Validation(
            false,
            issue: 'Peace River units must be placed in secondary units; See' +
                ' Expert Salvagers.',
          );
        }
        break;
      case FactionType.NuCoal:
        if (!rs.isRuleEnabled(ruleTheSourceNuCoal.id) &&
            gt == GroupType.primary) {
          return Validation(
            false,
            issue:
                'NuCoal units must be placed in secondary units; See Expert' +
                    ' Salvagers.',
          );
        }
        break;
      default:
    }
    return null;
  },
  unitFilter: (cgOptions) {
    return const SpecialUnitFilter(
      text: 'Expert Salvagers',
      id: _ruleExpertSalvagersId,
      filters: const [
        const UnitFilter(FactionType.North),
        const UnitFilter(FactionType.South),
        const UnitFilter(FactionType.PeaceRiver),
        const UnitFilter(FactionType.NuCoal),
      ],
    );
  },
  description: 'Secondary units may have a mix of models from the North,' +
      ' South, Peace River and NuCoal.',
);

final Rule ruleStripped = Rule(
  name: 'Stripped',
  id: _ruleStrippedId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: _onlyThreeUpgrades(_ruleStrippedId),
  hasGroupRole: (unit, target, group) {
    if (target == RoleType.FT) {
      return null;
    }

    if ((unit.faction == FactionType.North ||
            unit.faction == FactionType.South) &&
        matchStripped(unit.core)) {
      return true;
    }
    return null;
  },
  unitFilter: (cgOptions) {
    return const SpecialUnitFilter(
      text: 'Stripped',
      id: _ruleStrippedId,
      filters: const [
        const UnitFilter(FactionType.North, matcher: matchStripped),
        const UnitFilter(FactionType.South, matcher: matchStripped),
      ],
    );
  },
  description: 'Stripped-Down Hunters and Jagers may be included in this' +
      ' force and placed in GP, SK, FS, RC or SO units.',
);

final Rule ruleWeCameFromTheDesert = Rule(
  name: 'We Came From the Desert',
  id: _ruleWeCameFromTheDesertId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: _onlyThreeUpgrades(_ruleWeCameFromTheDesertId),
  unitFilter: (cgOptions) {
    return const SpecialUnitFilter(
      text: 'We Came From the Desert',
      id: _ruleWeCameFromTheDesertId,
      filters: const [
        const UnitFilter(FactionType.NuCoal, matcher: matchWeCameFromTheDesert),
      ],
    );
  },
  description: 'En Koreshi and Sandriders may be included in this force.',
);

/// Match units for the rule We Came From the Desert
bool matchWeCameFromTheDesert(UnitCore uc) {
  return uc.frame == 'Sandrider' || uc.frame == 'En Koreshi';
}

final Rule rulePurplePowered = Rule(
  name: 'Purple Powered',
  id: _rulePurplePowerId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: _onlyThreeUpgrades(_rulePurplePowerId),
  unitFilter: (cgOptions) {
    return const SpecialUnitFilter(
      text: 'Purple Powered',
      id: _rulePurplePowerId,
      filters: const [
        const UnitFilter(FactionType.NuCoal, matcher: matchPurplePowered),
      ],
    );
  },
  factionMods: (ur, cg, u) => [
    NuCoalFactionMods.somethingToProve(
      name: 'Purple Powered',
      ruleId: _rulePurplePowerId,
    )
  ],
  description: 'GREL infantry and Hoverbike GREL may be included in this' +
      ' force. GREL infantry may increase their GU skill by one for 1 TV each.',
);

/// Match units for the rule Purple Powered
bool matchPurplePowered(UnitCore uc) {
  return uc.frame == 'Hoverbike GREL' || uc.frame == 'GREL';
}

final Rule _rulePersonalEquipment = Rule(
  name: 'Personal Equipment',
  id: _rulePersonalEquipmentId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: (factionRules) =>
      _onlyThreeUpgrades(_rulePersonalEquipmentId)(factionRules),
  factionMods: (ur, cg, u) => [
    NuCoalFactionMods.personalEquipment(
      PersonalEquipment.One,
      ruleId: _rulePersonalEquipmentId,
      optionId: '',
    ),
    NuCoalFactionMods.personalEquipment(
      PersonalEquipment.Two,
      ruleId: _rulePersonalEquipmentId,
      optionId: '',
    ),
  ],
  veteranModCheck: (u, cg, {required modID}) {
    final mod1 = u.getMod(personalEquipment1Id);
    final mod2 = u.getMod(personalEquipment2Id);
    if (mod1 != null) {
      final selectedVetModName = mod1.options?.selectedOption?.text;
      if (selectedVetModName != null &&
          modID == VeteranModification.vetModId(selectedVetModName) &&
          VeteranModification.isVetMod(selectedVetModName)) {
        return true;
      }
    }

    if (mod2 != null) {
      final selectedVetModName = mod2.options?.selectedOption?.text;
      if (selectedVetModName != null &&
          modID == VeteranModification.vetModId(selectedVetModName) &&
          VeteranModification.isVetMod(selectedVetModName)) {
        return true;
      }
    }

    return null;
  },
  description: 'Two models in this combat group may purchase two veteran' +
      ' upgrades each without being veterans.',
);

Rule ruleLocalHero = Rule(
  name: 'Local Hero',
  id: _ruleLocalHeroId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: _onlyThreeUpgrades(_ruleLocalHeroId),
  factionMods: (ur, cg, u) => [LeaguelessFactionMods.localHero()],
  description: 'For 1 TV, upgrade one infantry, cavalry or gear with the' +
      ' following ability: Models with the Conscript trait that are in' +
      ' formation with this model are considered to be in formation with a' +
      ' commander. This model also uses the Lead by Example duelist rule' +
      ' without being a duelist.',
);

Rule ruleOlRusty = Rule(
  name: 'Ol’ Rusty',
  id: _ruleOlRustyId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: _onlyThreeUpgrades(_ruleOlRustyId),
  factionMods: (ur, cg, u) => [LeaguelessFactionMods.olRusty()],
  description: 'Reduce the cost of any gear or strider in one combat group by' +
      ' -1 TV each (to a minimum of 2 TV). But their Hull (H) is reduced by' +
      ' -1 and their Structure (S) is increased by +1. I.e., a H/S of 4/2' +
      ' will become a 3/3.',
);

Rule ruleDiscounts = Rule(
  name: 'Discounts',
  id: _ruleDiscountsId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: _onlyThreeUpgrades(_ruleDiscountsId),
  factionMods: (ur, cg, u) => [LeaguelessFactionMods.discounts(u)],
  description: 'Vehicles with an LLC may replace the LLC with a HAC for -1' +
      ' TV each.',
);

Rule _ruleLocalKnowledge = Rule(
  name: 'Local Knowledge',
  id: _ruleLocalKnowledgeId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: _onlyThreeUpgrades(_ruleLocalKnowledgeId),
  description: 'One combat group may use the recon special deployment option.',
);

Rule _ruleShadowWarriors = Rule(
  name: 'Shadow Warriors',
  id: _ruleShadowWarriorsId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: _onlyThreeUpgrades(_ruleShadowWarriorsId),
  description: 'Models that start the game in area terrain gain a hidden' +
      ' token at the start of the first round.',
);

final _ruleVetLeaders = _buildRuleFromOther(north.ruleVeteranLeaders);
final _ruleBadlandsSoup = _buildRuleFromOther(pps.ruleBadlandsSoup);
final _ruleThunderFromTheSky = _buildRuleFromOther(prdf.ruleThunderFromTheSky);
final _ruleConscription = _buildRuleFromOther(milicia.ruleConscription);
final _ruleOperators = _buildRuleFromOther(btrt.ruleOperators);
final _ruleJannitePilots = _buildRuleFromOther(th.ruleJannitePilots);

Rule _buildRuleFromOther(Rule rule) {
  return Rule.from(
    rule,
    isEnabled: false,
    canBeToggled: true,
    requirementCheck: (factionRules) =>
        _onlyThreeUpgrades(rule.id)(factionRules) &&
        rule.requirementCheck(factionRules),
  );
}

bool _onlyOne(List<Rule> rules, String excludeId) {
  int count = 0;
  rules.forEach((rule) {
    if (rule.isEnabled && rule.id != excludeId) {
      count++;
    }
  });
  return count < 2;
}

bool Function(List<Rule> rules) _onlyThreeUpgrades(String excludedId) {
  return (List<Rule> rules) {
    final ruleCount = (Rule rule, String excludedId) {
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
