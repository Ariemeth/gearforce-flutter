import 'dart:convert';

import 'package:gearforce/models/unit/frame.dart';
import 'package:test/test.dart';

const frameJSON =
    '{"name":"Hunter","manufacturer":"northco","unit type":"Trooper Gear","height":"4.3 meters / 14.1 ft","weight":"6,627 kgs / 14,610 lbs","description":"TBD","upgrades":[{"name":"headhunter"}],"variants":[{"model":"Hunter","tv":6,"role":"GP+, SK, FS","mr":"W/G:6","arm":6,"h/s":"4/2","a":1,"gu":"4+","pi":"4+","ew":"6+","react-weapons":"LAC, LVB","mounted-weapons":"LRP, LPZ, LAPGL","traits":"Hands","type":"Gear","height":1.5},{"model":"Hunter Gunner","tv":7,"role":"GP, SK, FS","mr":"W/G:6","arm":6,"h/s":"4/2","a":1,"gu":"4+","pi":"4+","ew":"6+","react-weapons":"MAC, LVB","mounted-weapons":"LRP, LAPGL","traits":"Hands","type":"Gear","height":1.5},{"model":"Hunter UC","tv":6,"role":"GP, SK","mr":"W/G:6","arm":6,"h/s":"4/2","a":1,"gu":"4+","pi":"4+","ew":"6+","react-weapons":"MFC, LVB","mounted-weapons":"LRP, LPZ, LAPGL","traits":"Hands","type":"Gear","height":1.5}]}';

void main() {
  test('test converting frame json', () {
    final fromJSON = Frame.fromJson(json.decode(frameJSON));

    expect(
      fromJSON.variants.length,
      equals(3),
    );
    expect(
      fromJSON.manufacturer,
      isNotEmpty,
      reason: 'ensure description not empty',
    );
    expect(
      fromJSON.unitType,
      isNotEmpty,
      reason: 'ensure unit type not empty',
    );
    expect(
      fromJSON.height,
      isNotEmpty,
      reason: 'ensure height type not empty',
    );
    expect(
      fromJSON.weight,
      isNotEmpty,
      reason: 'ensure weight type not empty',
    );
    expect(
      fromJSON.description,
      isNotEmpty,
      reason: 'ensure description type not empty',
    );
  });
}
