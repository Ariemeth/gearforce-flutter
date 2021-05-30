import 'dart:convert';

import 'package:test/test.dart';
import 'package:gearforce/models/unit/unit_core.dart';

const validUnitJSON =
    '{"model":"Hunter","tv":6,"role":"GP, SK,FS","mr":"W/G:6","arm":6,"h/s":"4/2","a":1,"gu":"4+","pi":"4+","ew":"6+","react-weapons":"LAC,LVB","mounted-weapons":"LRP,LAPGL,LPZ","traits":"Hands","type":"Gear", "height":1.5}';

const validUnitJSONWithDashes =
    '{"model":"Hunter","tv":6,"role":"N/A","mr":"-","arm":"-","h/s":"-","a":"-","gu":"-","pi":"-","ew":"-","react-weapons":"-","mounted-weapons":"-","traits":"Hands","type":"Gear", "height":1.5}';

void main() {
  test('test creating a unit from a valid json', () {
    final fromJson = UnitCore.fromJson(json.decode(validUnitJSON));

    expect(fromJson.name, equals('Hunter'), reason: "Name check");
    expect(fromJson.tv, equals(6), reason: "TV check");
    expect(fromJson.role!.roles.length, equals(3), reason: "Role check");
    expect(fromJson.movement!.type, equals('W/G'),
        reason: "Movement type check");
    expect(fromJson.movement!.rate, equals(6), reason: "Movement rate check");
    expect(fromJson.armor, equals(6), reason: "Armor check");
    expect(fromJson.hull, equals(4), reason: "Hull check");
    expect(fromJson.structure, equals(2), reason: "Structure check");
    expect(fromJson.actions, equals(1), reason: "Actions check");
    expect(fromJson.gunnery, equals(4), reason: "Gunnery check");
    expect(fromJson.piloting, equals(4), reason: "Piloting check");
    expect(fromJson.ew, equals(6), reason: "EW check");
    expect(fromJson.reactWeapons, equals(['LAC', 'LVB']),
        reason: "React Weapons check");
    expect(fromJson.mountedWeapons, equals(['LRP', 'LAPGL', 'LPZ']),
        reason: "Mounted Weapons check");
    expect(fromJson.traits, equals(['Hands']), reason: "Traits check");
    expect(fromJson.type, equals('Gear'), reason: "Unit type check");
    expect(fromJson.height, equals('1.5'), reason: "Height check");
  });

  test('test creating a unit from a valid json with dash values', () {
    final fromJson = UnitCore.fromJson(json.decode(validUnitJSONWithDashes));

    expect(fromJson.name, equals('Hunter'), reason: "Name check");
    expect(fromJson.tv, equals(6), reason: "TV check");
    expect(fromJson.role, equals(null), reason: "Role check");
    expect(fromJson.movement, equals(null), reason: "Movement type check");
    expect(fromJson.armor, equals(null), reason: "Armor check");
    expect(fromJson.hull, equals(null), reason: "Hull check");
    expect(fromJson.structure, equals(null), reason: "Structure check");
    expect(fromJson.actions, equals(null), reason: "Actions check");
    expect(fromJson.gunnery, equals(null), reason: "Gunnery check");
    expect(fromJson.piloting, equals(null), reason: "Piloting check");
    expect(fromJson.ew, equals(null), reason: "EW check");
    expect(fromJson.reactWeapons, equals([]), reason: "React Weapons check");
    expect(fromJson.mountedWeapons, equals([]),
        reason: "Mounted Weapons check");
    expect(fromJson.traits, equals(['Hands']), reason: "Traits check");
    expect(fromJson.type, equals('Gear'), reason: "Unit type check");
    expect(fromJson.height, equals('1.5'), reason: "Height check");
  });

  test('json string is empty', () {
    expect(() => UnitCore.fromJson(''), throwsA(isA<TypeError>()));
  });
}
