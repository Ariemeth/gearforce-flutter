import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/rules/rulesets/nucoal/hapf.dart';
import 'package:gearforce/v3/models/rules/rulesets/nucoal/hcsa.dart';
import 'package:gearforce/v3/models/rules/rulesets/nucoal/kada.dart';
import 'package:gearforce/v3/models/rules/rulesets/nucoal/nsdf.dart';
import 'package:gearforce/v3/models/rules/rulesets/nucoal/pak.dart';
import 'package:gearforce/v3/models/rules/rulesets/nucoal/th.dart';
import 'package:gearforce/v3/models/rules/options/combat_group_options.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/v3/models/unit/unit_core.dart';
import 'package:gearforce/widgets/settings.dart';

const String _baseRuleId = 'rule::nucoal::core';

const String _ruleHumanistTechId = '$_baseRuleId::10';
const String _rulePortArthurKorpsId = '$_baseRuleId::20';

/*
  All the models in the NuCoal Model List can be used in any of the sub-lists below. There are also models in the Universal
  Model List that may be selected as well.
  All NuCoal forces have the following rules:
  * Humanist Tech: Hetairoi, Fire Dragons or Sagittariuses from the South may be used in FS units.
  * Port Arthur Korps:
  f HPC-64s and F6-16s from the CEF model list may be used in GP or SK units.
  f LHT-67s and 71s from the CEF may be used in RC or FS units.
*/
class NuCoal extends RuleSet {
  NuCoal(
    DataV3 data,
    Settings settings, {
    String? description,
    required String name,
    List<String>? specialRules,
    List<Rule>? factionRules,
    List<Rule> subFactionRules = const [],
  }) : super(
          FactionType.nuCoal,
          data,
          settings: settings,
          name: name,
          description: description,
          factionRules: factionRules ?? [ruleHumanistTech, rulePortArthurKorps],
          subFactionRules: subFactionRules,
        );

  @override
  List<SpecialUnitFilter> availableUnitFilters(
    List<CombatGroupOption>? cgOptions,
  ) {
    final filters = [
      SpecialUnitFilter(
        text: type.name,
        id: coreTag,
        filters: const [
          UnitFilter(FactionType.nuCoal),
          UnitFilter(FactionType.airstrike),
          UnitFilter(FactionType.universal),
          UnitFilter(FactionType.universalTerraNova),
          UnitFilter(FactionType.terrain),
        ],
      ),
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory NuCoal.nsdf(DataV3 data, Settings settings) => NSDF(data, settings);
  factory NuCoal.pak(DataV3 data, Settings settings) => PAK(data, settings);
  factory NuCoal.hapf(DataV3 data, Settings settings) => HAPF(data, settings);
  factory NuCoal.kada(DataV3 data, Settings settings) => KADA(data, settings);
  factory NuCoal.th(DataV3 data, Settings settings) => TH(data, settings);
  factory NuCoal.hcsa(DataV3 data, Settings settings) => HCSA(data, settings);
}

final Rule ruleHumanistTech = Rule(
  name: 'Humanist Tech',
  id: _ruleHumanistTechId,
  hasGroupRole: (unit, target, group) {
    final frame = unit.core.frame;
    if (!(frame == 'Sagittarius' ||
        frame == 'Fire Dragon' ||
        frame == 'Hetairoi')) {
      return null;
    }

    if (target != RoleType.fs) {
      return false;
    }

    return true;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Humanist Tech',
      filters: [
        UnitFilter(
          FactionType.south,
          matcher: _matchHumanistTech,
        ),
      ],
      id: _ruleHumanistTechId),
  description: 'Hetairoi, Fire Dragons or Sagittariuses from the South may' +
      ' be used in FS units.',
);

/// Match Hetairoi, Fire Dragons or Sagittariuses
bool _matchHumanistTech(UnitCore uc) {
  return checkForHumanistTechUnit(uc.frame);
}

bool checkForHumanistTechUnit(String frame) {
  return frame == 'Sagittarius' ||
      frame == 'Fire Dragon' ||
      frame == 'Hetairoi';
}

final Rule rulePortArthurKorps = Rule(
  name: 'Port Arthur Korps',
  id: _rulePortArthurKorpsId,
  hasGroupRole: (unit, target, group) {
    final frame = unit.core.frame;
    if (!_checkForPortArthurKorps(frame)) {
      return null;
    }

    if ((frame == 'HPC-64' || frame == 'F6-16') &&
        (target == RoleType.gp || target == RoleType.sk)) {
      return true;
    }

    if ((frame == 'LHT-67' || frame == 'LHT-71') &&
        (target == RoleType.rc || target == RoleType.fs)) {
      return true;
    }

    return false;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Port Arthur Korps',
      filters: [
        UnitFilter(
          FactionType.cef,
          matcher: _matchPortArthurKorps,
        ),
      ],
      id: _rulePortArthurKorpsId),
  description: 'HPC-64s and F6-16s from the CEF model list may be used in GP' +
      ' or SK units.\n' +
      'LHT-67s and 71s from the CEF may be used in RC or FS units.',
);

/// Match HPC-64s and F6-16s and LHT-67s and 71s
bool _matchPortArthurKorps(UnitCore uc) {
  return _checkForPortArthurKorps(uc.frame);
}

bool _checkForPortArthurKorps(String frame) {
  return frame == 'HPC-64' ||
      frame == 'F6-16' ||
      frame == 'LHT-67' ||
      frame == 'LHT-71';
}
