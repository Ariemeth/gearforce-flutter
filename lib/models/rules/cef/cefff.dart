import 'package:gearforce/models/rules/cef/cef.dart';

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
  CEFFF(super.data)
      : super(
          name: 'CEF Frame Formation',
          subFactionRules: [],
        );
}
