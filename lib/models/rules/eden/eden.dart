import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/rules/eden/aef.dart';
import 'package:gearforce/models/rules/eden/eif.dart';
import 'package:gearforce/models/rules/eden/enh.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';

//const String _baseRuleId = 'rule::eden';

/*
  All the models in the Edenite Model List can be used in any of the sub-lists below. There are also models in the Universal
  Model List that may be selected as well.
  All Edenite models have the following rules:
  * Lancers: Golems may have their melee weapon upgraded to a lance for +2 TV each. The lance is an MSG (React,
  Reach:2). Models with a lance gain the Brawl:2 trait or add +2 to their existing Brawl:X trait if they have it.
  * Joust You Say?: Any golem with a lance may perform a melee attack using their jetpack and lance. If they are able to
  move at least 4 inches via a jetpack move and then perform a melee attack with the lance, then the attack is treated
  as using a HSG instead of a MSG.
  All Edenite forces have the following rules:
  * Allies: You may select models from Black Talon, CEF, Utopia or Caprice (pick one) for your secondary units.
*/
class Eden extends RuleSet {
  Eden(
    Data data, {
    String? description,
    required String name,
    List<String>? specialRules,
    List<FactionRule> subFactionRules = const [],
  }) : super(
          FactionType.Eden,
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
      SpecialUnitFilter(
        text: type.name,
        id: coreTag,
        filters: const [
          const UnitFilter(FactionType.Eden),
          const UnitFilter(FactionType.Airstrike),
          const UnitFilter(FactionType.Universal),
          const UnitFilter(FactionType.Universal_Non_TerraNova),
          const UnitFilter(FactionType.Terrain),
        ],
      )
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory Eden.EIF(Data data) => EIF(data);
  factory Eden.ENH(Data data) => ENH(data);
  factory Eden.AEF(Data data) => AEF(data);
}
