import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/rules/rulesets/cef/cef.dart';
import 'package:gearforce/v3/models/rules/rulesets/nucoal/pak.dart' as pak;
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:gearforce/v3/models/unit/role.dart';

const String _baseRuleId = 'rule::cef::cefif';
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
  CEFIF(super.data, super.settings)
      : super(
          name: 'CEF Infantry Formation',
          subFactionRules: [
            ruleTheAnvil,
            ruleAlternateApproach,
            pak.ruleSomethingToProve,
          ],
        );
}

final Rule ruleTheAnvil = Rule(
  name: 'The Anvil',
  id: _ruleTheAnvilId,
  hasGroupRole: (unit, target, group) {
    if (unit.type != ModelType.infantry) {
      return null;
    }
    if (target == RoleType.gp ||
        target == RoleType.sk ||
        target == RoleType.fs ||
        target == RoleType.rc ||
        target == RoleType.so) {
      return true;
    }
    return null;
  },
  description: 'Infantry may be placed in GP, SK, FS, RC or SO units.',
);

final Rule ruleAlternateApproach = Rule(
  name: 'Alternate Approach',
  id: _ruleAlternateApproachId,
  modifyTraits: (traits, uc) {
    if (uc.frame.contains('GREL') &&
        uc.type == ModelType.infantry &&
        traits.any((t) => Trait.vet().isSameType(t))) {
      traits.add(Trait.jetpack(4));
    }
  },
  description: 'GREL upgraded with the Veteran trait will also receive the' +
      ' Jetpack:4 trait.',
);
