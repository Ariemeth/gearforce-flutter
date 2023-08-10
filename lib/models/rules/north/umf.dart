import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/north.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/rules/peace_river/poc.dart' as poc;
import 'package:gearforce/models/rules/north/north.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/role.dart';

const String _baseRuleId = 'rule::north::umf';
const String _ruleLocalManufacturingId = '$_baseRuleId::10';
const String _ruleEWSpecialistId = '$_baseRuleId::20';
const String _ruleWellFundedId = '$_baseRuleId::30';

/*
UMF – United Mercantile Federation
Known as being the richest League on Terra Nova, the merchants of the UMF know
that in order to defend their prosperity they must have strong armed forces. As
such, they spend lavishly for the best soldiers and equipment. To maintain their edge
commercially the UMF is not against leveraging its considerable skill in electronic
warfare to gain business advantages.
* Local Manufacturing: Tigers and Weasels may be placed in GP, SK, FS, RC or
SO units. Tiger variants are not limited to 1-2 models of that variant and may be
selected an unlimited number of times.
* EW Specialists: One gear, strider, or vehicle per combat group may purchase
the ECCM veteran upgrade without being a veteran.
* Well Funded: Two models in each combat group may purchase one veteran
upgrade without making them veterans.
* Mercenary Contract: One combat group may be made with models from North,
South, Peace River, and NuCoal (may include a mix from all four factions) that
have an armor of 8 or lower.
*/
class UMF extends North {
  UMF(super.data)
      : super(
          name: 'United Mercantile Federation',
          subFactionRules: [
            ruleLocalManufacturing,
            ruleEWSpecialist,
            ruleWellFunded,
            poc.ruleMercenaryContract,
          ],
        );
}

final FactionRule ruleLocalManufacturing = FactionRule(
  name: 'Local Manufacturing',
  id: _ruleLocalManufacturingId,
  hasGroupRole: (unit, target, group) {
    final isAllowedUnit =
        unit.core.frame == 'Tiger' || unit.core.frame == 'Weasel';
    final isAllowedRole = target == RoleType.GP ||
        target == RoleType.SK ||
        target == RoleType.FS ||
        target == RoleType.RC ||
        target == RoleType.SO;

    return isAllowedUnit && isAllowedRole ? true : null;
  },
  isRoleTypeUnlimited: (unit, target, group, roster) {
    return unit.core.frame == 'Tiger' ? true : null;
  },
  description: 'Tigers and Weasels may be placed in GP, SK, FS, RC or SO' +
      ' units. Tiger variants are not limited to 1-2 models of that variant' +
      ' and may be selected an unlimited number of times.',
);

final FactionRule ruleEWSpecialist = FactionRule(
  name: 'EW Specialists',
  id: _ruleEWSpecialistId,
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
              rule.veteranModCheck != null && rule.id != ruleEWSpecialist.id);
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
  description: 'One gear, strider, or vehicle per combat group may purchase' +
      ' the ECCM veteran upgrade without being a veteran.',
);

final FactionRule ruleWellFunded = FactionRule(
  name: 'Well Funded',
  id: _ruleWellFundedId,
  veteranModCheck: (u, cg, {required modID}) {
    final mod = u.getMod(wellFundedID);
    if (mod == null) {
      return null;
    }

    final selectedVetModName = mod.options?.selectedOption?.text;
    if (selectedVetModName == null ||
        !VeteranModification.isVetMod(selectedVetModName)) {
      return null;
    }

    if (modID == VeteranModification.vetModId(selectedVetModName)) {
      return true;
    }

    return null;
  },
  factionMods: (ur, cg, u) => [NorthernFactionMods.wellFunded()],
  description: 'Two models in each combat group may purchase one veteran' +
      ' upgrade without making them veterans.',
);
