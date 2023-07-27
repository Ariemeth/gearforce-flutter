import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/north.dart';
import 'package:gearforce/models/rules/north/north.dart';
import 'package:gearforce/models/unit/role.dart';

const String _baseRuleId = 'rule::wfp';

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
  WFP(super.data)
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

final FactionRule rulePristineAntiques = FactionRule(
    name: 'Pristine Antiques',
    id: '$_baseRuleId::pristineAntiques',
    hasGroupRole: (unit, target, group) {
      final frameName = unit.core.frame;
      final isAllowedUnit = (frameName.toLowerCase().contains('hunter') &&
              !frameName.contains('XMG')) ||
          frameName == 'Ferret' ||
          frameName == 'Weasel' ||
          frameName == 'Wildcat' ||
          frameName == 'Bobcat';
      final isAllowedRole = target == RoleType.GP ||
          target == RoleType.SK ||
          target == RoleType.FS ||
          target == RoleType.RC;

      return isAllowedUnit && isAllowedRole ? true : null;
    },
    description: 'Hunters, Ferrets, Weasels, Wildcat and Bobcats may be' +
        ' placed in a GP, SK, FS or RC units. This does not include Hunter' +
        ' XMGs.');

final FactionRule ruleOlTrustyWFP = FactionRule(
    name: 'Ol’ Trusty',
    id: '$_baseRuleId::olTrusty',
    factionMod: (ur, cg, u) => NorthernFactionMods.olTrustyWFP(),
    description: 'Hunters, Ferrets, Weasels, Wildcats and Bobcats may ' +
        ' improve their GU skill by one for 1 TV each. This does not include ' +
        ' Hunter XMGs.');

final FactionRule ruleDropBears = FactionRule(
    name: 'Drop Bears',
    id: '$_baseRuleId::dropBears',
    description: 'Combat groups performing airdrop deployments are not ' +
        ' required to be placed in formation.');

final FactionRule ruleLiveFreeDieHard = FactionRule(
    name: 'Live Free Die Hard',
    id: '$_baseRuleId::liveFreeDieHard',
    description: 'Whenever a WFP commander is destroyed, immediately' +
        ' give one SP to one model in formation with the destroyed commander.' +
        ' This SP does not convert to a CP. If not used, this SP is removed' +
        ' during cleanup.');
