import 'package:gearforce/models/mods/unitUpgrades/north.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:test/test.dart';

void main() {
  test('ensure headhunter mod replaces the name Hunter', () {
    final mod = headHunter;
    const testName = "Hunter";
    expect(mod.applyMods(UnitAttribute.name, testName), equals('Headhunter'));
  });

  test('test headhunter mod sets ew to 5', () {
    final mod = headHunter;
    const ew = 6;
    expect(mod.applyMods(UnitAttribute.ew, ew), equals(5));
  });

  test('test headhunter mod adds 1 tv', () {
    final mod = headHunter;
    const tv = 6;
    expect(mod.applyMods(UnitAttribute.tv, tv), equals(tv + 1));
  });

  test('test headhunter mod adds Comms to list', () {
    final mod = headHunter;
    final List<Trait> traits = [];
    final List<Trait> result = mod.applyMods(UnitAttribute.traits, traits);
    expect(result.any((element) => element.name == 'Comms'), isTrue,
        reason: 'check Comms exists');
    expect(mod.applyMods(UnitAttribute.traits, traits), hasLength(1));
  });

  test('test headhunter mod does not duplicate Comms', () {
    final mod = headHunter;
    final List<Trait> traits = [Trait.Comms()];
    expect(
        mod.applyMods(UnitAttribute.traits, traits), contains(Trait.Comms()));
    expect(traits, hasLength(1),
        reason: 'original list should not have changed in length');
    expect(mod.applyMods(UnitAttribute.traits, traits), hasLength(1));
  });
}
