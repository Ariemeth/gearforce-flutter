import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/rules/south/ese.dart';
import 'package:gearforce/models/rules/south/fha.dart';
import 'package:gearforce/models/rules/south/md.dart';
import 'package:gearforce/models/rules/south/milicia.dart';
import 'package:gearforce/models/rules/south/sra.dart';

//const String _baseRuleId = 'rule::south';

/*
  All the models in the Southern Model List can be used in any of the sub-lists below. There are also models in the Universal
  Model List that may be selected as well.
  All Southern forces have the following rules:
  * Police State: Southern MP models may be placed in GP, SK, FS or SO units.
  * Amphibians: Up to 2 Water Vipers, or up to 2 Caimans (Caiman variants or the Crocodile variant), may be placed in
  GP, SK, FS, RC or SO units.
*/
class South extends RuleSet {
  South(
    Data data, {
    String? description,
    required String name,
    List<String>? specialRules,
    List<FactionRule> subFactionRules = const [],
  }) : super(
          FactionType.South,
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
          const UnitFilter(FactionType.South),
          const UnitFilter(FactionType.Airstrike),
          const UnitFilter(FactionType.Universal),
          const UnitFilter(FactionType.Universal_TerraNova),
          const UnitFilter(FactionType.Terrain),
        ],
      ),
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory South.SRA(Data data) => SRA(data);
  factory South.MILICIA(Data data) => MILICIA(data);
  factory South.MD(Data data) => MD(data);
  factory South.ESE(Data data) => ESE(data);
  factory South.FHA(Data data) => FHA(data);
}
