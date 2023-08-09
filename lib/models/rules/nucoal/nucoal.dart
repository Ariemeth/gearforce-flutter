import 'package:gearforce/data/data.dart';
import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/rules/nucoal/hapf.dart';
import 'package:gearforce/models/rules/nucoal/hcsa.dart';
import 'package:gearforce/models/rules/nucoal/kada.dart';
import 'package:gearforce/models/rules/nucoal/nsdf.dart';
import 'package:gearforce/models/rules/nucoal/pak.dart';
import 'package:gearforce/models/rules/nucoal/th.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_core.dart';

const String _baseRuleId = 'rule::nucoal';

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
    Data data, {
    String? description,
    required String name,
    List<String>? specialRules,
    List<FactionRule>? factionRules,
    List<FactionRule> subFactionRules = const [],
  }) : super(
          FactionType.NuCoal,
          data,
          name: name,
          description: description,
          factionRules: factionRules == null
              ? [ruleHumanistTech, rulePortArthurKorps]
              : factionRules,
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
          const UnitFilter(FactionType.NuCoal),
          const UnitFilter(FactionType.Airstrike),
          const UnitFilter(FactionType.Universal),
          const UnitFilter(FactionType.Universal_TerraNova),
          const UnitFilter(FactionType.Terrain),
        ],
      ),
    ];
    return [...filters, ...super.availableUnitFilters(cgOptions)];
  }

  factory NuCoal.NSDF(Data data) => NSDF(data);
  factory NuCoal.PAK(Data data) => PAK(data);
  factory NuCoal.HAPF(Data data) => HAPF(data);
  factory NuCoal.KADA(Data data) => KADA(data);
  factory NuCoal.TH(Data data) => TH(data);
  factory NuCoal.HCSA(Data data) => HCSA(data);
}

final FactionRule ruleHumanistTech = FactionRule(
  name: 'Humanist Tech',
  id: _ruleHumanistTechId,
  hasGroupRole: (unit, target, group) {
    final frame = unit.core.frame;
    if (!(frame == 'Sagittarius' ||
        frame == 'Fire Dragon' ||
        frame == 'Hetairoi')) {
      return null;
    }

    if (target != RoleType.FS) {
      return false;
    }

    return true;
  },
  unitFilter: () => const SpecialUnitFilter(
      text: 'Humanist Tech',
      filters: [
        UnitFilter(
          FactionType.South,
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

final FactionRule rulePortArthurKorps = FactionRule(
  name: 'Port Arthur Korps',
  id: _rulePortArthurKorpsId,
  hasGroupRole: (unit, target, group) {
    final frame = unit.core.frame;
    if (!_checkForPortArthurKorps(frame)) {
      return null;
    }

    if ((frame == 'HPC-64' || frame == 'F6-16') &&
        (target == RoleType.GP || target == RoleType.SK)) {
      return true;
    }

    if ((frame == 'LHT-67' || frame == 'LHT-71') &&
        (target == RoleType.RC || target == RoleType.FS)) {
      return true;
    }

    return false;
  },
  unitFilter: () => const SpecialUnitFilter(
      text: 'Port Arthur Korps',
      filters: [
        UnitFilter(
          FactionType.CEF,
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
