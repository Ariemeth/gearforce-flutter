import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/caprice.dart' as caprice;
import 'package:gearforce/models/mods/factionUpgrades/eden.dart';
import 'package:gearforce/models/rules/rule.dart';
import 'package:gearforce/models/rules/eden/aef.dart';
import 'package:gearforce/models/rules/eden/eif.dart';
import 'package:gearforce/models/rules/eden/enh.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/validation/validations.dart';

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
    List<Rule> subFactionRules = const [],
  }) : super(
          FactionType.Eden,
          data,
          name: name,
          description: description,
          factionRules: [ruleAllies],
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

final Rule ruleLancers = Rule(
  name: 'Lancers',
  id: _ruleLancersId,
  factionMods: (ur, cg, u) {
    if (u.type != ModelType.Gear) {
      return [];
    }
    if (u.faction == FactionType.Eden || u.core.frame == 'Druid') {
      return [EdenMods.lancers(u)];
    }
    return [];
  },
  description: 'Golems may have their melee weapon upgraded to a lance for +2' +
      ' TV each. The lance is an MSG (React, Reach:2). Models with a lance' +
      ' gain the Brawl:2 trait or add +2 to their existing Brawl:X trait if' +
      ' they have it.',
);

final Rule ruleJoustYouSay = Rule(
  name: 'Joust You Say?',
  id: _ruleJoustYouSayId,
  description: 'Any golem with a lance may perform a melee attack using their' +
      ' jetpack and lance. If they are able to move at least 4 inches via a' +
      ' jetpack move and then perform a melee attack with the lance, then the' +
      ' attack is treated as using a HSG instead of a MSG.',
);

final Rule ruleAllies = Rule(
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

final Rule _ruleAllyCEF = Rule(
  name: 'CEF',
  id: _ruleAlliesCEFId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
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
      return Validation(
        false,
        issue: 'CEF units must be placed in secondary units; See Allies rule.',
      );
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: CEF',
      filters: [const UnitFilter(FactionType.CEF)],
      id: _ruleAlliesCEFId),
  description:
      'You may select models from CEF to place into your secondary units.',
);

final Rule _ruleAllyBlackTalon = Rule(
  name: 'Black Talon',
  id: _ruleAlliesBlackTalonId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesCEFId,
    _ruleAlliesUtopiaId,
    _ruleAlliesCapriceId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }

    if (unit.faction == FactionType.BlackTalon) {
      return Validation(
        false,
        issue: 'Black Talon units must be placed in secondary units; See' +
            ' Allies rule.',
      );
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Black Talon',
      filters: [const UnitFilter(FactionType.BlackTalon)],
      id: _ruleAlliesBlackTalonId),
  description: 'You may select models from Black Talon to place into' +
      ' your secondary units.',
);

final Rule _ruleAllyUtopia = Rule(
  name: 'Utopia',
  id: _ruleAlliesUtopiaId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesCEFId,
    _ruleAlliesBlackTalonId,
    _ruleAlliesCapriceId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }

    if (unit.faction == FactionType.Utopia) {
      return Validation(
        false,
        issue: 'Utopia units must be placed in secondary units; See Allies' +
            ' rule.',
      );
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Utopia',
      filters: [const UnitFilter(FactionType.Utopia)],
      id: _ruleAlliesUtopiaId),
  description: 'You may select models from Utopia to place into your' +
      ' secondary units.',
);

final Rule _ruleAllyCaprice = Rule(
  name: 'Caprice',
  id: _ruleAlliesCapriceId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesCEFId,
    _ruleAlliesBlackTalonId,
    _ruleAlliesUtopiaId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }

    if (unit.faction == FactionType.Caprice) {
      return Validation(
        false,
        issue: 'Caprice units must be placed in secondary units; See Allies' +
            ' rule.',
      );
    }

    return null;
  },
  modCheckOverride: (u, cg, {required modID}) {
    if (modID == caprice.cyberneticUpgradesId &&
        u.group?.groupType == GroupType.Primary) {
      return false;
    }
    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Caprice',
      filters: [
        const UnitFilter(FactionType.Caprice),
        const UnitFilter(
          FactionType.Universal,
          matcher: matchInfantry,
          factionOverride: FactionType.Caprice,
        )
      ],
      id: _ruleAlliesCapriceId),
  description: 'You may select models from Caprice to place into your' +
      ' secondary units.',
);
