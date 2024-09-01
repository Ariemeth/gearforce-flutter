import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/caprice.dart' as caprice;
import 'package:gearforce/models/mods/factionUpgrades/utopia.dart';
import 'package:gearforce/models/rules/rule.dart';
import 'package:gearforce/models/rules/rulesets/north/north.dart' as north;
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/rules/rulesets/utopia/utopia.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/validation/validations.dart';

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
  CAF(super.data, super.settings)
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

final Rule ruleAllies = Rule(
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

final Rule _ruleAllyCEF = Rule(
  name: 'CEF',
  id: _ruleAlliesCEFId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
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
      return Validation(
        false,
        issue: 'CEF units may only be added to a secondary group; See Allies' +
            ' rule.',
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

final Rule _ruleAllyCaprice = Rule(
  name: 'Caprice',
  id: _ruleAlliesCapriceId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesCEFId,
    _ruleAlliesEdenId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }

    if (unit.faction == FactionType.Caprice) {
      return Validation(
        false,
        issue: 'Caprice units may only be added to a secondary group; See' +
            ' Allies rule.',
      );
    }

    return null;
  },
  modCheckOverride: (u, cg, {required modID}) {
    if (modID == caprice.cyberneticUpgradesId &&
        u.group?.groupType == GroupType.Primary) {
      return false;
    }
    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Caprice',
      filters: [
        const UnitFilter(FactionType.Caprice),
        const UnitFilter(
          FactionType.Universal,
          matcher: matchInfantry,
          factionOverride: FactionType.Caprice,
        )
      ],
      id: _ruleAlliesCapriceId),
  description: 'You may select models from the Caprice to place into your' +
      ' secondary units.',
);

final Rule _ruleAllyEden = Rule(
  name: 'Eden',
  id: _ruleAlliesEdenId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesCEFId,
    _ruleAlliesCapriceId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }

    if (unit.faction == FactionType.Eden) {
      return Validation(
        false,
        issue: 'Eden units may only be added to a secondary group; See' +
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

final Rule ruleCombinedArms = Rule(
  name: 'Combined Arms',
  id: _ruleCombinedArmsId,
  description: 'You may select one of the below for each combat group.\n' +
      'Commando Troupe, Recce Troupe, Support Troupe or Gilgamesh Troupe.',
);

final Rule ruleRecceTroupe = Rule(
  name: 'Recce Troupe',
  id: _ruleRecceTroupeId,
  options: [ruleQuietDeath, ruleSilentAssault],
  cgCheck: onlyOnePerCG(_getTroupeRuleIds(_ruleRecceTroupeId)),
  combatGroupOption: () => [ruleRecceTroupe.buidCombatGroupOption()],
  factionMods: (ur, cg, u) => [
    UtopiaMods.quietDeath(),
    UtopiaMods.silentAssault(),
  ],
  description: 'Quiet Death: Recce Armigers may purchase the React+ trait for' +
      ' 1 TV each.\n' +
      'Silent Assault: Recce N-KIDUs may increase their EW skill by one for 1' +
      ' TV each.',
);

final Rule ruleQuietDeath = Rule(
  name: 'Quiet Death',
  id: _ruleQuietDeathId,
  description: 'Recce Armigers may purchase the React+ trait for 1 TV each.',
);

final Rule ruleSilentAssault = Rule(
  name: 'Silent Assault',
  id: _ruleSilentAssaultId,
  description:
      'Recce N-KIDUs may increase their EW skill by one for 1 TV each.',
);

////////////////////
final Rule ruleSupportTroupe = Rule(
  name: 'Support Troupe',
  id: _ruleSupportTroupeId,
  options: [ruleWrathOfTheDemigods, ruleNotSoSilentAssault],
  cgCheck: onlyOnePerCG(_getTroupeRuleIds(_ruleSupportTroupeId)),
  combatGroupOption: () => [ruleSupportTroupe.buidCombatGroupOption()],
  factionMods: (ur, cg, u) => [
    UtopiaMods.wrathOfTheDemigods(),
    UtopiaMods.notSoSilentAssault(),
  ],
  description: 'Wrath of the Demigods: Each Support Armiger may upgrade their' +
      ' MRP with both the Precise trait and the Guided trait for 1 TV total.\n' +
      'Not So Silent Assault: Support N-KIDUs may increase their GU skill by' +
      ' one for 1 TV each.',
);

final Rule ruleWrathOfTheDemigods = Rule(
  name: 'Wrath of the Demigods',
  id: _ruleWrathOfTheDemigodsId,
  description: 'Each Support Armiger may upgrade their MRP with both the' +
      ' Precise trait and the Guided trait for 1 TV total.',
);

final Rule ruleNotSoSilentAssault = Rule(
  name: 'Not So Silent Assault',
  id: _ruleNotSoSilentAssaultId,
  description:
      'Support N-KIDUs may increase their GU skill by one for 1 TV each.',
);

////////////////////
final Rule ruleCommandoTroupe = Rule(
  name: 'Commando Troupe',
  id: _ruleCommandoTroupeId,
  options: [ruleWhoDares],
  cgCheck: onlyOnePerCG(_getTroupeRuleIds(_ruleCommandoTroupeId)),
  combatGroupOption: () => [ruleCommandoTroupe.buidCombatGroupOption()],
  factionMods: (ur, cg, u) => [UtopiaMods.whoDares()],
  description: 'Who Dares: Commando Armigers may add +1 action for 2 TV each.',
);

final Rule ruleWhoDares = Rule(
  name: 'Who Dares',
  id: _ruleWhoDaresId,
  description: 'Commando Armigers may add +1 action for 2 TV each.',
);

////////////////////
final Rule ruleGilgameshTroupe = Rule(
  name: 'Gilgamesh Troupe',
  id: _ruleGilgameshTroupeId,
  options: [_ruleTheDivineBrother, _ruleTheBrothersFriends],
  cgCheck: (cg, ur) {
    final onePerCGcheck =
        onlyOnePerCG(_getTroupeRuleIds(_ruleGilgameshTroupeId))(cg, ur);
    final onlyOne = onlyOneCG(_ruleGilgameshTroupeId)(cg, ur);
    return onePerCGcheck && onlyOne;
  },
  combatGroupOption: () => [ruleGilgameshTroupe.buidCombatGroupOption()],
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }
    final isGilgamesh = unit.core.frame.contains('Gilgamesh');
    final isNoActionUnit =
        unit.actions == null || (unit.actions != null && unit.actions == 0);
    if (isGilgamesh || isNoActionUnit) {
      return null;
    }
    return Validation(
      false,
      issue: 'Only a Gilgamesh or units with no actions can be added; See' +
          ' Gilgamesh Troupe rules',
    );
  },
  onForceLeaderChanged: (roster, newleader) {
    // Check if any cg is a Gilgamesh Troupe
    if (!roster
        .getCGs()
        .any((cg) => cg.isOptionEnabled(_ruleGilgameshTroupeId))) {
      return;
    }

    final leadersCG = newleader?.combatGroup;
    if (leadersCG == null) {
      return;
    }
    if (newleader!.core.frame.contains('Gilgamesh') &&
        leadersCG.isOptionEnabled(_ruleGilgameshTroupeId)) {
      return;
    }

    // check if there is a gilgamesh in the gilgamesh troupe cg
    final gilgaCG = roster
        .getCGs()
        .firstWhere((cg) => cg.isOptionEnabled(_ruleGilgameshTroupeId));
    if (!gilgaCG.units.any((u) => u.core.frame.contains('Gilgamesh'))) {
      // No Gilgamesh in the force, ignore this rule
      return;
    }

    // Check if the gilgamesh is an available force leader
    if (roster.availableForceLeaders().any((u) =>
        u.core.frame.contains('Gilgamesh') &&
        u.combatGroup != null &&
        u.combatGroup!.isOptionEnabled(_ruleGilgameshTroupeId))) {
      // The gilgamesh is available as a force leader so select it
      roster.selectedForceLeader = roster.availableForceLeaders().firstWhere(
          (u) =>
              u.core.frame.contains('Gilgamesh') &&
              u.combatGroup != null &&
              u.combatGroup!.isOptionEnabled(_ruleGilgameshTroupeId));
      return;
    }

    // A Gilgamesh exists in a Gilgamesh Troupe CG, is not the force leader and
    // does not have a high enough rank to be a force leader, so increase the
    // command level to make it the force leader.
    final nextCGRank =
        CommandLevel.NextGreater(roster.selectedForceLeader!.commandLevel);
    final gilgas =
        gilgaCG.units.where((u) => u.core.frame.contains('Gilgamesh'));

    var gilga = gilgas.first;
    gilgas.forEach((g) {
      if (g.commandLevel > gilga.commandLevel) {
        gilga = g;
      }
    });
    gilga.commandLevel = nextCGRank;
  },
  onLeadershipChanged: (roster, unit) {
    // make sure this unit is a Gilgamesh component.
    if (!unit.core.frame.contains('Gilgamesh')) {
      return;
    }

    // check if this unit is already the force leader
    if (roster.selectedForceLeader == unit) {
      return;
    }

    // make sure this gilgamesh is in a Gilgamesh Troupe
    final unitsCG = unit.combatGroup;
    if (unitsCG == null) {
      return;
    }
    if (!unitsCG.isOptionEnabled(_ruleGilgameshTroupeId)) {
      return;
    }

    // Check if the gilgamesh is an available force leader
    if (roster.availableForceLeaders().any((u) => u == unit)) {
      // The gilgamesh is available as a force leader so select it
      roster.selectedForceLeader = unit;
      return;
    }

    // A Gilgamesh exists in a Gilgamesh Troupe CG, is not the force leader and
    // does not have a high enough rank to be a force leader, so increase the
    // command level to make it the force leader.
    final nextCGRank =
        CommandLevel.NextGreater(roster.selectedForceLeader!.commandLevel);

    unit.commandLevel = nextCGRank;
  },
  description: 'The Divine Brother: This combat group must use a Gilgamesh.' +
      ' The Gilgamesh must be the force leader.\n' +
      'The Brother’s Friends: The Gilgamesh may spend 1 CP to issue a special' +
      ' order that removes the Conscript trait from all N-KIDUs within any' +
      ' one combat group during their activation.',
);

final Rule _ruleTheDivineBrother = Rule(
  name: 'The Divine Brother',
  id: _ruleTheDevineBrotherId,
  description: 'The Divine Brother: This combat group must use a Gilgamesh.' +
      ' The Gilgamesh must be the force leader.',
);

final Rule _ruleTheBrothersFriends = Rule(
  name: 'The Brother’s Friends',
  id: _ruleTheBrothersFriendsId,
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
