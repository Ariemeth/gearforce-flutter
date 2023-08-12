import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/utopia.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/rules/north/north.dart' as north;
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/rules/utopia/utopia.dart';
import 'package:gearforce/models/unit/role.dart';

const String _baseRuleId = 'rule::utopia::caf';
const String _ruleAlliesId = '$_baseRuleId::10';
const String _ruleAlliesCEFId = '$_baseRuleId::20';
const String _ruleAlliesCapriceId = '$_baseRuleId::40';
const String _ruleAlliesEdenId = '$_baseRuleId::50';
const String _ruleCombinedArmsId = '$_baseRuleId::60';
const String _ruleRecceTroupeId = '$_baseRuleId::70';
const String _ruleQuietDeathId = '$_baseRuleId::80';
const String _ruleSilentAssaultId = '$_baseRuleId::90';
const String _ruleSupportTroupeId = '$_baseRuleId::100';
const String _ruleWrathOfTheDemigodsId = '$_baseRuleId::110';
const String _ruleNotSoSilentAssaultId = '$_baseRuleId::120';
const String _ruleCommandoTroupeId = '$_baseRuleId::130';
const String _ruleWhoDaresId = '$_baseRuleId::140';
const String _ruleGilgameshTroupeId = '$_baseRuleId::150';
const String _ruleTheDevineBrotherId = '$_baseRuleId::160';
const String _ruleTheBrothersFriendsId = '$_baseRuleId::170';

/*
  CAF - Combined Armiger Force
  Utopia uses automatons to multiply their force’s limited human numbers. Over
  time Kogland and Steelgate have developed impressive synergy on the battlefield
  using human piloted armigers to lead N-KIDUs. Each N-KIDU develops a pseudopersonality
  that helps scientists on Utopia decide which task they would be best
  suited for. Stealthy personalities go into Commando Troupes while Support N-KIDUs
  usually have a penchant for excessive force.
  * Veteran Leaders: You may purchase the Vet trait for any commander in the
  force without counting against the veteran limitations.
  * Allies: You may select models from the CEF, Caprice or Eden (pick one) for
  secondary units.
  * Combined Arms: You may select one of the below for each combat group.
  Commando Troupe, Recce Troupe, Support Troupe or Gilgamesh Troupe.
  Each set of rules applies to one combat group. You may select the same Troupe type
  to be used for more than one combat group.
  Recce Troupe:
  * Quiet Death: Recce Armigers may purchase the React+ trait for 1 TV each.
  * Silent Assault: Recce N-KIDUs may increase their EW skill by one for 1 TV each.
  Support Troupe:
  * Wrath of the Demigods: Each Support Armiger may upgrade their MRP with
  both the Precise trait and the Guided trait for 1 TV total.
  * Not So Silent Assault: Support N-KIDUs may increase their GU skill by one for
  1 TV each.
  Commando Troupe:
  * Who Dares: Commando Armigers may add +1 action for 2 TV each.
  Gilgamesh Troupe:
  * The Divine Brother: This combat group must use a Gilgamesh. The Gilgamesh
  must be the force leader.
  * The Brother’s Friends: The Gilgamesh may spend 1 CP to issue a special order
  that removes the Conscript trait from all N-KIDUs within any one combat group
  during their activation.
*/

class CAF extends Utopia {
  CAF(super.data)
      : super(
          name: 'Combined Armiger Force',
          subFactionRules: [
            north.ruleVeteranLeaders,
            ruleAllies,
            ruleCombinedArms,
            ruleRecceTroupe,
            ruleSupportTroupe,
            ruleCommandoTroupe,
            ruleGilgameshTroupe,
          ],
        );
}

final FactionRule ruleAllies = FactionRule(
  name: 'Allies',
  id: _ruleAlliesId,
  options: [
    _ruleAllyCEF,
    _ruleAllyCaprice,
    _ruleAllyEden,
  ],
  description: 'You may select models from the CEF, Caprice or' +
      ' Eden to place into your secondary units.',
);

final FactionRule _ruleAllyCEF = FactionRule(
  name: 'CEF',
  id: _ruleAlliesCEFId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: FactionRule.thereCanBeOnlyOne([
    _ruleAlliesCapriceId,
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
  unitFilter: () => const SpecialUnitFilter(
      text: 'Allies: CEF',
      filters: [UnitFilter(FactionType.CEF)],
      id: _ruleAlliesCEFId),
  description: 'You may select models from the CEF to place into your' +
      ' secondary units.',
);

final FactionRule _ruleAllyCaprice = FactionRule(
  name: 'Caprice',
  id: _ruleAlliesCapriceId,
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

    if (unit.faction == FactionType.Caprice) {
      return false;
    }

    return null;
  },
  unitFilter: () => const SpecialUnitFilter(
      text: 'Allies: Caprice',
      filters: [UnitFilter(FactionType.Caprice)],
      id: _ruleAlliesCapriceId),
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
    _ruleAlliesCapriceId,
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
  unitFilter: () => const SpecialUnitFilter(
      text: 'Allies: Eden',
      filters: [UnitFilter(FactionType.Eden)],
      id: _ruleAlliesEdenId),
  description: 'You may select models from the Eden to place into your' +
      ' secondary units.',
);

final FactionRule ruleCombinedArms = FactionRule(
  name: 'Combined Arms',
  id: _ruleCombinedArmsId,
  description: 'You may select one of the below for each combat group.\n' +
      'Commando Troupe, Recce Troupe, Support Troupe or Gilgamesh Troupe.',
);

final FactionRule ruleRecceTroupe = FactionRule(
  name: 'Recce Troupe',
  id: _ruleRecceTroupeId,
  options: [ruleQuietDeath, ruleSilentAssault],
  cgCheck: onlyOnePerCG(_getTroupeRuleIds(_ruleRecceTroupeId)),
  combatGroupOption: () => _ruleRecceTroupeCGOption,
  description: 'Quiet Death: Recce Armigers may purchase the React+ trait for' +
      ' 1 TV each.\n' +
      'Silent Assault: Recce N-KIDUs may increase their EW skill by one for 1' +
      ' TV each.',
);

final _ruleRecceTroupeCGOption = ruleRecceTroupe.buidCombatGroupOption();

final FactionRule ruleQuietDeath = FactionRule(
  name: 'Quiet Death',
  id: _ruleQuietDeathId,
  cgCheck: (_, ur) => _ruleRecceTroupeCGOption.isEnabled,
  combatGroupOption: () => ruleQuietDeath.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleRecceTroupeCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleRecceTroupeCGOption.isEnabled,
  ),
  factionMods: (ur, cg, u) => [UtopiaMods.quietDeath()],
  description: 'Recce Armigers may purchase the React+ trait for 1 TV each.',
);

final FactionRule ruleSilentAssault = FactionRule(
  name: 'Silent Assault',
  id: _ruleSilentAssaultId,
  cgCheck: (_, ur) => _ruleRecceTroupeCGOption.isEnabled,
  combatGroupOption: () => ruleSilentAssault.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleRecceTroupeCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleRecceTroupeCGOption.isEnabled,
  ),
  factionMods: (ur, cg, u) => [UtopiaMods.silentAssault()],
  description:
      'Recce N-KIDUs may increase their EW skill by one for 1 TV each.',
);

////////////////////
final FactionRule ruleSupportTroupe = FactionRule(
  name: 'Support Troupe',
  id: _ruleSupportTroupeId,
  options: [ruleWrathOfTheDemigods, ruleNotSoSilentAssault],
  cgCheck: onlyOnePerCG(_getTroupeRuleIds(_ruleSupportTroupeId)),
  combatGroupOption: () => _ruleSupportTroupeCGOption,
  description: 'Wrath of the Demigods: Each Support Armiger may upgrade their' +
      ' MRP with both the Precise trait and the Guided trait for 1 TV total.\n' +
      'Not So Silent Assault: Support N-KIDUs may increase their GU skill by' +
      ' one for 1 TV each.',
);

final _ruleSupportTroupeCGOption = ruleSupportTroupe.buidCombatGroupOption();

final FactionRule ruleWrathOfTheDemigods = FactionRule(
  name: 'Wrath of the Demigods',
  id: _ruleWrathOfTheDemigodsId,
  cgCheck: (_, ur) => _ruleSupportTroupeCGOption.isEnabled,
  combatGroupOption: () => ruleWrathOfTheDemigods.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleSupportTroupeCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleSupportTroupeCGOption.isEnabled,
  ),
  factionMods: (ur, cg, u) => [UtopiaMods.wrathOfTheDemigods()],
  description: 'Each Support Armiger may upgrade their MRP with both the' +
      ' Precise trait and the Guided trait for 1 TV total.',
);

final FactionRule ruleNotSoSilentAssault = FactionRule(
  name: 'Not So Silent Assault',
  id: _ruleNotSoSilentAssaultId,
  cgCheck: (_, ur) => _ruleSupportTroupeCGOption.isEnabled,
  combatGroupOption: () => ruleNotSoSilentAssault.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleSupportTroupeCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleSupportTroupeCGOption.isEnabled,
  ),
  factionMods: (ur, cg, u) => [UtopiaMods.notSoSilentAssault()],
  description:
      'Support N-KIDUs may increase their GU skill by one for 1 TV each.',
);

////////////////////
final FactionRule ruleCommandoTroupe = FactionRule(
  name: 'Commando Troupe',
  id: _ruleCommandoTroupeId,
  options: [ruleWhoDares],
  cgCheck: onlyOnePerCG(_getTroupeRuleIds(_ruleCommandoTroupeId)),
  combatGroupOption: () => _ruleCommandoTroupeCGOption,
  description: 'Who Dares: Commando Armigers may add +1 action for 2 TV each.',
);

final _ruleCommandoTroupeCGOption = ruleCommandoTroupe.buidCombatGroupOption();

final FactionRule ruleWhoDares = FactionRule(
  name: 'Who Dares',
  id: _ruleWhoDaresId,
  cgCheck: (_, ur) => _ruleCommandoTroupeCGOption.isEnabled,
  combatGroupOption: () => ruleWhoDares.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleCommandoTroupeCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleCommandoTroupeCGOption.isEnabled,
  ),
  factionMods: (ur, cg, u) => [UtopiaMods.whoDares()],
  description: 'Commando Armigers may add +1 action for 2 TV each.',
);

////////////////////
final FactionRule ruleGilgameshTroupe = FactionRule(
  name: 'Gilgamesh Troupe',
  id: _ruleGilgameshTroupeId,
  options: [_ruleTheDivineBrother, _ruleTheBrothersFriends],
  cgCheck: (cg, ur) {
    final onePerCGcheck =
        onlyOnePerCG(_getTroupeRuleIds(_ruleGilgameshTroupeId))(cg, ur);
    final onlyOne = onlyOneCG(_ruleGilgameshTroupeId)(cg, ur);
    return onePerCGcheck && onlyOne;
  },
  combatGroupOption: () => _ruleGilgameshTroupeCGOption,
  description: 'The Divine Brother: This combat group must use a Gilgamesh.' +
      ' The Gilgamesh must be the force leader.\n' +
      'The Brother’s Friends: The Gilgamesh may spend 1 CP to issue a special' +
      ' order that removes the Conscript trait from all N-KIDUs within any' +
      ' one combat group during their activation.',
);

final _ruleGilgameshTroupeCGOption =
    ruleGilgameshTroupe.buidCombatGroupOption();

final FactionRule _ruleTheDivineBrother = FactionRule(
  name: 'The Divine Brother',
  id: _ruleTheDevineBrotherId,
  cgCheck: (_, ur) => _ruleGilgameshTroupeCGOption.isEnabled,
  combatGroupOption: () => _ruleTheDivineBrother.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleGilgameshTroupeCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleGilgameshTroupeCGOption.isEnabled,
  ),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.role() != RoleType.FS) {
      return false;
    }
    return unit.core.frame.contains('Gilgamesh');
  },
  description: 'The Divine Brother: This combat group must use a Gilgamesh.' +
      ' The Gilgamesh must be the force leader.',
);

final FactionRule _ruleTheBrothersFriends = FactionRule(
  name: 'The Brother’s Friends',
  id: _ruleTheBrothersFriendsId,
  cgCheck: (_, ur) => _ruleGilgameshTroupeCGOption.isEnabled,
  combatGroupOption: () => _ruleTheBrothersFriends.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleGilgameshTroupeCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleGilgameshTroupeCGOption.isEnabled,
  ),
  description: 'The Gilgamesh may spend 1 CP to issue a special order that' +
      ' removes the Conscript trait from all N-KIDUs within any one combat' +
      ' group during their activation.',
);

/// Get a list of the Troupe rule Ids excluding the one passed in as [id].
List<String> _getTroupeRuleIds(String id) {
  final ids = [
    _ruleRecceTroupeId,
    _ruleSupportTroupeId,
    _ruleCommandoTroupeId,
    _ruleGilgameshTroupeId,
  ];

  ids.remove(id);
  return ids;
}
