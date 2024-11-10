import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/mods/duelist/duelist_modification.dart'
    as duelist;
import 'package:gearforce/v3/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/v3/models/rules/rulesets/nucoal/nucoal.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:gearforce/v3/models/validation/validations.dart';

const String _baseRuleId = 'rule::nucoal::kada';
const String _ruleHeroesOfTheArenaId = '$_baseRuleId::10';
const String _ruleTheBruteId = '$_baseRuleId::20';
const String _ruleChallengersId = '$_baseRuleId::30';

/*
  KADA - Khayr ad-Din
  The arena city is a contradiction in terms. While the city itself is seedy and unsafe, there lives a
  deeper sense of honor amongst some within its walls. Warriors who normally face off against each
  other in glorious arena combat, to be the best, will also fight together to protect their city.
  * Heroes of the Arena: This force may include any number of duelists. Duelists may choose their
  gears from the North, South, Peace River, and NuCoal. This force cannot use the Independent
  Operator rule for duelists.
  * The Brute: One duelist may select a strider from the North, South, Peace River, or NuCoal.
  * Challengers: One objective selected for this force may be the assassinate objective, regardless
  of whether this force has the SO role as one of their primary roles. Select any remaining
  objectives normally.
*/
class KADA extends NuCoal {
  KADA(super.data, super.settings)
      : super(
          name: 'Khayr ad-Din',
          subFactionRules: [
            ruleHeroesOfTheArena,
            ruleTheBrute,
            ruleChallengers,
          ],
        );
}

final Rule ruleHeroesOfTheArena = Rule(
  name: 'Heroes of the Arena',
  id: _ruleHeroesOfTheArenaId,
  duelistMaxNumberOverride: (roster, cg, u) => 1000000,
  canBeAddedToGroup: (unit, group, cg) {
    if (!(unit.faction == FactionType.north ||
        unit.faction == FactionType.south ||
        unit.faction == FactionType.peaceRiver)) {
      return null;
    }

    if (checkForHumanistTechUnit(unit.core.frame)) {
      return null;
    }

    // a Northern, Southern, or Peace river model must be a duelist
    final canBeDuelist =
        cg.roster?.rulesetNotifer.value.duelistCheck(cg.roster!, cg, unit);
    if (canBeDuelist == null || !canBeDuelist) {
      return const Validation(
        false,
        issue: 'Unit must be a duelist; See Heroes of the Arena.',
      );
    }

    unit.addUnitMod(DuelistModification.makeDuelist(unit, cg.roster!));

    return null;
  },
  duelistModCheck: (u, cg, {required modID}) {
    if (modID == duelist.independentOperatorId) {
      return false;
    }
    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Heroes of the Arena',
      filters: [
        UnitFilter(
          FactionType.north,
          matcher: matchPossibleDuelist,
        ),
        UnitFilter(
          FactionType.south,
          matcher: matchPossibleDuelist,
        ),
        UnitFilter(
          FactionType.peaceRiver,
          matcher: matchPossibleDuelist,
        ),
        UnitFilter(
          FactionType.nuCoal,
          matcher: matchPossibleDuelist,
        ),
      ],
      id: _ruleHeroesOfTheArenaId),
  description: 'This force may include any number of duelists. Duelists may' +
      ' choose their gears from the North, South, Peace River, and NuCoal.' +
      ' This force cannot use the Independent Operator rule for duelists.',
);

final Rule ruleTheBrute = Rule(
  name: 'The Brute',
  id: _ruleTheBruteId,
  duelistModelCheck: (roster, u) {
    if (u.type != ModelType.strider) {
      return null;
    }

    final anyOtherStriderDuelist = roster.duelists
        .where((unit) => unit.type == ModelType.strider && unit != u)
        .toList()
        .length;
    return anyOtherStriderDuelist <= 0;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'The Brute',
      filters: [
        UnitFilter(
          FactionType.north,
          matcher: matchStriders,
        ),
        UnitFilter(
          FactionType.south,
          matcher: matchStriders,
        ),
        UnitFilter(
          FactionType.peaceRiver,
          matcher: matchStriders,
        ),
        UnitFilter(
          FactionType.nuCoal,
          matcher: matchStriders,
        ),
      ],
      id: _ruleTheBruteId),
  description: 'One duelist may select a strider from the North, South,' +
      ' Peace River, or NuCoal.',
);

final Rule ruleChallengers = Rule(
  name: 'Something to Prove',
  id: _ruleChallengersId,
  description: 'One objective selected for this force may be the' +
      ' assassinate objective, regardless of whether this force has the' +
      ' SO role as one of their primary roles. Select any remaining' +
      ' objectives normally.',
);
