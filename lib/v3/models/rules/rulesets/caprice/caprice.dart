import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/caprice.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/cef.dart';
import 'package:gearforce/v3/models/rules/rulesets/cef/cef.dart' as cef;
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/rules/rulesets/caprice/cid.dart';
import 'package:gearforce/v3/models/rules/rulesets/caprice/cse.dart';
import 'package:gearforce/v3/models/rules/rulesets/caprice/lrc.dart';
import 'package:gearforce/v3/models/rules/options/combat_group_options.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:gearforce/widgets/settings.dart';

const String _baseRuleId = 'rule::caprice::core';
const String _ruleDuelingMountsId = '$_baseRuleId::10';
const String _ruleCyberneticUpgradesId = '$_baseRuleId::20';
const String _ruleAbominationsId = '$_baseRuleId::30';

/*
  All the models in the Caprician Model List can be used in any of the sub-lists below. There are also models in the
  Universal Model List that may be selected as well.
  All Caprician models have the following special rule:
  * Dueling Mounts: Bashan, Kadesh, Aphek and Meggido may become duelists even though they are striders. Follow
  all other duelist rules as normal.
  * Advanced Interface Networks (AIN): Each veteran mount may improve their GU skill by one for 1 TV times the
  number of Actions that the model has.
  * Cybernetic Upgrades: Each veteran universal infantry may add the following bonuses for 1 TV total;
  +1 Armor, +1 GU and the Climber trait.
  All Caprician forces have the following special rule:
  * Abominations: One combat group may include FLAILs from the CEF.
*/
class Caprice extends RuleSet {
  Caprice(
    DataV3 data,
    Settings settings, {
    String? description,
    required String name,
    List<String>? specialRules,
    List<Rule> subFactionRules = const [],
  }) : super(
          FactionType.caprice,
          data,
          settings: settings,
          name: name,
          description: description,
          factionRules: [
            ruleAbominations,
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
          UnitFilter(FactionType.caprice),
          UnitFilter(FactionType.airstrike),
          UnitFilter(FactionType.universal),
          UnitFilter(FactionType.universalNonTerraNova),
          UnitFilter(FactionType.terrain),
        ],
      )
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory Caprice.cid(DataV3 data, Settings settings) => CID(data, settings);
  factory Caprice.cse(DataV3 data, Settings settings) => CSE(data, settings);
  factory Caprice.lrc(DataV3 data, Settings settings) => LRC(data, settings);
}

final Rule ruleDuelingMounts = Rule(
  name: 'Dueling Mounts',
  id: _ruleDuelingMountsId,
  duelistModelCheck: (roster, u) {
    if (u.faction != FactionType.caprice) {
      return null;
    }
    final frame = u.core.frame;
    if (frame == 'Bashan' ||
        frame == 'Kadesh' ||
        frame == 'Aphek' ||
        frame == 'Meggido') {
      return true;
    }
    return null;
  },
  description: 'Bashan, Kadesh, Aphek and Meggido may become duelists even' +
      ' though they are striders. Follow all other duelist rules as normal.',
);

final Rule ruleAdvancedInterfaceNetworks = Rule.from(
  cef.ruleAdvancedInterfaceNetwork,
  factionMods: (ur, cg, u) {
    if (u.faction == FactionType.caprice &&
        (u.type == ModelType.gear || u.type == ModelType.strider)) {
      return [CEFMods.advancedInterfaceNetwork(u, FactionType.caprice)];
    }
    return [];
  },
);

final Rule ruleCyberneticUpgrades = Rule(
  name: 'Cybernetic Upgrades',
  id: _ruleCyberneticUpgradesId,
  factionMods: (ur, cg, u) {
    if ((u.faction == FactionType.universal ||
            u.faction == FactionType.caprice) &&
        u.core.faction == FactionType.universal &&
        u.type == ModelType.infantry) {
      return [CapriceMods.cyberneticUpgrades()];
    }
    return [];
  },
  description: 'Each veteran universal infantry may add the following bonuses' +
      ' for 1 TV total; +1 Armor, +1 GU and the Climber trait.',
);

final Rule ruleAbominations = Rule(
  name: 'Abominations',
  id: _ruleAbominationsId,
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Abominations',
      filters: [
        UnitFilter(
          FactionType.cef,
          matcher: matchOnlyFlails,
        ),
      ],
      id: _ruleAbominationsId),
  cgCheck: onlyOneCG(_ruleAbominationsId),
  combatGroupOption: () => [ruleAbominations.buidCombatGroupOption()],
  description: 'One combat group may include FLAILs from the CEF.',
);
