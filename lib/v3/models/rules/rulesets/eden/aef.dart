import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/mods/duelist/duelist_modification.dart'
    as duelistMod;
import 'package:gearforce/v3/models/mods/factionUpgrades/eden.dart';
import 'package:gearforce/v3/models/mods/unitUpgrades/universal.dart';
import 'package:gearforce/v3/models/rules/rulesets/eden/eden.dart';
import 'package:gearforce/v3/models/rules/rulesets/eden/eif.dart' as eif;
import 'package:gearforce/v3/models/rules/rulesets/eden/enh.dart' as enh;
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/rules/rulesets/north/north.dart' as north;
import 'package:gearforce/v3/models/unit/model_type.dart';

const String _baseRuleId = 'rule::eden::aef';
const String _ruleImprovisoId = '$_baseRuleId::10';
const String _ruleSelfMadeId = '$_baseRuleId::20';
const String _ruleWaterBornId = '$_baseRuleId::30';
const String _ruleFreebladeId = '$_baseRuleId::40';

/*
  AEF – Ad-Hoc Edenite Force
  Ad-Hoc Edenite Forces represent the many varied types of militias and privateer militant
  forces on Eden. Whether they are privateers performing piracy or even anti-piracy
  operations, or whether they are conscripted militias for major cities, these forces contrast
  dramatically from each other. More than a few are suspected of taking part in resistance
  operations against CEF forces.
  * Improviso: Select one upgrade option from EIF or ENH.
  * Self-Made: Veteran golems may purchase the following duelist upgrades without
  being duelists; Duelist Melee Upgrade, Dual Melee Weapons and Shield.
  * Water-Born: Infantry that receive the Frogmen upgrade also receive a GU of 3+.
  * Freeblade: Constable and Man at Arm Golems may take the Conscript trait for -1 TV.
  Commanders, veterans and duelists may not take this upgrade.
*/
class AEF extends Eden {
  AEF(super.data, super.settings)
      : super(
          name: 'Ad-Hoc Edenite Force',
          subFactionRules: [
            ruleImproviso,
            ruleSelfMade,
            ruleWaterBorn,
            ruleFreeblade,
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
          north.ruleVeteranLeaders.id,
          eif.ruleExpertMarksmen.id,
          eif.ruleEquity.id,
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
            north.ruleVeteranLeaders.id,
            eif.ruleExpertMarksmen.id,
            eif.ruleEquity.id,
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
            north.ruleVeteranLeaders.id,
            eif.ruleExpertMarksmen.id,
            eif.ruleEquity.id,
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
            north.ruleVeteranLeaders.id,
            eif.ruleExpertMarksmen.id,
            eif.ruleEquity.id,
          ],
        )),
    Rule.from(north.ruleVeteranLeaders,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: Rule.thereCanBeOnlyOne(
          [
            enh.ruleChampions.id,
            enh.ruleIshara.id,
            enh.ruleWellSupported.id,
            enh.ruleAssertion.id,
            eif.ruleExpertMarksmen.id,
            eif.ruleEquity.id,
          ],
        )),
    Rule.from(eif.ruleExpertMarksmen,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: Rule.thereCanBeOnlyOne(
          [
            enh.ruleChampions.id,
            enh.ruleIshara.id,
            enh.ruleWellSupported.id,
            enh.ruleAssertion.id,
            north.ruleVeteranLeaders.id,
            eif.ruleEquity.id,
          ],
        )),
    Rule.from(eif.ruleEquity,
        isEnabled: false,
        canBeToggled: true,
        requirementCheck: Rule.thereCanBeOnlyOne(
          [
            enh.ruleChampions.id,
            enh.ruleIshara.id,
            enh.ruleWellSupported.id,
            enh.ruleAssertion.id,
            north.ruleVeteranLeaders.id,
            eif.ruleExpertMarksmen.id,
          ],
        )),
  ],
  description: 'Select one upgrade option from EIF or ENH.',
);

final Rule ruleSelfMade = Rule(
  name: 'Self-Made',
  id: _ruleSelfMadeId,
  duelistModCheck: (u, cg, {required modID}) {
    if (!(modID == duelistMod.meleeUpgradeId ||
        modID == duelistMod.dualMeleeWeaponsId ||
        modID == duelistMod.shieldId)) {
      return null;
    }

    if (u.faction != FactionType.Eden) {
      return null;
    }

    if (u.type != ModelType.Gear) {
      return null;
    }

    if (u.isVeteran) {
      return true;
    }
    return null;
  },
  description: 'Veteran golems may purchase the following duelist upgrades' +
      ' without being duelists; Duelist Melee Upgrade, Dual Melee Weapons' +
      ' and Shield.',
);

final Rule ruleWaterBorn = Rule(
  name: 'Water-Born',
  id: _ruleWaterBornId,
  onModAdded: (unit, modId) {
    if (modId != frogmen.id) {
      return;
    }
    if (unit.type != ModelType.Infantry) {
      return;
    }
    unit.addUnitMod(EdenMods.waterBorn());
  },
  onModRemoved: (unit, modId) {
    if (modId != frogmen.id) {
      return;
    }
    if (unit.type != ModelType.Infantry) {
      return;
    }
    unit.removeUnitMod(waterBornId);
  },
  description:
      'Infantry that receive the Frogmen upgrade also receive a GU of 3+.',
);

final Rule ruleFreeblade = Rule(
  name: 'Freeblade',
  id: _ruleFreebladeId,
  factionMods: (ur, cg, u) => [EdenMods.freeblade()],
  description: 'Constable and Man at Arm Golems may take the Conscript' +
      ' trait for -1 TV. Commanders, veterans and duelists may not take this' +
      ' upgrade.',
);
