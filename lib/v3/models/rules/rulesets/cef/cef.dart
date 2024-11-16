import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/combatGroups/group.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/caprice.dart'
    as caprice;
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/cef.dart';
import 'package:gearforce/v3/models/rules/rulesets/cef/cefff.dart';
import 'package:gearforce/v3/models/rules/rulesets/cef/cefif.dart';
import 'package:gearforce/v3/models/rules/rulesets/cef/ceftf.dart';
import 'package:gearforce/v3/models/rules/rulesets/north/north.dart' as north;
import 'package:gearforce/v3/models/rules/options/combat_group_options.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:gearforce/v3/models/validation/validations.dart';
import 'package:gearforce/widgets/settings.dart';

const String _baseRuleId = 'rule::cef::core';
const String _ruleMinervaId = '$_baseRuleId::10';
const String _ruleAdvancedInterfaceNetworkId = '$_baseRuleId::20';
const String _ruleAllies = '$_baseRuleId::30';
const String _ruleAlliesCapriceId = '$_baseRuleId::40';
const String _ruleAlliesUtopiaId = '$_baseRuleId::50';
const String _ruleAlliesEdenId = '$_baseRuleId::60';

/*
  All the models in the CEF Model List can be used in any of the sub-lists below. There are also models in the Universal
  Model List that may be selected as well.
  All CEF models have the following rules:
  * Minerva: CEF frames may choose to have a Minerva class GREL as a pilot for 1 TV each. This will improve the PI
  skill of that frame by one.
  * Advanced Interface Network (AIN): Each veteran CEF frame may improve their GU skill by one for 1 TV times the
  number of Actions that the model has.
  All CEF forces have the following rules:
  * Veteran Leaders: You may purchase the Vet trait for any commander in the force without counting against the
  veteran limitations.
  * Allies: You may select models from Caprice, Utopia or Eden (choose one) for secondary units.
*/
class CEF extends RuleSet {
  CEF(
    DataV3 data,
    Settings settings, {
    super.description,
    required super.name,
    super.specialRules,
    List<Rule> subFactionRules = const [],
  }) : super(
          FactionType.cef,
          data,
          settings: settings,
          factionRules: [
            north.ruleVeteranLeaders,
            ruleAllies,
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
          UnitFilter(FactionType.cef),
          UnitFilter(FactionType.airstrike),
          UnitFilter(FactionType.universal),
          UnitFilter(FactionType.universalNonTerraNova),
          UnitFilter(FactionType.terrain),
        ],
      )
    ];

    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory CEF.cefff(DataV3 data, Settings settings) => CEFFF(data, settings);
  factory CEF.ceftf(DataV3 data, Settings settings) => CEFTF(data, settings);
  factory CEF.cefif(DataV3 data, Settings settings) => CEFIF(data, settings);
}

final Rule ruleMinerva = Rule(
  name: 'Minerva',
  id: _ruleMinervaId,
  factionMods: (ur, cg, u) {
    if (u.faction == FactionType.cef && u.type == ModelType.gear) {
      return [CEFMods.minerva()];
    }
    return [];
  },
  description: 'CEF frames may choose to have a Minerva class GREL as a pilot' +
      ' for 1 TV each. This will improve the PI skill of that frame by one.',
);

final Rule ruleAdvancedInterfaceNetwork = Rule(
  name: 'Advanced Interface Network (AIN)',
  id: _ruleAdvancedInterfaceNetworkId,
  factionMods: (ur, cg, u) {
    if (u.faction == FactionType.cef && u.type == ModelType.gear) {
      return [CEFMods.advancedInterfaceNetwork(u, FactionType.cef)];
    }
    return [];
  },
  description: 'Each veteran CEF frame may improve their GU skill by one for' +
      ' 1 TV times the number of Actions that the model has.',
);

final Rule ruleAllies = Rule(
  name: 'Allies',
  id: _ruleAllies,
  options: [ruleAlliesCaprice, ruleAlliesUtopia, ruleAlliesEden],
  description: 'You may select models from Caprice, Utopia or Eden (choose' +
      ' one) for secondary units.',
);

final Rule ruleAlliesCaprice = Rule(
  name: 'Caprice',
  id: _ruleAlliesCapriceId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesUtopiaId,
    _ruleAlliesEdenId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (unit.faction != FactionType.caprice) {
      return null;
    }
    if (group.groupType == GroupType.primary) {
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
  description: 'You may select models from Caprice for secondary units.',
);

final Rule ruleAlliesUtopia = Rule(
  name: 'Utopia',
  id: _ruleAlliesUtopiaId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesCapriceId,
    _ruleAlliesEdenId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (unit.faction != FactionType.utopia) {
      return null;
    }
    if (group.groupType == GroupType.primary) {
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
  description: 'You may select models from Utopia for secondary units.',
);

final Rule ruleAlliesEden = Rule(
  name: 'Eden',
  id: _ruleAlliesEdenId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesCapriceId,
    _ruleAlliesUtopiaId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (unit.faction != FactionType.eden) {
      return null;
    }
    if (group.groupType == GroupType.primary) {
      return const Validation(
        false,
        issue: 'Eden units must be placed in secondary units; See Allies' +
            ' rule.',
      );
    }
    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Eden',
      filters: [UnitFilter(FactionType.eden)],
      id: _ruleAlliesEdenId),
  description: 'You may select models from Eden for secondary units.',
);
