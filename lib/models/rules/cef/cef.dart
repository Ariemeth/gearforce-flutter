import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/cef.dart';
import 'package:gearforce/models/rules/cef/cefff.dart';
import 'package:gearforce/models/rules/cef/cefif.dart';
import 'package:gearforce/models/rules/cef/ceftf.dart';
import 'package:gearforce/models/rules/north/north.dart' as north;
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/unit/model_type.dart';

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
    Data data, {
    super.description,
    required super.name,
    super.specialRules,
    List<FactionRule> subFactionRules = const [],
  }) : super(
          FactionType.CEF,
          data,
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
          const UnitFilter(FactionType.CEF),
          const UnitFilter(FactionType.Airstrike),
          const UnitFilter(FactionType.Universal),
          const UnitFilter(FactionType.Universal_Non_TerraNova),
          const UnitFilter(FactionType.Terrain),
        ],
      )
    ];

    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory CEF.CEFFF(Data data) => CEFFF(data);
  factory CEF.CEFTF(Data data) => CEFTF(data);
  factory CEF.CEFIF(Data data) => CEFIF(data);
}

final FactionRule ruleMinvera = FactionRule(
  name: 'Minerva',
  id: _ruleMinervaId,
  factionMods: (ur, cg, u) {
    if (u.faction == FactionType.CEF && u.type == ModelType.Gear) {
      return [CEFMods.minerva()];
    }
    return [];
  },
  description: 'CEF frames may choose to have a Minerva class GREL as a pilot' +
      ' for 1 TV each. This will improve the PI skill of that frame by one.',
);

final FactionRule ruleAdvancedInterfaceNetwork = FactionRule(
  name: 'Advanced Interface Network (AIN)',
  id: _ruleAdvancedInterfaceNetworkId,
  factionMods: (ur, cg, u) {
    if (u.faction == FactionType.CEF && u.type == ModelType.Gear) {
      return [CEFMods.advancedInterfaceNetwork(u, FactionType.CEF)];
    }
    return [];
  },
  description: 'Each veteran CEF frame may improve their GU skill by one for' +
      ' 1 TV times the number of Actions that the model has.',
);

final FactionRule ruleAllies = FactionRule(
  name: 'Allies',
  id: _ruleAllies,
  options: [ruleAlliesCaprice, ruleAlliesUtopia, ruleAlliesEden],
  description: 'You may select models from Caprice, Utopia or Eden (choose' +
      ' one) for secondary units.',
);

final FactionRule ruleAlliesCaprice = FactionRule(
  name: 'Caprice',
  id: _ruleAlliesCapriceId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: FactionRule.thereCanBeOnlyOne([
    _ruleAlliesUtopiaId,
    _ruleAlliesEdenId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (unit.faction != FactionType.Caprice) {
      return null;
    }
    if (group.groupType == GroupType.Primary) {
      return false;
    }
    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Caprice',
      filters: [UnitFilter(FactionType.Caprice)],
      id: _ruleAlliesCapriceId),
  description: 'You may select models from Caprice for secondary units.',
);

final FactionRule ruleAlliesUtopia = FactionRule(
  name: 'Utopia',
  id: _ruleAlliesUtopiaId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: FactionRule.thereCanBeOnlyOne([
    _ruleAlliesCapriceId,
    _ruleAlliesEdenId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (unit.faction != FactionType.Utopia) {
      return null;
    }
    if (group.groupType == GroupType.Primary) {
      return false;
    }
    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Utopia',
      filters: [UnitFilter(FactionType.Utopia)],
      id: _ruleAlliesUtopiaId),
  description: 'You may select models from Utopia for secondary units.',
);

final FactionRule ruleAlliesEden = FactionRule(
  name: 'Eden',
  id: _ruleAlliesEdenId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: FactionRule.thereCanBeOnlyOne([
    _ruleAlliesCapriceId,
    _ruleAlliesUtopiaId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (unit.faction != FactionType.Eden) {
      return null;
    }
    if (group.groupType == GroupType.Primary) {
      return false;
    }
    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Eden',
      filters: [UnitFilter(FactionType.Eden)],
      id: _ruleAlliesEdenId),
  description: 'You may select models from Eden for secondary units.',
);
