import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/caprice.dart'
    as capriceMods;
import 'package:gearforce/models/mods/factionUpgrades/cef.dart' as cefMods;
import 'package:gearforce/models/mods/factionUpgrades/utopia.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/rules/rule.dart';
import 'package:gearforce/models/rules/rulesets/north/north.dart' as north;
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/rules/rulesets/utopia/utopia.dart';
import 'package:gearforce/models/validation/validations.dart';

const String _baseRuleId = 'rule::utopia::ouf';
const String _ruleGreenwayCausticsId = '$_baseRuleId::10';
const String _ruleAlliesId = '$_baseRuleId::20';
const String _ruleAlliesCEFId = '$_baseRuleId::30';
const String _ruleAlliesBlackTalonId = '$_baseRuleId::40';
const String _ruleAlliesCapriceId = '$_baseRuleId::50';
const String _ruleAlliesEdenId = '$_baseRuleId::60';
const String _ruleNAIExperimentsId = '$_baseRuleId::70';
const String _ruleFrankNKiduId = '$_baseRuleId::80';

/*
  OUF – Other Utopian Forces
  Other places on Utopia are not as comfortable under CEF control. The Greenway
  Alliance and the independent states have benefitted the least from military contracts
  and they are becoming more vocal about their discontent. Whispers of revolt are
  sometimes heard but significant actions have yet to be taken.
  * Veteran Leaders: You may purchase the Vet trait for any commander in the
  force without counting against the veteran limitations.
  * Greenway Caustics: Models in one combat group may add the Corrosion trait
  to, and remove the AP trait from, their rocket packs for 0 TV.
  * Allies: You may select models from the CEF, Black Talon, Caprice or Eden (pick
  one) for secondary units.
  * NAI Experiments: This force may include CEF frames regardless of any allies
  chosen. CEF frames may add the Conscript trait for -1 TV. The CEF’s Minerva
  and Advanced Interface Network upgrades cannot be selected. Commanders,
  veterans and duelists may not receive the Conscript trait.
  * Frank-N-KIDU: One N-KIDU per combat group may purchase one veteran or
  duelist upgrade without being a veteran or a duelist.
*/

class OUF extends Utopia {
  OUF(super.data, super.settings)
      : super(
          name: 'Other Utopian Forces',
          subFactionRules: [
            north.ruleVeteranLeaders,
            ruleGreenwayCaustics,
            ruleAllies,
            ruleNAIExperiements,
            ruleFrankNKidu,
          ],
        );
}

final Rule ruleGreenwayCaustics = Rule(
  name: 'Greenway Caustics',
  id: _ruleGreenwayCausticsId,
  cgCheck: onlyOneCG(_ruleGreenwayCausticsId),
  combatGroupOption: () => [ruleGreenwayCaustics.buidCombatGroupOption()],
  factionMods: (ur, cg, u) => [UtopiaMods.greenwayCaustics()],
  description: 'Models in one combat group may add the Corrosion trait' +
      ' to, and remove the AP trait from, their rocket packs for 0 TV.',
);

final Rule ruleAllies = Rule(
  name: 'Allies',
  id: _ruleAlliesId,
  options: [
    _ruleAllyCEF,
    _ruleAllyBlackTalon,
    _ruleAllyCaprice,
    _ruleAllyEden,
  ],
  description: 'You may select models from the CEF, Black Talon, Caprice or' +
      ' Eden (pick one) for secondary units.',
);

final Rule _ruleAllyCEF = Rule(
  name: 'CEF',
  id: _ruleAlliesCEFId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesCapriceId,
    _ruleAlliesBlackTalonId,
    _ruleAlliesEdenId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }

    if (unit.faction == FactionType.CEF) {
      // handle CEF gears used by NAI Experiements
      if (!matchOnlyGears(unit.core)) {
        return Validation(
          false,
          issue: 'CEF units may only be added to a secondary group; See' +
              ' Allies rule.',
        );
      }
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
    _ruleAlliesCapriceId,
    _ruleAlliesEdenId,
  ]),
  canBeAddedToGroup: (unit, group, cg) {
    if (group.groupType == GroupType.Secondary) {
      return null;
    }

    if (unit.faction == FactionType.BlackTalon) {
      return Validation(
        false,
        issue: 'Black Talon units may only be added to a secondary group; See' +
            ' Allies rule.',
      );
    }

    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Black Talon',
      filters: [const UnitFilter(FactionType.BlackTalon)],
      id: _ruleAlliesBlackTalonId),
  description: 'You may select models from the Black Talon to place into your' +
      ' secondary units.',
);

final Rule _ruleAllyCaprice = Rule(
  name: 'Caprice',
  id: _ruleAlliesCapriceId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAlliesCEFId,
    _ruleAlliesBlackTalonId,
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
    if (modID == capriceMods.cyberneticUpgradesId &&
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
    _ruleAlliesBlackTalonId,
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

final Rule ruleNAIExperiements = Rule(
  name: 'NAI Experiements',
  id: _ruleNAIExperimentsId,
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'NAI Experiements',
      id: _ruleNAIExperimentsId,
      filters: const [
        const UnitFilter(FactionType.CEF, matcher: matchOnlyGears)
      ]),
  factionMods: (ur, cg, u) => [UtopiaMods.naiExperiments()],
  modCheckOverride: (u, cg, {required modID}) {
    if (modID == cefMods.minveraId ||
        modID == cefMods.advancedInterfaceNetworkId) {
      return false;
    }
    return null;
  },
  description: 'This force may include CEF frames regardless of any allies' +
      ' chosen. CEF frames may add the Conscript trait for -1 TV. The CEF’s' +
      ' Minerva and Advanced Interface Network upgrades cannot be selected.' +
      ' Commanders, veterans and duelists may not receive the Conscript trait.',
);

final Rule ruleFrankNKidu = Rule(
  name: 'Frank-N-KIDU',
  id: _ruleFrankNKiduId,
  veteranModCheck: (u, cg, {required modID}) {
    if (!u.core.frame.contains('N-KIDU')) {
      return null;
    }
    if (!u.hasMod(frankNKiduId)) {
      return null;
    }
    if (!u.getMods().where((m) => m.id != modID).any((m) =>
        VeteranModification.isVetMod(m.id) ||
        DuelistModification.isDuelistMod(m.id))) {
      return true;
    }

    return null;
  },
  duelistModCheck: (u, cg, {required modID}) {
    if (!u.core.frame.contains('N-KIDU')) {
      return null;
    }
    if (!u.hasMod(frankNKiduId)) {
      return null;
    }
    if (!u.getMods().where((m) => m.id != modID).any((m) =>
        VeteranModification.isVetMod(m.id) ||
        DuelistModification.isDuelistMod(m.id))) {
      return true;
    }
    return null;
  },
  factionMods: (ur, cg, u) => [UtopiaMods.frankNKidu()],
  description: 'One N-KIDU per combat group may purchase one veteran or' +
      ' duelist upgrade without being a veteran or a duelist.',
);
