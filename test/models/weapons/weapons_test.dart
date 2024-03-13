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
  test('test weapon combos', () {
    final weapon1 = 'LAC';
    final weapon2 = 'LAC/LGL';
    final weapon3 = 'HRC (Apex)/HVB';
    final weapon4 = 'LRC (AA)/HVB (Precise)';
    final weapon5 = 'MRC (Aux)/LVB (Precise Auto)';
    final weapon6 = 'HRC (T Aux)/HVB (Precise Auto)';
    final weapon7 = 'BB';

    final weaponList = [
      weapon1,
      weapon2,
      weapon3,
      weapon4,
      weapon5,
      weapon6,
      weapon7
    ];
    weaponList.forEach((w) {
      final weapon = buildWeapon(w);
      expect(weapon.toString(), w);
    });
  });

  final testTables = [
    TestTable(
      code: 'AAM',
      name: 'Anti-Air Missile',
      modes: [weaponModes.Direct, weaponModes.Indirect],
      range: Range(12, 36, 72),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [const Trait(name: 'Flak'), const Trait(name: 'Guided')],
    ),
    TestTable(
      code: 'ABM',
      name: 'Air Burst Missile',
      modes: [weaponModes.Indirect],
      range: Range(24, 48, 96),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        const Trait(name: 'AI'),
        const Trait(name: 'AOE', level: 3),
        const Trait(name: 'Blast'),
        const Trait(name: 'Guided'),
      ],
    ),
    TestTable(
      code: 'AVM',
      name: 'Anti-Vehicle Missile',
      modes: [weaponModes.Direct, weaponModes.Indirect],
      range: Range(6, 18, 36),
      damage: {'L': 5, 'M': 6, 'H': 7},
      traits: [
        const Trait(name: 'AP', level: 1),
        const Trait(name: 'Guided'),
      ],
    ),
    TestTable(
      code: 'CW',
      name: 'Combat Weapon',
      modes: [weaponModes.Melee],
      range: Range(0, null, null, hasReach: true, increasableReach: true),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [const Trait(name: 'Demo', level: 2)],
    ),
    TestTable(
      code: 'FM',
      name: 'Field Mortar',
      modes: [weaponModes.Indirect],
      range: Range(18, 36, 72),
      damage: {'L': 8, 'M': 9, 'H': 10},
      traits: [
        const Trait(name: 'AOE', level: 4),
        const Trait(name: 'Blast'),
      ],
    ),
    TestTable(
      code: 'GM',
      name: 'Guided Mortar',
      modes: [weaponModes.Indirect],
      range: Range(18, 36, 72),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [
        const Trait(name: 'AOE', level: 3),
        const Trait(name: 'Blast'),
        const Trait(name: 'Guided'),
      ],
    ),
    TestTable(
      code: 'HG',
      name: 'Hand Grenade',
      modes: [weaponModes.Direct, weaponModes.Indirect],
      range: Range(3, 6, 9),
      damage: {'L': 8, 'M': 9, 'H': 10},
      traits: [
        const Trait(name: 'AOE', level: 3),
        const Trait(name: 'Blast'),
        const Trait(name: 'AP', level: 1),
      ],
    ),
    TestTable(
      code: 'ICW',
      name: 'Infantry Combat Weapon',
      modes: [weaponModes.Melee],
      range: Range(0, null, null, hasReach: true, increasableReach: true),
      damage: {'L': 4, 'M': 5, 'H': 6},
      traits: [
        const Trait(name: 'AI'),
      ],
    ),
    TestTable(
      code: 'IGL',
      name: 'Infantry Grenade Launcher',
      modes: [weaponModes.Direct, weaponModes.Indirect],
      range: Range(3, 9, 18),
      damage: {'L': 5, 'M': 6, 'H': 7},
      traits: [
        const Trait(name: 'AOE', level: 2),
        const Trait(name: 'Blast'),
      ],
      optionalTraits: [
        const Trait(name: 'AP', level: 1),
      ],
    ),
    TestTable(
      code: 'IL',
      name: 'Infantry Laser',
      modes: [weaponModes.Direct],
      range: Range(6, 18, 36),
      damage: {'L': 3, 'M': 4, 'H': 5},
      traits: [
        const Trait(name: 'AI'),
        const Trait(name: 'Advanced'),
        const Trait(name: 'Burst', level: 1),
      ],
    ),
    TestTable(
      code: 'IM',
      name: 'Infantry Mortar',
      modes: [weaponModes.Indirect],
      range: Range(12, 24, 48),
      damage: {'L': 4, 'M': 5, 'H': 6},
      traits: [
        const Trait(name: 'AOE', level: 2),
        const Trait(name: 'Blast'),
        const Trait(name: 'AI'),
      ],
    ),
    TestTable(
      code: 'IR',
      name: 'Infantry Rifle',
      modes: [weaponModes.Direct],
      range: Range(6, 24, 48),
      damage: {'L': 4, 'M': 5, 'H': 6},
      traits: [
        const Trait(name: 'Precise'),
        const Trait(name: 'AI'),
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
        const Trait(name: 'AI'),
        const Trait(name: 'Burst', level: 1),
      ],
    ),
    TestTable(
      code: 'LC',
      name: 'Laser Cannon',
      modes: [weaponModes.Direct],
      range: Range(12, 36, 72),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        const Trait(name: 'Precise'),
        const Trait(name: 'Advanced'),
      ],
    ),
    TestTable(
      code: 'MG',
      name: 'Machine Gun',
      modes: [weaponModes.Direct],
      range: Range(3, 9, 18),
      damage: {'L': 3, 'M': 4, 'H': 5},
      traits: [
        const Trait(name: 'AI'),
        const Trait(name: 'Burst', level: 2),
        const Trait(name: 'Split'),
      ],
    ),
    TestTable(
      code: 'P',
      name: 'Pistol',
      modes: [weaponModes.Direct],
      range: Range(0, 12, 24),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        const Trait(name: 'Precise'),
      ],
    ),
    TestTable(
      code: 'PA',
      name: 'Particle Accelerator',
      modes: [weaponModes.Direct],
      range: Range(6, 24, 48),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [
        const Trait(name: 'Haywire'),
        const Trait(name: 'Advanced'),
      ],
    ),
    TestTable(
      code: 'RC',
      name: 'Rotary Cannon',
      modes: [weaponModes.Direct],
      range: Range(6, 18, 36),
      damage: {'L': 5, 'M': 6, 'H': 7},
      traits: [
        const Trait(name: 'Burst', level: 2),
        const Trait(name: 'Split'),
      ],
    ),
    TestTable(
      code: 'RF',
      name: 'Rifle',
      modes: [weaponModes.Direct],
      range: Range(12, 36, 72),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        const Trait(name: 'Precise'),
      ],
    ),
    TestTable(
      code: 'RP',
      name: 'Rocket Pack',
      modes: [weaponModes.Direct, weaponModes.Indirect],
      range: Range(6, 18, 36),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [
        const Trait(name: 'AOE', level: 3),
        const Trait(name: 'AP', level: 1),
      ],
    ),
  ];
  for (var tt in testTables) {
    group('test building ${tt.code}s', () {
      for (var size in _sizes) {
        test('test building $size${tt.code}', () {
          final l = buildWeapon('$size${tt.code}');
          expect(l, isNotNull, reason: 'weapon should not be null');
          expect(l?.abbreviation, '$size${tt.code}',
              reason: 'check weapon code');
          expect(l?.name, equals(tt.name), reason: 'check name');
          expect(l?.modes, equals(tt.modes), reason: 'check modes');
          expect(l?.damage, equals(tt.damage[size]), reason: 'check damage');
          expect(l?.range.toString(), equals(tt.range.toString()),
              reason: 'check range');
          expect(l?.traits.toString(), equals(tt.traits.toString()),
              reason: 'check traits');
          expect(
              l?.baseAlternativeTraits.length, equals(tt.optionalTraits.length),
              reason: 'check traits');
          expect(l?.toString(), equals('$size${tt.code}'),
              reason: 'check toString');
        });
      }
    });
  }

  // Weapons to test that have traits with variable values
  // ATM
  group('test building ATM', () {
    const code = 'ATM';
    const name = 'Anti-Tank Missile';
    const modes = [weaponModes.Direct, weaponModes.Indirect];
    const range = Range(12, 36, 72);
    const damage = {'L': 8, 'M': 9, 'H': 10};
    const ap = {'L': 2, 'M': 3, 'H': 4};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
        const Trait(name: 'Guided'),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.abbreviation, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.baseAlternativeTraits, isEmpty,
            reason: 'check optional traits');
      });
    }
  });
  // BZ
  group('test building BZ', () {
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
        expect(l?.abbreviation, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.baseAlternativeTraits, isEmpty,
            reason: 'check optional traits');
      });
    }
  });
  // FG
  group('test building FG', () {
    const code = 'FG';
    const name = 'Field Gun';
    const modes = [weaponModes.Direct, weaponModes.Indirect];
    const range = Range(12, 24, 48);
    const damage = {'L': 9, 'M': 10, 'H': 11};
    const ap = {'L': 3, 'M': 4, 'H': 5};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
      ];
      final optionalTraits = [
        const Trait(name: 'AOE', level: 3),
        const Trait(name: 'Blast'),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.abbreviation, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.baseAlternativeTraits.toString(),
            equals(optionalTraits.toString()),
            reason: 'check optional traits');
      });
    }
  });

  // PZ
  group('test building PZ', () {
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
        expect(l?.abbreviation, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.baseAlternativeTraits, isEmpty,
            reason: 'check optional traits');
      });
    }
  });
  // RG
  group('test building RG', () {
    const code = 'RG';
    const name = 'Railgun';
    const modes = [weaponModes.Direct];
    const range = Range(12, 48, 96);
    const damage = {'L': 4, 'M': 5, 'H': 6};
    const ap = {'L': 4, 'M': 5, 'H': 6};
    for (var size in _sizes) {
      final traits = [
        const Trait(name: 'Precise'),
        const Trait(name: 'Advanced'),
        Trait(name: 'AP', level: ap[size]),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.abbreviation, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.baseAlternativeTraits, isEmpty,
            reason: 'check optional traits');
      });
    }
  });
  // SC
  group('test building SC', () {
    const code = 'SC';
    const name = 'Snub Cannon';
    const modes = [weaponModes.Direct];
    const range = Range(3, 9, 18);
    const damage = {'L': 8, 'M': 9, 'H': 10};
    const ap = {'L': 2, 'M': 3, 'H': 4};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
        const Trait(name: 'Demo', level: 3),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.abbreviation, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.baseAlternativeTraits, isEmpty,
            reason: 'check optional traits');
      });
    }
  });
  // SE
  group('test building SE', () {
    const code = 'SE';
    const name = 'Shaped Explosives';
    const modes = [weaponModes.Melee];
    const range = Range(0, null, null, hasReach: true);
    const damage = {'L': 8, 'M': 9, 'H': 10};
    const ap = {'L': 2, 'M': 3, 'H': 4};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
        const Trait(name: 'Demo', level: 4),
        const Trait(name: 'Brawl', level: -1),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.abbreviation, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.baseAlternativeTraits, isEmpty,
            reason: 'check optional traits');
      });
    }
  });
  // SG
  group('test building SG', () {
    const code = 'SG';
    const name = 'Spike Gun';
    const modes = [weaponModes.Melee];
    const range = Range(0, null, null, hasReach: true, increasableReach: true);
    const damage = {'L': 6, 'M': 7, 'H': 8};
    const ap = {'L': 3, 'M': 4, 'H': 5};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.abbreviation, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.baseAlternativeTraits, isEmpty,
            reason: 'check optional traits');
      });
    }
  });
  // TG
  group('test building TG', () {
    const code = 'TG';
    const name = 'Tank Gun';
    const modes = [weaponModes.Direct];
    const range = Range(12, 36, 72);
    const damage = {'L': 9, 'M': 10, 'H': 11};
    const ap = {'L': 3, 'M': 4, 'H': 5};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
        const Trait(name: 'Demo', level: 2),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.abbreviation, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.baseAlternativeTraits, isEmpty,
            reason: 'check optional traits');
      });
    }
  });
  // VB
  group('test building VB', () {
    const code = 'VB';
    const name = 'Vibroblade';
    const modes = [weaponModes.Melee];
    const range = Range(0, null, null, hasReach: true, increasableReach: true);
    const damage = {'L': 7, 'M': 8, 'H': 9};
    const ap = {'L': 2, 'M': 3, 'H': 4};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
      ];
      test('test building $size$code', () {
        final l = buildWeapon('$size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.abbreviation, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.baseAlternativeTraits, isEmpty,
            reason: 'check optional traits');
      });
    }
  });

  group('test building 2 x VB', () {
    const code = 'VB';
    const name = 'Vibroblade';
    const modes = [weaponModes.Melee];
    const range = Range(0, null, null, hasReach: true, increasableReach: true);
    const damage = {'L': 7, 'M': 8, 'H': 9};
    const ap = {'L': 2, 'M': 3, 'H': 4};
    for (var size in _sizes) {
      final traits = [
        Trait(name: 'AP', level: ap[size]),
      ];
      test('test building 2 X $size$code', () {
        final l = buildWeapon('2 X $size$code');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.abbreviation, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.baseAlternativeTraits, isEmpty,
            reason: 'check optional traits');
        expect(l?.toString(), equals('2 X $size$code'),
            reason: 'toString check');
      });
      test('test building 2 X $size${code}s', () {
        final l = buildWeapon('2 X $size${code}s');
        expect(l, isNotNull, reason: 'weapon should not be null');
        expect(l?.abbreviation, '$size$code', reason: 'check weapon code');
        expect(l?.name, equals(name), reason: 'check name');
        expect(l?.modes, equals(modes), reason: 'check modes');
        expect(l?.damage, equals(damage[size]), reason: 'check damage');
        expect(l?.range.toString(), equals(range.toString()),
            reason: 'check range');
        expect(l?.traits.toString(), equals(traits.toString()),
            reason: 'check traits');
        expect(l?.baseAlternativeTraits, isEmpty,
            reason: 'check optional traits');
        expect(l?.toString(), equals('2 X $size$code'),
            reason: 'toString check');
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
      traits: [
        const Trait(name: 'Flak'),
        const Trait(name: 'Guided'),
        const Trait(name: 'T'),
        const Trait(name: 'Auto'),
      ],
      bonusTraits: '(T Auto)',
    );

    for (var size in _sizes) {
      test(
        'test building $size${tt.code}',
        () {
          final l = buildWeapon('$size${tt.code} ${tt.bonusTraits}');
          expect(l, isNotNull, reason: 'weapon should not be null');
          expect(l?.abbreviation, '$size${tt.code}',
              reason: 'check weapon code');
          expect(l?.name, equals(tt.name), reason: 'check name');
          expect(l?.modes, equals(tt.modes), reason: 'check modes');
          expect(l?.damage, equals(tt.damage[size]), reason: 'check damage');
          expect(l?.range.toString(), equals(tt.range.toString()),
              reason: 'check range');
          expect(l?.traits.toString(), equals(tt.traits.toString()),
              reason: 'check traits');
          expect(
              l?.baseAlternativeTraits.length, equals(tt.optionalTraits.length),
              reason: 'check traits');
          expect(l?.toString(), equals('$size${tt.code} ${tt.bonusTraits}'),
              reason: 'check toString');
        },
      );
    }
  });

  test('test building combo weapon', () {
    final l = buildWeapon('LAC/LGL');
    expect(l, isNotNull, reason: 'weapon should not be null');
    expect(l?.abbreviation, equals('LAC'), reason: 'check weapon code');
    expect(l?.name, isNotNull, reason: 'check that name is not null');
    expect(l?.damage, isNot(equals(-1)), reason: 'check that damage is not -1');
    expect(l?.combo, isNotNull, reason: 'combo should not be null');
    expect(l?.combo?.damage, isNot(equals(-1)),
        reason: 'combo weapons damage should not be -1');
    expect(l?.combo?.abbreviation, equals('LGL'), reason: 'combo weapon name');
    expect(l?.toString(), equals('LAC/LGL'), reason: 'check toString');
  });

  test('test building combo weapon with bonus traits', () {
    final l = buildWeapon('LAC/LGL (Auto)');
    expect(l, isNotNull, reason: 'weapon should not be null');
    expect(l?.abbreviation, equals('LAC'), reason: 'check weapon code');
    expect(l?.name, isNotNull, reason: 'check that name is not null');
    expect(l?.damage, isNot(equals(-1)), reason: 'check that damage is not -1');
    expect(l?.combo, isNotNull, reason: 'combo should not be null');
    expect(l?.combo?.damage, isNot(equals(-1)),
        reason: 'combo weapons damage should not be -1');
    expect(l?.combo?.abbreviation, equals('LGL'), reason: 'combo weapon name');
    expect(l?.toString(), equals('LAC/LGL (Auto)'), reason: 'check toString');
  });

  test('test building standard LB', () {
    final modes = [weaponModes.Direct];
    final range = Range(0, null, null);
    const damage = 8;
    final traits = [const Trait(name: 'AOE', level: 4)];
    const name = 'Bomb';

    final l = buildWeapon('LB');
    expect(l, isNotNull, reason: 'weapon should not be null');
    expect(l?.abbreviation, 'LB', reason: 'check weapon code');
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
