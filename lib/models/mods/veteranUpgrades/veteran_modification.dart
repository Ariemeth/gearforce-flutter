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
