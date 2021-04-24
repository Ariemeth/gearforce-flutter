import 'package:flutter_test/flutter_test.dart';
import 'package:gearforce/data/data.dart';

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
    data.load().whenComplete(() => expect(data.north().length, greaterThan(0)));
  });
}
