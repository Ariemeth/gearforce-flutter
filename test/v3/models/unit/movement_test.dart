import 'dart:convert';

import 'package:gearforce/v3/models/unit/movement.dart';
import 'package:test/test.dart';

const validMovementJSON = '"W/G:6"';

void main() {
  test('test creating a movment from a valid json', () {
    final fromJson = Movement.fromJson(json.decode(validMovementJSON));

    expect(fromJson.type, equals('W/G'), reason: 'type check');
    expect(fromJson.rate, equals(6), reason: 'rate check');
  });

  test('rate is non-number', () {
    expect(() => Movement.fromJson('"W/G:P"'), throwsA(isA<FormatException>()));
  });
  test('json string is empty', () {
    expect(() => Movement.fromJson(''), throwsA(isA<FormatException>()));
  });
}
