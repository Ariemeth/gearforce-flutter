import 'dart:convert';

import 'package:test/test.dart';
import 'package:gearforce/models/unit/unit.dart';

const validUnitJSON =
    '{"model":"Hunter","tv":6,"ua":"GP,SK,FS","mr":"W/G:6","ar":6,"h/s":"4/2","a":1,"gu":4,"pi":4,"ew":6,"weapons":["LAC (Arm)","LRP","LAPGL","LPZ","LVB (Arm)"],"traits":["Arms"],"type/height":"Gear 1.5"}';

void main() {
  test('test creating a unit from a valid json', () {
    final fromJson = Unit.fromJson(json.decode(validUnitJSON));

    expect(fromJson.name, equals('Hunter'), reason: "Name check");
    expect(fromJson.tv, equals(6), reason: "TV check");
    expect(fromJson.ua, equals(['GP', 'SK', 'FS']), reason: "UA check");
    expect(fromJson.movement.type, equals('W/G'),
        reason: "Movement type check");
    expect(fromJson.movement.rate, equals(6), reason: "Movement rate check");
    expect(fromJson.armor, equals(6), reason: "Armor check");
    expect(fromJson.hull, equals(4), reason: "Hull check");
    expect(fromJson.structure, equals(2), reason: "Structure check");
    expect(fromJson.actions, equals(1), reason: "Actions check");
    expect(fromJson.gunnery, equals(4), reason: "Gunnery check");
    expect(fromJson.piloting, equals(4), reason: "Piloting check");
    expect(fromJson.ew, equals(6), reason: "EW check");
    expect(fromJson.weapons,
        equals(['LAC (Arm)', 'LRP', 'LAPGL', 'LPZ', 'LVB (Arm)']),
        reason: "Weapons check");
    expect(fromJson.traits, equals(['Arms']), reason: "Traits check");
    expect(fromJson.type, equals('Gear'), reason: "Unit type check");
    expect(fromJson.height, equals('1.5'), reason: "Height check");
  });

  test('json string is empty', () {
    expect(() => Unit.fromJson(''), throwsA(isA<TypeError>()));
  });

}
