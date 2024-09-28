import 'package:gearforce/v3/models/mods/factionUpgrades/eden.dart';
import 'package:gearforce/v3/models/rules/rulesets/eden/aef.dart' as aef;
import 'package:gearforce/v3/models/rules/rulesets/eden/eden.dart';
import 'package:gearforce/v3/models/rules/rulesets/eden/enh.dart' as enh;
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/rules/rulesets/north/north.dart' as north;

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
  EIF(super.data, super.settings)
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

final Rule ruleImproviso = Rule(
  name: 'Improviso',
  id: _ruleImprovisoId,
  options: [
    Rule.from(
      enh.ruleChampions,
      isEnabled: false,
      canBeToggled: true,
      requirementCheck: Rule.thereCanBeOnlyOne(
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
    Rule.from(enh.ruleIshara,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: Rule.thereCanBeOnlyOne(
          [
            enh.ruleChampions.id,
            enh.ruleWellSupported.id,
            enh.ruleAssertion.id,
            aef.ruleSelfMade.id,
            aef.ruleWaterBorn.id,
            aef.ruleFreeblade.id,
          ],
        )),
    Rule.from(enh.ruleWellSupported,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: Rule.thereCanBeOnlyOne(
          [
            enh.ruleChampions.id,
            enh.ruleIshara.id,
            enh.ruleAssertion.id,
            aef.ruleSelfMade.id,
            aef.ruleWaterBorn.id,
            aef.ruleFreeblade.id,
          ],
        )),
    Rule.from(enh.ruleAssertion,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: Rule.thereCanBeOnlyOne(
          [
            enh.ruleChampions.id,
            enh.ruleIshara.id,
            enh.ruleWellSupported.id,
            aef.ruleSelfMade.id,
            aef.ruleWaterBorn.id,
            aef.ruleFreeblade.id,
          ],
        )),
    Rule.from(aef.ruleSelfMade,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: Rule.thereCanBeOnlyOne(
          [
            enh.ruleChampions.id,
            enh.ruleIshara.id,
            enh.ruleWellSupported.id,
            enh.ruleAssertion.id,
            aef.ruleWaterBorn.id,
            aef.ruleFreeblade.id,
          ],
        )),
    Rule.from(aef.ruleWaterBorn,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: Rule.thereCanBeOnlyOne(
          [
            enh.ruleChampions.id,
            enh.ruleIshara.id,
            enh.ruleWellSupported.id,
            enh.ruleAssertion.id,
            aef.ruleSelfMade.id,
            aef.ruleFreeblade.id,
          ],
        )),
    Rule.from(aef.ruleFreeblade,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: Rule.thereCanBeOnlyOne(
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

final Rule ruleExpertMarksmen = Rule(
  name: 'Expert Marksmen',
  id: _ruleExpertMarksmenId,
  factionMods: (ur, cg, u) => [EdenMods.expertMarksmen()],
  description:
      'Each golem with a rifle may increase their GU skill by one for 1 TV.',
);

final Rule ruleEquity = Rule(
  name: 'Equity',
  id: _ruleEquityId,
  description: 'This force may select one capture objective regardless of its' +
      ' unit composition. Select any remaining objectives normally.',
);
