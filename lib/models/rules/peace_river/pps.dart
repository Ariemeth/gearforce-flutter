import 'package:gearforce/data/unit_filter.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/combat_group_options.dart';
import 'package:gearforce/models/rules/peace_river/peace_river.dart';
import 'package:gearforce/models/rules/peace_river/poc.dart';
import 'package:gearforce/models/rules/peace_river/prdf.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/special_unit_filter.dart';
import 'package:gearforce/models/unit/unit.dart';

const String _subContractors = 'Sub-Contractors';
const String _ppsFullName = 'Paxton Private Securities';
const String _badlandsSoup = 'Badland’s Soup';

/*
  Sub-Contractors: One combat group may be made with models from North,
  South, Peace River, and NuCoal (may include a mix from all four factions) that
  have an armor of 8 or lower.
*/
const PPSSubContractors = SpecialUnitFilter(
  text: _subContractors,
  filters: [
    const UnitFilter(FactionType.North, matcher: matchArmor8),
    const UnitFilter(FactionType.South, matcher: matchArmor8),
    const UnitFilter(FactionType.PeaceRiver, matcher: matchArmor8),
    const UnitFilter(FactionType.NuCoal, matcher: matchArmor8),
  ],
);

/*
PPS - Paxton Private Securities
The Paxton Private Securities LLC offers private contractors at a good rate. After all, if
you can’t afford your own army made with the best of Paxton’s offerings, maybe you
can rent their forces at competitive rates instead. While held in reserve for the highest
bidder, discounts are available during times of peace to ensure they stay well practiced.
Z Ex-PRDF: Choose any one upgrade option from the PRDF.
Z Ex-POC: Choose any one upgrade option from the POC.
* Badland’s Soup: One combat group may purchase the following veteran upgrades
for their models without being veterans; Improved Gunnery, Dual Guns, Brawler,
Veteran Melee upgrade, or ECCM.
* Sub-Contractors: One combat group may be made with models from North,
South, Peace River, and NuCoal (may include a mix from all four factions) that
have an armor of 8 or lower.
*/
class PPS extends PeaceRiver {
  PPS(super.data);

  final List<FactionRule> _rules = [
    FactionRule(
        name: 'Ex-PRDF',
        id: 'rule::pps::exPRDF',
        description: 'Choose any one upgrade option from the PRDF.',
        options: [
          FactionRule.from(
            ruleOlTrusty,
            isEnabled: false,
            canBeToggled: true,
            requirementCheck: FactionRule.thereCanBeOnlyOne(
              [
                ruleThunderFromTheSky.id,
                ruleHighTech.id,
                ruleBestMenAndWomen.id,
                ruleEliteElements.id,
                ruleGhostStrike.id,
              ],
            ),
          ),
          FactionRule.from(
            ruleThunderFromTheSky,
            isEnabled: false,
            canBeToggled: true,
            requirementCheck: FactionRule.thereCanBeOnlyOne(
              [
                ruleOlTrusty.id,
                ruleHighTech.id,
                ruleBestMenAndWomen.id,
                ruleEliteElements.id,
                ruleGhostStrike.id,
              ],
            ),
          ),
          FactionRule.from(
            ruleHighTech,
            isEnabled: false,
            canBeToggled: true,
            requirementCheck: FactionRule.thereCanBeOnlyOne(
              [
                ruleOlTrusty.id,
                ruleThunderFromTheSky.id,
                ruleBestMenAndWomen.id,
                ruleEliteElements.id,
                ruleGhostStrike.id,
              ],
            ),
          ),
          FactionRule.from(
            ruleBestMenAndWomen,
            isEnabled: false,
            canBeToggled: true,
            requirementCheck: FactionRule.thereCanBeOnlyOne(
              [
                ruleOlTrusty.id,
                ruleThunderFromTheSky.id,
                ruleHighTech.id,
                ruleEliteElements.id,
                ruleGhostStrike.id,
              ],
            ),
          ),
          FactionRule.from(
            ruleEliteElements,
            isEnabled: false,
            canBeToggled: true,
            requirementCheck: FactionRule.thereCanBeOnlyOne(
              [
                ruleOlTrusty.id,
                ruleThunderFromTheSky.id,
                ruleHighTech.id,
                ruleBestMenAndWomen.id,
                ruleGhostStrike.id,
              ],
            ),
          ),
          FactionRule.from(
            ruleGhostStrike,
            isEnabled: false,
            canBeToggled: true,
            requirementCheck: FactionRule.thereCanBeOnlyOne(
              [
                ruleOlTrusty.id,
                ruleThunderFromTheSky.id,
                ruleHighTech.id,
                ruleBestMenAndWomen.id,
                ruleEliteElements.id,
              ],
            ),
          ),
        ]),
    FactionRule(
        name: 'Ex-POC',
        id: 'rule::pps::exPOC',
        description: 'Choose any one upgrade option from the POC.',
        options: [
          FactionRule.from(
            ruleSpecialIssue,
            isEnabled: false,
            canBeToggled: true,
            requirementCheck: FactionRule.thereCanBeOnlyOne(
              [
                ruleECMSpecialist.id,
                rulePOCOlTrusty.id,
                rulePeaceOfficer.id,
                ruleGSwatSniper.id,
                ruleMercenaryContract.id,
              ],
            ),
          ),
          FactionRule.from(
            ruleECMSpecialist,
            isEnabled: false,
            canBeToggled: true,
            requirementCheck: FactionRule.thereCanBeOnlyOne(
              [
                ruleSpecialIssue.id,
                rulePOCOlTrusty.id,
                rulePeaceOfficer.id,
                ruleGSwatSniper.id,
                ruleMercenaryContract.id,
              ],
            ),
          ),
          FactionRule.from(
            rulePOCOlTrusty,
            isEnabled: false,
            canBeToggled: true,
            requirementCheck: FactionRule.thereCanBeOnlyOne(
              [
                ruleSpecialIssue.id,
                ruleECMSpecialist.id,
                rulePeaceOfficer.id,
                ruleGSwatSniper.id,
                ruleMercenaryContract.id,
              ],
            ),
          ),
          FactionRule.from(
            rulePeaceOfficer,
            isEnabled: false,
            canBeToggled: true,
            requirementCheck: FactionRule.thereCanBeOnlyOne(
              [
                ruleSpecialIssue.id,
                ruleECMSpecialist.id,
                rulePOCOlTrusty.id,
                ruleGSwatSniper.id,
                ruleMercenaryContract.id,
              ],
            ),
          ),
          FactionRule.from(
            ruleGSwatSniper,
            isEnabled: false,
            canBeToggled: true,
            requirementCheck: FactionRule.thereCanBeOnlyOne(
              [
                ruleSpecialIssue.id,
                ruleECMSpecialist.id,
                rulePOCOlTrusty.id,
                rulePeaceOfficer.id,
                ruleMercenaryContract.id,
              ],
            ),
          ),
          FactionRule.from(
            ruleMercenaryContract,
            isEnabled: false,
            canBeToggled: true,
            requirementCheck: FactionRule.thereCanBeOnlyOne(
              [
                ruleSpecialIssue.id,
                ruleECMSpecialist.id,
                rulePOCOlTrusty.id,
                rulePeaceOfficer.id,
                ruleGSwatSniper.id,
              ],
            ),
          ),
        ]),
    FactionRule(
        name: 'Badland\'s Soup',
        id: 'rule::pps::badlandSoup',
        description:
            'One combat group may purchase the following veteran upgrades for their models without being veterans; Improved Gunnery, Dual Guns, Brawler, Veteran Melee upgrade, or ECCM.'),
    FactionRule(
        name: 'Sub-Contractors',
        id: 'rule::pps::subContractors',
        description:
            'One combat group may be made with models from North, South, Peace River, and NuCoal (may include a mix from all four factions) that have an armor of 8 or lower.'),
  ];
  @override
  bool isRuleEnabled(String ruleName) {
    return FactionRule.isRuleEnabled(_rules, ruleName);
  }

  @override
  List<FactionModification> availableFactionMods(
      UnitRoster ur, CombatGroup cg, Unit u) {
    return super.availableFactionMods(ur, cg, u);
  }

  @override
  List<FactionRule> availableSubFactionUpgrades() {
    return _rules;
  }

  @override
  bool canBeAddedToGroup(Unit unit, Group group, CombatGroup cg) {
    // core unit into a core combatgroup
    if (unit.hasTag(tagCore) && !cg.hasTag(_subContractors)) {
      return super.canBeAddedToGroup(unit, group, cg);
    }

    if (unit.hasTag(_subContractors) && cg.hasTag(_subContractors)) {
      return super.canBeAddedToGroup(unit, group, cg);
    }

    return false;
  }

  @override
  bool veteranModCheck(
    Unit u,
    CombatGroup cg, {
    required String modID,
  }) {
    /*
      Badland’s Soup: One combat group may purchase the following veteran upgrades
      for their models without being veterans; Improved Gunnery, Dual Guns, Brawler,
      Veteran Melee upgrade, or ECCM.
    */
    if (cg.hasTag(_badlandsSoup)) {
      switch (modID) {
        case improvedGunneryID:
        case dualGunsId:
        case brawl1Id:
        case brawler2Id:
        case meleeUpgradeId:
        case eccmId:
          return true;
      }
    }

    return super.veteranModCheck(u, cg, modID: modID);
  }

  @override
  List<SpecialUnitFilter> availableUnitFilters() {
    return super.availableUnitFilters()
      ..addAll(
        [
          PPSSubContractors,
        ],
      );
  }

  @override
  CombatGroupOption combatGroupSettings() {
    return CombatGroupOption(name: '$_ppsFullName options', options: [
      Option(
        name: _subContractors,
        requirementCheck: onlyOneCG(_subContractors),
      ),
      Option(
        name: _badlandsSoup,
        requirementCheck: onlyOneCG(_badlandsSoup),
      )
    ]);
  }
}
