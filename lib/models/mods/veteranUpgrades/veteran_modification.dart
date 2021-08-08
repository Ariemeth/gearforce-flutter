import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:uuid/uuid.dart';

final veteranId = Uuid().v4();
final ewSpecId = Uuid().v4();
final fieldArmorId = Uuid().v4();
final inYourFaceId1 = Uuid().v4();
final inYourFaceId2 = Uuid().v4();
final insulatedId = Uuid().v4();
final fireproofId = Uuid().v4();
final oldReliableId = Uuid().v4();
final stainlessSteelId = Uuid().v4();
final sharpshooterId = Uuid().v4();
final trickShotId = Uuid().v4();
final meleeUpgradeLVB = Uuid().v4();
final meleeUpgradLCW = Uuid().v4();

class VeternModification extends BaseModification {
  VeternModification({
    required String name,
    required String id,
    this.requirementCheck = _defaultRequirementsFunction,
    this.unit,
    this.group,
  }) : super(name: name, id: id);

  // function to ensure the modification can be applied to the unit
  final bool Function() requirementCheck;
  final Unit? unit;
  final CombatGroup? group;

  static bool _defaultRequirementsFunction() => true;

  factory VeternModification.makeVet(Unit u, CombatGroup cg) {
    return VeternModification(
        name: 'Veteran Upgrade',
        id: veteranId,
        requirementCheck: () {
          if (u.hasMod(veteranId)) {
            return false;
          }

          return cg.isVeteran && !u.traits.contains('Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
      ..addMod(UnitAttribute.traits, createAddToList('Vet'),
          description: '+Vet');
  }

  factory VeternModification.ewSpecialist(Unit u, CombatGroup cg) {
    return VeternModification(
        name: 'EW Specialist',
        id: ewSpecId,
        requirementCheck: () {
          if (u.hasMod(ewSpecId)) {
            return false;
          }

          return u.traits.contains('Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.special,
          createAddToList('Add +1d6 to any EW rolls made by this model'),
          description: 'Add +1d6 to any EW rolls made by this model');
  }

  factory VeternModification.fieldArmor(Unit u, CombatGroup cg) {
    return VeternModification(
        name: 'Field Armor',
        id: fieldArmorId,
        requirementCheck: () {
          if (u.hasMod(fieldArmorId)) {
            return false;
          }

          if (u.armor == null || u.armor! > 12) {
            return false;
          }

          return u.traits.contains('Vet');
        })
      ..addMod(
        UnitAttribute.tv,
        (value) {
          if (u.armor == null) {
            return value;
          }
          int change = _fieldArmorCost(u.armor);

          return value + change;
        },
        description: 'TV +${_fieldArmorCost(u.armor)}',
      )
      ..addMod(UnitAttribute.traits, createAddToList('Field Armor'),
          description: '+Field Armor');
  }

  factory VeternModification.inYourFace1(Unit u, CombatGroup cg) {
    final brawlCheck = RegExp(r'Brawl:(\d)', caseSensitive: false);
    final traits = u.traits.toList();
    return VeternModification(
        name: 'In Your Face',
        id: inYourFaceId1,
        requirementCheck: () {
          if (u.hasMod(inYourFaceId1) || u.hasMod(inYourFaceId2)) {
            return false;
          }

          return u.traits.contains('Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.traits, (value) {
        if (!(value is List<String>)) {
          return value;
        }
        if (traits.any((trait) => brawlCheck.hasMatch(trait))) {
          var result = traits.firstWhere((trait) => brawlCheck.hasMatch(trait));
          return createReplaceInList(
                  oldValue: result,
                  newValue:
                      'brawl:${(int.parse(brawlCheck.firstMatch(result)!.group(1)!)) + 1}')(
              value);
        }

        return createAddToList('Brawl:1')(value);
      }, description: '+Brawl:1 or +1 to existing Brawl');
  }

  factory VeternModification.inYourFace2(Unit u, CombatGroup cg) {
    final brawlCheck = RegExp(r'Brawl:(\d)', caseSensitive: false);
    final traits = u.traits.toList();
    return VeternModification(
        name: 'In Your Face',
        id: inYourFaceId2,
        requirementCheck: () {
          if (u.hasMod(inYourFaceId2) || u.hasMod(inYourFaceId1)) {
            return false;
          }

          return u.traits.contains('Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
      ..addMod(UnitAttribute.traits, (value) {
        if (!(value is List<String>)) {
          return value;
        }
        if (traits.any((trait) => brawlCheck.hasMatch(trait))) {
          var result = traits.firstWhere((trait) => brawlCheck.hasMatch(trait));
          return createReplaceInList(
                  oldValue: result,
                  newValue:
                      'brawl:${(int.parse(brawlCheck.firstMatch(result)!.group(1)!)) + 2}')(
              value);
        }

        return createAddToList('Brawl:2')(value);
      }, description: '+Brawl:2 or +2 to existing Brawl');
  }

  /*
INSULATED 1 TV
Add the Resist:Haywire trait or remove the Vuln:Haywire
trait.
  */
  factory VeternModification.insulated(Unit u, CombatGroup cg) {
    final traits = u.traits.toList();
    final isVulnerable = traits.contains('Vuln:Haywire');
    return VeternModification(
        name: 'Insulated',
        id: insulatedId,
        requirementCheck: () {
          if (u.hasMod(insulatedId)) {
            return false;
          }

          if (traits.contains('Resist:Haywire')) {
            return false;
          }

          return u.traits.contains('Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(
        UnitAttribute.traits,
        (value) {
          if (!(value is List<String>)) {
            return value;
          }

          if (isVulnerable) {
            return createRemoveFromList('Vuln:Haywire')(value);
          } else {
            return createAddToList('Resist:Haywire')(value);
          }
        },
        description: '${isVulnerable ? '-Vuln:Haywire' : ' +Resist:Haywire'}',
      );
  }

  /*
FIREPROOF 1 TV
Add the Resist:Fire trait or remove the Vuln:Fire trait.
  */
  factory VeternModification.fireproof(Unit u, CombatGroup cg) {
    final traits = u.traits.toList();
    final isVulnerable = traits.contains('Vuln:Fire');
    return VeternModification(
        name: 'Fireproof',
        id: fireproofId,
        requirementCheck: () {
          if (u.hasMod(fireproofId)) {
            return false;
          }

          if (traits.contains('Resist:Fire')) {
            return false;
          }

          return u.traits.contains('Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(
        UnitAttribute.traits,
        (value) {
          if (!(value is List<String>)) {
            return value;
          }

          if (isVulnerable) {
            return createRemoveFromList('Vuln:Fire')(value);
          } else {
            return createAddToList('Resist:Fire')(value);
          }
        },
        description: '${isVulnerable ? '-Vuln:Fire' : ' +Resist:Fire'}',
      );
  }

  /*
OLD RELIABLE 0 TV
One Light (L) or Medium (M) melee weapon with the
React trait can be swapped for an equal class melee
weapon for 0 TV, i.e. a LCW can be swapped for a
LVB or a LSG. This upgrade does not include Shaped
Explosives. It also does not include traits belonging to
the previous weapons unless it was the React trait. I.e.
A LCW (React, Brawl:1) will become LVB (React). The
Brawl:X trait does not swap with it.
  */

  /*
STAINLESS STEEL 1 TV
Add the Resist:Corrosion trait or remove the
Vuln:Corrosion trait.
  */
  factory VeternModification.stainlessSteel(Unit u, CombatGroup cg) {
    final traits = u.traits.toList();
    final isVulnerable = traits.contains('Vuln:Corrosion');
    return VeternModification(
        name: 'Stainless Steel',
        id: stainlessSteelId,
        requirementCheck: () {
          if (u.hasMod(stainlessSteelId)) {
            return false;
          }

          if (traits.contains('Resist:Corrosion')) {
            return false;
          }

          return u.traits.contains('Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(
        UnitAttribute.traits,
        (value) {
          if (!(value is List<String>)) {
            return value;
          }

          if (isVulnerable) {
            return createRemoveFromList('Vuln:Corrosion')(value);
          } else {
            return createAddToList('Resist:Corrosion')(value);
          }
        },
        description:
            '${isVulnerable ? '-Vuln:Corrosion' : ' +Resist:Corrosion'}',
      );
  }

  /*
SHARPSHOOTER 2 TV
Gunnery rolls made by this model have -1 TN
(minimum 2+). This costs 2 TV for each action point
that the models has. This cost increases by 2TV per
additional action purchased via other upgrades.
  */

  /*
TRICK SHOT 1 TV
This model does not suffer the -1D6 modifier when
using the Split weapon trait.
  */

  /*
MELEE WEAPON UPGRADE 1TV
One gear with a melee weapon, that has the React trait,
can upgrade it to one of the following:
Z LVB (React, Precise)
Z LCW (React, Brawl:1)
  */
}

int _fieldArmorCost(int? armor) {
  int change = 0;

  if (armor == null) {
    return change;
  }

  if (armor > 0 && armor <= 6) {
    change = 1;
  } else if (armor == 7 || armor == 8) {
    change = 2;
  } else if (armor == 9 || armor == 10) {
    change = 3;
  } else if (armor == 11 || armor == 12) {
    change = 4;
  }
  return change;
}
