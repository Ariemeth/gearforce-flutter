import 'dart:convert';

import 'package:gearforce/models/unit/role.dart';
import 'package:test/test.dart';

const validUnlimitedRoleJSON = '"GP+"';
const validRoleJSON = '"SK"';

void main() {
  test('test creating a role from a valid json', () {
    final fromJson = Role.fromJson(json.decode(validRoleJSON));

    expect(fromJson.name, equals(RoleType.SK), reason: 'name check');
    expect(fromJson.unlimited, equals(false), reason: 'unlimited check');
    expect(
      fromJson.toString(),
      equals("SK"),
      reason: 'check toString',
    );
  });

  test('test creating an unlimited role from a valid json', () {
    final fromJson = Role.fromJson(json.decode(validUnlimitedRoleJSON));

    expect(fromJson.name, equals(RoleType.GP), reason: 'name check');
    expect(fromJson.unlimited, equals(true), reason: 'unlimited check');
    expect(
      fromJson.toString(),
      equals("GP+"),
      reason: 'check toString',
    );
  });

  test('json string is empty', () {
    expect(() => Role.fromJson(''), throwsA(isA<FormatException>()));
  });

  test('role type does not exist', () {
    expect(() => Role.fromJson('bad'), throwsA(isA<FormatException>()));
  });
}
