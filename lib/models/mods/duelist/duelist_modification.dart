import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';
import 'package:gearforce/models/weapons/weapons.dart';

const duelistId = 'duelist';
const independentOperatorId = 'duelist: independent';
const aceGunnerId = 'duelist: ace gunner';
const advancedControlSystemId = 'duelist: advanced control system';
const crackShotId = 'duelist: crack shot';
const defenderId = 'duelist: defender';
const dualWieldId = 'duelist: dual wield';
const gunslingerId = 'duelist: gunslinger';
const lungeId = 'duelist: lunge';
const pushTheEnvelopeId = 'duelist: push the envelope';
const quickDrawId = 'duelist: quickdraw';
const shieldBearerId = 'duelist: shield bearer';
const smashFestId = 'duelist: smash fest';

class DuelistModification extends BaseModification {
  DuelistModification({
    required String name,
    required String id,
    this.requirementCheck = _defaultRequirementsFunction,
    this.unit,
    this.roster,
    final ModificationOption? options,
  }) : super(name: name, id: id, options: options);

  // function to ensure the modification can be applied to the unit
  final bool Function() requirementCheck;
  final Unit? unit;
  final UnitRoster? roster;

  static bool _defaultRequirementsFunction() => true;

  factory DuelistModification.makeDuelist(Unit u, UnitRoster roster) {
    final traits = u.traits.toList();
    final isVet =
        traits.any((element) => element.name == 'Vet') || u.hasMod(veteranId);
    var mod = DuelistModification(
        name: 'Duelist Upgrade',
        id: duelistId,
        requirementCheck: () {
          if (u.hasMod(duelistId)) {
            return false;
          }

          if (u.type != 'Gear') {
            return false;
          }

          for (final cg in roster.getCGs()) {
            if (cg.hasDuelist()) {
              return false;
            }
          }

          return !traits.any((trait) => trait.name == 'Duelist');
        });
    mod.addMod(
      UnitAttribute.tv,
      (value) {
        return createSimpleIntMod(
          u.core.traits.any((trait) => trait.name == 'Vet') ||
                  u.hasMod(veteranId)
              ? 0
              : 2,
        )(value);
      },
      description: 'TV +${isVet ? 0 : 2}',
    );
    mod.addMod(
      UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'Duelist')),
      description: '+Duelist',
    );

    mod.addMod(
      UnitAttribute.traits,
      createAddTraitToList(Trait(name: 'Vet')),
      description: '+Vet',
    );

    return mod;
  }

  factory DuelistModification.independentOperator(Unit u, UnitRoster roster) {
    return DuelistModification(
        name: 'Independent Operator',
        id: independentOperatorId,
        requirementCheck: () {
          if (u.hasMod(independentOperatorId)) {
            return false;
          }

          return u.isDuelist;
        })
      ..addMod(
        UnitAttribute.traits,
        createAddTraitToList(Trait(name: 'Independent Operator')),
        description:
            'Duelist is an Independent Operator and will be the sole ' +
                'model in a combat group',
      );
  }

  /*
  ACE GUNNER 2–3 TV
  Add the Stable trait to any one weapon for 2 TV. Or, add
  the Stable trait to a combo weapon for 3 TV.
  */
  factory DuelistModification.aceGunner(Unit u) {
    final react = u.reactWeapons;
    final mounted = u.mountedWeapons;
    final List<ModificationOption> _options = [];
    const traitToAdd = Trait(name: 'Stable');

    final allWeapons = react.toList()..addAll(mounted);
    allWeapons.forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Ace Gunner',
        subOptions: _options,
        description: 'Choose a weapon to gain the Stable trait.');

    final mod = DuelistModification(
        name: 'Ace Gunner',
        id: aceGunnerId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(aceGunnerId)) {
            return false;
          }
          return u.isDuelist;
        })
      ..addMod(UnitAttribute.tv, (value) {
        if (!(value is int)) {
          return value;
        }

        return value +
            _comboNotComboCost(modOptions.selectedOption,
                comboCost: 3, nonComboCost: 2);
      },
          description:
              'TV +2/3, Add Stable to a weapon for TV +3 for combo weapons or +2 for regular weapons')
      ..addMod(UnitAttribute.react_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }
        final newList = value;

        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text &&
                weapon.hasReact)) {
          var existingWeapon = newList.firstWhere((weapon) =>
              weapon.toString() == modOptions.selectedOption?.text &&
              weapon.hasReact);
          existingWeapon.bonusTraits.add(traitToAdd);
        }
        return newList;
      })
      ..addMod(UnitAttribute.mounted_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }
        final newList = value;

        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text &&
                !weapon.hasReact)) {
          var existingWeapon = newList.firstWhere((weapon) =>
              weapon.toString() == modOptions.selectedOption?.text &&
              !weapon.hasReact);
          existingWeapon.bonusTraits.add(traitToAdd);
        }
        return newList;
      });

    return mod;
  }

  /*
  ADVANCED CONTROL SYSTEM 3 TV
  Gain +1 action point. All models have a maximum of
  3 actions.
  */
  factory DuelistModification.advancedControlSystem(Unit u) {
    return DuelistModification(
        name: 'Advanced Control System',
        id: advancedControlSystemId,
        requirementCheck: () {
          if (u.hasMod(advancedControlSystemId)) {
            return false;
          }

          if (u.actions != null && u.actions! >= 3) {
            return false;
          }
          return u.isDuelist;
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
      ..addMod(UnitAttribute.actions, (value) {
        if (!(value is int)) {
          return value;
        }
        if (value >= 3) {
          return value;
        }
        return value + 1;
      },
          description:
              'Gain +1 action point. All models have a maximum of 3 actions');
  }

  /*
  CRACK SHOT 2–3 TV
  Add the Precise trait to any one weapon for 2 TV. Or,
  add the Precise trait to a combo weapon for 3 TV.
  */
  factory DuelistModification.crackShot(Unit u) {
    final react = u.reactWeapons;
    final mounted = u.mountedWeapons;
    final List<ModificationOption> _options = [];
    const traitToAdd = Trait(name: 'Precise');

    final allWeapons = react.toList()..addAll(mounted);
    allWeapons.forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Crack Shot',
        subOptions: _options,
        description: 'Choose a weapon to gain the Precise trait.');

    final mod = DuelistModification(
        name: 'Crack Shot',
        id: crackShotId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(crackShotId)) {
            return false;
          }
          return u.isDuelist;
        })
      ..addMod(UnitAttribute.tv, (value) {
        if (!(value is int)) {
          return value;
        }

        return value +
            _comboNotComboCost(modOptions.selectedOption,
                comboCost: 3, nonComboCost: 2);
      },
          description:
              'TV +2/3, Add Precise to a weapon for TV +3 for combo weapons or +2 for regular weapons')
      ..addMod(UnitAttribute.react_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }
        final newList = value;

        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text &&
                weapon.hasReact)) {
          var existingWeapon = newList.firstWhere((weapon) =>
              weapon.toString() == modOptions.selectedOption?.text &&
              weapon.hasReact);
          existingWeapon.bonusTraits.add(traitToAdd);
        }
        return newList;
      })
      ..addMod(UnitAttribute.mounted_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }
        final newList = value;

        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text &&
                !weapon.hasReact)) {
          var existingWeapon = newList.firstWhere((weapon) =>
              weapon.toString() == modOptions.selectedOption?.text &&
              !weapon.hasReact);
          existingWeapon.bonusTraits.add(traitToAdd);
        }
        return newList;
      });

    return mod;
  }

  /*
  DEFENDER 1 TV
  Add the Anti-Missile System (AMS) trait to any weapon
  with the Frag or Burst trait.
  */
  factory DuelistModification.defender(Unit u) {
    final react = u.reactWeapons;
    final mounted = u.mountedWeapons;
    final List<ModificationOption> _options = [];
    const traitToAdd = Trait(name: 'AMS');

    final allWeapons = react.toList()..addAll(mounted);
    allWeapons
        .where((weapon) =>
            weapon.traits.any((trait) => trait.name == 'Frag') ||
            weapon.traits.any((trait) => trait.name == 'Burst'))
        .forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Defender',
        subOptions: _options,
        description:
            'Choose an available weapon to gain the Anti-Missile System (AMS)' +
                ' trait');
    return DuelistModification(
        name: 'Defender',
        id: defenderId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(defenderId)) {
            return false;
          }
          return u.isDuelist;
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1),
          description:
              'TV +1, Add the Anti-Missile System (AMS) trait to any weapon ' +
                  'with the Frag or Burst trait.')
      ..addMod(UnitAttribute.react_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }
        final newList = value;

        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text &&
                weapon.hasReact)) {
          var existingWeapon = newList.firstWhere((weapon) =>
              weapon.toString() == modOptions.selectedOption?.text &&
              weapon.hasReact);
          existingWeapon.bonusTraits.add(traitToAdd);
        }
        return newList;
      })
      ..addMod(UnitAttribute.mounted_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }
        final newList = value;

        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text &&
                !weapon.hasReact)) {
          var existingWeapon = newList.firstWhere((weapon) =>
              weapon.toString() == modOptions.selectedOption?.text &&
              !weapon.hasReact);
          existingWeapon.bonusTraits.add(traitToAdd);
        }
        return newList;
      });
  }

  /*
  DUAL WIELD 1 TV
  Add the Link trait to any melee weapon other than
  Shaped Explosives. This adds a second weapon of the
  same type to the model. For example, a linked medium
  vibroblade becomes two medium vibroblades (ideally
  one in each hand).
  */
  factory DuelistModification.dualWield(Unit u) {
    final RegExp meleeCheck = RegExp(r'(VB|CW)');
    final react = u.reactWeapons;
    final mounted = u.mountedWeapons;
    final List<ModificationOption> _options = [];
    const traitToAdd = Trait(name: 'Link');

    final allWeapons = react.toList()..addAll(mounted);
    allWeapons
        .where((weapon) => meleeCheck.hasMatch(weapon.code))
        .forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Dual Wield',
        subOptions: _options,
        description: 'Choose a melee weapon to have the Link trait added');

    return DuelistModification(
        name: 'Dual Wield',
        id: dualWieldId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(dualWieldId)) {
            return false;
          }
          return u.isDuelist;
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1),
          description:
              'TV +1, Add the Link trait to any melee weapon other than ' +
                  'Shaped Explosives. This adds a second weapon of the ' +
                  'same type to the model.')
      ..addMod(UnitAttribute.react_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }
        final newList =
            value.map((weapon) => Weapon.fromWeapon(weapon)).toList();
        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text &&
                weapon.hasReact)) {
          var existingWeapon = newList.firstWhere((weapon) =>
              weapon.toString() == modOptions.selectedOption?.text &&
              weapon.hasReact);
          existingWeapon.bonusTraits.add(traitToAdd);
        }
        return newList;
      })
      ..addMod(UnitAttribute.mounted_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }
        final newList = value;

        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text &&
                !weapon.hasReact)) {
          var existingWeapon = newList.firstWhere((weapon) =>
              weapon.toString() == modOptions.selectedOption?.text &&
              !weapon.hasReact);
          existingWeapon.bonusTraits.add(traitToAdd);
        }
        return newList;
      });
  }

  /*
  GUNSLINGER 1–2 TV
  Add the Link trait to one Pistol, Submachine Gun,
  Autocannon, Frag Cannon, Flamer or Grenade
  Launcher with the React trait for 1 TV. Or add the Link
  trait to a combo weapon with the React trait for 2 TV.
  For modeling purposes, this adds a second weapon of
  the same type to the model. For example, a LAC with
  the Link trait is represented on the miniature as 2 X
  LACs (ideally one in each hand).
  */
  factory DuelistModification.gunslinger(Unit u) {
    final RegExp weaponCheck = RegExp(r'^(P|SMG|AC|FC|FL|GL)');
    final react = u.reactWeapons;
    final List<ModificationOption> _options = [];
    const traitToAdd = Trait(name: 'Link');

    final allWeapons = react.toList();
    allWeapons
        .where((weapon) => weaponCheck.hasMatch(weapon.code) || weapon.isCombo)
        .forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Gunslinger',
        subOptions: _options,
        description: 'Add the Link trait to one Pistol, Submachine Gun, ' +
            'Autocannon, Frag Cannon, Flamer or Grenade ' +
            'Launcher with the React trait for 1 TV. Or add the Link' +
            'trait to a combo weapon with the React trait for 2 TV.');

    return DuelistModification(
        name: 'Gunslinger',
        id: gunslingerId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(gunslingerId)) {
            return false;
          }

          if (!u.reactWeapons.any((weapon) =>
              weaponCheck.hasMatch(weapon.code) || weapon.isCombo)) {
            return false;
          }
          return u.isDuelist;
        })
      ..addMod(UnitAttribute.tv, (value) {
        if (!(value is int)) {
          return value;
        }

        return value +
            _comboNotComboCost(modOptions.selectedOption,
                comboCost: 2, nonComboCost: 1);
      }, description: 'TV +1/2')
      ..addMod(UnitAttribute.react_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }
        final newList = value;

        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text &&
                weapon.hasReact)) {
          var existingWeapon = newList.firstWhere((weapon) =>
              weapon.toString() == modOptions.selectedOption?.text &&
              weapon.hasReact);
          existingWeapon.bonusTraits.add(traitToAdd);
        }
        return newList;
      },
          description: 'Add the Link trait to one Pistol, Submachine Gun, ' +
              'Autocannon, Frag Cannon, Flamer or Grenade ' +
              'Launcher with the React trait for 1 TV. Or add the Link' +
              'trait to a combo weapon with the React trait for 2 TV.');
  }

  /*
  LUNGE 0 TV
  Add the Reach:1 trait to any Vibro Blade, Spike Gun
  or Combat Weapon with the React trait. If the weapon
  already has the Reach:X trait then this upgrade cannot
  be used.
  */
  factory DuelistModification.lunge(Unit u) {
    final react = u.reactWeapons;
    final List<ModificationOption> _options = [];
    const traitToAdd = Trait(name: 'Brawl', level: 1);
    final allowedWeaponMatch = RegExp(r'^(VB|SG|CW)$');
    react.where((weapon) {
      return allowedWeaponMatch.hasMatch(weapon.code) &&
          !weapon.traits.any((trait) => trait.name == 'Reach');
    }).forEach((weapon) {
      _options.add(ModificationOption(weapon.toString()));
    });

    final modOptions = ModificationOption('Lunge',
        subOptions: _options,
        description: 'Choose one of the available weapons to add Reach:1');

    return DuelistModification(
        name: 'Lunge',
        id: lungeId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(lungeId)) {
            return false;
          }

          if (!u.reactWeapons.any((weapon) =>
              allowedWeaponMatch.hasMatch(weapon.code) &&
              !weapon.traits.any((trait) => trait.name == 'Reach'))) {
            return false;
          }
          return u.isDuelist;
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
      ..addMod(UnitAttribute.react_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }
        final newList = value;

        if (modOptions.selectedOption != null) {
          var existingWeapon = newList.firstWhere(
              (weapon) => weapon.toString() == modOptions.selectedOption?.text);
          existingWeapon.bonusTraits.add(traitToAdd);
        }
        return newList;
      },
          description: 'Add the Reach:1 trait to any Vibro Blade, Spike Gun ' +
              'or Combat Weapon with the React trait.');
  }

  /*
  PUSH THE ENVELOPE 1 TV
  Add the Agile trait. Models with the Lumbering Trait
  cannot receive Agile.
  */
  factory DuelistModification.pushTheEnvelope(Unit u) {
    final RegExp traitCheck = RegExp(r'(Agile|Lumbering)');
    final Trait newTrait = Trait(name: 'Agile');
    return DuelistModification(
        name: 'Push the Envelope',
        id: pushTheEnvelopeId,
        requirementCheck: () {
          if (u.hasMod(pushTheEnvelopeId)) {
            return false;
          }

          if (u.traits.any((trait) => traitCheck.hasMatch(trait.name))) {
            return false;
          }
          return u.isDuelist;
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.traits, createAddTraitToList(newTrait),
          description: 'Add the Agile trait. Models with the Lumbering Trait ' +
              'cannot receive Agile.');
  }

  /*
  QUICK DRAW 1 TV
  Add the Auto trait to one ranged weapon or combination
  weapon that has the React trait.
  */
  factory DuelistModification.quickDraw(Unit u) {
    final react = u.reactWeapons;
    final List<ModificationOption> _options = [];
    const traitToAdd = Trait(name: 'Auto');

    final availableWeapons = react.where((weapon) =>
        weapon.modes.any((mode) => mode != weaponModes.Melee) ||
        weapon.isCombo);

    availableWeapons.forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Quick Draw',
        subOptions: _options,
        description: 'Choose an available weapon to have the Auto trait added');

    return DuelistModification(
        name: 'Quick Draw',
        id: quickDrawId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(quickDrawId)) {
            return false;
          }

          if (u.reactWeapons
              .where((weapon) =>
                  weapon.modes.any((mode) => mode != weaponModes.Melee) ||
                  weapon.isCombo)
              .isEmpty) {
            return false;
          }
          return u.isDuelist;
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(
        UnitAttribute.react_weapons,
        (value) {
          if (!(value is List<Weapon>)) {
            return value;
          }
          final newList = value;

          if (modOptions.selectedOption != null &&
              newList.any((weapon) =>
                  weapon.toString() == modOptions.selectedOption?.text)) {
            var existingWeapon = newList.firstWhere((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text);
            existingWeapon.bonusTraits.add(traitToAdd);
          }
          return newList;
        },
        description: 'Add the Auto trait to one ranged weapon or ' +
            'combination weapon that has the React trait',
      );
  }

  /*
  SHIELD-BEARER 1–2 TV
  Add the Shield trait to a model. This upgrade costs 1
  TV for models with an Armor of 7 or lower and 2 TV for
  models with an Armor of 8 or higher.
  */
  factory DuelistModification.shieldBearer(Unit u) {
    final Trait newTrait = Trait(name: 'Shield');
    final armor = u.armor;
    return DuelistModification(
        name: 'Shield-Bearer',
        id: shieldBearerId,
        requirementCheck: () {
          if (u.hasMod(shieldBearerId)) {
            return false;
          }
          return u.isDuelist;
        })
      ..addMod(
        UnitAttribute.tv,
        createSimpleIntMod(armor != null
            ? armor <= 7
                ? 1
                : 2
            : 0),
        description: 'TV +${armor != null ? armor <= 7 ? 1 : 2 : 0}',
      )
      ..addMod(UnitAttribute.traits, createAddTraitToList(newTrait),
          description:
              'Add the Shield trait to a model. This upgrade costs 1 ' +
                  'TV for models with an Armor of 7 or lower and 2 TV for ' +
                  'models with an Armor of 8 or higher.');
  }

  /*
  SMASHFEST 1 TV
  Upgrade one melee weapon with the React trait to one
  of the following:
  * M Vibroblade +React
  * M Combat Weapon +React, Demo:4
  */
  factory DuelistModification.smashfest(Unit u) {
    final react = u.reactWeapons;
    final List<ModificationOption> _options = [];
    final weaponOption1 = buildWeapon('MVB');
    final weaponOption2 = buildWeapon('MCW (Demo:4)');

    react
        .where((weapon) =>
            weapon.hasReact &&
            weapon.modes.any((mode) => mode == weaponModes.Melee))
        .toList()
        .forEach((weapon) {
      final baseOption = ModificationOption(
        weapon.toString(),
        subOptions: [
          ModificationOption(weaponOption1.toString()),
          ModificationOption(weaponOption2.toString()),
        ],
      );

      _options.add(baseOption);
    });

    var modOptions = ModificationOption('Smashfest',
        subOptions: _options,
        description: 'Choose an available weapon to upgrade');

    return DuelistModification(
        name: 'Smashfest',
        id: smashFestId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(smashFestId)) {
            return false;
          }
          return u.isDuelist;
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.react_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }

        // check if an option has been selected
        if (modOptions.selectedOption == null ||
            modOptions.selectedOption!.selectedOption == null) {
          return value;
        }

        var indexToRemove = value.indexWhere(
            (weapon) => weapon.toString() == modOptions.selectedOption!.text);

        final weaponToAdd = buildWeapon(
            modOptions.selectedOption!.selectedOption!.text,
            hasReact: true);
        if (weaponToAdd != null) {
          value = value
              .where((weapon) =>
                  weapon.toString() != modOptions.selectedOption!.text)
              .toList();
          value.insert(indexToRemove, weaponToAdd);
        }

        return value;
      },
          description: 'Upgrade one melee weapon with the React trait to one ' +
              'of the following with react: MVB, MCW (Demo:4)');
  }
}

int _comboNotComboCost(ModificationOption? selectedOption,
    {required int comboCost, required int nonComboCost}) {
  int result = 0;
  if (selectedOption != null) {
    var w = buildWeapon(selectedOption.text);

    if (w != null) {
      result = w.isCombo ? comboCost : nonComboCost;
    }
  }
  return result;
}
