import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/eden.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/rules/eden/aef.dart';
import 'package:gearforce/models/rules/eden/eif.dart';
import 'package:gearforce/models/rules/eden/enh.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';

const String _baseRuleId = 'rule::eden::core';
const String _ruleLancersId = '$_baseRuleId::10';
const String _ruleJoustYouSayId = '$_baseRuleId::20';
const String _ruleAlliesId = '$_baseRuleId::30';
const String _ruleAlliesBlackTalonId = '$_baseRuleId::40';
const String _ruleAlliesCEFId = '$_baseRuleId::50';
const String _ruleAlliesUtopiaId = '$_baseRuleId::60';
const String _ruleAlliesCapriceId = '$_baseRuleId::70';

/*
  All the models in the Edenite Model List can be used in any of the sub-lists below. There are also models in the Universal
  Model List that may be selected as well.
  All Edenite models have the following rules:
  * Lancers: Golems may have their melee weapon upgraded to a lance for +2 TV each. The lance is an MSG (React,
  Reach:2). Models with a lance gain the Brawl:2 trait or add +2 to their existing Brawl:X trait if they have it.
  * Joust You Say?: Any golem with a lance may perform a melee attack using their jetpack and lance. If they are able to
  move at least 4 inches via a jetpack move and then perform a melee attack with the lance, then the attack is treated
  as using a HSG instead of a MSG.
  All Edenite forces have the following rules:
  * Allies: You may select models from Black Talon, CEF, Utopia or Caprice (pick one) for your secondary units.
*/
class Eden extends RuleSet {
  Eden(
    Data data, {
    String? description,
    required String name,
    List<String>? specialRules,
    List<FactionRule> subFactionRules = const [],
  }) : super(
          FactionType.Eden,
          data,
          name: name,
          description: description,
          factionRules: [ruleLancers, ruleJoustYouSay, ruleAllies],
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
          const UnitFilter(FactionType.Eden),
          const UnitFilter(FactionType.Airstrike),
          const UnitFilter(FactionType.Universal),
          const UnitFilter(FactionType.Universal_Non_TerraNova),
          const UnitFilter(FactionType.Terrain),
        ],
      )
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory Eden.EIF(Data data) => EIF(data);
  factory Eden.ENH(Data data) => ENH(data);
  factory Eden.AEF(Data data) => AEF(data);
}

final FactionRule ruleLancers = FactionRule(
  name: 'Lancers',
  id: _ruleLancersId,
  factionMods: (ur, cg, u) => [EdenMods.lancers(u)],
  description: 'Golems may have their melee weapon upgraded to a lance for +2' +
      ' TV each. The lance is an MSG (React, Reach:2). Models with a lance' +
      ' gain the Brawl:2 trait or add +2 to their existing Brawl:X trait if' +
      ' they have it.',
);

final FactionRule ruleJoustYouSay = FactionRule(
  name: 'Joust You Say?',
  id: _ruleJoustYouSayId,
  description: 'Any golem with a lance may perform a melee attack using their' +
      ' jetpack and lance. If they are able to move at least 4 inches via a' +
      ' jetpack move and then perform a melee attack with the lance, then the' +
      ' attack is treated as using a HSG instead of a MSG.',
);

final FactionRule ruleAllies = FactionRule(
  name: 'Allies',
  id: _ruleAlliesId,
  options: [
    _ruleAllyCEF,
    _ruleAllyBlackTalon,
    _ruleAllyUtopia,
    _ruleAllyCaprice,
  ],
  description: 'You may select models from Black Talon, CEF, Utopia or' +
      ' Caprice (pick one) for your secondary units.',
);

final FactionRule _ruleAllyCEF = FactionRule(
  name: 'CEF',
  id: _ruleAlliesCEFId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: FactionRule.thereCanBeOnlyOne([
    _ruleAlliesBlackTalonId,
    _ruleAlliesUtopiaId,
    _ruleAlliesCapriceId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }

    if (unit.faction == FactionType.CEF) {
      // account for core cef rule Abominations
      if (matchOnlyFlails(unit.core)) {
        return null;
      }
      return false;
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: CEF',
      filters: [UnitFilter(FactionType.CEF)],
      id: _ruleAlliesCEFId),
  description:
      'You may select models from CEF to place into your secondary units.',
);

final FactionRule _ruleAllyBlackTalon = FactionRule(
  name: 'Black Talon',
  id: _ruleAlliesBlackTalonId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: FactionRule.thereCanBeOnlyOne([
    _ruleAlliesCEFId,
    _ruleAlliesUtopiaId,
    _ruleAlliesCapriceId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }

    if (unit.faction == FactionType.BlackTalon) {
      return false;
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Black Talon',
      filters: [UnitFilter(FactionType.BlackTalon)],
      id: _ruleAlliesBlackTalonId),
  description: 'You may select models from Black Talon to place into' +
      ' your secondary units.',
);

final FactionRule _ruleAllyUtopia = FactionRule(
  name: 'Utopia',
  id: _ruleAlliesUtopiaId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: FactionRule.thereCanBeOnlyOne([
    _ruleAlliesCEFId,
    _ruleAlliesBlackTalonId,
    _ruleAlliesCapriceId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }

    if (unit.faction == FactionType.Utopia) {
      return false;
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Utopia',
      filters: [UnitFilter(FactionType.Utopia)],
      id: _ruleAlliesUtopiaId),
  description: 'You may select models from Utopia to place into your' +
      ' secondary units.',
);

final FactionRule _ruleAllyCaprice = FactionRule(
  name: 'Eden',
  id: _ruleAlliesCapriceId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: FactionRule.thereCanBeOnlyOne([
    _ruleAlliesCEFId,
    _ruleAlliesBlackTalonId,
    _ruleAlliesUtopiaId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }

    if (unit.faction == FactionType.Eden) {
      return false;
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Caprice',
      filters: [UnitFilter(FactionType.Caprice)],
      id: _ruleAlliesCapriceId),
  description: 'You may select models from Caprice to place into your' +
      ' secondary units.',
);
