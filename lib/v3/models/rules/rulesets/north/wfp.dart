import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/north.dart';
import 'package:gearforce/v3/models/rules/rulesets/north/north.dart';
import 'package:gearforce/v3/models/unit/role.dart';

const String _baseRuleId = 'rule::north::wfp';
const String _rulePristineAntiquesId = '$_baseRuleId::10';
const String _ruleOlTrustyId = '$_baseRuleId::20';
const String _ruleDropBearsId = '$_baseRuleId::30';
const String _ruleLiveFreeDieHardId = '$_baseRuleId::40';

/*
WFP - Western Frontier Protectorate
Self-reliance and a true pioneer spirit motivate the under-equipped armies of
the WFP. Their commanders have an almost instinctive understanding of how to
marshal their forces. The aged gears of the WFP armies are known for their skill and
responsiveness to their pilots due to their excellent upkeep and well used ONNets.
* Pristine Antiques: Hunters, Ferrets, Weasels, Wildcat and Bobcats may be
placed in a GP, SK, FS or RC units. This does not include Hunter XMGs.
* Ol’ Trusty: Hunters, Ferrets, Weasels, Wildcats and Bobcats may improve their
GU skill by one for 1 TV each. This does not include Hunter XMGs.
* Drop Bears: Combat groups performing airdrop deployments are not required
to be placed in formation.
* Live Free Die Hard: Whenever a WFP commander is destroyed, immediately
give one SP to one model in formation with the destroyed commander. This SP
does not convert to a CP. If not used, this SP is removed during cleanup.
*/
class WFP extends North {
  WFP(super.data, super.settings)
      : super(
          name: 'Western Frontier Protectorate',
          subFactionRules: [
            rulePristineAntiques,
            ruleOlTrustyWFP,
            ruleDropBears,
            ruleLiveFreeDieHard,
          ],
        );
}

final Rule rulePristineAntiques = Rule(
  name: 'Pristine Antiques',
  id: _rulePristineAntiquesId,
  hasGroupRole: (unit, target, group) {
    final frameName = unit.core.frame;
    final isAllowedUnit = (frameName.toLowerCase().contains('hunter') &&
            !frameName.contains('XMG')) ||
        frameName == 'Ferret' ||
        frameName == 'Weasel' ||
        frameName == 'Wildcat' ||
        frameName == 'Bobcat';
    final isAllowedRole = target == RoleType.gp ||
        target == RoleType.sk ||
        target == RoleType.fs ||
        target == RoleType.rc;

    return isAllowedUnit && isAllowedRole ? true : null;
  },
  description: 'Hunters, Ferrets, Weasels, Wildcat and Bobcats may be' +
      ' placed in a GP, SK, FS or RC units. This does not include Hunter' +
      ' XMGs.',
);

final Rule ruleOlTrustyWFP = Rule(
  name: 'Ol’ Trusty',
  id: _ruleOlTrustyId,
  factionMods: (ur, cg, u) => [NorthernFactionMods.olTrustyWFP()],
  description: 'Hunters, Ferrets, Weasels, Wildcats and Bobcats may ' +
      ' improve their GU skill by one for 1 TV each. This does not include ' +
      ' Hunter XMGs.',
);

final Rule ruleDropBears = Rule(
  name: 'Drop Bears',
  id: _ruleDropBearsId,
  description: 'Combat groups performing airdrop deployments are not ' +
      ' required to be placed in formation.',
);

final Rule ruleLiveFreeDieHard = Rule(
  name: 'Live Free Die Hard',
  id: _ruleLiveFreeDieHardId,
  description: 'Whenever a WFP commander is destroyed, immediately' +
      ' give one SP to one model in formation with the destroyed commander.' +
      ' This SP does not convert to a CP. If not used, this SP is removed' +
      ' during cleanup.',
);
