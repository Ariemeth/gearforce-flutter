import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/black_talon.dart';
import 'package:gearforce/models/rules/black_talons/btat.dart';
import 'package:gearforce/models/rules/black_talons/btit.dart';
import 'package:gearforce/models/rules/black_talons/btrt.dart';
import 'package:gearforce/models/rules/black_talons/btst.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';

const String _baseRuleId = 'rule::blackTalon';
const String _ruleTheChosenId = '$_baseRuleId::10';
const String _ruleSpecialOperatorsId = '$_baseRuleId::20';

/*
  All the models in the Black Talon Model List can be used in any of the sub-lists below. There are also models in the
  Universal Model List that may be selected as well.
  All Black Talon forces have the following special rule:
  * The Chosen: The force leader may purchase 1 extra CP for 2 TV.
  * Special Operators: This force may select one assassinate and/or one raid objective regardless of its unit composition.
  Select any remaining objectives normally.
*/
class BlackTalons extends RuleSet {
  BlackTalons(
    Data data, {
    String? description,
    required String name,
    List<String>? specialRules,
    List<FactionRule> subFactionRules = const [],
  }) : super(
          FactionType.BlackTalon,
          data,
          name: name,
          description: description,
          factionRules: [ruleTheChosen, ruleSpecialOperators],
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
          const UnitFilter(FactionType.BlackTalon),
          const UnitFilter(FactionType.Airstrike),
          const UnitFilter(FactionType.Universal),
          const UnitFilter(FactionType.Universal_TerraNova),
          const UnitFilter(FactionType.Terrain),
        ],
      )
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory BlackTalons.BTRT(Data data) => BTRT(data);
  factory BlackTalons.BTIT(Data data) => BTIT(data);
  factory BlackTalons.BTST(Data data) => BTST(data);
  factory BlackTalons.BTAT(Data data) => BTAT(data);
}

final FactionRule ruleTheChosen = FactionRule(
  name: 'The Chosen',
  id: _ruleTheChosenId,
  factionMods: (ur, cg, u) => [BlackTalonMods.theChosen()],
  description: 'The force leader may purchase 1 extra CP for 2 TV.',
);

final FactionRule ruleSpecialOperators = FactionRule(
  name: 'Special Operators',
  id: _ruleSpecialOperatorsId,
  description: 'This force may select one assassinate and/or one raid' +
      ' objective regardless of its unit composition. Select any remaining' +
      ' objectives normally.',
);
