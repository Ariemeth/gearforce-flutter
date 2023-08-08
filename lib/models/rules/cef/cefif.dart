import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/rules/cef/cef.dart';
import 'package:gearforce/models/rules/nucoal/pak.dart' as pak;
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/role.dart';

const String _baseRuleId = 'rule::cefif';
const String _ruleTheAnvilId = '$_baseRuleId::10';
const String _ruleAlternateApproachId = '$_baseRuleId::20';

/*
  CEFIF - CEF Infantry Formation
  The CEF infantry formations swarm across the landscape, each genetically
  engineered soldier hypno-trained from birth to fight to their last breath and to follow
  orders to the letter. A more disciplined army has never existed in all of history
  and no army survives being engaged by the relentless attacks of the CEF infantry
  formations for very long.
  * The Anvil: Infantry may be placed in GP, SK, FS, RC or SO units.
  * Alternate Approach: GREL upgraded with the Veteran trait will also receive the
  Jetpack:4 trait.
  * Something to Prove: GREL infantry models may increase their GU skill by one
  for 1 TV each.
*/
class CEFIF extends CEF {
  CEFIF(super.data)
      : super(
          name: 'CEF Infantry Formation',
          subFactionRules: [
            ruleTheAnvil,
            ruleAlternateApproach,
            pak.ruleSomethingToProve,
          ],
        );
}

final FactionRule ruleTheAnvil = FactionRule(
  name: 'The Anvil',
  id: _ruleTheAnvilId,
  hasGroupRole: (unit, target, group) {
    if (unit.type != ModelType.Infantry) {
      return null;
    }
    if (target == RoleType.GP ||
        target == RoleType.SK ||
        target == RoleType.FS ||
        target == RoleType.RC ||
        target == RoleType.SO) {
      return true;
    }
    return null;
  },
  description: 'Infantry may be placed in GP, SK, FS, RC or SO units.',
);

final FactionRule ruleAlternateApproach = FactionRule(
  name: 'Alternate Approach',
  id: _ruleAlternateApproachId,
  modifyTraits: (traits, uc) {
    if (uc.frame.contains('GREL') &&
        uc.type == ModelType.Infantry &&
        traits.any((t) => Trait.Vet().isSameType(t))) {
      traits.add(Trait.Jetpack(4));
    }
  },
  description: 'GREL upgraded with the Veteran trait will also receive the' +
      ' Jetpack:4 trait.',
);
