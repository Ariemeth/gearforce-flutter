import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gearforce/models/mods/base_modification.dart';

void main() {
  test(
    'Test fromJson',
    () {
      const testjson =
          '{"id":"vet: old reliable","selected":{"text":"LVB","selected":{"text":"LCW","selected":null}}}';
      final mf = ModInfo.fromJson(json.decode(testjson));
      expect(mf.id, equals('vet'), reason: 'check id');
      expect(mf.selected, isNotNull, reason: 'select should not be null');
      expect(mf.selected!.text, equals('LVB'), reason: 'check selected text');
      expect(mf.selected!.selected, isNotNull,
          reason: 'selected.selected should not be null');
      expect(mf.selected!.selected!.text, equals('LCW'),
          reason: 'check selected.selected.txt');
      expect(mf.selected!.selected!.selected, isNull,
          reason: 'selected.selected.selected should be null');
    },
    skip: true,
  );
}
