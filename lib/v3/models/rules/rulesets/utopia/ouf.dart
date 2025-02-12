import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/combatGroups/group.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/caprice.dart'
    as caprice_nods;
import 'package:gearforce/v3/models/mods/factionUpgrades/cef.dart' as cef_mods;
import 'package:gearforce/v3/models/mods/factionUpgrades/utopia.dart';
import 'package:gearforce/v3/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/rules/rulesets/north/north.dart' as north;
import 'package:gearforce/v3/models/rules/options/combat_group_options.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/rules/rulesets/utopia/utopia.dart';
import 'package:gearforce/v3/models/validation/validations.dart';

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
    if (group.groupType == GroupType.secondary) {
      return null;
    }

    if (unit.faction == FactionType.cef) {
      // handle CEF gears used by NAI Experiements
      if (!matchOnlyGears(unit.core)) {
        return const Validation(
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
      filters: [UnitFilter(FactionType.cef)],
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
    if (group.groupType == GroupType.secondary) {
      return null;
    }

    if (unit.faction == FactionType.blackTalon) {
      return const Validation(
        false,
        issue: 'Black Talon units may only be added to a secondary group; See' +
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
    if (group.groupType == GroupType.secondary) {
      return null;
    }

    if (unit.faction == FactionType.caprice) {
      return const Validation(
        false,
        issue: 'Caprice units may only be added to a secondary group; See' +
            ' Allies rule.',
      );
    }

    return null;
  },
  modCheckOverride: (u, cg, {required modID}) {
    if (modID == caprice_nods.cyberneticUpgradesId &&
        u.group?.groupType == GroupType.primary) {
      return false;
    }
    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Caprice',
      filters: [
        UnitFilter(FactionType.caprice),
        UnitFilter(
          FactionType.universal,
          matcher: matchInfantry,
          factionOverride: FactionType.caprice,
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
    if (group.groupType == GroupType.secondary) {
      return null;
    }

    if (unit.faction == FactionType.eden) {
      return const Validation(
        false,
        issue: 'Eden units may only be added to a secondary group; See' +
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

final Rule ruleNAIExperiements = Rule(
  name: 'NAI Experiements',
  id: _ruleNAIExperimentsId,
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'NAI Experiements',
      id: _ruleNAIExperimentsId,
      filters: [UnitFilter(FactionType.cef, matcher: matchOnlyGears)]),
  factionMods: (ur, cg, u) => [UtopiaMods.naiExperiments()],
  modCheckOverride: (u, cg, {required modID}) {
    if (modID == cef_mods.minveraId ||
        modID == cef_mods.advancedInterfaceNetworkId) {
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
