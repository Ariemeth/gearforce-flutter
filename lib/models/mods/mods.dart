import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/movement.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/weapons/weapon.dart';

int Function(int) createSimpleIntMod(int change) {
  return (value) {
    return value + change;
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

int Function(int) createSetIntMod(int newValue) {
  return (value) {
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

List<Weapon> Function(List<Weapon>) createAddWeaponToList(Weapon newValue) {
  return (value) {
    var newList = new List<Weapon>.from(value);

    if (!newList.any((existingWeapon) =>
        existingWeapon.abbreviation == newValue.abbreviation)) {
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

List<Trait> Function(List<Trait>) createReplaceTraitInList(
    {required Trait oldValue, required Trait newValue}) {
  return (value) {
    var newList = new List<Trait>.from(value);

    newList.remove(oldValue);

    if (!newList.contains(newValue)) {
      newList.add(newValue);
    }

    return newList;
  };
}

List<Weapon> Function(List<Weapon>) createReplaceWeaponInList(
    {required Weapon oldValue, required Weapon newValue}) {
  return (value) {
    var newList = new List<Weapon>.from(value);

    var index = newList
        .indexWhere((element) => element.abbreviation == oldValue.abbreviation);

    if (index < 0) {
      print('$oldValue was not found in list of weapons ${value.toString()}');
      return value;
    }

    newList.removeAt(index);

    if (!newList
        .any((element) => element.abbreviation == newValue.abbreviation)) {
      newList.add(newValue);
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
