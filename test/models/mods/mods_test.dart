import 'package:gearforce/models/mods/mods.dart';
import 'package:test/test.dart';

void main() {
  test('test createSimpleIntMod adds 1', () {
    final mod = createSimpleIntMod(1);
    expect(mod(5), equals(5 + 1));
  });

  test('test createSimpleIntMod subtracts 1', () {
    final mod = createSimpleIntMod(-1);
    expect(mod(5), equals(5 - 1));
  });

  test('test createSimpleIntMod returns value when 0 is the change', () {
    final mod = createSimpleIntMod(0);
    expect(mod(5), equals(5));
  });

  test('test createSimpleStringMod mod adds prefix to value', () {
    const String prefix = 'test';
    final mod = createSimpleStringMod(true, prefix);
    const testName = 'test mod';
    expect(mod(testName), equals('$prefix $testName'));
  });

  test('test createSimpleStringMod mod adds postfix to value', () {
    const String postfix = 'test';
    final mod = createSimpleStringMod(false, postfix);
    const testName = 'test mod';
    expect(mod(testName), equals('$testName $postfix'));
  });

  test('test createSetIntMod mod sets a value', () {
    final mod = createSetIntMod(0);
    expect(mod(5), equals(0));
  });

  test('test createAddToList mod adds Comms to list', () {
    const trait = 'Comms';
    final mod = createAddToList(trait);
    final List<String> traits = ['something'];
    expect(mod(traits), contains(trait));
    expect(traits, hasLength(1),
        reason: 'original list should not have changed in length');
    expect(mod(traits), hasLength(2));
  });

  test('test createAddToList mod adds Comms to list with existing +', () {
    const trait = 'Comms';
    final mod = createAddToList(trait);
    final List<String> traits = ['$trait+'];
    expect(mod(traits), contains(trait));
    expect(traits, hasLength(1),
        reason: 'original list should not have changed in length');
    expect(mod(traits), contains('Comms'));
  });

  test('test createAddToList mod does not duplicate Comms', () {
    const trait = 'Comms';
    final mod = createAddToList(trait);
    final List<String> traits = [trait];
    expect(mod(traits), contains(trait));
    expect(traits, hasLength(1),
        reason: 'original list should not have changed in length');
    expect(mod(traits), hasLength(1));
  });

  test('test createReplaceInList mod adds Brawl:2 to list removes Brawl:1', () {
    const traitOld = 'Brawl:1';
    const traitNew = 'Brawl:2';
    final mod = createReplaceInList(oldValue: traitOld, newValue: traitNew);
    final List<String> traits = [traitOld];
    expect(mod(traits), contains(traitNew));
    expect(mod(traits), isNot(contains(traitOld)));
    expect(traits, hasLength(1),
        reason: 'original list should not have changed in length');
    expect(mod(traits), hasLength(1));
  });

  test(
      'test createReplaceInList mod adds Brawl:2 to list removes Brawl:1 when Brawl:1 dne',
      () {
    const traitOld = 'Brawl:1';
    const traitNew = 'Brawl:2';
    final mod = createReplaceInList(oldValue: traitOld, newValue: traitNew);
    final List<String> traits = [];
    expect(mod(traits), contains(traitNew));
    expect(mod(traits), isNot(contains(traitOld)));
    expect(traits, hasLength(0),
        reason: 'original list should not have changed in length');
    expect(mod(traits), hasLength(1));
  });

  test('test createMultiReplaceInList mod add 1 remove 2', () {
    const traitOld1 = 'LATM';
    const traitOld2 = 'MATM';
    const traitNew = 'MRL (T,Link)';
    final mod = createMultiReplaceInList(
        oldItems: [traitOld1, traitOld2], newItems: [traitNew]);
    final List<String> traits = [traitOld1, traitOld2];
    expect(mod(traits), contains(traitNew));
    expect(mod(traits), isNot(contains(traitOld1)));
    expect(mod(traits), isNot(contains(traitOld2)));
    expect(traits, hasLength(2),
        reason: 'original list should not have changed in length');
    expect(mod(traits), hasLength(1));
  });

  test('test createMultiReplaceInList mod add 1 remove 2 where 1 previous dne',
      () {
    const traitOld1 = 'LATM';
    const traitOld2 = 'MATM';
    const traitNew = 'MRL (T,Link)';
    final mod = createMultiReplaceInList(
        oldItems: [traitOld1, traitOld2], newItems: [traitNew]);
    final List<String> traits = [traitOld2];
    expect(mod(traits), contains(traitNew));
    expect(mod(traits), isNot(contains(traitOld1)));
    expect(mod(traits), isNot(contains(traitOld2)));
    expect(traits, hasLength(1),
        reason: 'original list should not have changed in length');
    expect(mod(traits), hasLength(1));
  });

  test('test createMultiReplaceInList mod add 2 remove 1', () {
    const traitNew1 = 'LATM';
    const traitNew2 = 'MATM';
    const traitOld = 'MRL (T,Link)';
    final mod = createMultiReplaceInList(
        oldItems: [traitOld], newItems: [traitNew1, traitNew2]);
    final List<String> traits = [traitOld];
    expect(mod(traits), contains(traitNew1));
    expect(mod(traits), contains(traitNew2));
    expect(mod(traits), isNot(contains(traitOld)));
    expect(traits, hasLength(1),
        reason: 'original list should not have changed in length');
    expect(mod(traits), hasLength(2));
  });

  test('test createMultiReplaceInList mod add 1 remove 1', () {
    const traitNew1 = 'LATM';
    const traitOld = 'MRL (T,Link)';
    final mod =
        createMultiReplaceInList(oldItems: [traitOld], newItems: [traitNew1]);
    final List<String> traits = [traitOld];
    expect(mod(traits), contains(traitNew1));
    expect(mod(traits), isNot(contains(traitOld)));
    expect(traits, hasLength(1),
        reason: 'original list should not have changed in length');
    expect(mod(traits), hasLength(1));
  });

  test(
      'test createMultiReplaceInList mod add 1 remove 2 with the add already existing',
      () {
    const traitOld1 = 'LATM';
    const traitOld2 = 'MATM';
    const traitNew = 'MRL (T,Link)';
    final mod = createMultiReplaceInList(
        oldItems: [traitOld1, traitOld2], newItems: [traitNew]);
    final List<String> traits = [traitOld1, traitOld2, traitNew];
    expect(mod(traits), contains(traitNew));
    expect(mod(traits), isNot(contains(traitOld1)));
    expect(mod(traits), isNot(contains(traitOld2)));
    expect(traits, hasLength(3),
        reason: 'original list should not have changed in length');
    expect(mod(traits), hasLength(1));
  });
}
