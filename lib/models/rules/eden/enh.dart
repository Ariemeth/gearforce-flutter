import 'package:gearforce/models/mods/duelist/duelist_modification.dart'
    as duelistMod;
import 'package:gearforce/models/mods/factionUpgrades/eden.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/rules/eden/eden.dart';
import 'package:gearforce/models/rules/faction_rule.dart';

const String _baseRuleId = 'rule::eden::enh';
const String _ruleChampionsId = '$_baseRuleId::10';
const String _ruleIsharaId = '$_baseRuleId::20';
const String _ruleWellSupportedId = '$_baseRuleId::30';
const String _ruleAssertionId = '$_baseRuleId::40';

/*
  ENH - Edenite Noble Houses
  “Protect the innocent, shield thy lord, honor thine ancestors.” - Code Chivalei, Chapter 1,
  Verse 4. While the CEF invasion was successful, they suffered unexpected losses at the
  hands of some noble houses. Of note, the Fasaim Knights were never truly defeated. They
  merely yielded for the sake of Edenites everywhere.
  * Champions: This force may include one duelist per combat group. This force cannot
  use the Independent Operator rule for duelists.
  * Ishara: Golems may have their melee weapon upgraded to a halberd for +1 TV each.
  The halberd is a MVB (React, Reach:1). Models with a halberd gain the Brawl:1 trait
  or add +1 to their existing Brawl:X trait if they have it.
  * Well Supported: One model per combat group may select one veteran upgrade
  without being a veteran.
  * Assertion: This force may select one flag objective regardless of its unit composition.
  Select any remaining objectives normally.
*/
class ENH extends Eden {
  ENH(super.data)
      : super(
          name: 'Edenite Noble Houses',
          subFactionRules: [
            ruleChampions,
            ruleIshara,
            ruleWellSupported,
            ruleAssertion,
          ],
        );
}

final Rule ruleChampions = Rule(
  name: 'Champions',
  id: _ruleChampionsId,
  duelistModCheck: (u, cg, {required modID}) {
    if (modID == duelistMod.independentOperatorId) {
      return false;
    }
    return null;
  },
  duelistMaxNumberOverride: (roster, cg, u) {
    final numOtherDuelist = cg.duelists.where((unit) => unit != u).length;

    if (numOtherDuelist == 0) {
      return roster.duelistCount + 1;
    }

    return null;
  },
  description: 'This force may include one duelist per combat group. This' +
      ' force cannot use the Independent Operator rule for duelists.',
);

final Rule ruleIshara = Rule(
  name: 'Ishara',
  id: _ruleIsharaId,
  factionMods: (ur, cg, u) => [EdenMods.ishara(u)],
  description: 'Golems may have their melee weapon upgraded to a halberd for' +
      ' +1 TV each. The halberd is a MVB (React, Reach:1). Models with a' +
      ' halberd gain the Brawl:1 trait or add +1 to their existing Brawl:X' +
      ' trait if they have it.',
);

final Rule ruleWellSupported = Rule(
  name: 'Well Supported',
  id: _ruleWellSupportedId,
  veteranModCheck: (u, cg, {required modID}) {
    final mod = u.getMod(wellSupportedId);
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
  factionMods: (ur, cg, u) => [EdenMods.wellSupported()],
  description: 'One model per combat group may select one veteran upgrade' +
      ' without being a veteran.',
);

final Rule ruleAssertion = Rule(
  name: 'Assertion',
  id: _ruleAssertionId,
  description: 'This force may select one flag objective regardless of its' +
      ' unit composition. Select any remaining objectives normally.',
);
