import 'dart:math';

import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/movement.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/weapons/weapon.dart';

int Function(int) createSimpleIntMod(
  int change, {
  int? minValue,
  int? maxValue,
}) {
  return (value) {
    var newValue = value + change;

    if (minValue != null && newValue < minValue) {
      newValue = minValue;
    }

    if (maxValue != null && newValue > maxValue) {
      newValue = maxValue;
    }

    return newValue;
  };
}

String Function(String) createSimpleStringMod(bool isPrefix, String change) {
  return (value) {
    return isPrefix ? '$change $value' : '$value $change';
  };
}

String Function(String) createReplaceStringMod(
    {required String old, required String change}) {
  return (value) {
    return value.replaceAll(old, change);
  };
}

int Function(int) createSetIntMod(int newValue, {bool onlyIfLessThan = false}) {
  return (value) {
    if (onlyIfLessThan) {
      return min(value, newValue);
    }

    return newValue;
  };
}

List<String> Function(String) createSetStringListMod(List<String> newValue) {
  return (value) {
    return newValue;
  };
}

Movement Function(Movement) createSetMovementMod(Movement newValue) {
  return (value) {
    return newValue;
  };
}

List<String> Function(List<String>) createAddStringToList(String newValue) {
  return (value) {
    var newList = new List<String>.from(value);

    if (!newList.contains(newValue)) {
      newList.add(newValue);
    }

    return newList;
  };
}

List<Trait> Function(List<Trait>) createAddTraitToList(Trait newValue) {
  return (value) {
    var newList = new List<Trait>.from(value);

    if (!newList.any((element) => element.name == newValue.name)) {
      newList.add(newValue);
    }

    return newList;
  };
}

/// Add the trait to the list if it does not already exist in the list.  Otherwise
/// combine the trait with the existing trait in the list by summing the levels.
List<Trait> Function(List<Trait>) createAddOrCombineTraitToList(
    Trait newValue) {
  return (value) {
    var newList = new List<Trait>.from(value);

    if (!newList.any((trait) => trait.isSameType(newValue))) {
      newList.add(newValue);
      return newList;
    }

    final existingTrait =
        newList.firstWhere((trait) => trait.isSameType(newValue));
    final newLevel = (existingTrait.level ?? 0) + (newValue.level ?? 0);
    final index = newList.indexOf(existingTrait);
    newList.removeAt(index);

    newList.insert(index, Trait.fromTrait(existingTrait, level: newLevel));

    return newList;
  };
}

List<Weapon> Function(List<Weapon>) createAddWeaponToList(Weapon newValue) {
  return (value) {
    var newList = new List<Weapon>.from(value);

    if (!newList.any((existingWeapon) => existingWeapon == newValue)) {
      newList.add(newValue);
    }

    return newList;
  };
}

Roles Function(Roles) createAddRoleToList(Role newValue) {
  return (value) {
    var newRoles = value.roles.toList();

    if (newRoles.any((element) => element.name == newValue.name)) {
      var index =
          newRoles.indexWhere((element) => element.name == newValue.name);
      if (index >= 0) {
        newRoles.removeAt(index);
        newRoles.insert(index, newValue);
      }
    } else {
      newRoles.add(newValue);
    }

    return Roles(roles: newRoles);
  };
}

Roles Function(Roles) createReplaceRoles(Roles newValue) {
  return (value) {
    return newValue;
  };
}

List<Trait> Function(List<Trait>) createRemoveTraitFromList(Trait newValue) {
  return (value) {
    var newList = new List<Trait>.from(value);
    newList.remove(newValue);

    return newList;
  };
}

List<Weapon> Function(List<Weapon>) createRemoveWeaponFromList(
    Weapon newValue) {
  return (value) {
    if (!value.any((w) =>
        w.abbreviation == newValue.abbreviation &&
        w.bonusString == newValue.bonusString)) {
      return value;
    }

    var newList = new List<Weapon>.from(value)
        .where((existingWeapon) =>
            existingWeapon.abbreviation != newValue.abbreviation &&
            existingWeapon.bonusString != newValue.bonusString)
        .toList();

    return newList;
  };
}

/// [createReplaceTraitInList] will replace the [oldValue] with the [newValue]
/// in an existing list or insert it at the end of the list if the is not found.
List<Trait> Function(List<Trait>) createReplaceTraitInList(
    {required Trait oldValue, required Trait newValue}) {
  return (value) {
    var newList = new List<Trait>.from(value);

    var index = newList.indexWhere((trait) => trait == oldValue);

    newList.removeWhere((trait) => trait == oldValue);

    if (index >= 0) {
      newList.insert(index, newValue);
    } else {
      print('$oldValue was not found in list of traits ${value.toString()}');
      newList.add(newValue);
    }

    return newList;
  };
}

List<Weapon> Function(List<Weapon>) createReplaceWeaponInList(
    {required Weapon oldValue, required Weapon newValue}) {
  return (value) {
    var newList = new List<Weapon>.from(value);

    var index =
        newList.indexWhere((w) => w.abbreviation == oldValue.abbreviation);

    if (index < 0) {
      print('$oldValue was not found in list of weapons ${value.toString()}');
    }

    newList.removeWhere((w) => w.abbreviation == oldValue.abbreviation);

    if (!newList.any((w) => w.abbreviation == newValue.abbreviation)) {
      if (index >= 0) {
        newList.insert(index, newValue);
      } else {
        newList.add(newValue);
      }
    }

    return newList;
  };
}

List<Weapon> Function(List<Weapon>) createMultiReplaceWeaponsInList(
    {required List<Weapon> oldItems, required List<Weapon> newItems}) {
  return (value) {
    var newList = new List<Weapon>.from(value);

    oldItems.forEach((oldWeapon) {
      newList.removeWhere((currentWeapon) =>
          currentWeapon.abbreviation == oldWeapon.abbreviation);
    });

    newItems.forEach((newWeapon) {
      if (!newList.any((currentWeapon) =>
          currentWeapon.abbreviation == newWeapon.abbreviation)) {
        newList.add(newWeapon);
      }
    });

    return newList;
  };
}
