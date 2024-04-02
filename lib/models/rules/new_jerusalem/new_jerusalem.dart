import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';

//const String _baseRuleId = 'rule::nj::core';

/*
  All New Jerusalem models have the following rules:
*/

class NewJerusalem extends RuleSet {
  NewJerusalem(
    Data data, {
    super.description,
    required super.name,
    List<FactionRule> subFactionRules = const [],
  }) : super(FactionType.NewJerusalem, data,
            factionRules: [],
            subFactionRules: subFactionRules,
            specialRules: [
              'Order - Inspiring Oratory: This order may be issued at any' +
                  ' time by a New Jerusalem commander. Affected models' +
                  ' immediately refresh their Faithful SP. A CG can only be' +
                  ' affected by this order once per round '
            ]);

  @override
  List<SpecialUnitFilter> availableUnitFilters(
    List<CombatGroupOption>? cgOptions,
  ) {
    final filters = [
      SpecialUnitFilter(
        text: type.name,
        id: coreTag,
        filters: const [
          const UnitFilter(FactionType.NewJerusalem),
          const UnitFilter(FactionType.Airstrike),
          const UnitFilter(FactionType.Universal),
          const UnitFilter(FactionType.Terrain),
        ],
      ),
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  // factory NewJerusalem.OSG(Data data) => OSG(data);
  // factory NewJerusalem.OSM(Data data) => OSM(data);
  // factory NewJerusalem.ODC(Data data) => ODC(data);
}
