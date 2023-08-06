import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/nucoal.dart';
import 'package:gearforce/models/rules/north/umf.dart' as umf;
import 'package:gearforce/models/rules/nucoal/nucoal.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/rules/peace_river/peace_river.dart'
    as peaceRiver;
import 'package:gearforce/models/rules/south/fha.dart' as fha;
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_core.dart';

const String _baseRuleId = 'rule::hcsa';

const String _ruleCityStateDetachmentsId = '$_baseRuleId::10';
const String _ruleLancePointId = '$_baseRuleId::20';
const String _ruleFortNeilId = '$_baseRuleId::30';
const String _rulePrinceGableId = '$_baseRuleId::40';
const String _ruleErechAndNinevehId = '$_baseRuleId::50';

const String _ruleAlliesLancePointId = '$_baseRuleId::60';
const String _rulePathfinderId = '$_baseRuleId::70';
const String _ruleGallicManufacturingId = '$_baseRuleId::80';
const String _ruleLicensedManufacturingId = '$_baseRuleId::90';
const String _ruleFastCavalryId = '$_baseRuleId::100';
const String _ruleAlliesPrinceGableId = '$_baseRuleId::110';
const String _ruleAlliesErechAndNinevehId = '$_baseRuleId::120';
const String _rulePersonalEquipmentId = '$_baseRuleId::130';
const String _ruleHighOctaneId = '$_baseRuleId::140';

/*
  HCSA - Hardscrabble City-State Armies
  The NuCoal city-states each have a standing army for self defense. Individually, they are all hard
  pressed to field enough of a fighting force for any kind of major operation. But they are well practiced
  at combining their powers to support larger military actions in support of NuCoal’s interests.
  All HCSA forces have the following upgrade options:
  * City-States Detachments: Select a city-state from below for each combat group.
  Lance Point, Fort Neil, Prince Gable and/or Erech & Nineveh.
  Each set of rules applies to one combat group. You may select the same city-state to be used for
  more than one combat group.
  Lance Point: A fast-growing city-state, Lance Point is an oil boom town currently occupied by
  Southern forces. Time will tell if the presence of these ‘Observers’ will become a permanent feature
  of the situation in Lance Point.
  * Allies: This combat group may include models from the South with an armor of 9 or less.
  * Pathfinder: If this combat group is composed entirely of gears, then it may use the recon special
  deployment option.
  Fort Neil: An industrial hub that has spearheaded many of the new developments of the Gallic series
  of gears. In addition, the Sampson hover APC was developed by Fort Neil engineers. Formations of
  Sampsons are common in Fort Neil regiments and the local rally scene.
  * Gallic Manufacturing: Chasseurs and Chasseur MK2s may be placed in GP, SK, FS or RC units.
  * Licensed Manufacturing: This combat group may include Sidewinders from the South, and
  Ferrets from the North.
  * Test Pilots: Two models in this combat group may purchase the Vet trait without counting
  against the veteran limitations.
  * Fast Cavalry: Sampsons in this combat group may purchase the Agile trait for 1 TV each.
  Prince Gable: This is the home to the manufacturer of the Jerboa, Verton Tech, which got its own
  start as a rally gear company. Because the city’s infrastructure is rather advanced, especially for the
  Badlands, many refugees and tech companies have made their way to this city-state.
  * Allies: This combat group may include models from the North with an armor of 9 or less.
  * EW Specialists: One gear, strider, or vehicle in this combat group may purchase the ECCM
  veteran upgrade without being a veteran.
  * E-pex: One model in this combat group may improve its EW skill by one for 1 TV.
  Erech & Nineveh: The Twin Cities have vast wealth, enough to host several private military contractors
  each. When not on active duty, the citizens and soldiers spend a lot of their time participating in
  races, wagering their fuel allowances and even their lives on the outcomes.
  * Allies: This combat group may include models from the North or South (pick one) with an
  armor of 9 or less.
  * Personal Equipment: Two models in this combat group may purchase two veteran upgrades
  each without being veterans.
  * High Octane: Add +1 to the MR of any veteran gears in this combat group for 1 TV each.
*/
class HCSA extends NuCoal {
  HCSA(super.data)
      : super(
          name: 'Hardscrabble City-State Armies',
          subFactionRules: [
            ruleCityStateDetachments,
            ruleLancePoint,
            ruleFortNeil,
            rulePrinceGable,
            ruleErechAndNineveh,
          ],
        );
}

final FactionRule ruleCityStateDetachments = FactionRule(
  name: 'City-States Detachments',
  id: _ruleCityStateDetachmentsId,
  description: 'Select a city-state from below for each combat group.\n' +
      '\tLance Point, Fort Neil, Prince Gable and/or Erech & Nineveh.',
);

final FactionRule ruleLancePoint = FactionRule(
  name: 'Lance Point',
  id: _ruleLancePointId,
  options: [_ruleAlliesLancePoint, _rulePathfinder],
  cgCheck: onlyOnePerCG(_getCityStateRuleIds(_ruleLancePointId)),
  combatGroupOption: () => _ruleLancePointCGOption,
  description: 'A fast-growing city-state, Lance Point is an oil boom town' +
      ' currently occupied by Southern forces. Time will tell if the presence' +
      ' of these ‘Observers’ will become a permanent feature of the situation' +
      ' in Lance Point.',
);

final _ruleLancePointCGOption = ruleLancePoint.buidCombatGroupOption();

final FactionRule _ruleAlliesLancePoint = FactionRule(
  name: 'Allies',
  id: _ruleAlliesLancePointId,
  cgCheck: (_, ur) => _ruleLancePointCGOption.isEnabled,
  combatGroupOption: () => _ruleAlliesLancePoint.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleLancePointCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleLancePointCGOption.isEnabled,
  ),
  unitFilter: () => const SpecialUnitFilter(
      text: 'Allies: Lance Point',
      filters: [
        UnitFilter(
          FactionType.South,
          matcher: matchArmor9,
        ),
      ],
      id: _ruleAlliesLancePointId),
  description: 'This combat group may include models from the South with an' +
      ' armor of 9 or less.',
);

final FactionRule _rulePathfinder = FactionRule(
  name: 'Pathfinder',
  id: _rulePathfinderId,
  cgCheck: (_, ur) => _ruleLancePointCGOption.isEnabled,
  combatGroupOption: () => _rulePathfinder.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleLancePointCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleLancePointCGOption.isEnabled,
  ),
  description: 'If this combat group is composed entirely of gears, then it' +
      ' may use the recon special deployment option.',
);

final FactionRule ruleFortNeil = FactionRule(
  name: 'Fort Neil',
  id: _ruleFortNeilId,
  options: [
    _ruleGallicManufacturing,
    _ruleLicensedManufacturing,
    _ruleTestPilots,
    _ruleFastCavalry,
  ],
  cgCheck: onlyOnePerCG(_getCityStateRuleIds(_ruleFortNeilId)),
  combatGroupOption: () => _ruleFortNeilCGOption,
  description: 'An industrial hub that has spearheaded many of the new' +
      ' developments of the Gallic series of gears. In addition, the Sampson' +
      ' hover APC was developed by Fort Neil engineers. Formations of' +
      ' Sampsons are common in Fort Neil regiments and the local rally scene.',
);
final _ruleFortNeilCGOption = ruleFortNeil.buidCombatGroupOption();

final FactionRule _ruleGallicManufacturing = FactionRule(
  name: 'Gallic Manufacturing',
  id: _ruleGallicManufacturingId,
  cgCheck: (_, ur) => _ruleFortNeilCGOption.isEnabled,
  combatGroupOption: () => _ruleGallicManufacturing.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleFortNeilCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleFortNeilCGOption.isEnabled,
  ),
  hasGroupRole: (unit, target, group) {
    final frame = unit.core.frame;
    if (!(frame == 'Chasseur' || frame == 'Chasseur Mk2')) {
      return null;
    }
    if (target == RoleType.GP ||
        target == RoleType.SK ||
        target == RoleType.FS ||
        target == RoleType.RC) {
      return true;
    }
    return null;
  },
  description: 'Chasseurs and Chasseur MK2s may be placed in GP, SK, FS or RC' +
      ' units.',
);

final FactionRule _ruleLicensedManufacturing = FactionRule(
  name: 'Licensed Manufacturing',
  id: _ruleLicensedManufacturingId,
  cgCheck: (_, ur) => _ruleFortNeilCGOption.isEnabled,
  combatGroupOption: () => _ruleLicensedManufacturing.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleFortNeilCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleFortNeilCGOption.isEnabled,
  ),
  unitFilter: () => const SpecialUnitFilter(
      text: 'Licensed Manufacturing',
      filters: [
        UnitFilter(
          FactionType.North,
          matcher: _matchFerrets,
        ),
        UnitFilter(
          FactionType.South,
          matcher: _matchSidewinders,
        ),
      ],
      id: _ruleLicensedManufacturingId),
  description: 'This combat group may include Sidewinders from the South, and' +
      ' Ferrets from the North.',
);

/// Match units only if they have the Ferret frame.
bool _matchFerrets(UnitCore uc) {
  return uc.frame == 'Ferret';
}

/// Match units only if they have the Sidewinder frame.
bool _matchSidewinders(UnitCore uc) {
  return uc.frame == 'Sidewinder';
}

final FactionRule _ruleTestPilots = FactionRule.from(
  fha.ruleWroteTheBook,
  name: 'Test Pilots',
  cgCheck: (_, ur) => _ruleFortNeilCGOption.isEnabled,
  combatGroupOption: () => _ruleTestPilots.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleFortNeilCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleFortNeilCGOption.isEnabled,
  ),
);

final FactionRule _ruleFastCavalry = FactionRule(
  name: 'Fast Cavalry',
  id: _ruleFastCavalryId,
  cgCheck: (_, ur) => _ruleFortNeilCGOption.isEnabled,
  combatGroupOption: () => _ruleFastCavalry.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleFortNeilCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleFortNeilCGOption.isEnabled,
  ),
  factionMod: (ur, cg, u) => NuCoalFactionMods.fastCavalry(),
  description: 'Sampsons in this combat group may purchase the Agile trait' +
      ' for 1 TV each.',
);

final FactionRule rulePrinceGable = FactionRule(
  name: 'Prince Gable',
  id: _rulePrinceGableId,
  options: [
    _ruleAlliesPrinceGable,
    _ruleEwSpecialist,
    _ruleEPex,
  ],
  cgCheck: onlyOnePerCG(_getCityStateRuleIds(_rulePrinceGableId)),
  combatGroupOption: () => _rulePrinceGableCGOption,
  description: 'This is the home to the manufacturer of the Jerboa, Verton' +
      ' Tech, which got its own start as a rally gear company. Because the' +
      ' city’s infrastructure is rather advanced, especially for the' +
      ' Badlands, many refugees and tech companies have made their way to' +
      ' this city-state.',
);
final _rulePrinceGableCGOption = rulePrinceGable.buidCombatGroupOption();

// TODO Implement _ruleAlliesPrinceGable
final FactionRule _ruleAlliesPrinceGable = FactionRule(
  name: 'Allies',
  id: _ruleAlliesPrinceGableId,
  cgCheck: (_, ur) => _rulePrinceGableCGOption.isEnabled,
  combatGroupOption: () => _ruleAlliesPrinceGable.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _rulePrinceGableCGOption.isEnabled,
    isEnabledOverrideCheck: () => _rulePrinceGableCGOption.isEnabled,
  ),
  description: '',
);

final FactionRule _ruleEwSpecialist = FactionRule.from(
  umf.ruleEWSpecialist,
  cgCheck: (_, ur) => _rulePrinceGableCGOption.isEnabled,
  combatGroupOption: () => _ruleEwSpecialist.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _rulePrinceGableCGOption.isEnabled,
    isEnabledOverrideCheck: () => _rulePrinceGableCGOption.isEnabled,
  ),
);

final FactionRule _ruleEPex = FactionRule.from(
  peaceRiver.ruleEPex,
  cgCheck: (_, ur) => _rulePrinceGableCGOption.isEnabled,
  combatGroupOption: () => _ruleEPex.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _rulePrinceGableCGOption.isEnabled,
    isEnabledOverrideCheck: () => _rulePrinceGableCGOption.isEnabled,
  ),
);

final FactionRule ruleErechAndNineveh = FactionRule(
  name: 'Erech & Nineveh',
  id: _ruleErechAndNinevehId,
  options: [
    _ruleAlliesErechAndNineveh,
    _rulePersonalEquipment,
    _ruleHighOctane,
  ],
  cgCheck: onlyOnePerCG(_getCityStateRuleIds(_ruleErechAndNinevehId)),
  combatGroupOption: () => _ruleErechAndNinevehCGOption,
  description: 'The Twin Cities have vast wealth, enough to host several' +
      ' private military contractors each. When not on active duty, the' +
      ' citizens and soldiers spend a lot of their time participating in' +
      ' races, wagering their fuel allowances and even their lives on the' +
      ' outcomes.',
);
final _ruleErechAndNinevehCGOption =
    ruleErechAndNineveh.buidCombatGroupOption();

// TODO Implement _ruleAlliesErechAndNineveh
final FactionRule _ruleAlliesErechAndNineveh = FactionRule(
  name: 'Allies',
  id: _ruleAlliesErechAndNinevehId,
  cgCheck: (_, ur) => _ruleErechAndNinevehCGOption.isEnabled,
  combatGroupOption: () => _ruleAlliesErechAndNineveh.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleErechAndNinevehCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleErechAndNinevehCGOption.isEnabled,
  ),
  description: '',
);

// TODO Implement _rulePersonalEquipment
final FactionRule _rulePersonalEquipment = FactionRule(
  name: 'Personal Equipment',
  id: _rulePersonalEquipmentId,
  cgCheck: (_, ur) => _ruleErechAndNinevehCGOption.isEnabled,
  combatGroupOption: () => _rulePersonalEquipment.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleErechAndNinevehCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleErechAndNinevehCGOption.isEnabled,
  ),
  description: '',
);

// TODO Implement _ruleHighOctane
final FactionRule _ruleHighOctane = FactionRule(
  name: 'High Octane',
  id: _ruleHighOctaneId,
  cgCheck: (_, ur) => _ruleErechAndNinevehCGOption.isEnabled,
  combatGroupOption: () => _ruleHighOctane.buidCombatGroupOption(
    canBeToggled: false,
    initialState: _ruleErechAndNinevehCGOption.isEnabled,
    isEnabledOverrideCheck: () => _ruleErechAndNinevehCGOption.isEnabled,
  ),
  description: '',
);

/// Get a list of the City State rule Ids excluding the point passed in as [id].
List<String> _getCityStateRuleIds(String id) {
  final ids = [
    _ruleLancePointId,
    _ruleFortNeilId,
    _rulePrinceGableId,
    _ruleErechAndNinevehId,
  ];

  ids.remove(id);
  return ids;
}
