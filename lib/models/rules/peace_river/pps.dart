import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/rules/options/combat_group_options.dart';
import 'package:gearforce/models/rules/peace_river/peace_river.dart';
import 'package:gearforce/models/rules/peace_river/poc.dart' as poc;
import 'package:gearforce/models/rules/peace_river/prdf.dart' as prdf;
import 'package:gearforce/models/rules/options/special_unit_filter.dart';
import 'package:gearforce/models/validation/validations.dart';

const String _exPOC = 'Ex-POC';
const String _exPRDF = 'Ex-PRDF';
const String _baseRuleId = 'rule::peaceriver::pps';

const String _ruleSubContractorsName = 'Sub-Contractors';
const String _ruleSubContractorsId = '$_baseRuleId::10';
const String _badlandsSoupName = 'Badland\'s Soup';
const String _ruleBadlandsSoupId = '$_baseRuleId::20';
const String _ruleExPRDFId = '$_baseRuleId::30';
const String _ruleExPOCId = '$_baseRuleId::40';

/*
PPS - Paxton Private Securities
The Paxton Private Securities LLC offers private contractors at a good rate. After all, if
you can’t afford your own army made with the best of Paxton’s offerings, maybe you
can rent their forces at competitive rates instead. While held in reserve for the highest
bidder, discounts are available during times of peace to ensure they stay well practiced.
* Ex-PRDF: Choose any one upgrade option from the PRDF.
* Ex-POC: Choose any one upgrade option from the POC.
* Badland’s Soup: One combat group may purchase the following veteran upgrades
for their models without being veterans; Improved Gunnery, Dual Guns, Brawler,
Veteran Melee upgrade, or ECCM.
* Sub-Contractors: One combat group may be made with models from North,
South, Peace River, and NuCoal (may include a mix from all four factions) that
have an armor of 8 or lower.
*/
class PPS extends PeaceRiver {
  PPS(super.data)
      : super(
          name: 'Paxton Private Securities',
          subFactionRules: [
            ruleExPRDF,
            ruleExPOC,
            ruleBadlandsSoup,
            ruleSubContractors,
          ],
        );
}

const filterSubContractor = SpecialUnitFilter(
  text: _ruleSubContractorsName,
  id: _ruleSubContractorsId,
  filters: [
    const UnitFilter(FactionType.North, matcher: matchArmor8),
    const UnitFilter(FactionType.South, matcher: matchArmor8),
    const UnitFilter(FactionType.PeaceRiver, matcher: matchArmor8),
    const UnitFilter(FactionType.NuCoal, matcher: matchArmor8),
  ],
);

final ruleExPRDF = FactionRule(
    name: _exPRDF,
    id: _ruleExPRDFId,
    description: 'Choose any one rule from the PRDF.',
    options: [
      FactionRule.from(
        prdf.ruleOlTrusty,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            prdf.ruleThunderFromTheSky.id,
            prdf.ruleHighTech.id,
            prdf.ruleBestMenAndWomen.id,
            prdf.ruleEliteElements.id,
            prdf.ruleGhostStrike.id,
          ],
        ),
      ),
      FactionRule.from(
        prdf.ruleThunderFromTheSky,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            prdf.ruleOlTrusty.id,
            prdf.ruleHighTech.id,
            prdf.ruleBestMenAndWomen.id,
            prdf.ruleEliteElements.id,
            prdf.ruleGhostStrike.id,
          ],
        ),
      ),
      FactionRule.from(
        prdf.ruleHighTech,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            prdf.ruleOlTrusty.id,
            prdf.ruleThunderFromTheSky.id,
            prdf.ruleBestMenAndWomen.id,
            prdf.ruleEliteElements.id,
            prdf.ruleGhostStrike.id,
          ],
        ),
      ),
      FactionRule.from(
        prdf.ruleBestMenAndWomen,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            prdf.ruleOlTrusty.id,
            prdf.ruleThunderFromTheSky.id,
            prdf.ruleHighTech.id,
            prdf.ruleEliteElements.id,
            prdf.ruleGhostStrike.id,
          ],
        ),
      ),
      FactionRule.from(
        prdf.ruleEliteElements,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            prdf.ruleOlTrusty.id,
            prdf.ruleThunderFromTheSky.id,
            prdf.ruleHighTech.id,
            prdf.ruleBestMenAndWomen.id,
            prdf.ruleGhostStrike.id,
          ],
        ),
      ),
      FactionRule.from(
        prdf.ruleGhostStrike,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            prdf.ruleOlTrusty.id,
            prdf.ruleThunderFromTheSky.id,
            prdf.ruleHighTech.id,
            prdf.ruleBestMenAndWomen.id,
            prdf.ruleEliteElements.id,
          ],
        ),
      ),
    ]);

final ruleExPOC = FactionRule(
    name: _exPOC,
    id: _ruleExPOCId,
    description: 'Choose any one rule from the POC.',
    options: [
      FactionRule.from(
        poc.ruleSpecialIssue,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            poc.ruleECMSpecialist.id,
            poc.rulePOCOlTrusty.id,
            poc.rulePeaceOfficer.id,
            poc.ruleGSwatSniper.id,
            poc.ruleMercenaryContract.id,
          ],
        ),
      ),
      FactionRule.from(
        poc.ruleECMSpecialist,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            poc.ruleSpecialIssue.id,
            poc.rulePOCOlTrusty.id,
            poc.rulePeaceOfficer.id,
            poc.ruleGSwatSniper.id,
            poc.ruleMercenaryContract.id,
          ],
        ),
      ),
      FactionRule.from(
        poc.rulePOCOlTrusty,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            poc.ruleSpecialIssue.id,
            poc.ruleECMSpecialist.id,
            poc.rulePeaceOfficer.id,
            poc.ruleGSwatSniper.id,
            poc.ruleMercenaryContract.id,
          ],
        ),
      ),
      FactionRule.from(
        poc.rulePeaceOfficer,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            poc.ruleSpecialIssue.id,
            poc.ruleECMSpecialist.id,
            poc.rulePOCOlTrusty.id,
            poc.ruleGSwatSniper.id,
            poc.ruleMercenaryContract.id,
          ],
        ),
      ),
      FactionRule.from(
        poc.ruleGSwatSniper,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            poc.ruleSpecialIssue.id,
            poc.ruleECMSpecialist.id,
            poc.rulePOCOlTrusty.id,
            poc.rulePeaceOfficer.id,
            poc.ruleMercenaryContract.id,
          ],
        ),
      ),
      FactionRule.from(
        poc.ruleMercenaryContract,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            poc.ruleSpecialIssue.id,
            poc.ruleECMSpecialist.id,
            poc.rulePOCOlTrusty.id,
            poc.rulePeaceOfficer.id,
            poc.ruleGSwatSniper.id,
          ],
        ),
      ),
    ]);

final FactionRule ruleBadlandsSoup = FactionRule(
    name: _badlandsSoupName,
    id: _ruleBadlandsSoupId,
    cgCheck: onlyOneCG(_ruleBadlandsSoupId),
    veteranModCheck: (u, cg, {required modID}) {
      switch (modID) {
        case improvedGunneryID:
        case dualGunsId:
        case brawler1Id:
        case brawler2Id:
        case meleeUpgradeId:
        case eccmId:
          return true;
      }

      return null;
    },
    combatGroupOption: () => [ruleBadlandsSoup.buidCombatGroupOption()],
    description:
        'One combat group may purchase the following veteran upgrades for their models without being veterans; Improved Gunnery, Dual Guns, Brawler, Veteran Melee upgrade, or ECCM.');

final FactionRule ruleSubContractors = FactionRule(
    name: _ruleSubContractorsName,
    id: _ruleSubContractorsId,
    cgCheck: onlyOneCG(_ruleSubContractorsId),
    canBeAddedToGroup: (unit, group, cg) {
      final canBeAdded =
          unit.armor == null || (unit.armor != null && unit.armor! <= 8);
      return Validation(
        canBeAdded,
        issue: 'Must have an armor value of 8 or lower; See Sub Contractors' +
            ' rule.',
      );
    },
    combatGroupOption: () => [ruleSubContractors.buidCombatGroupOption()],
    unitFilter: (cgOptions) => filterSubContractor,
    description:
        'One combat group may be made with models from North, South, Peace River, and NuCoal (may include a mix from all four factions) that have an armor of 8 or lower.');
