import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/weapons/range.dart';
import 'package:gearforce/v3/models/weapons/weapon_modes.dart';
import 'package:gearforce/v3/models/weapons/weapons.dart';
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
  final List<WeaponModes> modes;
  final Range range;
  final Map<String, int> damage;
  final List<Trait> traits;
  final List<Trait> optionalTraits;
  final String? bonusTraits;
}

void main() {
  test('test weapon combos', () {
    const weapon1 = 'LAC';
    const weapon2 = 'LAC/LGL';
    const weapon3 = 'HRC (Apex)/HVB';
    const weapon4 = 'LRC (AA)/HVB (Precise)';
    const weapon5 = 'MRC (Aux)/LVB (Precise Auto)';
    const weapon6 = 'HRC (T Aux)/HVB (Precise Auto)';
    const weapon7 = 'BB';

    final weaponList = [
      weapon1,
      weapon2,
      weapon3,
      weapon4,
      weapon5,
      weapon6,
      weapon7
    ];
    for (var w in weaponList) {
      final weapon = buildWeapon(w);
      expect(weapon.toString(), w);
    }
  });

  final testTables = [
    const TestTable(
      code: 'AAM',
      name: 'Anti-Air Missile',
      modes: [WeaponModes.direct, WeaponModes.indirect],
      range: Range(12, 36, 72),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [Trait(name: 'Flak'), Trait(name: 'Guided')],
    ),
    const TestTable(
      code: 'ABM',
      name: 'Air Burst Missile',
      modes: [WeaponModes.indirect],
      range: Range(24, 48, 96),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        Trait(name: 'AI'),
        Trait(name: 'AOE', level: 3),
        Trait(name: 'Blast'),
        Trait(name: 'Guided'),
      ],
    ),
    const TestTable(
      code: 'AVM',
      name: 'Anti-Vehicle Missile',
      modes: [WeaponModes.direct, WeaponModes.indirect],
      range: Range(6, 18, 36),
      damage: {'L': 5, 'M': 6, 'H': 7},
      traits: [
        Trait(name: 'AP', level: 1),
        Trait(name: 'Guided'),
      ],
    ),
    const TestTable(
      code: 'CW',
      name: 'Combat Weapon',
      modes: [WeaponModes.melee],
      range: Range(0, null, null, hasReach: true, increasableReach: true),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [Trait(name: 'Demo', level: 2)],
    ),
    const TestTable(
      code: 'FM',
      name: 'Field Mortar',
      modes: [WeaponModes.indirect],
      range: Range(18, 36, 72),
      damage: {'L': 8, 'M': 9, 'H': 10},
      traits: [
        Trait(name: 'AOE', level: 4),
        Trait(name: 'Blast'),
      ],
    ),
    const TestTable(
      code: 'GM',
      name: 'Guided Mortar',
      modes: [WeaponModes.indirect],
      range: Range(18, 36, 72),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [
        Trait(name: 'AOE', level: 3),
        Trait(name: 'Blast'),
        Trait(name: 'Guided'),
      ],
    ),
    const TestTable(
      code: 'HG',
      name: 'Hand Grenade',
      modes: [WeaponModes.direct, WeaponModes.indirect],
      range: Range(3, 6, 9),
      damage: {'L': 8, 'M': 9, 'H': 10},
      traits: [
        Trait(name: 'AOE', level: 3),
        Trait(name: 'Blast'),
        Trait(name: 'AP', level: 1),
      ],
    ),
    const TestTable(
      code: 'ICW',
      name: 'Infantry Combat Weapon',
      modes: [WeaponModes.melee],
      range: Range(0, null, null, hasReach: true, increasableReach: true),
      damage: {'L': 4, 'M': 5, 'H': 6},
      traits: [
        Trait(name: 'AI'),
      ],
    ),
    const TestTable(
      code: 'IGL',
      name: 'Infantry Grenade Launcher',
      modes: [WeaponModes.direct, WeaponModes.indirect],
      range: Range(3, 9, 18),
      damage: {'L': 5, 'M': 6, 'H': 7},
      traits: [
        Trait(name: 'AOE', level: 2),
        Trait(name: 'Blast'),
      ],
      optionalTraits: [
        Trait(name: 'AP', level: 1),
      ],
    ),
    const TestTable(
      code: 'IL',
      name: 'Infantry Laser',
      modes: [WeaponModes.direct],
      range: Range(6, 18, 36),
      damage: {'L': 3, 'M': 4, 'H': 5},
      traits: [
        Trait(name: 'AI'),
        Trait(name: 'Advanced'),
        Trait(name: 'Burst', level: 1),
      ],
    ),
    const TestTable(
      code: 'IM',
      name: 'Infantry Mortar',
      modes: [WeaponModes.indirect],
      range: Range(12, 24, 48),
      damage: {'L': 4, 'M': 5, 'H': 6},
      traits: [
        Trait(name: 'AOE', level: 2),
        Trait(name: 'Blast'),
        Trait(name: 'AI'),
      ],
    ),
    const TestTable(
      code: 'IR',
      name: 'Infantry Rifle',
      modes: [WeaponModes.direct],
      range: Range(6, 24, 48),
      damage: {'L': 4, 'M': 5, 'H': 6},
      traits: [
        Trait(name: 'Precise'),
        Trait(name: 'AI'),
      ],
    ),
    const TestTable(
      code: 'IS',
      name: 'Infantry Support Weapon',
      modes: [WeaponModes.direct],
      range: Range(6, 18, 36),
      damage: {'L': 4, 'M': 5, 'H': 6},
      traits: [],
    ),
    const TestTable(
      code: 'IW',
      name: 'Infantry Weapon',
      modes: [WeaponModes.direct],
      range: Range(0, 9, 18),
      damage: {'L': 3, 'M': 4, 'H': 5},
      traits: [
        Trait(name: 'AI'),
        Trait(name: 'Burst', level: 1),
      ],
    ),
    const TestTable(
      code: 'LC',
      name: 'Laser Cannon',
      modes: [WeaponModes.direct],
      range: Range(12, 36, 72),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        Trait(name: 'Precise'),
        Trait(name: 'Advanced'),
      ],
    ),
    const TestTable(
      code: 'MG',
      name: 'Machine Gun',
      modes: [WeaponModes.direct],
      range: Range(3, 9, 18),
      damage: {'L': 3, 'M': 4, 'H': 5},
      traits: [
        Trait(name: 'AI'),
        Trait(name: 'Burst', level: 2),
        Trait(name: 'Split'),
      ],
    ),
    const TestTable(
      code: 'P',
      name: 'Pistol',
      modes: [WeaponModes.direct],
      range: Range(0, 12, 24),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        Trait(name: 'Precise'),
      ],
    ),
    const TestTable(
      code: 'PA',
      name: 'Particle Accelerator',
      modes: [WeaponModes.direct],
      range: Range(6, 24, 48),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [
        Trait(name: 'Haywire'),
        Trait(name: 'Advanced'),
      ],
    ),
    const TestTable(
      code: 'RC',
      name: 'Rotary Cannon',
      modes: [WeaponModes.direct],
      range: Range(6, 18, 36),
      damage: {'L': 5, 'M': 6, 'H': 7},
      traits: [
        Trait(name: 'Burst', level: 2),
        Trait(name: 'Split'),
      ],
    ),
    const TestTable(
      code: 'RF',
      name: 'Rifle',
      modes: [WeaponModes.direct],
      range: Range(12, 36, 72),
      damage: {'L': 6, 'M': 7, 'H': 8},
      traits: [
        Trait(name: 'Precise'),
      ],
    ),
    const TestTable(
      code: 'RP',
      name: 'Rocket Pack',
      modes: [WeaponModes.direct, WeaponModes.indirect],
      range: Range(6, 18, 36),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [
        Trait(name: 'AOE', level: 3),
        Trait(name: 'AP', level: 1),
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
    const modes = [WeaponModes.direct, WeaponModes.indirect];
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
    const modes = [WeaponModes.direct];
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
    const modes = [WeaponModes.direct, WeaponModes.indirect];
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
    const modes = [WeaponModes.direct];
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
    const modes = [WeaponModes.direct];
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
    const modes = [WeaponModes.direct];
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
    const modes = [WeaponModes.melee];
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
    const modes = [WeaponModes.melee];
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
    const modes = [WeaponModes.direct];
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
    const modes = [WeaponModes.melee];
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
    const modes = [WeaponModes.melee];
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
    const tt = TestTable(
      code: 'AAM',
      name: 'Anti-Air Missile',
      modes: [WeaponModes.direct, WeaponModes.indirect],
      range: Range(12, 36, 72),
      damage: {'L': 7, 'M': 8, 'H': 9},
      traits: [
        Trait(name: 'Flak'),
        Trait(name: 'Guided'),
        Trait(name: 'T'),
        Trait(name: 'Auto'),
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
    final modes = [WeaponModes.direct];
    const range = Range(0, null, null);
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
