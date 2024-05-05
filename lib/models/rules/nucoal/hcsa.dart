import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/factionUpgrades/nucoal.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/rules/nucoal/nucoal.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_core.dart';

const String _baseRuleId = 'rule::nucoal::hcsa';

const String _ruleCityStateDetachmentsId = '$_baseRuleId::10';
const String _ruleLancePointId = '$_baseRuleId::20';
const String _ruleFortNeilId = '$_baseRuleId::30';
const String _rulePrinceGableId = '$_baseRuleId::40';
const String _ruleErechAndNinevehId = '$_baseRuleId::50';

const String _ruleAlliesLancePointId = '$_baseRuleId::60';
const String _rulePathfinderId = '$_baseRuleId::70';
const String _ruleGallicManufacturingId = '$_baseRuleId::80';
const String _ruleLicensedManufacturingId = '$_baseRuleId::90';
const String _ruleTestPilotsId = '$_baseRuleId::100';
const String _ruleFastCavalryId = '$_baseRuleId::110';
const String _ruleAlliesPrinceGableId = '$_baseRuleId::120';
const String _ruleEwSpecialistsId = '$_baseRuleId::130';
const String _ruleAlliesErechAndNinevehNorthId = '$_baseRuleId::140';
const String _ruleAlliesErechAndNinevehSouthId = '$_baseRuleId::150';
const String _rulePersonalEquipmentId = '$_baseRuleId::160';
const String _ruleHighOctaneId = '$_baseRuleId::170';
const String _ruleEPexId = '$_baseRuleId::180';

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

final Rule ruleCityStateDetachments = Rule(
  name: 'City-States Detachments',
  id: _ruleCityStateDetachmentsId,
  description: 'Select a city-state from below for each combat group.\n' +
      '\tLance Point, Fort Neil, Prince Gable and/or Erech & Nineveh.',
);

final Rule ruleLancePoint = Rule(
  name: 'Lance Point',
  id: _ruleLancePointId,
  options: [_ruleAlliesLancePoint, _rulePathfinder],
  cgCheck: onlyOnePerCG(_getCityStateRuleIds(_ruleLancePointId)),
  combatGroupOption: () => [ruleLancePoint.buidCombatGroupOption()],
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Lance Point',
      filters: [
        UnitFilter(
          FactionType.South,
          matcher: matchArmor9,
        ),
      ],
      id: _ruleLancePointId),
  description: 'A fast-growing city-state, Lance Point is an oil boom town' +
      ' currently occupied by Southern forces. Time will tell if the presence' +
      ' of these ‘Observers’ will become a permanent feature of the situation' +
      ' in Lance Point.',
);

final Rule _ruleAlliesLancePoint = Rule(
  name: 'Allies',
  id: _ruleAlliesLancePointId,
  description: 'This combat group may include models from the South with an' +
      ' armor of 9 or less.',
);

final Rule _rulePathfinder = Rule(
  name: 'Pathfinder',
  id: _rulePathfinderId,
  description: 'If this combat group is composed entirely of gears, then it' +
      ' may use the recon special deployment option.',
);

final Rule ruleFortNeil = Rule(
  name: 'Fort Neil',
  id: _ruleFortNeilId,
  options: [
    _ruleGallicManufacturing,
    _ruleLicensedManufacturing,
    _ruleTestPilots,
    ruleFastCavalry,
  ],
  cgCheck: onlyOnePerCG(_getCityStateRuleIds(_ruleFortNeilId)),
  combatGroupOption: () => [ruleFortNeil.buidCombatGroupOption()],
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
  unitFilter: (cgOptions) => const SpecialUnitFilter(
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
      id: _ruleFortNeilId),
  veteranCheckOverride: (u, cg) {
    if (cg.isVeteran) {
      return null;
    }

    if (cg.roster?.rulesetNotifer.value == null) {
      return null;
    }
    final vetsNeedingRule = cg.veterans.where((unit) =>
        !cg.roster!.rulesetNotifer.value
            .vetCheck(cg, u, ruleExclusions: [_ruleFortNeilId]) &&
        unit != u);

    if (vetsNeedingRule.length < 2) {
      return true;
    }
    return null;
  },
  factionMods: (ur, cg, u) => [NuCoalFactionMods.fastCavalry()],
  description: 'An industrial hub that has spearheaded many of the new' +
      ' developments of the Gallic series of gears. In addition, the Sampson' +
      ' hover APC was developed by Fort Neil engineers. Formations of' +
      ' Sampsons are common in Fort Neil regiments and the local rally scene.',
);

final Rule _ruleGallicManufacturing = Rule(
  name: 'Gallic Manufacturing',
  id: _ruleGallicManufacturingId,
  description: 'Chasseurs and Chasseur MK2s may be placed in GP, SK, FS or RC' +
      ' units.',
);

final Rule _ruleLicensedManufacturing = Rule(
  name: 'Licensed Manufacturing',
  id: _ruleLicensedManufacturingId,
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

final Rule _ruleTestPilots = Rule(
    name: 'Test Pilots',
    id: _ruleTestPilotsId,
    description: 'Two models in this combat group may purchase the Vet trait' +
        ' without counting against the veteran limitations.');

final Rule ruleFastCavalry = Rule(
  name: 'Fast Cavalry',
  id: _ruleFastCavalryId,
  description: 'Sampsons in this combat group may purchase the Agile trait' +
      ' for 1 TV each.',
);

final Rule rulePrinceGable = Rule(
  name: 'Prince Gable',
  id: _rulePrinceGableId,
  options: [
    _ruleAlliesPrinceGable,
    _ruleEwSpecialist,
    ruleEPex,
  ],
  cgCheck: onlyOnePerCG(_getCityStateRuleIds(_rulePrinceGableId)),
  combatGroupOption: () => [rulePrinceGable.buidCombatGroupOption()],
  factionMods: (ur, cg, u) => [NuCoalFactionMods.e_pex()],
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Allies: Prince Gable',
      filters: [
        UnitFilter(
          FactionType.North,
          matcher: matchArmor9,
        ),
      ],
      id: _rulePrinceGableId),
  veteranModCheck: (u, cg, {required modID}) {
    if (modID != eccmId) {
      return null;
    }
    if (!(u.type == ModelType.Gear ||
        u.type == ModelType.Strider ||
        u.type == ModelType.Vehicle)) {
      return null;
    }

    // Since only 1 model in a combat group can use this, need to check for any
    // other models in the cg that have the vet upgrade eccm and check to see if
    // the only way they can have that upgrade is by use of this rule.
    final unitsWithUpgrade = cg
        .unitsWithMod(eccmId)
        .where((unit) => unit != u)
        .where((unit) => !unit.isVeteran);
    if (unitsWithUpgrade.isEmpty) {
      return true;
    }

    final unitsNeedingThisRule = unitsWithUpgrade.where((unit) {
      final g = unit.group;
      if (g == null) {
        return false;
      }
      final vetModCheckOverrideRules = cg.roster?.rulesetNotifer.value
          .allEnabledRules(cg.options)
          .where((rule) =>
              rule.veteranModCheck != null && rule.id != rulePrinceGable.id);
      if (vetModCheckOverrideRules == null) {
        return false;
      }
      final overrideValues = vetModCheckOverrideRules
          .map((rule) => rule.veteranModCheck!(u, cg, modID: modID))
          .where((result) => result != null);
      if (overrideValues.isNotEmpty) {
        if (overrideValues.any((status) => status == false)) {
          return true;
        }
        return false;
      }
      return true;
    });

    if (unitsNeedingThisRule.isEmpty) {
      return true;
    }

    return null;
  },
  description: 'This is the home to the manufacturer of the Jerboa, Verton' +
      ' Tech, which got its own start as a rally gear company. Because the' +
      ' city’s infrastructure is rather advanced, especially for the' +
      ' Badlands, many refugees and tech companies have made their way to' +
      ' this city-state.',
);

final Rule _ruleAlliesPrinceGable = Rule(
  name: 'Allies',
  id: _ruleAlliesPrinceGableId,
  description: 'This combat group may include models from the North with an' +
      ' armor of 9 or less.',
);

final Rule _ruleEwSpecialist = Rule(
  name: 'EW Specialists',
  id: _ruleEwSpecialistsId,
  description: 'One gear, strider, or vehicle in this combat group may' +
      ' purchase the ECCM veteran upgrade without being a veteran.',
);

final Rule ruleEPex = Rule(
  name: 'E-pex',
  id: _ruleEPexId,
  description: 'One model in this combat group may improve its EW skill by' +
      ' one for 1 TV.',
);

final Rule ruleErechAndNineveh = Rule(
  name: 'Erech & Nineveh',
  id: _ruleErechAndNinevehId,
  options: [
    _ruleAlliesErechAndNinevehNorth,
    _ruleAlliesErechAndNinevehSouth,
    rulePersonalEquipment,
    ruleHighOctane,
  ],
  cgCheck: onlyOnePerCG(_getCityStateRuleIds(_ruleErechAndNinevehId)),
  combatGroupOption: () {
    final mainOption = ruleErechAndNineveh.buidCombatGroupOption();
    final north = _ruleAlliesErechAndNinevehNorth.buidCombatGroupOption(
      canBeToggled: true,
      initialState: false,
      isEnabledOverrideCheck: () {
        if (!mainOption.isEnabled) {
          return false;
        }
        return null;
      },
    );

    final south = _ruleAlliesErechAndNinevehSouth.buidCombatGroupOption(
      canBeToggled: true,
      initialState: false,
      isEnabledOverrideCheck: () {
        if (!mainOption.isEnabled) {
          return false;
        }
        return null;
      },
    );

    return [mainOption, north, south];
  },
  factionMods: (ur, cg, u) => [
    NuCoalFactionMods.personalEquipment(PersonalEquipment.One),
    NuCoalFactionMods.personalEquipment(PersonalEquipment.Two),
    NuCoalFactionMods.highOctane(),
  ],
  veteranModCheck: (u, cg, {required modID}) {
    final mod1 = u.getMod(personalEquipment1Id);
    final mod2 = u.getMod(personalEquipment2Id);
    if (mod1 != null) {
      final selectedVetModName = mod1.options?.selectedOption?.text;
      if (selectedVetModName != null &&
          modID == VeteranModification.vetModId(selectedVetModName) &&
          VeteranModification.isVetMod(selectedVetModName)) {
        return true;
      }
    }

    if (mod2 != null) {
      final selectedVetModName = mod2.options?.selectedOption?.text;
      if (selectedVetModName != null &&
          modID == VeteranModification.vetModId(selectedVetModName) &&
          VeteranModification.isVetMod(selectedVetModName)) {
        return true;
      }
    }

    return null;
  },
  unitFilter: (cgOptions) {
    if (cgOptions == null) {
      return null;
    }
    if (cgOptions.any((o) => o.id == _north.id && o.isEnabled)) {
      return _north;
    }
    if (cgOptions.any((o) => o.id == _south.id && o.isEnabled)) {
      return _south;
    }
    return null;
  },
  description: 'The Twin Cities have vast wealth, enough to host several' +
      ' private military contractors each. When not on active duty, the' +
      ' citizens and soldiers spend a lot of their time participating in' +
      ' races, wagering their fuel allowances and even their lives on the' +
      ' outcomes.',
);

const _north = const SpecialUnitFilter(
    text: 'Allies: E & N North',
    filters: [
      UnitFilter(
        FactionType.North,
        matcher: matchArmor9,
      ),
    ],
    id: _ruleAlliesErechAndNinevehNorthId);

const _south = const SpecialUnitFilter(
    text: 'Allies: E & N South',
    filters: [
      UnitFilter(
        FactionType.South,
        matcher: matchArmor9,
      ),
    ],
    id: _ruleAlliesErechAndNinevehSouthId);

final Rule _ruleAlliesErechAndNinevehNorth = Rule(
  name: '  Allies: North',
  id: _ruleAlliesErechAndNinevehNorthId,
  cgCheck: (cg, ur) {
    if (cg == null) {
      return false;
    }
    final cityStateEnabled =
        cg.options.any((o) => o.id == _ruleErechAndNinevehId && o.isEnabled);
    if (!cityStateEnabled) {
      return false;
    }
    final southEnabled = cg.options
        .any((o) => o.id == _ruleAlliesErechAndNinevehSouthId && o.isEnabled);

    return !southEnabled;
  },
  description: 'This combat group may include models from the North' +
      ' with an armor of 9 or less.',
);

final Rule _ruleAlliesErechAndNinevehSouth = Rule(
  name: '  Allies: South',
  id: _ruleAlliesErechAndNinevehSouthId,
  cgCheck: (cg, ur) {
    if (cg == null) {
      return false;
    }
    final cityStateEnabled =
        cg.options.any((o) => o.id == _ruleErechAndNinevehId && o.isEnabled);
    if (!cityStateEnabled) {
      return false;
    }
    final northEnabled = cg.options
        .any((o) => o.id == _ruleAlliesErechAndNinevehNorthId && o.isEnabled);

    return !northEnabled;
  },
  description: 'This combat group may include models from the South' +
      ' with an armor of 9 or less.',
);

final Rule rulePersonalEquipment = Rule(
  name: 'Personal Equipment',
  id: _rulePersonalEquipmentId,
  description: 'Two models in this combat group may purchase two veteran' +
      ' upgrades each without being veterans.',
);

final Rule ruleHighOctane = Rule(
  name: 'High Octane',
  id: _ruleHighOctaneId,
  description: 'Add +1 to the MR of any veteran gears in this combat group' +
      ' for 1 TV each.',
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
