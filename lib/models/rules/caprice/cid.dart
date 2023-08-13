import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/caprice.dart';
import 'package:gearforce/models/rules/caprice/caprice.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/rules/south/milicia.dart' as milicia;
import 'package:gearforce/models/unit/role.dart';

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
  CID(super.data)
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

final FactionRule ruleCommandersInvestment = FactionRule(
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
  description: 'You may select models from the CEF, Black Talon, Utopia or' +
      ' Eden (pick one) to place into your secondary units.',
);

final FactionRule ruleAllies = FactionRule(
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

final FactionRule _ruleAllyCEF = FactionRule(
  name: 'CEF',
  id: _ruleAlliesCEFId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: FactionRule.thereCanBeOnlyOne([
    _ruleAlliesBlackTalonId,
    _ruleAlliesUtopiaId,
    _ruleAlliesEdenId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }

    if (unit.faction == FactionType.CEF) {
      // account for core cef rule Abominations
      if (matchOnlyFlails(unit.core)) {
        return null;
      }
      return false;
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: CEF',
      filters: [UnitFilter(FactionType.CEF)],
      id: _ruleAlliesCEFId),
  description: 'You may select models from the CEF to place into your' +
      ' secondary units.',
);

final FactionRule _ruleAllyBlackTalon = FactionRule(
  name: 'Black Talon',
  id: _ruleAlliesBlackTalonId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: FactionRule.thereCanBeOnlyOne([
    _ruleAlliesCEFId,
    _ruleAlliesUtopiaId,
    _ruleAlliesEdenId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }

    if (unit.faction == FactionType.BlackTalon) {
      return false;
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Black Talon',
      filters: [UnitFilter(FactionType.BlackTalon)],
      id: _ruleAlliesBlackTalonId),
  description: 'You may select models from the Black Talon to place into' +
      ' your secondary units.',
);

final FactionRule _ruleAllyUtopia = FactionRule(
  name: 'Utopia',
  id: _ruleAlliesUtopiaId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: FactionRule.thereCanBeOnlyOne([
    _ruleAlliesCEFId,
    _ruleAlliesBlackTalonId,
    _ruleAlliesEdenId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }

    if (unit.faction == FactionType.Utopia) {
      return false;
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Utopia',
      filters: [UnitFilter(FactionType.Utopia)],
      id: _ruleAlliesUtopiaId),
  description: 'You may select models from the Utopia to place into your' +
      ' secondary units.',
);

final FactionRule _ruleAllyEden = FactionRule(
  name: 'Eden',
  id: _ruleAlliesEdenId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: FactionRule.thereCanBeOnlyOne([
    _ruleAlliesCEFId,
    _ruleAlliesBlackTalonId,
    _ruleAlliesUtopiaId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }

    if (unit.faction == FactionType.Eden) {
      return false;
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Eden',
      filters: [UnitFilter(FactionType.Eden)],
      id: _ruleAlliesEdenId),
  description: 'You may select models from the Eden to place into your' +
      ' secondary units.',
);

final FactionRule ruleMeleeSpecialists = FactionRule(
  name: 'Melee Specialist',
  id: _ruleMeleeSpecialistsId,
  factionMods: (ur, cg, u) => [CapriceMods.meleeSpecialists(u)],
  description: 'Up to two models per combat group may take this upgrade if' +
      ' they have the Brawl:1 trait. Upgrade their Brawl:1 trait to Brawl:2' +
      ' for 1 TV each.',
);
