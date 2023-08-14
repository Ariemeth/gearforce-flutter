import 'package:gearforce/models/mods/factionUpgrades/eden.dart';
import 'package:gearforce/models/rules/eden/aef.dart' as aef;
import 'package:gearforce/models/rules/eden/eden.dart';
import 'package:gearforce/models/rules/eden/enh.dart' as enh;
import 'package:gearforce/models/rules/faction_rule.dart';
import 'package:gearforce/models/rules/north/north.dart' as north;

const String _baseRuleId = 'rule::eden::eif';
const String _ruleImprovisoId = '$_baseRuleId::10';
const String _ruleExpertMarksmenId = '$_baseRuleId::20';
const String _ruleEquityId = '$_baseRuleId::30';

/*
  EIF - Edenite Invasion Force
  The Edenite Invasion Force is a mix of feudal households, militias, and militant privateers.
  Nobles from the Seiath Empire hold ultimate leadership. Their motivations seem dubious
  as their tactics frequently place rival nobles from other kingdoms on missions that have a
  low probability for survival. In turn, their field commanders have started doing their best
  to not always follow the plans as given. This ultimately gives the EIF a very random profile
  on which tactics and strategies are selected.
  * Veteran Leaders: You may purchase the Vet trait for any commander in the force
  without counting against the veteran limitations.
  * Improviso: Select one upgrade option from ENH or AEF.
  * Expert Marksmen: Each golem with a rifle may increase their GU skill by one for 1 TV.
  * Equity: This force may select one capture objective
*/
class EIF extends Eden {
  EIF(super.data)
      : super(
          name: 'Edenite Invasion Force',
          subFactionRules: [
            north.ruleVeteranLeaders,
            ruleImproviso,
            ruleExpertMarksmen,
            ruleEquity,
          ],
        );
}

final FactionRule ruleImproviso = FactionRule(
  name: 'Improviso',
  id: _ruleImprovisoId,
  options: [
    FactionRule.from(
      enh.ruleChampions,
      isEnabled: false,
      canBeToggled: true,
      requirementCheck: FactionRule.thereCanBeOnlyOne(
        [
          enh.ruleIshara.id,
          enh.ruleWellSupported.id,
          enh.ruleAssertion.id,
          aef.ruleSelfMade.id,
          aef.ruleWaterBorn.id,
          aef.ruleFreeblade.id,
        ],
      ),
    ),
    FactionRule.from(enh.ruleIshara,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            enh.ruleChampions.id,
            enh.ruleWellSupported.id,
            enh.ruleAssertion.id,
            aef.ruleSelfMade.id,
            aef.ruleWaterBorn.id,
            aef.ruleFreeblade.id,
          ],
        )),
    FactionRule.from(enh.ruleWellSupported,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            enh.ruleChampions.id,
            enh.ruleIshara.id,
            enh.ruleAssertion.id,
            aef.ruleSelfMade.id,
            aef.ruleWaterBorn.id,
            aef.ruleFreeblade.id,
          ],
        )),
    FactionRule.from(enh.ruleAssertion,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            enh.ruleChampions.id,
            enh.ruleIshara.id,
            enh.ruleWellSupported.id,
            aef.ruleSelfMade.id,
            aef.ruleWaterBorn.id,
            aef.ruleFreeblade.id,
          ],
        )),
    FactionRule.from(aef.ruleSelfMade,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            enh.ruleChampions.id,
            enh.ruleIshara.id,
            enh.ruleWellSupported.id,
            enh.ruleAssertion.id,
            aef.ruleWaterBorn.id,
            aef.ruleFreeblade.id,
          ],
        )),
    FactionRule.from(aef.ruleWaterBorn,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            enh.ruleChampions.id,
            enh.ruleIshara.id,
            enh.ruleWellSupported.id,
            enh.ruleAssertion.id,
            aef.ruleSelfMade.id,
            aef.ruleFreeblade.id,
          ],
        )),
    FactionRule.from(aef.ruleFreeblade,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: FactionRule.thereCanBeOnlyOne(
          [
            enh.ruleChampions.id,
            enh.ruleIshara.id,
            enh.ruleWellSupported.id,
            enh.ruleAssertion.id,
            aef.ruleSelfMade.id,
            aef.ruleWaterBorn.id,
          ],
        )),
  ],
  description: 'Select one upgrade option from ENH or AEF.',
);

final FactionRule ruleExpertMarksmen = FactionRule(
  name: 'Expert Marksmen',
  id: _ruleExpertMarksmenId,
  factionMods: (ur, cg, u) => [EdenMods.expertMarksmen()],
  description:
      'Each golem with a rifle may increase their GU skill by one for 1 TV.',
);

final FactionRule ruleEquity = FactionRule(
  name: 'Equity',
  id: _ruleEquityId,
  description: 'This force may select one capture objective regardless of its' +
      ' unit composition. Select any remaining objectives normally.',
);
