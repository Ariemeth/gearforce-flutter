import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/caprice/caprice.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit_core.dart';

const String _baseRuleId = 'rule::caprice::cse';
const String _ruleTheBestWayToMakeMoneyId = '$_baseRuleId::10';
const String _ruleAlliesId = '$_baseRuleId::20';
const String _ruleAlliesCEFId = '$_baseRuleId::30';
const String _ruleAlliesUtopiaId = '$_baseRuleId::40';
const String _ruleAlliesEdenId = '$_baseRuleId::50';
const String _ruleAppropriationsId = '$_baseRuleId::60';
const String _ruleAcquisitionsId = '$_baseRuleId::70';

/*
  CSE - Corporate Security Element
  The major corporations regard their security elements much like any nation would regard their
  military. With assets from people, equipment and even secret research, the corporations have
  much to protect. Shadow wars have been known to sprout up between competing corporations.
  * The Best Money Can Buy: Two combat groups may be designated as veteran combat groups
  instead of the normal limit of one combat group.
  * Allies: You may select models from the CEF, Utopia or Eden (pick one) to place into your
  secondary units.
  * Appropriations: This force may have one primary unit composed of CEF frames, Utopian
  APEs or Eden golems. The CEF Minerva upgrade cannot be selected. These models may be
  mixed with Caprician models or each other.
  * Acquisitions: One objective selected for this force may be the raid objective, regardless of
  whether this force has the SO role as one of their primary unit’s roles. Select any remaining
*/
class CSE extends Caprice {
  CSE(super.data)
      : super(
          name: 'Corporate Security Element',
          subFactionRules: [
            ruleTheBestMoneyCanBuy,
            ruleAllies,
            ruleAppropriations,
            ruleAcquisitions,
          ],
        );
}

final FactionRule ruleTheBestMoneyCanBuy = FactionRule(
  name: 'The Best Money Can Buy',
  id: _ruleTheBestWayToMakeMoneyId,
  veteranCGCountOverride: (ur, cg) => 2,
  description: 'Two combat groups may be designated as veteran combat groups' +
      ' instead of the normal limit of one combat group.',
);

final FactionRule ruleAllies = FactionRule(
  name: 'Allies',
  id: _ruleAlliesId,
  options: [
    _ruleAllyCEF,
    _ruleAllyUtopia,
    _ruleAllyEden,
  ],
  description: 'You may select models from the CEF, Utopia or' +
      ' Eden to place into your secondary units.',
);

final FactionRule _ruleAllyCEF = FactionRule(
  name: 'CEF',
  id: _ruleAlliesCEFId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: FactionRule.thereCanBeOnlyOne([
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
      filters: [const UnitFilter(FactionType.CEF)],
      id: _ruleAlliesCEFId),
  description: 'You may select models from the CEF to place into your' +
      ' secondary units.',
);

final FactionRule _ruleAllyUtopia = FactionRule(
  name: 'Utopia',
  id: _ruleAlliesUtopiaId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: FactionRule.thereCanBeOnlyOne([
    _ruleAlliesCEFId,
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
      filters: [const UnitFilter(FactionType.Utopia)],
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
      filters: [const UnitFilter(FactionType.Eden)],
      id: _ruleAlliesEdenId),
  description: 'You may select models from the Eden to place into your' +
      ' secondary units.',
);

final FactionRule ruleAppropriations = FactionRule(
  name: 'Appropriations',
  id: _ruleAppropriationsId,
  canBeAddedToGroup: (unit, group, cg) {
    if (!_matchForAppropriations(unit.core)) {
      return null;
    }
    return group.groupType == GroupType.Primary;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Appropriations',
      filters: [
        UnitFilter(FactionType.CEF, matcher: _matchForAppropriations),
        UnitFilter(FactionType.Utopia, matcher: _matchForAppropriations),
        UnitFilter(FactionType.Eden, matcher: _matchForAppropriations)
      ],
      id: _ruleAppropriationsId),
  cgCheck: onlyOneCG(_ruleAppropriationsId),
  combatGroupOption: () => [ruleAppropriations.buidCombatGroupOption()],
  description: 'This force may have one primary unit composed of CEF frames,' +
      ' Utopian APEs or Eden golems. The CEF Minerva upgrade cannot be' +
      ' selected. These models may be mixed with Caprician models or each' +
      ' other.',
);

/// Match only with Gears
bool _matchForAppropriations(UnitCore uc) {
  if (!(uc.faction == FactionType.CEF ||
      uc.faction == FactionType.Utopia ||
      uc.faction == FactionType.Eden)) {
    return false;
  }
  return uc.type == ModelType.Gear;
}

final FactionRule ruleAcquisitions = FactionRule(
  name: 'Acquisitions',
  id: _ruleAcquisitionsId,
  description: 'One objective selected for this force may be the raid' +
      ' objective, regardless of whether this force has the SO role as one of' +
      ' their primary unit’s roles. Select any remaining objectives normally.',
);
