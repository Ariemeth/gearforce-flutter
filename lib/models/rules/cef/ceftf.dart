import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart'
    as vetMod;
import 'package:gearforce/models/rules/cef/cef.dart';
import 'package:gearforce/models/unit/model_type.dart';

const String _baseRuleId = 'rule::ceftf';
const String _ruleTheHammerId = '$_baseRuleId::10';
const String _ruleTankJockeysId = '$_baseRuleId::20';
const String _ruleOutridersId = '$_baseRuleId::30';

/*
  CEFTF - CEF Tank Formation
  When the mobile elements of the CEF begin their blitzing attacks, it is the hover
  tank formations that lead the way. Powerful enough to destroy most targets and
  fast enough to escape fights they cannot win; these formations are a tried and true.
  * The Hammer: Vehicles in this force may purchase the Improved Gunnery
  veteran upgrade without being veterans.
  * Tank Jockeys: Light and medium hovertanks upgraded with the Vet trait ignore
  the movement penalty for traveling through difficult terrain.
  * Outriders: One combat group, with all models having the hover type movement,
  may deploy using the recon special deployment.
*/
class CEFTF extends CEF {
  CEFTF(super.data)
      : super(
          name: 'CEF Tank Formation',
          subFactionRules: [ruleTheHammer, ruleTankJockeys, ruleOutriders],
        );
}

final FactionRule ruleTheHammer = FactionRule(
  name: 'The Hammer',
  id: _ruleTheHammerId,
  veteranModCheck: (u, cg, {required modID}) {
    if (modID != vetMod.improvedGunneryID) {
      return null;
    }

    if (u.type == ModelType.Vehicle) {
      return true;
    }

    return null;
  },
  description: 'Vehicles in this force may purchase the Improved Gunnery' +
      ' veteran upgrade without being veterans.',
);

final FactionRule ruleTankJockeys = FactionRule(
  name: 'Tank Jockeys',
  id: _ruleTankJockeysId,
  description: 'Light and medium hovertanks upgraded with the Vet trait' +
      ' ignore the movement penalty for traveling through difficult terrain.',
);

final FactionRule ruleOutriders = FactionRule(
  name: 'Outriders',
  id: _ruleOutridersId,
  description: 'One combat group, with all models having the hover type' +
      ' movement, may deploy using the recon special deployment..',
);
