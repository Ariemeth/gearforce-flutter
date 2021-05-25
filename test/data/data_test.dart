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

  test('ensure faction list loaded', () {
    final data = Data();
    data
        .load()
        .whenComplete(() => expect(data.factions().length, greaterThan(0)));
  });

  test('ensure north unit list loaded', () {
    final data = Data();
    data.load().whenComplete(
        () => expect(data.unitList(Factions.North).length, greaterThan(0)));
  });

  test('ensure south unit list loaded', () {
    final data = Data();
    data.load().whenComplete(
        () => expect(data.unitList(Factions.South).length, greaterThan(0)));
  });

  test('ensure peace river unit list loaded', () {
    final data = Data();
    data.load().whenComplete(() =>
        expect(data.unitList(Factions.PeaceRiver).length, greaterThan(0)));
  });
}
