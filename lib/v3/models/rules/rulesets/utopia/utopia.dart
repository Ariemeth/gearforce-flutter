import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/rules/options/combat_group_options.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/rules/rulesets/utopia/caf.dart';
import 'package:gearforce/v3/models/rules/rulesets/utopia/ouf.dart';
import 'package:gearforce/widgets/settings.dart';

const String _baseRuleId = 'rule::utopia::core';
const String _ruleDroneMatrixId = '$_baseRuleId::10';
const String _ruleManualControlId = '$_baseRuleId::20';
const String _ruleDroneHackingId = '$_baseRuleId::30';
const String _ruleExpendableId = '$_baseRuleId::40';

/*
  All the models in the Utopian Model List can be used in any of the sub-lists below. There are also models in the Universal
  Model List that may be selected as well.
  All Utopian models have the following special rule:
  * Drone Matrix: Armiger and Gilgamesh models may spend 1 CP to issue a special order that removes the Conscript
  trait from all N-KIDU within their own combat group during any one combat group’s activation.
  * Manual Control: Armiger and Gilgamesh models may spend one action to improve one N-KIDU’s GU and PI skill by
  one, during that N-KIDU’s activation.
  * Drone Hacking: Armiger and Gilgamesh models may attempt to force a universal drone or an N-KIDU drone, which
  they have sensor lock on, to self destruct. This will cost one action and require an opposed EW roll between the two
  models (jamming reactions can be used in an attempt to stop this). On an MOS:0 or better, the drone self-detonates
  becoming a small explosion with the AOE:3 trait. All models caught within the area must make an independent roll
  against their PI skill. If they fail the roll, they take one damage. After a drone self-destructs, remove the drone from
  the battlefield. Destroying friendly models in this way will count towards an opponent’s objectives (if applicable).
  * Expendable: When an armiger is targeted by a direct or indirect attack, a friendly N-KIDU within 3 inches may
  choose to be the target instead. Resolve the attack normally against the N-KIDU as if the N-KIDU was in the armiger’s
  position. This may result in the N-KIDU being the target of the attack twice in the case of Split or AOE weapons. Only
  one N-KIDU may be targeted in this way per attack.
*/

class Utopia extends RuleSet {
  Utopia(
    DataV3 data,
    Settings settings, {
    String? description,
    required String name,
    List<String>? specialRules,
    List<Rule> subFactionRules = const [],
  }) : super(
          FactionType.utopia,
          data,
          settings: settings,
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
          UnitFilter(FactionType.utopia),
          UnitFilter(FactionType.airstrike),
          UnitFilter(FactionType.universal),
          UnitFilter(FactionType.universalNonTerraNova),
          UnitFilter(FactionType.terrain),
        ],
      )
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory Utopia.caf(DataV3 data, Settings settings) => CAF(data, settings);
  factory Utopia.ouf(DataV3 data, Settings settings) => OUF(data, settings);
}

final Rule ruleDroneMatrix = Rule(
  name: 'Drone Matrix',
  id: _ruleDroneMatrixId,
  description: 'Armiger and Gilgamesh models may spend 1 CP to issue a' +
      ' special order that removes the Conscript trait from all N-KIDU within' +
      ' their own combat group during any one combat group’s activation.',
);

final Rule ruleManualControl = Rule(
  name: 'Manual Control',
  id: _ruleManualControlId,
  description: 'Armiger and Gilgamesh models may spend one action to improve' +
      ' one N-KIDU’s GU and PI skill by one, during that N-KIDU’s activation.',
);

final Rule ruleDroneHacking = Rule(
  name: 'Drone Hacking',
  id: _ruleDroneHackingId,
  description: 'Armiger and Gilgamesh models may attempt to force a universal' +
      ' drone or an N-KIDU drone, which they have sensor lock on, to self' +
      ' destruct. This will cost one action and require an opposed EW roll' +
      ' between the two models (jamming reactions can be used in an attempt' +
      ' to stop this). On an MOS:0 or better, the drone self-detonates' +
      ' becoming a small explosion with the AOE:3 trait. All models caught' +
      ' within the area must make an independent roll against their PI skill.' +
      ' If they fail the roll, they take one damage. After a drone' +
      ' self-destructs, remove the drone from the battlefield. Destroying' +
      ' friendly models in this way will count towards an opponent’s' +
      ' objectives (if applicable).',
);

final Rule ruleExpendable = Rule(
  name: 'Expendable',
  id: _ruleExpendableId,
  description: 'When an armiger is targeted by a direct or indirect attack, a' +
      ' friendly N-KIDU within 3 inches may choose to be the target instead.' +
      ' Resolve the attack normally against the N-KIDU as if the N-KIDU was' +
      ' in the armiger’s position. This may result in the N-KIDU being the' +
      ' target of the attack twice in the case of Split or AOE weapons. Only' +
      ' one N-KIDU may be targeted in this way per attack.',
);
