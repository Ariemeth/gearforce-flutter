import 'package:gearforce/models/factions/faction_rule.dart';
import 'package:gearforce/models/rules/north/north.dart';

const String _baseRuleId = 'rule::ng';

/*
NG - Norguard
Norguard is tasked with the overall defense of all Northern territories. Not very
numerous on their own, they have excellent equipment and training, and are
considered the masters of combined arms warfare. Each league’s army normally
operates independently. But when the CNCS faces a threat which any of the three
league’s armies can not handle on their own, Norguard becomes the unified
command to lead them all.
* Pan-Northern: Each combat group may use one upgrade option from WFP, UMF
or NLC. Live Free Die Hard, The Pride and Devoted may not be selected.
* Surplus Hunters: Hunters may be placed in GP, SK, FS or RC units. Hunter
and Stripped-Down Hunter variants are not limited to 1-2 models and may be
selected an unlimited number of times.
* Surplus Jaguars: Jaguars may be placed in GP, SK, FS, RC or SO units.
*/
class NG extends North {
  NG(super.data)
      : super(
          name: 'Norguard',
          subFactionRules: [
            rule1,
            rule2,
            rule3,
          ],
        );
}

final FactionRule rule1 = FactionRule(
  name: 'Pan-Northern',
  id: '$_baseRuleId::rule1',
  description: 'Each combat group may use one upgrade option from WFP, UMF' +
      'or NLC. Live Free Die Hard, The Pride and Devoted may not be selected.',
);

final FactionRule rule2 = FactionRule(
  name: 'Surplus Hunters',
  id: '$_baseRuleId::rule2',
  description: 'Hunters may be placed in GP, SK, FS or RC units. Hunter and' +
      ' Stripped-Down Hunter variants are not limited to 1-2 models and may' +
      ' be selected an unlimited number of times.',
);

final FactionRule rule3 = FactionRule(
  name: 'Surplus Jaguars',
  id: '$_baseRuleId::rule3',
  description: 'Jaguars may be placed in GP, SK, FS, RC or SO units.',
);
