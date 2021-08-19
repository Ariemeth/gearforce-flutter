import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/movement.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/weapons/weapon.dart';

dynamic Function(dynamic) createSimpleIntMod(int change) {
  return (value) {
    if (value is! int) return value;

    return value + change;
  };
}

dynamic Function(dynamic) createSimpleStringMod(bool isPrefix, String change) {
  return (value) {
    if (value is! String) return value;

    return isPrefix ? '$change $value' : '$value $change';
  };
}

dynamic Function(dynamic) createSetIntMod(int newValue) {
  return (value) {
    return newValue;
  };
}

dynamic Function(dynamic) createSetStringListMod(List<String> newValue) {
  return (value) {
    return newValue;
  };
}

dynamic Function(dynamic) createSetMovementMod(Movement newValue) {
  return (value) {
    return newValue;
  };
}

dynamic Function(dynamic) createAddStringToList(String newValue) {
  return (value) {
    if (value is! List<String>) {
      return value;
    }

    var newList = new List<String>.from(value);

    if (!newList.contains(newValue)) {
      newList.add(newValue);
    }

    return newList;
  };
}

dynamic Function(dynamic) createAddTraitToList(Trait newValue) {
  return (value) {
    if (value is! List<Trait>) {
      return value;
    }

    var newList = new List<Trait>.from(value);

    if (!newList.any((element) => element.name == newValue.name)) {
      newList.add(newValue);
    }

    return newList;
  };
}

dynamic Function(dynamic) createAddWeaponToList(Weapon newValue) {
  return (value) {
    if (value is! List<Weapon>) {
      return value;
    }

    var newList = new List<Weapon>.from(value);

    if (!newList.any((existingWeapon) =>
        existingWeapon.abbreviation == newValue.abbreviation)) {
      newList.add(newValue);
    }

    return newList;
  };
}

dynamic Function(dynamic) createAddRoleToList(Role newValue) {
  return (value) {
    if (value is! Roles) {
      return value;
    }

    var newRoles = value.roles.toList();

    if (newRoles.any((element) => element.name == newValue.name)) {
      var index =
          newRoles.indexWhere((element) => element.name == newValue.name);
      if (index >= 0) {
        newRoles.removeAt(index);
        newRoles.insert(index, newValue);
      }
    }

    return Roles(roles: newRoles);
  };
}

dynamic Function(dynamic) createRemoveFromList(Trait newValue) {
  return (value) {
    if (value is! List<Trait>) {
      return value;
    }

    var newList = new List<Trait>.from(value);
    newList.remove(newValue);

    return newList;
  };
}

dynamic Function(dynamic) createRemoveWeaponFromList(Weapon newValue) {
  return (value) {
    if (value is! List<Weapon>) {
      return value;
    }

    var newList = new List<Weapon>.from(value).where((existingWeapon) =>
        existingWeapon.abbreviation != newValue.abbreviation);

    return newList;
  };
}

dynamic Function(dynamic) createReplaceTraitInList(
    {required Trait oldValue, required Trait newValue}) {
  return (value) {
    if (value is! List<Trait>) {
      return value;
    }

    var newList = new List<Trait>.from(value);

    newList.remove(oldValue);

    if (!newList.contains(newValue)) {
      newList.add(newValue);
    }

    return newList;
  };
}

dynamic Function(dynamic) createReplaceWeaponInList(
    {required Weapon oldValue, required Weapon newValue}) {
  return (value) {
    if (value is! List<Weapon>) {
      return value;
    }

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

dynamic Function(dynamic) createMultiReplaceWeaponsInList(
    {required List<Weapon> oldItems, required List<Weapon> newItems}) {
  return (value) {
    if (value is! List<Weapon>) {
      return value;
    }

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
