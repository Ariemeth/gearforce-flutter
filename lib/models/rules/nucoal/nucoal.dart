import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/rules/nucoal/hapf.dart';
import 'package:gearforce/models/rules/nucoal/hcsa.dart';
import 'package:gearforce/models/rules/nucoal/kada.dart';
import 'package:gearforce/models/rules/nucoal/nsdf.dart';
import 'package:gearforce/models/rules/nucoal/pak.dart';
import 'package:gearforce/models/rules/nucoal/th.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';

//const String _baseRuleId = 'rule::nucoal';

/*
  All the models in the NuCoal Model List can be used in any of the sub-lists below. There are also models in the Universal
  Model List that may be selected as well.
  All NuCoal forces have the following rules:
  * Humanist Tech: Hetairoi, Fire Dragons or Sagittariuses from the South may be used in FS units.
  * Port Arthur Korps:
  f HPC-64s and F6-16s from the CEF model list may be used in GP or SK units.
  f LHT-67s and 71s from the CEF may be used in RC or FS units.
*/
class NuCoal extends RuleSet {
  NuCoal(
    Data data, {
    String? description,
    required String name,
    List<String>? specialRules,
    List<FactionRule> subFactionRules = const [],
  }) : super(
          FactionType.NuCoal,
          data,
          name: name,
          description: description,
          factionRules: [],
          subFactionRules: subFactionRules,
        );

  @override
  List<SpecialUnitFilter> availableUnitFilters(
      List<CombatGroupOption>? cgOptions) {
    final filters = [
      const SpecialUnitFilter(
        text: coreName,
        id: coreTag,
        filters: const [
          const UnitFilter(FactionType.NuCoal),
          const UnitFilter(FactionType.Airstrike),
          const UnitFilter(FactionType.Universal),
          const UnitFilter(FactionType.Universal_TerraNova),
          const UnitFilter(FactionType.Terrain),
        ],
      ),
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory NuCoal.NSDF(Data data) => NSDF(data);
  factory NuCoal.PAK(Data data) => PAK(data);
  factory NuCoal.HAPF(Data data) => HAPF(data);
  factory NuCoal.KADA(Data data) => KADA(data);
  factory NuCoal.TH(Data data) => TH(data);
  factory NuCoal.HCSA(Data data) => HCSA(data);
}
