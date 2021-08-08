import 'package:gearforce/models/unit/movement.dart';

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

dynamic Function(dynamic) createAddToList(String newValue) {
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

dynamic Function(dynamic) createRemoveFromList(String newValue) {
  return (value) {
    if (value is! List<String>) {
      return value;
    }

    var newList = new List<String>.from(value);
    newList.remove(newValue);

    return newList;
  };
}

dynamic Function(dynamic) createReplaceInList(
    {required String oldValue, required String newValue}) {
  return (value) {
    if (value is! List<String>) {
      return value;
    }

    var newList = new List<String>.from(value);

    newList.remove(oldValue);

    if (!newList.contains(newValue)) {
      newList.add(newValue);
    }

    return newList;
  };
}

dynamic Function(dynamic) createMultiReplaceInList(
    {required List<String> oldItems, required List<String> newItems}) {
  return (value) {
    if (value is! List<String>) {
      return value;
    }

    var newList = new List<String>.from(value);

    oldItems.forEach((element) {
      newList.remove(element);
    });

    newItems.forEach((element) {
      if (!newList.contains(element)) {
        newList.add(element);
      }
    });

    return newList;
  };
}
