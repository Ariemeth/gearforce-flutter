import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/rules/rule_set.dart';

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
    String? description,
    required String name,
    List<String>? specialRules,
    List<FactionRule> subFactionRules = const [],
  }) : super(
          FactionType.Universal,
          data,
          name: name,
          description: description,
          factionRules: [],
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
        filters: const [],
      )
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }
}
