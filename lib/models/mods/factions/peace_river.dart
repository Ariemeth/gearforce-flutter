import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

const e_pexID = 'faction: peace river - 10';
const warriorElite = 'faction: peace river - 20';
const crisisCrusader = 'faction: peace river - 30';
const laserTech = 'faction: peace river - 40';
const architects = 'faction: peace river - 50';

/*
E-pex: One Peace River model within each combat group may increase its EW skill by one for 1 TV each.
Z Warrior Elite: Any Warrior IV may be upgraded to a Warrior Elite for 1 TV each. This upgrade gives the Warrior IV a
H/S of 4/2, an EW skill of 4+, and the Agile trait.
Z Crisis Responders: Any Crusader IV that has been upgraded to a Crusader V may swap their HAC, MSC, MBZ or LFG
for a MPA (React) and a Shield for 1 TV. This Crisis Responder variant is unlimited for this force.
Z Laser Tech: Veteran universal infantry and veteran Spitz Monowheels may upgrade their IW, IR or IS for 1 TV each.
These weapons receive the Advanced trait.
Z Architects: The duelist for this force may use a Peace River strider.
*/

class FactionModification extends BaseModification {
  FactionModification({
    required String name,
    // required CombatGroup cg,
    this.requirementCheck = _defaultRequirementsFunction,
    ModificationOption? options,
    required String id,
  }) : super(name: name, options: options, id: id);

  // function to ensure the modification can be applied to the unit
  final bool Function(CombatGroup) requirementCheck;

  static bool _defaultRequirementsFunction(CombatGroup cg) => true;

  /*
  E-pex: One Peace River model within each combat group may increase its EW skill by one for 1 TV each.
  */
  factory FactionModification.e_pex(CombatGroup cg) {
    final bool Function(CombatGroup) reqCheck = (CombatGroup cg) {
      return cg.modCount(e_pexID) == 0;
    };
    return FactionModification(
        name: 'E-pex', requirementCheck: reqCheck, id: e_pexID)
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
      ..addMod(UnitAttribute.ew, createSimpleIntMod(-1), description: 'EW -1');
  }

  factory FactionModification.fromId(String id, CombatGroup cg) {
    switch (id) {
      case e_pexID:
        return FactionModification.e_pex(cg);
    }
    throw Exception('Unable to create mod with id $id');
  }
}

/*
E-pex: One Peace River model within each combat group may increase its EW skill by one for 1 TV each.
*/
/*final FactionModification boasLongFang = FactionModification(
    name: 'Long Fang Upgrade',
    requirementCheck: (Unit u) {
      return u.mountedWeapons.any((w) => w.abbreviation == 'LGM');
    },
    cg: null)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV: +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Long Fang'))
  ..addMod(
      UnitAttribute.mounted_weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LGM')!, newValue: buildWeapon('MFM')!),
      description: '-LGM, +MFM');
*/