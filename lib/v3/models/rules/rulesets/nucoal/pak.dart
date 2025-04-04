import 'package:gearforce/v3/data/unit_filter.dart';
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/nucoal.dart';
import 'package:gearforce/v3/models/rules/rulesets/nucoal/nucoal.dart';
import 'package:gearforce/v3/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/v3/models/unit/unit_core.dart';

const String _baseRuleId = 'rule::nucoal::pak';

const String _ruleHoverTankCommanderId = '$_baseRuleId::10';
const String _ruleTankJockeysId = '$_baseRuleId::20';
const String _ruleAlliesId = '$_baseRuleId::30';
const String _ruleAcquiredTechId = '$_baseRuleId::40';
const String _ruleSomethingToProveId = '$_baseRuleId::50';

/*
  PAK - Port Arthur Korps
  The Port Arthur Korps is the CEF remnants of the first failed invasion of Terra Nova. This force is
  led by Colonel Arthur himself. The Korp’s GREL army is the largest contributor to the defense of
  NuCoal. Their equipment is not the top of the line, but the GREL infantry and hover vehicles form a
  very strong core that few are willing to test.
  * Hover Tank Commander: Any commander that is in a vehicle type model may improve its EW
  skill by one, to a maximum of 3+, for 1 TV each.
  * Tank Jockeys: Vehicles with the Agile trait may purchase the following ability for 1 TV each:
  Ignore the movement penalty for traveling through difficult terrain.
  * Allies: This force may include gears from the North and South (may include a mix) in GP, SK, FS
  and RC units. Models that come with the Vet trait on their profile cannot be purchased. However,
  the Vet trait may be purchased for models that do not come with it.
  * Acquired Tech: This force may also select the following models from the CEF model list: F6-16s,
  LHT-67s, 71s, MHT-68s, 72s, 95s, HPC-64s and HC-3As.
  * Something to Prove: GREL infantry may increase their GU skill by one for 1 TV each.
*/
class PAK extends NuCoal {
  PAK(super.data, super.settings)
      : super(
          name: 'Port Arthur Korps',
          factionRules: [
            ruleHumanistTech,
            Rule.from(
              rulePortArthurKorps,
              isEnabled: false,
              requirementCheck: (_) => false,
            )
          ],
          subFactionRules: [
            ruleHoverTankCommander,
            ruleTankJockeys,
            ruleAllies,
            ruleAcquiredTech,
            ruleSomethingToProve,
          ],
        );
}

final Rule ruleHoverTankCommander = Rule(
    name: 'Hover Tank Commander',
    id: _ruleHoverTankCommanderId,
    factionMods: (ur, cg, u) => [NuCoalFactionMods.hoverTankCommander()],
    description: 'Hover Tank Commander: Any commander that is in a vehicle' +
        ' type model may improve its EW skill by one, to a maximum of 3+, for' +
        ' 1 TV each.');

final Rule ruleTankJockeys = Rule(
    name: 'Tank Jockeys',
    id: _ruleTankJockeysId,
    factionMods: (ur, cg, u) => [NuCoalFactionMods.tankJockeys()],
    description: 'Vehicles with the Agile trait may purchase the following' +
        ' ability for 1 TV each: Ignore the movement penalty for traveling' +
        ' through difficult terrain.');

final Rule ruleAllies = Rule(
    name: 'Allies',
    id: _ruleAlliesId,
    hasGroupRole: (unit, target, group) {
      if (!(unit.faction == FactionType.north ||
          unit.faction == FactionType.south)) {
        return null;
      }

      if (target == RoleType.gp ||
          target == RoleType.sk ||
          target == RoleType.fs ||
          target == RoleType.rc) {
        return true;
      }
      return false;
    },
    unitFilter: (cgOptions) => const SpecialUnitFilter(
        text: 'Allies',
        filters: [
          UnitFilter(
            FactionType.north,
            matcher: matchNonVetGears,
          ),
          UnitFilter(
            FactionType.south,
            matcher: matchNonVetGears,
          ),
        ],
        id: _ruleAlliesId),
    description: 'This force may include gears from the North and South (may' +
        ' include a mix) in GP, SK, FS and RC units. Models that come with' +
        ' the Vet trait on their profile cannot be purchased. However, the' +
        ' Vet trait may be purchased for models that do not come with it.');

final Rule ruleAcquiredTech = Rule(
    name: 'Acquired Tech',
    id: _ruleAcquiredTechId,
    unitFilter: (cgOptions) => const SpecialUnitFilter(
        text: 'Acquired Tech',
        filters: [
          UnitFilter(
            FactionType.cef,
            matcher: _matchAcquiredTech,
          ),
        ],
        id: _ruleAcquiredTechId),
    description: 'This force may also select the following models from the' +
        ' CEF model list: F6-16s, LHT-67s, 71s, MHT-68s, 72s, 95s, HPC-64s' +
        ' and HC-3As.');

/// Match for models for the Acquired Tech rule.
bool _matchAcquiredTech(UnitCore uc) {
  return _checkForAcquiredTech(uc.frame);
}

/// Check to see if a particular frame is part of the Acquired Tech rule.
bool _checkForAcquiredTech(String frame) {
  return frame == 'F6-16' ||
      frame == 'LHT-67' ||
      frame == 'LHT-71' ||
      frame == 'MHT-68' ||
      frame == 'MHT-72' ||
      frame == 'MHT-95' ||
      frame == 'HPC-64' ||
      frame == 'HC-3A';
}

final Rule ruleSomethingToProve = Rule(
  name: 'Something to Prove',
  id: _ruleSomethingToProveId,
  factionMods: (ur, cg, u) => [NuCoalFactionMods.somethingToProve()],
  description:
      'GREL infantry may increase their GU skill by one for 1 TV each.',
);
