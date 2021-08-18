import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/weapons/range.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';
import 'package:gearforce/models/weapons/weapons.dart';
import 'package:test/test.dart';

const _sizes = ['L', 'M', 'H'];

class TestTable {
  const TestTable({
    required this.code,
    required this.name,
    required this.modes,
    required this.range,
    required this.damage,
    required this.traits,
    this.optionalTraits = const [],
    this.bonusTraits,
  });
  final String code;
  final String name;
  final List<weaponModes> modes;
  final Range range;
  final Map<String, int> damage;
  final List<Trait> traits;
  final List<Trait> optionalTraits;
  final String? bonusTraits;
}

void main() {
  final testTables = [
    TestTable(
      code: 'AAM',
      name: 'Anti-Air Missile',
      modes: [weaponModes.Direct, weaponModes.Indirect],
      range: Range(12, 36, 72),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [Trait(name: 'Flak'), Trait(name: 'Guided')],
    ),
    TestTable(
      code: 'ABM',
      name: 'Air Burst Missile',
      modes: [weaponModes.Direct, weaponModes.Indirect],
      range: Range(18, 48, 96),
      damage: {'L': 5, 'M': 6, 'H': 7},
      traits: [
        Trait(name: 'AI'),
        Trait(name: 'AE', level: 3),
        Trait(name: 'Blast'),
        Trait(name: 'Guided'),
      ],
    ),
    TestTable(
      code: 'AC',
      name: 'Autocannon',
      modes: [weaponModes.Direct],
      range: Range(6, 18, 36),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        Trait(name: 'Burst', level: 1),
        Trait(name: 'Split', level: 2),
      ],
    ),
    TestTable(
      code: 'AG',
      name: 'Artillery Gun',
      modes: [weaponModes.Indirect],
      range: Range(24, 48, 96),
      damage: {'L': 9, 'M': 10, 'H': 11},
      traits: [
        Trait(name: 'AE', level: 4),
        Trait(name: 'Blast'),
        Trait(name: 'AP', level: 1),
        Trait(name: 'Demo', level: 2)
      ],
    ),
    TestTable(
      code: 'AM',
      name: 'Artillery Missile',
      modes: [weaponModes.Indirect],
      range: Range(18, 48, 96),
      damage: {'L': 9, 'M': 10, 'H': 11},
      traits: [
        Trait(name: 'AE', level: 4),
        Trait(name: 'Blast'),
        Trait(name: 'Demo', level: 2),
        Trait(name: 'Guided')
      ],
    ),
    TestTable(
      code: 'APGL',
      name: 'Anti-Per Grenade Launchers',
      modes: [weaponModes.Proximity],
      range: Range(3, null, null),
      damage: {'L': 4, 'M': 5, 'H': 6},
      traits: [
        Trait(name: 'AI'),
        Trait(name: 'Frag'),
      ],
    ),
    TestTable(
      code: 'APR',
      name: 'Anti-Personnel Rockets',
      modes: [weaponModes.Direct, weaponModes.Indirect],
      range: Range(6, 18, 36),
      damage: {'L': 4, 'M': 5, 'H': 6},
      traits: [
        Trait(name: 'AI'),
        Trait(name: 'AE', level: 5),
      ],
    ),
    TestTable(
      code: 'AR',
      name: 'Artillery Rockets',
      modes: [weaponModes.Indirect],
      range: Range(18, 36, 72),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [
        Trait(name: 'AE', level: 5),
      ],
    ),
    TestTable(
      code: 'AVM',
      name: 'Anti-Vehicle Missile',
      modes: [weaponModes.Direct, weaponModes.Indirect],
      range: Range(6, 18, 36),
      damage: {'L': 5, 'M': 6, 'H': 7},
      traits: [
        Trait(name: 'AP', level: 1),
        Trait(name: 'Guided'),
      ],
    ),
    TestTable(
      code: 'CW',
      name: 'Combat Weapon',
      modes: [weaponModes.Melee],
      range: Range(0, null, null, hasReach: true, increasableReach: true),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [],
    ),
    TestTable(
      code: 'FC',
      name: 'Frag Cannon',
      modes: [weaponModes.Direct],
      range: Range(3, 9, 18),
      damage: {'L': 5, 'M': 6, 'H': 7},
      traits: [
        Trait(name: 'AP', level: 1),
      ],
      optionalTraits: [
        Trait(name: 'Frag'),
        Trait(name: 'AI'),
      ],
    ),
    TestTable(
      code: 'FM',
      name: 'Field Mortar',
      modes: [weaponModes.Indirect],
      range: Range(18, 36, 72),
      damage: {'L': 8, 'M': 9, 'H': 10},
      traits: [
        Trait(name: 'AE', level: 4),
        Trait(name: 'Blast'),
      ],
    ),
    TestTable(
      code: 'GL',
      name: 'Grenade Launcher',
      modes: [weaponModes.Direct, weaponModes.Indirect],
      range: Range(6, 12, 24),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [
        Trait(name: 'AE', level: 3),
        Trait(name: 'Blast'),
        Trait(name: 'AP', level: 1),
      ],
    ),
    TestTable(
      code: 'GM',
      name: 'Guided Mortar',
      modes: [weaponModes.Indirect],
      range: Range(18, 36, 72),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [
        Trait(name: 'AE', level: 3),
        Trait(name: 'Blast'),
        Trait(name: 'Guided'),
      ],
    ),
    TestTable(
      code: 'HG',
      name: 'Hand Grenades',
      modes: [weaponModes.Direct, weaponModes.Indirect],
      range: Range(3, 6, 9),
      damage: {'L': 8, 'M': 9, 'H': 10},
      traits: [
        Trait(name: 'AE', level: 3),
        Trait(name: 'Blast'),
        Trait(name: 'AP', level: 1),
      ],
    ),
    TestTable(
      code: 'ICW',
      name: 'Infantry Combat Weapon',
      modes: [weaponModes.Melee],
      range: Range(0, null, null, hasReach: true, increasableReach: true),
      damage: {'L': 4, 'M': 5, 'H': 6},
      traits: [
        Trait(name: 'AI'),
      ],
    ),
    TestTable(
      code: 'IGL',
      name: 'Infantry Grenade Launcher',
      modes: [weaponModes.Direct, weaponModes.Indirect],
      range: Range(3, 9, 18),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        Trait(name: 'AE', level: 2),
        Trait(name: 'Blast'),
      ],
      optionalTraits: [
        Trait(name: 'AP', level: 1),
      ],
    ),
    TestTable(
      code: 'IL',
      name: 'Infantry Laser',
      modes: [weaponModes.Direct],
      range: Range(6, 18, 36),
      damage: {'L': 3, 'M': 4, 'H': 5},
      traits: [
        Trait(name: 'AI'),
        Trait(name: 'Advanced'),
        Trait(name: 'Burst', level: 1),
      ],
    ),
    TestTable(
      code: 'IM',
      name: 'Infantry Mortar',
      modes: [weaponModes.Indirect],
      range: Range(12, 24, 48),
      damage: {'L': 4, 'M': 5, 'H': 6},
      traits: [
        Trait(name: 'AE', level: 2),
        Trait(name: 'Blast'),
        Trait(name: 'AI'),
      ],
    ),
    TestTable(
      code: 'IR',
      name: 'Infantry Rifle',
      modes: [weaponModes.Direct],
      range: Range(6, 24, 48),
      damage: {'L': 4, 'M': 5, 'H': 6},
      traits: [
        Trait(name: 'Precise'),
        Trait(name: 'AI'),
      ],
    ),
    TestTable(
      code: 'IS',
      name: 'Infantry Support Weapon',
      modes: [weaponModes.Direct],
      range: Range(6, 18, 36),
      damage: {'L': 4, 'M': 5, 'H': 6},
      traits: [],
    ),
    TestTable(
      code: 'IW',
      name: 'Infantry Weapon',
      modes: [weaponModes.Direct],
      range: Range(0, 9, 18),
      damage: {'L': 3, 'M': 4, 'H': 5},
      traits: [
        Trait(name: 'AI'),
        Trait(name: 'Burst', level: 1),
      ],
    ),
    TestTable(
      code: 'LC',
      name: 'Laser Cannon',
      modes: [weaponModes.Direct],
      range: Range(12, 36, 72),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        Trait(name: 'Precise'),
        Trait(name: 'Advanced'),
      ],
    ),
    TestTable(
      code: 'MG',
      name: 'Machine Gun',
      modes: [weaponModes.Direct],
      range: Range(3, 9, 18),
      damage: {'L': 3, 'M': 4, 'H': 5},
      traits: [
        Trait(name: 'AI'),
        Trait(name: 'Burst', level: 2),
      ],
    ),
    TestTable(
      code: 'P',
      name: 'Pistol',
      modes: [weaponModes.Direct],
      range: Range(0, 9, 18),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        Trait(name: 'Precise'),
      ],
    ),
    TestTable(
      code: 'PA',
      name: 'Particle Accelerator',
      modes: [weaponModes.Direct],
      range: Range(6, 18, 36),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [
        Trait(name: 'Haywire'),
        Trait(name: 'Advanced'),
      ],
    ),
    TestTable(
      code: 'RC',
      name: 'Rotary Cannon',
      modes: [weaponModes.Direct],
      range: Range(6, 18, 36),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        Trait(name: 'Burst', level: 2),
        Trait(name: 'Split', level: 2),
      ],
    ),
    TestTable(
      code: 'RF',
      name: 'Rifle',
      modes: [weaponModes.Direct],
      range: Range(12, 36, 72),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        Trait(name: 'Precise'),
      ],
    ),
    TestTable(
      code: 'RL',
      name: 'Rotary Laser',
      modes: [weaponModes.Direct],
      range: Range(6, 18, 36),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        Trait(name: 'Burst', level: 1),
        Trait(name: 'Split', level: 2),
        Trait(name: 'Advanced'),
      ],
    ),
    TestTable(
      code: 'RP',
      name: 'Rocket Pack',
      modes: [weaponModes.Direct, weaponModes.Indirect],
      range: Range(6, 18, 36),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [
        Trait(name: 'AE', level: 3),
        Trait(name: 'AP', level: 1),
      ],
    ),
    TestTable(
      code: 'SMG',
      name: 'Submachine Gun',
      modes: [weaponModes.Direct],
      range: Range(0, 9, 18),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        Trait(name: 'Burst', level: 2),
      ],
    ),
  ];
  for (var tt in testTables) {
    group('test building ${tt.code}s', () {
      for (var size in _sizes) {
        test('test building $size${tt.code}', () {
          final l = buildWeapon('$size${tt.code}');
          expect(l, isNotNull, reason: 'weapon should not be null');
          expect(l?.code, '$size${tt.code}', reason: 'check weapon code');
          expect(l?.name, equals(tt.name), reason: 'check name');
          expect(l?.modes, equals(tt.modes), reason: 'check modes');
          expect(l?.damage, equals(tt.damage[size]), reason: 'check damage');
          expect(l?.range.toString(), equals(tt.range.toString()),
              reason: 'check range');
          expect(l?.traits.toString(), equals(tt.traits.toString()),
              reason: 'check traits');
          expect(l?.optionalTraits.length, equals(tt.optionalTraits.length),
              reason: 'check traits');
          expect(l?.toString(), equals('$size${tt.code}'),
              reason: 'check toString');
        });
      }
    });
  }

  // Weapons to test that have traits with variable valeus
  // ATM
  group('test building ATMs', () {
    const code = 'ATM';
    const name = 'Anti-Tank Missile';
    const modes = [weaponModes.Direct, weaponModes.Indirect];
    const range = Range(12, 36, 72);
    const damage = {'L': 8, 'M': 9, 'H': 10};
    const ap = {'L': 3, 'M': 4, 'H': 5};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
        Trait(name: 'Guided'),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.code, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.optionalTraits, isEmpty, reason: 'check optional traits');
      });
    }
  });
  // BZ
  group('test building BZs', () {
    const code = 'BZ';
    const name = 'Bazooka';
    const modes = [weaponModes.Direct];
    const range = Range(6, 12, 24);
    const damage = {'L': 7, 'M': 8, 'H': 9};
    const ap = {'L': 2, 'M': 3, 'H': 4};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.code, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.optionalTraits, isEmpty, reason: 'check optional traits');
      });
    }
  });
  // FG
  group('test building FGs', () {
    const code = 'FG';
    const name = 'Field Gun';
    const modes = [weaponModes.Direct, weaponModes.Indirect];
    const range = Range(12, 24, 48);
    const damage = {'L': 9, 'M': 10, 'H': 11};
    const ap = {'L': 1, 'M': 2, 'H': 3};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
      ];
      final optionalTraits = [
        Trait(name: 'AE', level: 3),
        Trait(name: 'Blast'),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.code, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.optionalTraits.toString(), equals(optionalTraits.toString()),
            reason: 'check optional traits');
      });
    }
  });
  // FL
  group('test building FLs', () {
    const code = 'FL';
    const name = 'Flamer';
    const modes = [weaponModes.Direct];
    const range = Range(0, 6, 9);
    const damage = {'L': 3, 'M': 4, 'H': 5};
    const fire = {'L': 2, 'M': 3, 'H': 4};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AE', level: 3),
        Trait(name: 'AI'),
        Trait(name: 'Fire', level: fire[size]),
        Trait(name: 'Spray'),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.code, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.optionalTraits, isEmpty, reason: 'check optional traits');
      });
    }
  });
  // PL
  group('test building PLs', () {
    const code = 'PL';
    const name = 'Pulse Laser';
    const modes = [weaponModes.Direct];
    const range = Range(12, 24, 48);
    const damage = {'L': 7, 'M': 8, 'H': 9};
    const ap = {'L': 2, 'M': 4, 'H': 6};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
        Trait(name: 'Advanced'),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.code, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.optionalTraits, isEmpty, reason: 'check optional traits');
      });
    }
  });
  // PZ
  group('test building PZs', () {
    const code = 'PZ';
    const name = 'Panzerfaust';
    const modes = [weaponModes.Direct];
    const range = Range(3, 6, 9);
    const damage = {'L': 7, 'M': 8, 'H': 9};
    const ap = {'L': 2, 'M': 3, 'H': 4};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.code, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.optionalTraits, isEmpty, reason: 'check optional traits');
      });
    }
  });
  // RG
  group('test building RGs', () {
    const code = 'RG';
    const name = 'Railgun';
    const modes = [weaponModes.Direct];
    const range = Range(12, 36, 72);
    const damage = {'L': 7, 'M': 8, 'H': 9};
    const ap = {'L': 2, 'M': 4, 'H': 6};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
        Trait(name: 'Advanced')
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.code, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.optionalTraits, isEmpty, reason: 'check optional traits');
      });
    }
  });
  // SC
  group('test building SCs', () {
    const code = 'SC';
    const name = 'Snub Cannon';
    const modes = [weaponModes.Direct];
    const range = Range(3, 9, 18);
    const damage = {'L': 8, 'M': 9, 'H': 10};
    const ap = {'L': 2, 'M': 3, 'H': 4};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
        Trait(name: 'Demo', level: 3),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.code, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.optionalTraits, isEmpty, reason: 'check optional traits');
      });
    }
  });
  // SE
  group('test building SEs', () {
    const code = 'SE';
    const name = 'Shaped Explosives';
    const modes = [weaponModes.Melee];
    const range = Range(0, null, null, hasReach: true);
    const damage = {'L': 8, 'M': 9, 'H': 10};
    const ap = {'L': 2, 'M': 3, 'H': 4};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
        Trait(name: 'Demo', level: 4),
        Trait(name: 'Brawl', level: -1),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.code, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.optionalTraits, isEmpty, reason: 'check optional traits');
      });
    }
  });
  // SG
  group('test building SGs', () {
    const code = 'SG';
    const name = 'Spike Gun';
    const modes = [weaponModes.Melee];
    const range = Range(0, null, null, hasReach: true, increasableReach: true);
    const damage = {'L': 6, 'M': 7, 'H': 8};
    const ap = {'L': 2, 'M': 4, 'H': 6};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.code, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.optionalTraits, isEmpty, reason: 'check optional traits');
      });
    }
  });
  // TG
  group('test building TGs', () {
    const code = 'TG';
    const name = 'Tank Gun';
    const modes = [weaponModes.Direct];
    const range = Range(18, 36, 72);
    const damage = {'L': 9, 'M': 10, 'H': 11};
    const ap = {'L': 2, 'M': 3, 'H': 4};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
        Trait(name: 'Demo', level: 2),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.code, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.optionalTraits, isEmpty, reason: 'check optional traits');
      });
    }
  });
  // VB
  group('test building VBs', () {
    const code = 'VB';
    const name = 'Vibroblade';
    const modes = [weaponModes.Melee];
    const range = Range(0, null, null, hasReach: true, increasableReach: true);
    const damage = {'L': 7, 'M': 8, 'H': 9};
    const ap = {'L': 1, 'M': 3, 'H': 5};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.code, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.optionalTraits, isEmpty, reason: 'check optional traits');
      });
    }
  });

  group('test building weapons with unique bonus traits', () {
    final tt = TestTable(
      code: 'AAM',
      name: 'Anti-Air Missile',
      modes: [weaponModes.Direct, weaponModes.Indirect],
      range: Range(12, 36, 72),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [Trait(name: 'Flak'), Trait(name: 'Guided'), Trait(name: 'T')],
      bonusTraits: '(T)',
    );

    for (var size in _sizes) {
      test(
        'test building $size${tt.code}',
        () {
          final l = buildWeapon('$size${tt.code} ${tt.bonusTraits}');
          expect(l, isNotNull, reason: 'weapon should not be null');
          expect(l?.code, '$size${tt.code}', reason: 'check weapon code');
          expect(l?.name, equals(tt.name), reason: 'check name');
          expect(l?.modes, equals(tt.modes), reason: 'check modes');
          expect(l?.damage, equals(tt.damage[size]), reason: 'check damage');
          expect(l?.range.toString(), equals(tt.range.toString()),
              reason: 'check range');
          expect(l?.traits.toString(), equals(tt.traits.toString()),
              reason: 'check traits');
          expect(l?.optionalTraits.length, equals(tt.optionalTraits.length),
              reason: 'check traits');
          expect(l?.toString(), equals('$size${tt.code}'),
              reason: 'check toString');
        },
      );
    }
  });

  group('test building weapons with non-unique bonus traits', () {
    final tt = TestTable(
      code: 'AC',
      name: 'Autocannon',
      modes: [weaponModes.Direct],
      range: Range(6, 18, 36),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        Trait(name: 'Burst', level: 2),
        Trait(name: 'Split', level: 2),
      ],
      bonusTraits: '(Burst:2)',
    );

    for (var size in _sizes) {
      test(
        'test building $size${tt.code}',
        () {
          final l = buildWeapon('$size${tt.code} ${tt.bonusTraits}');
          expect(l, isNotNull, reason: 'weapon should not be null');
          expect(l?.code, '$size${tt.code}', reason: 'check weapon code');
          expect(l?.name, equals(tt.name), reason: 'check name');
          expect(l?.modes, equals(tt.modes), reason: 'check modes');
          expect(l?.damage, equals(tt.damage[size]), reason: 'check damage');
          expect(l?.range.toString(), equals(tt.range.toString()),
              reason: 'check range');
          expect(l?.traits.toString(), equals(tt.traits.toString()),
              reason: 'check traits');
          expect(l?.optionalTraits.length, equals(tt.optionalTraits.length),
              reason: 'check traits');
          expect(l?.toString(), equals('$size${tt.code}'),
              reason: 'check toString');
        },
      );
    }
  });

  test('test building combo weapon', () {
    final l = buildWeapon('LAC/LGL');
    expect(l, isNotNull, reason: 'weapon should not be null');
    expect(l?.code, equals('LAC'), reason: 'check weapon code');
    expect(l?.name, isNotNull, reason: 'check that name is not null');
    expect(l?.damage, isNot(equals(-1)), reason: 'check that damage is not -1');
    expect(l?.combo, isNotNull, reason: 'combo should not be null');
    expect(l?.combo?.damage, isNot(equals(-1)),
        reason: 'combo weapons damage should not be -1');
    expect(l?.combo?.code, equals('LGL'), reason: 'combo weapon name');
    expect(l?.toString(), equals('LAC/LGL'), reason: 'check toString');
  });

  test('test building combo weapon with bonus traits', () {
    final l = buildWeapon('LAC/LGL (Auto)');
    expect(l, isNotNull, reason: 'weapon should not be null');
    expect(l?.code, equals('LAC'), reason: 'check weapon code');
    expect(l?.name, isNotNull, reason: 'check that name is not null');
    expect(l?.damage, isNot(equals(-1)), reason: 'check that damage is not -1');
    expect(l?.combo, isNotNull, reason: 'combo should not be null');
    expect(l?.combo?.damage, isNot(equals(-1)),
        reason: 'combo weapons damage should not be -1');
    expect(l?.combo?.code, equals('LGL'), reason: 'combo weapon name');
    expect(l?.traits.last.toString(), equals(l?.combo?.traits.last.toString()),
        reason: 'compare main weapon traits with combo weapon traits');
    expect(l?.toString(), equals('LAC/LGL'), reason: 'check toString');
  });

  test('test building standard BB', () {
    final modes = [weaponModes.Direct];
    final range = Range(0, null, null);
    const damage = 8;
    final traits = [Trait(name: 'AE', level: 4)];
    const name = 'Bomb';

    final l = buildWeapon('BB');
    expect(l, isNotNull, reason: 'weapon should not be null');
    expect(l?.code, 'BB', reason: 'check weapon code');
    expect(l?.name, equals(name), reason: 'check name');
    expect(l?.modes, equals(modes), reason: 'check modes');
    expect(l?.damage, equals(damage), reason: 'check damage');
    expect(l?.range.toString(), equals(range.toString()),
        reason: 'check range');
    expect(l?.traits.toString(), equals(traits.toString()),
        reason: 'check traits');
  });

  test('test building non-existent type', () {
    final l = buildWeapon('zzzzzz');
    expect(l, isNull);
  });
}
