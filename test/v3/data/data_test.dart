import 'package:flutter_test/flutter_test.dart';
import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/widgets/settings.dart';

void main() {
  setUpAll(() async {
    // Data class uses the rootBundle, therefore the the flutterbindings need to
    // be initialized before testing.
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('loading the data files', () {
    final data = DataV3();
    expect(data.load(Settings()), completes);
  });

  test('ensure faction list loaded', () async {
    final data = DataV3();
    await data
        .load(Settings())
        .whenComplete(() => expect(data.factions().length, greaterThan(0)));
  });

  test('ensure north unit list loads', () async {
    final data = DataV3();
    await data.load(Settings()).whenComplete(() => expect(
        data.getUnits(baseFactionFilters: [FactionType.north]).length,
        greaterThan(0)));
  });

  test('ensure south unit list loads', () async {
    final data = DataV3();
    await data.load(Settings()).whenComplete(() => expect(
        data.getUnits(baseFactionFilters: [FactionType.south]).length,
        greaterThan(0)));
  });

  test('ensure black talon unit list loads', () async {
    final data = DataV3();
    await data.load(Settings()).whenComplete(() => expect(
        data.getUnits(baseFactionFilters: [FactionType.blackTalon]).length,
        greaterThan(0)));
  });

  test('ensure caprice unit list loads', () async {
    final data = DataV3();
    await data.load(Settings()).whenComplete(() => expect(
        data.getUnits(baseFactionFilters: [FactionType.caprice]).length,
        greaterThan(0)));
  });

  test('ensure cef unit list loads', () async {
    final data = DataV3();
    await data.load(Settings()).whenComplete(() => expect(
        data.getUnits(baseFactionFilters: [FactionType.cef]).length,
        greaterThan(0)));
  });

  test('ensure eden unit list loads', () async {
    final data = DataV3();
    await data.load(Settings()).whenComplete(() => expect(
        data.getUnits(baseFactionFilters: [FactionType.eden]).length,
        greaterThan(0)));
  });

  test('ensure nucoal unit list loads', () async {
    final data = DataV3();
    await data.load(Settings()).whenComplete(() => expect(
        data.getUnits(baseFactionFilters: [FactionType.nuCoal]).length,
        greaterThan(0)));
  });

  test('ensure terrain unit list loads', () async {
    final data = DataV3();
    await data.load(Settings()).whenComplete(() => expect(
        data.getUnits(baseFactionFilters: [FactionType.terrain]).length,
        greaterThan(0)));
  });

  test('ensure universal unit list loads', () async {
    final data = DataV3();
    await data.load(Settings()).whenComplete(() => expect(
        data.getUnits(baseFactionFilters: [FactionType.universal]).length,
        greaterThan(0)));
  });

  test('ensure utopia unit list loads', () async {
    final data = DataV3();
    await data.load(Settings()).whenComplete(() => expect(
        data.getUnits(baseFactionFilters: [FactionType.utopia]).length,
        greaterThan(0)));
  });

  test('ensure peace river unit list loads', () async {
    final data = DataV3();
    await data.load(Settings()).whenComplete(() => expect(
        data.getUnits(baseFactionFilters: [FactionType.peaceRiver]).length,
        greaterThan(0)));
  });

  test('test unitlist with name filter', () async {
    final data = DataV3();
    await data.load(Settings());
    expect(
        data.getUnits(
            baseFactionFilters: [FactionType.peaceRiver],
            characterFilters: ['warrior']).length,
        greaterThan(0),
        reason: 'check for at least 1 result');
    expect(
        data.getUnits(
            baseFactionFilters: [FactionType.peaceRiver],
            characterFilters: ['warrior']).length,
        lessThan(
            data.getUnits(baseFactionFilters: [FactionType.peaceRiver]).length),
        reason: 'filtered list should be smaller');
    print(data.getUnits(
        baseFactionFilters: [FactionType.peaceRiver],
        characterFilters: ['warrior']).length);
  });

  test('test unitlist with trait filter', () async {
    final data = DataV3();
    await data.load(Settings());
    expect(
        data.getUnits(
            baseFactionFilters: [FactionType.peaceRiver],
            characterFilters: ['airdrop']).length,
        greaterThan(0),
        reason: 'check for at least 1 result');
    expect(
        data.getUnits(
            baseFactionFilters: [FactionType.peaceRiver],
            characterFilters: ['airdrop']).length,
        lessThan(
            data.getUnits(baseFactionFilters: [FactionType.peaceRiver]).length),
        reason: 'filtered list should be smaller');
    print(data.getUnits(
        baseFactionFilters: [FactionType.peaceRiver],
        characterFilters: ['airdrop']).length);
  });

  test('test unitlist with trait filter and name filter', () async {
    final data = DataV3();
    await data.load(Settings());
    expect(
        data.getUnits(
            baseFactionFilters: [FactionType.peaceRiver],
            characterFilters: ['airdrop', 'warrior']).length,
        greaterThan(0),
        reason: 'check for at least 1 result');
    expect(
        data.getUnits(
            baseFactionFilters: [FactionType.peaceRiver],
            characterFilters: ['airdrop', 'warrior']).length,
        lessThan(
            data.getUnits(baseFactionFilters: [FactionType.peaceRiver]).length),
        reason: 'filtered list should be smaller');
    print(data.getUnits(
        baseFactionFilters: [FactionType.peaceRiver],
        characterFilters: ['airdrop', 'warrior']).length);
  });
}
