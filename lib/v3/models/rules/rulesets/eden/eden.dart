import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/combatGroups/group.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/caprice.dart'
    as caprice;
import 'package:gearforce/v3/models/mods/factionUpgrades/eden.dart';
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/rules/rulesets/eden/aef.dart';
import 'package:gearforce/v3/models/rules/rulesets/eden/eif.dart';
import 'package:gearforce/v3/models/rules/rulesets/eden/enh.dart';
import 'package:gearforce/v3/models/rules/options/combat_group_options.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:gearforce/v3/models/validation/validations.dart';
import 'package:gearforce/widgets/settings.dart';

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
    DataV3 data,
    Settings settings, {
    String? description,
    required String name,
    List<String>? specialRules,
    List<Rule> subFactionRules = const [],
  }) : super(
          FactionType.eden,
          data,
          settings: settings,
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
          UnitFilter(FactionType.eden),
          UnitFilter(FactionType.airstrike),
          UnitFilter(FactionType.universal),
          UnitFilter(FactionType.universalNonTerraNova),
          UnitFilter(FactionType.terrain),
        ],
      )
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory Eden.eif(DataV3 data, Settings settings) => EIF(data, settings);
  factory Eden.enh(DataV3 data, Settings settings) => ENH(data, settings);
  factory Eden.aef(DataV3 data, Settings settings) => AEF(data, settings);
}

final Rule ruleLancers = Rule(
  name: 'Lancers',
  id: _ruleLancersId,
  factionMods: (ur, cg, u) {
    if (u.type != ModelType.gear) {
      return [];
    }
    if (u.faction == FactionType.eden || u.core.frame == 'Druid') {
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
    if (group.groupType == GroupType.secondary) {
      return null;
    }

    if (unit.faction == FactionType.cef) {
      // account for core cef rule Abominations
      if (matchOnlyFlails(unit.core)) {
        return null;
      }
      return const Validation(
        false,
        issue: 'CEF units must be placed in secondary units; See Allies rule.',
      );
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: CEF',
      filters: [UnitFilter(FactionType.cef)],
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
    if (group.groupType == GroupType.secondary) {
      return null;
    }

    if (unit.faction == FactionType.blackTalon) {
      return const Validation(
        false,
        issue: 'Black Talon units must be placed in secondary units; See' +
            ' Allies rule.',
      );
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Black Talon',
      filters: [UnitFilter(FactionType.blackTalon)],
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
    if (group.groupType == GroupType.secondary) {
      return null;
    }

    if (unit.faction == FactionType.utopia) {
      return const Validation(
        false,
        issue: 'Utopia units must be placed in secondary units; See Allies' +
            ' rule.',
      );
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Utopia',
      filters: [UnitFilter(FactionType.utopia)],
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
    if (group.groupType == GroupType.secondary) {
      return null;
    }

    if (unit.faction == FactionType.caprice) {
      return const Validation(
        false,
        issue: 'Caprice units must be placed in secondary units; See Allies' +
            ' rule.',
      );
    }

    return null;
  },
  modCheckOverride: (u, cg, {required modID}) {
    if (modID == caprice.cyberneticUpgradesId &&
        u.group?.groupType == GroupType.primary) {
      return false;
    }
    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Caprice',
      filters: [
        UnitFilter(FactionType.caprice),
        UnitFilter(
          FactionType.universal,
          matcher: matchInfantry,
          factionOverride: FactionType.caprice,
        )
      ],
      id: _ruleAlliesCapriceId),
  description: 'You may select models from Caprice to place into your' +
      ' secondary units.',
);
