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

dynamic Function(dynamic) createAddToList<T>(T newValue) {
  return (value) {
    if (value is! List<T>) {
      return value;
    }

    var newList = new List<T>.from(value);

    if (!newList.contains(newValue)) {
      newList.add(newValue);
    }

    return newList;
  };
}

dynamic Function(dynamic) createRemoveFromList<T>(T newValue) {
  return (value) {
    if (value is! List<T>) {
      return value;
    }

    var newList = new List<T>.from(value);
    newList.remove(newValue);

    return newList;
  };
}

dynamic Function(dynamic) createReplaceInList<T>(
    {required T oldValue, required T newValue}) {
  return (value) {
    if (value is! List<T>) {
      return value;
    }

    var newList = new List<T>.from(value);

    newList.remove(oldValue);

    if (!newList.contains(newValue)) {
      newList.add(newValue);
    }

    return newList;
  };
}

dynamic Function(dynamic) createMultiReplaceInList<T>(
    {required List<T> oldItems, required List<T> newItems}) {
  return (value) {
    if (value is! List<T>) {
      return value;
    }

    var newList = new List<T>.from(value);

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
