import 'dart:math';

import 'package:gearforce/models/traits/trait.dart';
import 'package:test/test.dart';

void main() {
  test('test creating a trait with no level', () {
    const traitName = 'Advanced';
    const toString = 'Advanced';

    const w = Trait(name: traitName);
    expect(w.name, equals(traitName), reason: 'check name');
    expect(w.level, isNull, reason: 'check level');
    expect(w.isAux, isFalse, reason: 'check aux');
    expect(w.toString(), equals(toString), reason: 'check toString');
  });

  test('test creating a trait with a level', () {
    const traitName = 'AE';
    const traitLevel = 2;
    const toString = '$traitName:$traitLevel';

    const w = Trait(name: traitName, level: traitLevel);
    expect(w.name, equals(traitName), reason: 'check name');
    expect(w.level, equals(traitLevel), reason: 'check level');
    expect(w.isAux, isFalse, reason: 'check aux');
    expect(w.toString(), equals(toString), reason: 'check toString');
  });

  test('test creating an Aux trait', () {
    const traitName = 'ECM';
    const toString = '$traitName (Aux)';
    const isAux = true;

    const w = Trait(name: traitName, isAux: isAux);
    expect(w.name, equals(traitName), reason: 'check name');
    expect(w.isAux, equals(isAux), reason: 'check aux');
    expect(w.toString(), equals(toString), reason: 'check toString');
  });

  test('test fromString with simple trait', () {
    const traitName = 'ECM';
    const toString = '$traitName';
    const isAux = false;

    final w = Trait.fromString(toString);
    expect(w.name, equals(traitName), reason: 'check name');
    expect(w.isAux, equals(isAux), reason: 'check aux');
    expect(w.toString(), equals(toString), reason: 'check toString');
  });

  test('test fromString with aux trait', () {
    const traitName = 'ECM';
    const isAux = true;
    const toString = '$traitName${isAux ? ' (Aux)' : ''}';

    final w = Trait.fromString(toString);
    expect(w.name, equals(traitName), reason: 'check name');
    expect(w.isAux, equals(isAux), reason: 'check aux');
    expect(w.toString(), equals(toString), reason: 'check toString');
  });

  test('test fromString with trait with level', () {
    const traitName = 'AE';
    const level = 2;
    const isAux = false;
    const toString = '$traitName:$level${isAux ? ' (Aux)' : ''}';

    final w = Trait.fromString(toString);
    expect(w.name, equals(traitName), reason: 'check name');
    expect(w.isAux, equals(isAux), reason: 'check aux');
    expect(w.level, equals(level), reason: 'check level');
    expect(w.toString(), equals(toString), reason: 'check toString');
  });
}
