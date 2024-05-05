import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/rules/rule.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/nucoal/nucoal.dart';
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/rules/south/fha.dart' as fha;
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_core.dart';

const String _baseRuleId = 'rule::nucoal::hapf';
const String _ruleSouthernSurplusId = '$_baseRuleId::10';

/*
  HAPF - Humanist Alliance Protection Force
  In the aftermath of a failed revolt against the Southern Republic, eight percent of the Humanist
  Alliance’s population, including most of its military, migrated to NuCoal. The protector caste of the
  Humanist Alliance boasts a small, powerful and highly advanced armed force.
  * Wrote the Book: Two models per combat group may purchase the Vet trait without counting
  against the veteran limitations.
  * Experts: Veteran Sagittariuses, veteran Fire Dragons and veteran Hetairoi may purchase the
  Stable and/or Precise duelist upgrades, without having to be duelists.
  * Southern Surplus: This force may include models from the South in GP, SK, FS and RC units,
  except for King Cobras and Drakes.
*/
class HAPF extends NuCoal {
  HAPF(super.data)
      : super(
          name: 'Humanist Alliance Protection Force',
          subFactionRules: [
            fha.ruleWroteTheBook,
            fha.ruleExperts,
            ruleSouthernSurplus,
          ],
        );
}

final Rule ruleSouthernSurplus = Rule(
  name: 'Southern Surplus',
  id: _ruleSouthernSurplusId,
  hasGroupRole: (unit, target, group) {
    if (unit.faction != FactionType.South) {
      return null;
    }

    if (target == RoleType.FT || target == RoleType.SO) {
      return false;
    }
    return null;
  },
  unitFilter: (cgOptions) => const SpecialUnitFilter(
      text: 'Southern Surplus',
      filters: [
        UnitFilter(
          FactionType.South,
          matcher: _matchSouthernSurplus,
        ),
      ],
      id: _ruleSouthernSurplusId),
  description: 'This force may include models from the South in GP, SK, FS' +
      ' and RC units, except for King Cobras and Drakes.',
);

/// Match for models for the Souther Surplus rule.
bool _matchSouthernSurplus(UnitCore uc) {
  final frame = uc.frame;
  return frame != 'King Cobra' && frame != 'Drake';
}
