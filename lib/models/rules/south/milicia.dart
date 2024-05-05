import 'package:gearforce/models/rules/rule.dart';
import 'package:gearforce/models/mods/factionUpgrades/south.dart';
import 'package:gearforce/models/rules/north/north.dart' as north;
import 'package:gearforce/models/rules/south/south.dart';
import 'package:gearforce/models/rules/south/sra.dart' as sra;

const _baseRuleId = 'rule::south::milicia';
const _ruleConscriptionId = '$_baseRuleId::10';

/*
  MILICIA - Military Intervention and
  Counter Insurgency Army
  The MILICIA is the conscripted force for the four southern leagues. It is composed
  of drafted civilians, some military rejects from the other southern armies and the
  occasional volunteer. Disciplinary problems abound and extreme social stratification
  is the defining characteristic of the MILICIA. Despite this, they are fierce fighters
  who know that the only ones they can count on are each other. Often at the forefront
  of combat operations in the South and the Badlands the MILICIA has a reputation
  as a dangerous opponent.
  * Veteran Leaders: You may purchase the Vet trait for any commander in the
  force without counting against the veteran limitations.
  * Conscription: You may add the Conscript trait to any non-commander,
  non-veteran and non-duelist in the force if they do not already possess the trait.
  Reduce the TV of these models by 1 TV per action.
  * Political Officer: You may select one non-commander to be a Political Officer
  (PO) for 2 TV. The PO becomes an officer and can take the place as a third
  commander within a combat group. The PO comes with 1 CP and can use it to
  give orders to any model or combat group in the force. POs will only be used
  to roll for initiative if there are no other commanders in the force. When there
*/
class MILICIA extends South {
  MILICIA(super.data)
      : super(
          name: 'Military Intervention and Counter Insurgency Army',
          subFactionRules: [
            north.ruleVeteranLeaders,
            ruleConscription,
            sra.rulePoliticalOfficer,
          ],
        );
}

final Rule ruleConscription = Rule(
  name: 'Conscription',
  id: _ruleConscriptionId,
  factionMods: (ur, cg, u) => [SouthernFactionMods.conscription(u)],
  description: 'You may add the Conscript trait to any non-commander,' +
      ' non-veteran and non-duelist in the force if they do not already' +
      ' possess the trait. Reduce the TV of these models by 1 TV per action.',
);
