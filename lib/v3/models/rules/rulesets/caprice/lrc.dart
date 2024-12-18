import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/combatGroups/group.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/mods/duelist/duelist_modification.dart'
    as duelist_mod;
import 'package:gearforce/v3/models/rules/rulesets/caprice/caprice.dart';
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/validation/validations.dart';

const String _baseRuleId = 'rule::caprice::lrc';
const String _ruleHeroesOfTheResistanceId = '$_baseRuleId::10';
const String _ruleAlliesId = '$_baseRuleId::20';
const String _ruleAlliesBlackTalonId = '$_baseRuleId::30';
const String _ruleAlliesUtopiaId = '$_baseRuleId::40';
const String _ruleAlliesEdenId = '$_baseRuleId::50';
const String _ruleAmbushId = '$_baseRuleId::60';
const String _ruleEliminationId = '$_baseRuleId::70';

/*
  LRC - Liberati Resistance Cell
  Caprician corporations have tried for hundreds of years to rid themselves of the Liberati threat.
  However, they are in fact a society within itself, with millions of people. The Liberati cells are only
  one smaller aspect. On the other end of this spectrum is a work force that’s willing to do jobs no
  one else on Caprice will do. And after 30 years of CEF occupation, many have started looking at
  the Liberati as allies instead of adversaries.
  * Heroes of the Resistance: This force may include one duelist per combat group. This force
  cannot use the Independent Operator rule for duelists.
  * Allies: You may select models from Black Talon, Utopia or Eden (pick one) to place into your
  secondary units.
  * Ambush: One combat group may use the special operations deployment regardless of their
  primary unit’s role.
  * Elimination: One objective selected for this force may be the assassinate objective,
  regardless of whether this force has the SO role as one of their primary unit’s roles. Select
  any remaining objectives normally.
*/
class LRC extends Caprice {
  LRC(super.data, super.settings)
      : super(
          name: 'Liberati Resistance Cell',
          subFactionRules: [ruleHeroesOfTheResistance, ruleAllies],
        );
}

final Rule ruleHeroesOfTheResistance = Rule(
  name: 'Heroes of the Resistance',
  id: _ruleHeroesOfTheResistanceId,
  duelistModCheck: (u, cg, {required modID}) {
    if (modID == duelist_mod.independentOperatorId) {
      return false;
    }
    return null;
  },
  duelistMaxNumberOverride: (roster, cg, u) {
    final numOtherDuelist = cg.duelists.where((unit) => unit != u).length;

    if (numOtherDuelist == 0) {
      return roster.duelistCount + 1;
    }

    return null;
  },
  description: 'One gear in each combat group may be a duelist. This force' +
      ' cannot use the Independent Operator rule for duelists.',
);

final Rule ruleAllies = Rule(
  name: 'Allies',
  id: _ruleAlliesId,
  options: [
    _ruleAllyBlackTalon,
    _ruleAllyUtopia,
    _ruleAllyEden,
  ],
  description: 'You may select models from the Black Talon, Utopia or' +
      ' Eden to place into your secondary units.',
);

final Rule _ruleAllyBlackTalon = Rule(
  name: 'Black Talon',
  id: _ruleAlliesBlackTalonId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesUtopiaId,
    _ruleAlliesEdenId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.secondary) {
      return null;
    }

    if (unit.faction == FactionType.blackTalon) {
      return const Validation(
        false,
        issue: 'Black Talon units may only be placed in secondary units; See' +
            ' Allies rule.',
      );
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Black Talon',
      filters: [UnitFilter(FactionType.blackTalon)],
      id: _ruleAlliesBlackTalonId),
  description: 'You may select models from the Black Talon to place into your' +
      ' secondary units.',
);

final Rule _ruleAllyUtopia = Rule(
  name: 'Utopia',
  id: _ruleAlliesUtopiaId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesBlackTalonId,
    _ruleAlliesEdenId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.secondary) {
      return null;
    }

    if (unit.faction == FactionType.utopia) {
      return const Validation(
        false,
        issue: 'Utopia units may only be placed in secondary units; See' +
            ' Allies rule.',
      );
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Utopia',
      filters: [UnitFilter(FactionType.utopia)],
      id: _ruleAlliesUtopiaId),
  description: 'You may select models from the Utopia to place into your' +
      ' secondary units.',
);

final Rule _ruleAllyEden = Rule(
  name: 'Eden',
  id: _ruleAlliesEdenId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesBlackTalonId,
    _ruleAlliesUtopiaId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.secondary) {
      return null;
    }

    if (unit.faction == FactionType.eden) {
      return const Validation(
        false,
        issue: 'Eden units may only be placed in secondary units; See' +
            ' Allies rule.',
      );
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Eden',
      filters: [UnitFilter(FactionType.eden)],
      id: _ruleAlliesEdenId),
  description: 'You may select models from the Eden to place into your' +
      ' secondary units.',
);

final Rule ruleAmbush = Rule(
  name: 'Ambush',
  id: _ruleAmbushId,
  description: 'One combat group may use the special operations deployment' +
      ' regardless of their primary unit’s role.',
);

final Rule ruleElimination = Rule(
  name: 'Elimination',
  id: _ruleEliminationId,
  description: 'One objective selected for this force may be the assassinate' +
      ' objective, regardless of whether this force has the SO role as one of' +
      ' their primary unit’s roles. Select any remaining objectives normally.',
);
