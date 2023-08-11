import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/caprice.dart';
import 'package:gearforce/models/mods/factionUpgrades/cef.dart';
import 'package:gearforce/models/rules/cef/cef.dart' as cef;
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/rules/caprice/cid.dart';
import 'package:gearforce/models/rules/caprice/cse.dart';
import 'package:gearforce/models/rules/caprice/lrc.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';

const String _baseRuleId = 'rule::caprice::core';
const String _ruleDuelingMountsId = '$_baseRuleId::10';
const String _ruleCyberneticUpgradesId = '$_baseRuleId::10';
const String _ruleAbominationsId = '$_baseRuleId::10';

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
    Data data, {
    String? description,
    required String name,
    List<String>? specialRules,
    List<FactionRule> subFactionRules = const [],
  }) : super(
          FactionType.Caprice,
          data,
          name: name,
          description: description,
          factionRules: [
            ruleDuelingMounts,
            ruleAdvancedInterfaceNetworks,
            ruleCyberneticUpgrades,
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
          const UnitFilter(FactionType.Caprice),
          const UnitFilter(FactionType.Airstrike),
          const UnitFilter(FactionType.Universal),
          const UnitFilter(FactionType.Universal_Non_TerraNova),
          const UnitFilter(FactionType.Terrain),
        ],
      )
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory Caprice.CID(Data data) => CID(data);
  factory Caprice.CSE(Data data) => CSE(data);
  factory Caprice.LRC(Data data) => LRC(data);
}

final FactionRule ruleDuelingMounts = FactionRule(
  name: 'Dueling Mounts',
  id: _ruleDuelingMountsId,
  duelistModelCheck: (roster, u) {
    if (u.faction != FactionType.Caprice) {
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

final FactionRule ruleAdvancedInterfaceNetworks = FactionRule.from(
  cef.ruleAdvancedInterfaceNetwork,
  factionMods: (ur, cg, u) => [
    CEFMods.advancedInterfaceNetwork(u, FactionType.Caprice),
  ],
);

final FactionRule ruleCyberneticUpgrades = FactionRule(
  name: 'Cybernetic Upgrades',
  id: _ruleCyberneticUpgradesId,
  factionMods: (ur, cg, u) => [CapriceMods.cyberneticUpgrades()],
  description: 'Each veteran universal infantry may add the following bonuses' +
      ' for 1 TV total; +1 Armor, +1 GU and the Climber trait.',
);

final FactionRule ruleAbominations = FactionRule(
  name: 'Abominations',
  id: _ruleAbominationsId,
  unitFilter: () => const SpecialUnitFilter(
      text: 'Abominations',
      filters: [
        UnitFilter(
          FactionType.CEF,
          matcher: matchOnlyFlails,
        ),
      ],
      id: _ruleAbominationsId),
  cgCheck: onlyOneCG(_ruleAbominationsId),
  combatGroupOption: () => ruleAbominations.buidCombatGroupOption(),
  description: 'One combat group may include FLAILs from the CEF.',
);
