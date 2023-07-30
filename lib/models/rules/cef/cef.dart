import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/rules/cef/cefff.dart';
import 'package:gearforce/models/rules/cef/cefif.dart';
import 'package:gearforce/models/rules/cef/ceftf.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';

//const String _baseRuleId = 'rule::cef';

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
    String? description,
    required String name,
    List<String>? specialRules,
    List<FactionRule> subFactionRules = const [],
  }) : super(
          FactionType.CEF,
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
