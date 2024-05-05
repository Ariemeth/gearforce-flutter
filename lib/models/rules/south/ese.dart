import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/rules/rule.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/rules/south/south.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/role.dart';

const String _baseRuleId = 'rule::south::ese';

const String _ruleLocalManufacturingId = '$_baseRuleId::10';
const String _rulePersonalEscortId = '$_baseRuleId::20';
const String _ruleAlliesId = '$_baseRuleId::30';
const String _ruleAllyNorthId = '$_baseRuleId::40';
const String _ruleAllyPeaceRiverId = '$_baseRuleId::50';
const String _ruleAllyNuCoalId = '$_baseRuleId::60';

/*
  ESE - Eastern Sun Emirates
  Perpetually in turmoil, the various Emirates maintain armed forces more to continue
  the bid for overall power than to protect against outside invaders. War in the
  Emirates is an extension of politics and allies one week will turn on each other the
  next. With their need for replacements far outstripping their local supply, the Emirs
  must make deals and purchases from any arms manufacturer who will see them.
  Failure in the Emirates is met with harsh repercussions, but success leads to a life
  of luxury and renown.
  * Local Manufacturing: Iguanas may be placed in GP, SK, FS, RC and SO units.
  * Personal Escort: The force leader’s combat group may include a duelist in
  addition to any other duelist this force may have. This duelist model may be
  chosen from the North, South, Peace River or NuCoal model lists and must
  follow all normal duelist rules.
  * Allies: This force may include models from the North, Peace River or NuCoal
  (pick one). Models that come with the Vet trait on their profile cannot be
  purchased.
*/
class ESE extends South {
  ESE(super.data)
      : super(
          name: 'Eastern Sun Emirates',
          subFactionRules: [
            ruleLocalManufacturing,
            rulePersonalEscort,
            ruleAllies,
          ],
        );
}

final Rule ruleLocalManufacturing = Rule(
  name: 'Local Manufacturing',
  id: _ruleLocalManufacturingId,
  hasGroupRole: (unit, target, group) {
    final isAllowedUnit = unit.core.frame.contains('Iguana');
    final isAllowedRole = target == RoleType.GP ||
        target == RoleType.SK ||
        target == RoleType.FS ||
        target == RoleType.RC ||
        target == RoleType.SO;

    return isAllowedUnit && isAllowedRole ? true : null;
  },
  description: 'Iguanas may be placed in GP, SK, FS, RC and SO units.',
);

final Rule rulePersonalEscort = Rule(
  name: 'Personal Escort',
  id: _rulePersonalEscortId,
  duelistMaxNumberOverride: (roster, cg, u) {
    if (roster.selectedForceLeader == null) {
      return null;
    }

    if (roster.selectedForceLeader!.group?.combatGroup == cg) {
      return 2;
    }

    if (roster.duelists.any((unit) =>
        roster.selectedForceLeader!.group?.combatGroup != null &&
        unit.group?.combatGroup ==
            roster.selectedForceLeader!.group?.combatGroup)) {
      return 2;
    }

    return null;
  },
  // personal escort units cannot have a command greater then the current force leader
  availableCommandLevelOverride: (u) {
    if (_notEnabledAllies().any((f) => u.faction == f)) {
      final forceleaderCL = u.roster?.selectedForceLeader?.commandLevel;

      if (forceleaderCL != null && forceleaderCL >= CommandLevel.cgl) {
        return [CommandLevel.secic, CommandLevel.none];
      }
      return [CommandLevel.none];
    }
    return null;
  },
  isUnitCountWithinLimits: (cg, group, unit) {
    final faction = cg.roster?.factionNotifier.value;
    if (faction == null) {
      return null;
    }
    if (unit.faction == faction.factionType) {
      return null;
    }

    final allyFaction = _enabledAlly();
    if (unit.faction == allyFaction) {
      return null;
    }

    // If the unit is not an ally or primary faction it must be part of the personal escort
    // personal escort units can only be added to the cg with the force leader
    final forceLeadersCG = cg.roster?.selectedForceLeader?.combatGroup;
    if (forceLeadersCG == null || forceLeadersCG != cg) {
      return false;
    }
    // There can also only be 1 unit that is a personal escort
    final numberOfPersonalEscorts = cg.units
        .where(
            (u) => u != unit && _notEnabledAllies().any((f) => u.faction == f))
        .length;

    if (numberOfPersonalEscorts > 0) {
      return false;
    }

    // a non-ally must be a duelist
    final canBeDuelist =
        cg.roster?.rulesetNotifer.value.duelistCheck(cg.roster!, cg, unit);
    if (canBeDuelist != null && !canBeDuelist) {
      return false;
    }

    if (canBeDuelist != null) {
      unit.addUnitMod(DuelistModification.makeDuelist(unit, cg.roster!));
    }

    return null;
  },
  isRoleTypeUnlimited: (unit, target, group, ur) {
    // only 1 unit from the personal escort factions can be added that isn't
    // an ally or the primary faction
    final notSelectedAllyFactions = _notEnabledAllies();
    if (notSelectedAllyFactions.any((f) => f == unit.faction)) {
      return false;
    }
    return null;
  },
  unitFilter: (cgOptions) => personalEscortFilter,
  description: 'The force leader’s combat group may include a duelist in' +
      ' addition to any other duelist this force may have. This duelist model' +
      ' may be chosen from the North, South, Peace River or NuCoal model' +
      ' lists and must follow all normal duelist rules.',
);

const personalEscortFilter = const SpecialUnitFilter(
    text: 'Personal Escort',
    filters: [
      UnitFilter(FactionType.North, matcher: matchPossibleDuelist),
      UnitFilter(FactionType.South, matcher: matchPossibleDuelist),
      UnitFilter(FactionType.PeaceRiver, matcher: matchPossibleDuelist),
      UnitFilter(FactionType.NuCoal, matcher: matchPossibleDuelist),
    ],
    id: _ruleAllyNuCoalId);

final Rule ruleAllies = Rule(
  name: 'Allies',
  id: _ruleAlliesId,
  options: [_allyNorth, _allyPeaceRiver, _allyNuCoal],
  description: 'Allies: This force may include models from the North, Peace' +
      ' River or NuCoal (pick one). Models that come with the Vet trait on' +
      ' their profile cannot be purchased. However, the Vet trait may be' +
      ' purchased for models that do not come with it.',
);

final Rule _allyNorth = Rule(
  name: 'North',
  id: _ruleAllyNorthId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAllyPeaceRiverId,
    _ruleAllyNuCoalId,
  ]),
  combatGroupOption: () => [
    _allyNorth.buidCombatGroupOption(canBeToggled: false, initialState: true)
  ],
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Ally: North',
      filters: [
        UnitFilter(
          FactionType.North,
          matcher: matchNotAVet,
        ),
        ...SouthFilters,
      ],
      id: _ruleAllyNorthId),
  description: 'May include models from the North',
);

final Rule _allyPeaceRiver = Rule(
  name: 'Peace River',
  id: _ruleAllyPeaceRiverId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAllyNorthId,
    _ruleAllyNuCoalId,
  ]),
  combatGroupOption: () => [
    _allyPeaceRiver.buidCombatGroupOption(
      canBeToggled: false,
      initialState: true,
    )
  ],
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Ally: Peace River',
      filters: [
        UnitFilter(
          FactionType.PeaceRiver,
          matcher: matchNotAVet,
        ),
        ...SouthFilters,
      ],
      id: _ruleAllyPeaceRiverId),
  description: 'May include models from Peace River',
);

final Rule _allyNuCoal = Rule(
  name: 'NuCoal',
  id: _ruleAllyNuCoalId,
  isEnabled: false,
  canBeToggled: true,
  requirementCheck: Rule.thereCanBeOnlyOne([
    _ruleAllyNorthId,
    _ruleAllyPeaceRiverId,
  ]),
  combatGroupOption: () => [
    _allyNuCoal.buidCombatGroupOption(canBeToggled: false, initialState: true)
  ],
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Ally: NuCoal',
      filters: [
        UnitFilter(
          FactionType.NuCoal,
          matcher: matchNotAVet,
        ),
        ...SouthFilters,
      ],
      id: _ruleAllyNuCoalId),
  description: 'May include models from NuCoal',
);

FactionType? _enabledAlly() {
  if (_allyNorth.isEnabled) {
    return FactionType.North;
  }
  if (_allyNuCoal.isEnabled) {
    return FactionType.NuCoal;
  }
  if (_allyPeaceRiver.isEnabled) {
    return FactionType.PeaceRiver;
  }
  return null;
}

List<FactionType> _notEnabledAllies() {
  final List<FactionType> results = [];
  if (!_allyNorth.isEnabled) {
    results.add(FactionType.North);
  }
  if (!_allyNuCoal.isEnabled) {
    results.add(FactionType.NuCoal);
  }
  if (!_allyPeaceRiver.isEnabled) {
    results.add(FactionType.PeaceRiver);
  }
  return results;
}
