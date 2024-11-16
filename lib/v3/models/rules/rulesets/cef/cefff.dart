import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/cef.dart';
import 'package:gearforce/v3/models/mods/veteranUpgrades/veteran_modification.dart'
    as vet_mod;
import 'package:gearforce/v3/models/rules/rulesets/cef/cef.dart';

const String _baseRuleId = 'rule::cef::cefff';
const String _ruleDuelingFramesId = '$_baseRuleId::10';
const String _ruleValkyriesId = '$_baseRuleId::20';
const String _ruleDualLasersId = '$_baseRuleId::30';
const String _ruleEWDuelistsId = '$_baseRuleId::40';

/*
  CEFFF - CEF Frame Formation
  A battle formation of frames screaming across the desert at top speed is a fearsome
  sight. Those few humans who lead squads of battle frames know that casualties are
  acceptable, failure is not.
  * Dueling Frames: You may select two frames in this force to become duelists.
  * Valkyries: Veteran frames in this force with 1 action may upgrade to 2 actions
  for +2 TV each.
  * Dual Lasers: Duelist frames may select the Dual Guns veteran upgrade for laser
  cannons. Remove any TD or Shield traits when this upgrade is chosen.
  * EW Duelists: Each duelist frame may purchase the ECM trait and the Sensors:36
  trait for 1 TV total.
*/
class CEFFF extends CEF {
  CEFFF(super.data, super.settings)
      : super(
          name: 'CEF Frame Formation',
          subFactionRules: [
            ruleDuelingFrames,
            ruleValkyries,
            ruleDualLasers,
            ruleEWDuelists,
          ],
        );
}

final Rule ruleDuelingFrames = Rule(
  name: 'Dueling Frames',
  id: _ruleDuelingFramesId,
  duelistMaxNumberOverride: (roster, cg, u) => 2,
  description: 'You may select two frames in this force to become duelists.',
);

final Rule ruleValkyries = Rule(
  name: 'Valkyries',
  id: _ruleValkyriesId,
  factionMods: (ur, cg, u) => [CEFMods.valkyries()],
  description: 'Veteran frames in this force with 1 action may upgrade to 2' +
      ' actions for +2 TV each.',
);

final Rule ruleDualLasers = Rule(
  name: 'Dual Lasers',
  id: _ruleDualLasersId,
  factionMods: (ur, cg, u) => [CEFMods.dualLasers(u)],
  veteranModCheck: (u, cg, {required modID}) {
    if (modID == vet_mod.dualGunsId && u.hasMod(dualLasersId)) {
      return false;
    }
    if (modID == dualLasersId && u.hasMod(vet_mod.dualGunsId)) {
      return false;
    }
    return null;
  },
  description: 'Duelist frames may select the Dual Guns veteran upgrade for' +
      ' laser cannons. Remove any TD or Shield traits when this upgrade is' +
      ' chosen.',
);

final Rule ruleEWDuelists = Rule(
  name: 'EW Duelists',
  id: _ruleEWDuelistsId,
  factionMods: (ur, cg, u) => [CEFMods.ewDuelists()],
  description: 'Each duelist frame may purchase the ECM trait and the' +
      ' Sensors:36 trait for 1 TV total.',
);
