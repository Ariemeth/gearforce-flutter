import 'package:gearforce/models/rules/rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/nucoal.dart';
import 'package:gearforce/models/rules/rulesets/north/north.dart' as north;
import 'package:gearforce/models/rules/rulesets/nucoal/nucoal.dart';

const String _baseRuleId = 'rule::nucoal::nsdf';

const String _ruleBaitAndSwitchId = '$_baseRuleId::10';
const String _ruleHighSpeedLowDragId = '$_baseRuleId::20';

/*
  NSDF - NuCoal Self Defense Force
  The NSDF is a somewhat recently established force that benefits from being well funded and
  motivated. The main strengths of the NSDF are its hover gears and hovertanks. They are particularly
  effective at hit-and-run tactics utilizing their high-speed machines.
  * Veteran Leaders: You may purchase the Vet trait for any commander in the force without
  counting against the veteran limitations.
  * Bait and Switch: One combat group composed of all gears may use the special operations
  deployment or the recon special deployment option.
  * High Speed, Low Drag: Veteran gears may purchase
*/
class NSDF extends NuCoal {
  NSDF(super.data, super.settings)
      : super(
          name: 'NuCoal Self Defense Force',
          subFactionRules: [
            north.ruleVeteranLeaders,
            ruleBaitAndSwitch,
            ruleHighSpeedLowDrag,
          ],
        );
}

final Rule ruleBaitAndSwitch = Rule(
  name: 'Bait and Switch',
  id: _ruleBaitAndSwitchId,
  description: 'One combat group composed of all gears may use the special' +
      ' operations deployment or the recon special deployment option.',
);

final Rule ruleHighSpeedLowDrag = Rule(
  name: 'High Speed, Low Drag',
  id: _ruleHighSpeedLowDragId,
  factionMods: (ur, cg, u) => [NuCoalFactionMods.highSpeedLowDrag()],
  description: 'Veteran gears may purchase the Agile trait for 1 TV each.' +
      ' Models with the Lumbering trait may not purchase this upgrade.',
);
