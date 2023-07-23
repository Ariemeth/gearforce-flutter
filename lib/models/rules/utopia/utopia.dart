import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';

//const String _baseRuleId = 'rule::utopia';

class Utopia extends RuleSet {
  Utopia(
    Data data, {
    String? description,
    required String name,
    List<String>? specialRules,
    List<FactionRule> subFactionRules = const [],
  }) : super(
          FactionType.Utopia,
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
      const SpecialUnitFilter(
        text: coreName,
        id: coreTag,
        filters: const [
          const UnitFilter(FactionType.Utopia),
          const UnitFilter(FactionType.Airstrike),
          const UnitFilter(FactionType.Universal),
          const UnitFilter(FactionType.Universal_Non_TerraNova),
          const UnitFilter(FactionType.Terrain),
        ],
      )
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }
}
