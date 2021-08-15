import 'package:gearforce/models/traits/trait.dart';
import 'package:test/test.dart';

void main() {
  test('test creating a trait with no level', () {
    const traitName = 'Advanced';
    const toString = 'Advanced';

    const w = Trait(name: traitName);
    expect(w.name, equals(traitName), reason: 'check name');
    expect(w.level, isNull, reason: 'check level');
    expect(w.toString(), equals(toString), reason: 'check toString');
  });

  test('test creating a trait with a level', () {
    const traitName = 'AE';
    const traitLevel = 2;
    const toString = '$traitName:$traitLevel';

    const w = Trait(name: traitName, level: traitLevel);
    expect(w.name, equals(traitName), reason: 'check name');
    expect(w.level, equals(traitLevel), reason: 'check level');
    expect(w.toString(), equals(toString), reason: 'check toString');
  });
}
