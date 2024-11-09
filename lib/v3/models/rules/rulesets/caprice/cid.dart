import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/combatGroups/group.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/caprice.dart';
import 'package:gearforce/v3/models/rules/rulesets/caprice/caprice.dart';
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/rules/rulesets/south/milicia.dart'
    as milicia;
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/v3/models/validation/validations.dart';

const String _baseRuleId = 'rule::caprice::cid';
const String _ruleCommandersInvestmentId = '$_baseRuleId::10';
const String _ruleAlliesId = '$_baseRuleId::20';
const String _ruleAlliesCEFId = '$_baseRuleId::30';
const String _ruleAlliesBlackTalonId = '$_baseRuleId::40';
const String _ruleAlliesUtopiaId = '$_baseRuleId::50';
const String _ruleAlliesEdenId = '$_baseRuleId::60';
const String _ruleMeleeSpecialistsId = '$_baseRuleId::70';

/*
  CID - Caprice Invasion Detachment
  These units are adapting to combat on Terra Nova quite well. Their experience operating in
  environments on Caprice makes them perfect for urban and mountainous regions on Terra Nova.
  There are unconfirmed reports of CID forces operating in conjunction with Black Talon teams.
  * Commander’s Investment: The force leader’s model may be placed in GP, SK, FS, RC,
  or SO units, regardless of the model’s available roles.
  * Allies: You may select models from the CEF, Black Talon, Utopia or Eden (pick one) to place
  into your secondary units.
  * Melee Specialists: Up to two models per combat group may take this upgrade if they have
  the Brawl:1 trait. Upgrade their Brawl:1 trait to Brawl:2 for 1 TV each.
  * Conscription: You may add the Conscript trait to any non-commander, non-veteran and
  non-duelist in the force if they do not already possess the trait. Reduce the TV of these
  models by 1 TV per action.
*/
class CID extends Caprice {
  CID(super.data, super.settings)
      : super(
          name: 'Caprice Invasion Detachment',
          subFactionRules: [
            ruleCommandersInvestment,
            ruleAllies,
            ruleMeleeSpecialists,
            milicia.ruleConscription,
          ],
        );
}

final Rule ruleCommandersInvestment = Rule(
  name: 'Commander’s Investment',
  id: _ruleCommandersInvestmentId,
  hasGroupRole: (unit, target, group) {
    if (group.combatGroup?.roster?.selectedForceLeader != unit) {
      return null;
    }
    if (target == RoleType.GP ||
        target == RoleType.SK ||
        target == RoleType.FS ||
        target == RoleType.RC ||
        target == RoleType.SO) {
      return true;
    }
    return false;
  },
  description: 'The force leader’s model may be placed in GP, SK, FS, RC,' +
      ' or SO units, regardless of the model’s available roles.',
);

final Rule ruleAllies = Rule(
  name: 'Allies',
  id: _ruleAlliesId,
  options: [
    _ruleAllyCEF,
    _ruleAllyBlackTalon,
    _ruleAllyUtopia,
    _ruleAllyEden,
  ],
  description: 'You may select models from the CEF, Black Talon, Utopia or' +
      ' Eden to place into your secondary units.',
);

final Rule _ruleAllyCEF = Rule(
  name: 'CEF',
  id: _ruleAlliesCEFId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesBlackTalonId,
    _ruleAlliesUtopiaId,
    _ruleAlliesEdenId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.secondary) {
      return null;
    }

    if (unit.faction == FactionType.CEF) {
      // account for core cef rule Abominations
      if (matchOnlyFlails(unit.core)) {
        return null;
      }
      return Validation(
        false,
        issue: 'CEF units must be placed in secondary units; See' +
            ' Allies rule.',
      );
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: CEF',
      filters: [const UnitFilter(FactionType.CEF)],
      id: _ruleAlliesCEFId),
  description: 'You may select models from the CEF to place into your' +
      ' secondary units.',
);

final Rule _ruleAllyBlackTalon = Rule(
  name: 'Black Talon',
  id: _ruleAlliesBlackTalonId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesCEFId,
    _ruleAlliesUtopiaId,
    _ruleAlliesEdenId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.secondary) {
      return null;
    }

    if (unit.faction == FactionType.BlackTalon) {
      return Validation(
        false,
        issue: 'Black Talon units must be placed in secondary units; See' +
            ' Allies rule.',
      );
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Black Talon',
      filters: [const UnitFilter(FactionType.BlackTalon)],
      id: _ruleAlliesBlackTalonId),
  description: 'You may select models from the Black Talon to place into' +
      ' your secondary units.',
);

final Rule _ruleAllyUtopia = Rule(
  name: 'Utopia',
  id: _ruleAlliesUtopiaId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesCEFId,
    _ruleAlliesBlackTalonId,
    _ruleAlliesEdenId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.secondary) {
      return null;
    }

    if (unit.faction == FactionType.Utopia) {
      return Validation(
        false,
        issue: 'Utopia units must be placed in secondary units; See' +
            ' Allies rule.',
      );
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Utopia',
      filters: [const UnitFilter(FactionType.Utopia)],
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
    _ruleAlliesCEFId,
    _ruleAlliesBlackTalonId,
    _ruleAlliesUtopiaId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.secondary) {
      return null;
    }

    if (unit.faction == FactionType.Eden) {
      return Validation(
        false,
        issue: 'Eden units must be placed in secondary units; See' +
            ' Allies rule.',
      );
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Eden',
      filters: [const UnitFilter(FactionType.Eden)],
      id: _ruleAlliesEdenId),
  description: 'You may select models from the Eden to place into your' +
      ' secondary units.',
);

final Rule ruleMeleeSpecialists = Rule(
  name: 'Melee Specialist',
  id: _ruleMeleeSpecialistsId,
  factionMods: (ur, cg, u) => [CapriceMods.meleeSpecialists(u)],
  description: 'Up to two models per combat group may take this upgrade if' +
      ' they have the Brawl:1 trait. Upgrade their Brawl:1 trait to Brawl:2' +
      ' for 1 TV each.',
);
