import 'dart:convert';

import 'package:gearforce/v3/models/unit/role.dart';
import 'package:test/test.dart';

const validUnlimitedRoleJSON = '"GP+"';
const validRoleJSON = '"SK"';
const validRolesJSON = '"SK, GP"';

void main() {
  test('test creating a role from a valid json', () {
    final fromJson = Role.fromJson(json.decode(validRoleJSON));

    expect(fromJson.name, equals(RoleType.sk), reason: 'name check');
    expect(fromJson.unlimited, equals(false), reason: 'unlimited check');
    expect(
      fromJson.toString(),
      equals('SK'),
      reason: 'check toString',
    );
  });

  test('test creating an unlimited role from a valid json', () {
    final fromJson = Role.fromJson(json.decode(validUnlimitedRoleJSON));

    expect(fromJson.name, equals(RoleType.gp), reason: 'name check');
    expect(fromJson.unlimited, equals(true), reason: 'unlimited check');
    expect(
      fromJson.toString(),
      equals('GP+'),
      reason: 'check toString',
    );
  });

  test('json string is empty', () {
    expect(() => Role.fromJson(''), throwsA(isA<FormatException>()));
  });

  test('role type does not exist', () {
    expect(() => Role.fromJson('bad'), throwsA(isA<FormatException>()));
  });

  test('test creating a Roles from json', () {
    Roles.fromJson(json.decode(validRolesJSON));
  });

  test('test includesRole where Roletype is included', () {
    const rolesJSON = '"SK,GP"';
    final fromJSON = Roles.fromJson(json.decode(rolesJSON));
    expect(fromJSON.includesRole([RoleType.gp]), equals(true));
  });

  test('test includesRole where Roletype is included with unlimited marker',
      () {
    const rolesJSON = '"SK,GP+"';
    final fromJSON = Roles.fromJson(json.decode(rolesJSON));
    expect(fromJSON.includesRole([RoleType.gp]), equals(true));
  });

  test('test includesRole where Roletype is not included', () {
    const rolesJSON = '"SK,GP+"';
    final fromJSON = Roles.fromJson(json.decode(rolesJSON));
    expect(fromJSON.includesRole([RoleType.rc]), equals(false));
  });
}
