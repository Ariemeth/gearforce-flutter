import 'package:flutter_test/flutter_test.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction.dart';

void main() {
  setUpAll(() async {
    // Data class uses the rootBundle, therefore the the flutterbindings need to
    // be initialized before testing.
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('loading the data files', () {
    final data = Data();
    expect(data.load(), completes);
  });

  test('ensure faction list loaded', () async {
    final data = Data();
    await data
        .load()
        .whenComplete(() => expect(data.factions().length, greaterThan(0)));
  });

  test('ensure north unit list loads', () async {
    final data = Data();
    await data.load().whenComplete(
        () => expect(data.unitList(Factions.North).length, greaterThan(0)));
  });

  test('ensure south unit list loads', () async {
    final data = Data();
    await data.load().whenComplete(
        () => expect(data.unitList(Factions.South).length, greaterThan(0)));
  });

  test('ensure black talon unit list loads', () async {
    final data = Data();
    await data.load().whenComplete(() =>
        expect(data.unitList(Factions.BlackTalon).length, greaterThan(0)));
  });

  test('ensure caprice unit list loads', () async {
    final data = Data();
    await data.load().whenComplete(
        () => expect(data.unitList(Factions.Caprice).length, greaterThan(0)));
  });

  test('ensure cef unit list loads', () async {
    final data = Data();
    await data.load().whenComplete(
        () => expect(data.unitList(Factions.CEF).length, greaterThan(0)));
  });

  test('ensure eden unit list loads', () async {
    final data = Data();
    await data.load().whenComplete(
        () => expect(data.unitList(Factions.Eden).length, greaterThan(0)));
  });

  test('ensure nucoal unit list loads', () async {
    final data = Data();
    await data.load().whenComplete(
        () => expect(data.unitList(Factions.NuCoal).length, greaterThan(0)));
  });

  test('ensure terrain unit list loads', () async {
    final data = Data();
    await data.load().whenComplete(
        () => expect(data.unitList(Factions.Terrain).length, greaterThan(0)));
  });

  test('ensure universal unit list loads', () async {
    final data = Data();
    await data.load().whenComplete(
        () => expect(data.unitList(Factions.Universal).length, greaterThan(0)));
  });

  test('ensure utopia unit list loads', () async {
    final data = Data();
    await data.load().whenComplete(
        () => expect(data.unitList(Factions.Utopia).length, greaterThan(0)));
  });

  test('ensure peace river unit list loads', () async {
    final data = Data();
    await data.load().whenComplete(() =>
        expect(data.unitList(Factions.PeaceRiver).length, greaterThan(0)));
  });

  test('test unitlist with name filter', () async {
    final data = Data();
    await data.load();
    expect(data.unitList(Factions.PeaceRiver, filters: ['warrior']).length,
        greaterThan(0),
        reason: 'check for at least 1 result');
    expect(data.unitList(Factions.PeaceRiver, filters: ['warrior']).length,
        lessThan(data.unitList(Factions.PeaceRiver).length),
        reason: 'filtered list should be smaller');
    print(data.unitList(Factions.PeaceRiver, filters: ['warrior']).length);
  });

  test('test unitlist with trait filter', () async {
    final data = Data();
    await data.load();
    expect(data.unitList(Factions.PeaceRiver, filters: ['airdrop']).length,
        greaterThan(0),
        reason: 'check for at least 1 result');
    expect(data.unitList(Factions.PeaceRiver, filters: ['airdrop']).length,
        lessThan(data.unitList(Factions.PeaceRiver).length),
        reason: 'filtered list should be smaller');
    print(data.unitList(Factions.PeaceRiver, filters: ['airdrop']).length);
  });

  test('test unitlist with trait filter and name filter', () async {
    final data = Data();
    await data.load();
    expect(
        data.unitList(Factions.PeaceRiver,
            filters: ['airdrop', 'warrior']).length,
        greaterThan(0),
        reason: 'check for at least 1 result');
    expect(
        data.unitList(Factions.PeaceRiver,
            filters: ['airdrop', 'warrior']).length,
        lessThan(data.unitList(Factions.PeaceRiver).length),
        reason: 'filtered list should be smaller');
    print(data
        .unitList(Factions.PeaceRiver, filters: ['airdrop', 'warrior']).length);
  });
}
