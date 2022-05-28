import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';
import 'package:gearforce/models/weapons/weapons.dart';

const veteranId = 'veteran';
const improvedGunneryId = 'vet: improved gunnery';
const dualGunsId = 'vet: dual guns';
const eccmId = 'vet: eccm';
const brawl1Id = 'vet: brawler1';
const brawler2Id = 'vet: brawler2';
const reachId = 'vet: reach';
const meleeUpgradeId = 'vet: melee upgrade';
const resistHId = 'vet: resist:h';
const resistFId = 'vet: resist:f';
const resistCId = 'vet: resist:c';
const fieldArmorId = 'vet: field armor';
const amsId = 'vet: ams';

final RegExp _gearVehicleStriderMatch = RegExp(
  r'^Gear|Vehicle|Strider',
  caseSensitive: false,
);
final RegExp _handsMatch = RegExp(r'^Hands', caseSensitive: false);

class VeteranModification extends BaseModification {
  VeteranModification({
    required String name,
    required String id,
    this.requirementCheck = _defaultRequirementsFunction,
    this.unit,
    this.group,
    ModificationOption? options,
    final BaseModification Function()? refreshData,
  }) : super(name: name, id: id, options: options, refreshData: refreshData);

  // function to ensure the modification can be applied to the unit
  final bool Function() requirementCheck;
  final Unit? unit;
  final CombatGroup? group;

  static bool _defaultRequirementsFunction() => true;

  factory VeteranModification.makeVet(Unit u, CombatGroup cg) {
    return VeteranModification(
        name: 'Veteran Upgrade',
        id: veteranId,
        requirementCheck: () {
          if (u.hasMod(veteranId)) {
            return false;
          }

          return cg.isVeteran && !u.traits.any((trait) => trait.name == 'Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'Vet')),
          description: '+Vet');
  }

  /*
  ECCM
  Add ECCM trait to a gear, vehicle, or strider for 1 TV.
  */
  factory VeteranModification.eccm(Unit u) {
    return VeteranModification(
        name: 'ECCM',
        id: eccmId,
        requirementCheck: () {
          if (u.hasMod(eccmId)) {
            return false;
          }

          if (!_gearVehicleStriderMatch.hasMatch(u.type)) {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'ECCM')),
          description: '+ECCM');
  }

  /*
  Reach
  Add the Reach:1 trait to one vibro-blade, spike gun,
  combat weapon or infantry combat weapon with the
  React trait for 1 TV. If the weapon already has the Reach
  trait, then increase it by +1.
  */
  factory VeteranModification.reach(Unit u) {
    final react = u.reactWeapons;
    final List<ModificationOption> _options = [];
    const traitToAdd = Trait(name: 'Brawl', level: 1);
    final allowedWeaponMatch = RegExp(r'^(VB|SG|CW|ICW)$');
    react.where((weapon) {
      return allowedWeaponMatch.hasMatch(weapon.code) &&
          !weapon.traits.any((trait) => trait.name == 'Reach');
    }).forEach((weapon) {
      _options.add(ModificationOption(weapon.toString()));
    });

    final modOptions = ModificationOption('Reach',
        subOptions: _options,
        description: 'Choose one of the available weapons to add Reach:1');

    return VeteranModification(
        name: 'Reach',
        id: reachId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(reachId)) {
            return false;
          }

          if (!u.reactWeapons.any((weapon) =>
              allowedWeaponMatch.hasMatch(weapon.code) &&
              !weapon.traits.any((trait) => trait.name == 'Reach'))) {
            return false;
          }
          return u.traits.any((trait) => trait.name == 'Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
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
  FIELD ARMOR 1–4 TV
  Add the Field Armor trait to any model. The cost is
  determined by its listed Armor:
  Z Armor 6 or lower for 1 TV
  Z Armor 7–8 for 2 TV
  Z Armor 9–10 for 3 TV
  Z Armor 11–12 for 4 TV
  */
  factory VeteranModification.fieldArmor(Unit u) {
    return VeteranModification(
        name: 'Field Armor',
        id: fieldArmorId,
        requirementCheck: () {
          if (u.hasMod(fieldArmorId)) {
            return false;
          }

          if (u.armor == null || u.armor! > 12) {
            return false;
          }

          if (u.traits.any((element) => element.name == 'Field Armor')) {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        })
      ..addMod(
        UnitAttribute.tv,
        (value) {
          if (u.armor == null) {
            return value;
          }
          int change = _fieldArmorCost(u.armor);

          return value + change;
        },
        description: 'TV +${_fieldArmorCost(u.armor)}',
      )
      ..addMod(
        UnitAttribute.traits,
        createAddTraitToList(Trait(name: 'Field Armor')),
        description: '+Field Armor',
      );
  }

  /*
  Brawler
  For infantry, cavalry, gears and striders:
  > Add the Brawl:1 trait or increase an existing Brawl
  trait by +1 for 1 TV.
  */
  factory VeteranModification.brawler1(Unit u) {
    final traits = u.traits.toList();
    return VeteranModification(
        name: 'Brawler 1',
        id: brawl1Id,
        requirementCheck: () {
          if (u.hasMod(brawl1Id) || u.hasMod(brawler2Id)) {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.traits, (value) {
        if (!(value is List<Trait>)) {
          return value;
        }

        var newLevel = 0;
        if (traits.any((element) => element.name == 'Brawl')) {
          var oldTrait =
              traits.firstWhere((element) => element.name == 'Brawl');
          newLevel = oldTrait.level == null ? 1 : oldTrait.level!;
          value = createRemoveFromList(oldTrait)(value);
        }

        return createAddTraitToList(Trait(name: 'Brawl', level: newLevel + 1))(
            value);
      }, description: '+Brawl:1 or +1 to existing Brawl');
  }

  /*
  Brawler
  For infantry, cavalry, gears and striders:
  > Or add the Brawl:2 trait or increase the Brawl trait by
  +2 for 2 TV.
  */
  factory VeteranModification.brawler2(Unit u) {
    final traits = u.traits.toList();
    return VeteranModification(
        name: 'Brawler 2',
        id: brawler2Id,
        requirementCheck: () {
          if (u.hasMod(brawler2Id) || u.hasMod(brawl1Id)) {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        },
        refreshData: () {
          return VeteranModification.brawler2(u);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
      ..addMod(UnitAttribute.traits, (value) {
        if (!(value is List<Trait>)) {
          return value;
        }

        var newLevel = 0;
        if (traits.any((element) => element.name == 'Brawl')) {
          var oldTrait =
              traits.firstWhere((element) => element.name == 'Brawl');
          newLevel = oldTrait.level == null ? 0 : oldTrait.level!;
          value = createRemoveFromList(oldTrait)(value);
        }

        return createAddTraitToList(Trait(name: 'Brawl', level: newLevel + 2))(
            value);
      }, description: '+Brawl:2 or +2 to existing Brawl');
  }

  /*
  Resist:H
  Add the Resist:H trait or remove the Vuln:H trait for 1 TV.
  */
  factory VeteranModification.resistHaywire(Unit u) {
    final traits = u.traits.toList();
    final isVulnerable = traits
        .any((element) => element.name == 'Vuln' && element.type == 'Haywire');
    return VeteranModification(
        name: 'Resist Haywire',
        id: resistHId,
        requirementCheck: () {
          if (u.hasMod(resistHId)) {
            return false;
          }

          if (traits.any((element) =>
              element.name == 'Resist' && element.type == 'Haywire')) {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(
        UnitAttribute.traits,
        (value) {
          if (!(value is List<Trait>)) {
            return value;
          }

          if (isVulnerable) {
            var oldTrait = traits.firstWhere((element) =>
                element.name == 'Vuln' && element.type == 'Haywire');
            return createRemoveFromList(oldTrait)(value);
          } else {
            return createAddTraitToList(
              Trait(name: 'Resist', type: 'Haywire'),
            )(value);
          }
        },
        description: '${isVulnerable ? '-Vuln:Haywire' : ' +Resist:Haywire'}',
      );
  }

  /*
  Resist:F
  Add the Resist:F trait or remove the Vuln:F trait for 1 TV.
  */
  factory VeteranModification.resistFire(Unit u) {
    final traits = u.traits.toList();
    final isVulnerable = traits
        .any((element) => element.name == 'Vuln' && element.type == 'Fire');
    return VeteranModification(
        name: 'Resist Fire',
        id: resistFId,
        requirementCheck: () {
          if (u.hasMod(resistFId)) {
            return false;
          }

          if (traits.any((element) =>
              element.name == 'Resist' && element.type == 'Fire')) {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(
        UnitAttribute.traits,
        (value) {
          if (!(value is List<Trait>)) {
            return value;
          }

          if (isVulnerable) {
            var oldTrait = traits.firstWhere(
                (element) => element.name == 'Vuln' && element.type == 'Fire');
            return createRemoveFromList(oldTrait)(value);
          } else {
            return createAddTraitToList(Trait(name: 'Resist', type: 'Fire'))(
                value);
          }
        },
        description: '${isVulnerable ? '-Vuln:Fire' : ' +Resist:Fire'}',
      );
  }

  /*
  Resist:C
  Add the Resist:C trait or remove the Vuln:C trait for 1 TV.
  */
  factory VeteranModification.resistCorrosion(Unit u) {
    final traits = u.traits.toList();
    final isVulnerable = traits.any(
        (element) => element.name == 'Vuln' && element.type == 'Corrosion');
    return VeteranModification(
        name: 'Resist Corrosion',
        id: resistCId,
        requirementCheck: () {
          if (u.hasMod(resistCId)) {
            return false;
          }

          if (traits.any((element) =>
              element.name == 'Resist' && element.type == 'Corrosion')) {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(
        UnitAttribute.traits,
        (value) {
          if (!(value is List<Trait>)) {
            return value;
          }

          if (isVulnerable) {
            var oldTrait = traits.firstWhere((element) =>
                element.name == 'Vuln' && element.type == 'Corrosion');
            return createRemoveFromList(oldTrait)(value);
          } else {
            return createAddTraitToList(
                Trait(name: 'Resist', type: 'Corrosion'))(value);
          }
        },
        description:
            '${isVulnerable ? '-Vuln:Corrosion' : ' +Resist:Corrosion'}',
      );
  }

  /*
  Improved Gunnery
  Improve this model’s gunnery skill by one for 2 TV, for
  each action point that this model has. This cost also
  increases by 2 TV per additional action purchased via any
  other upgrades.
  */
  factory VeteranModification.improvedGunnery(Unit u) {
    final gunnery = u.gunnery;

    return VeteranModification(
        name: 'Improved Gunnery',
        id: improvedGunneryId,
        requirementCheck: () {
          if (u.hasMod(improvedGunneryId)) {
            return false;
          }

          if (u.actions == null || u.gunnery == null || u.gunnery == '-') {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        })
      ..addMod(
        UnitAttribute.tv,
        (value) {
          return value + (u.actions != null ? u.actions! * 2 : 0);
        },
        dynamicDescription: () =>
            'TV +${u.actions != null ? u.actions! * 2 : 0}',
      )
      ..addMod(
        UnitAttribute.gunnery,
        (value) {
          if (value is! int) {
            return value;
          }

          return value - 1;
        },
        description:
            'Improve this model’s gunnery skill by one for 2 TV to (${gunnery == null ? '-' : '${gunnery - 1}+'})',
      );
  }

  /*
  Dual Guns
  > Add the Link trait to one light or medium; pistol,
  submachine gun, autocannon, frag cannon, flamer or
  grenade launcher with the React trait for 1 TV.
  > This upgrade cannot be added to combo weapons
  such as a LAC/LGL.
  */
  factory VeteranModification.dualGuns(Unit u) {
    final RegExp weaponCheck = RegExp(r'^(P|SMG|AC|FC|FL|GL)');
    final react = u.reactWeapons;
    final List<ModificationOption> _options = [];
    const traitToAdd = Trait(name: 'Link');

    final allWeapons = react.toList();
    allWeapons
        .where((weapon) => weaponCheck.hasMatch(weapon.code) && !weapon.isCombo)
        .forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Dual Guns',
        subOptions: _options,
        description: 'Add the Link trait to one Pistol, Submachine Gun, ' +
            'Autocannon, Frag Cannon, Flamer or Grenade ' +
            'Launcher with the React trait for 1 TV.');

    return VeteranModification(
        name: 'Dual Guns',
        id: dualGunsId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(dualGunsId)) {
            return false;
          }

          if (!u.reactWeapons.any((weapon) =>
              weaponCheck.hasMatch(weapon.code) && !weapon.isCombo)) {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
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
              'Launcher with the React trait for 1 TV.');
  }

  /*
  Veteran Melee Upgrade
  A gear with the Hands trait may receive one of the
  following for 1 TV:
  > LVB (React, Precise)
  > LCW (React, Brawl:1)
  */
  factory VeteranModification.meleeWeaponUpgrade(Unit u) {
    final react = u.reactWeapons;
    final List<ModificationOption> _options = [];

    final availableWeapons = react.where(
        (weapon) => weapon.modes.any((mode) => mode == weaponModes.Melee));

    availableWeapons.forEach((weapon) {
      _options.add(ModificationOption(weapon.toString(), subOptions: [
        ModificationOption('LVB (React Precise)'),
        ModificationOption('LCW (React Brawl:1)')
      ]));
    });

    var modOptions = ModificationOption('Melee Weapon Upgrade',
        subOptions: _options,
        description: 'A gear with the hands trait may add either  ' +
            'a LVB (React, Precise) or LCW (React, Brawl:1)');

    return VeteranModification(
        name: 'Melee Weapon Upgrade',
        id: meleeUpgradeId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(meleeUpgradeId)) {
            return false;
          }

          if (u.type != 'Gear') {
            return false;
          }

          if (!u.traits
              .toList()
              .any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          // check to ensure the unit has an appropriate weapon that can be upgraded
          if (!u.reactWeapons.any((weapon) =>
              weapon.modes.any((mode) => mode == weaponModes.Melee))) {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        },
        refreshData: () {
          return VeteranModification.meleeWeaponUpgrade(u);
        })
      ..addMod(
        UnitAttribute.tv,
        createSimpleIntMod(1),
        description: 'TV +1',
      )
      ..addMod(UnitAttribute.react_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }

        final newList =
            value.map((weapon) => Weapon.fromWeapon(weapon)).toList();

        // check if an option has been selected
        if (modOptions.selectedOption == null ||
            modOptions.selectedOption!.selectedOption == null) {
          return newList;
        }

        final weaponToAdd = buildWeapon(
            modOptions.selectedOption!.selectedOption!.text,
            hasReact: true);
        if (weaponToAdd != null) {
          newList.add(weaponToAdd);
        }

        return newList;
      },
          description: 'A gear with the hands trait may add either  ' +
              'a LVB (React, Precise) or LCW (React, Brawl:1)');
  }

  /*
  DEFENDER 1 TV
  Add the Anti-Missile System (AMS) trait to any weapon
  with the Frag or Burst trait.

  AMS
  Add the AMS trait to a model that has a frag cannon,
  autocannon, submachine gun, machine gun or rotary
  cannon for 1 TV.


  */
  factory VeteranModification.ams(Unit u) {
    final allowedWeaponMatch = RegExp(r'^(FC|AC|SMG|MG|RC)$');
    return VeteranModification(
        name: 'AMS',
        id: amsId,
        requirementCheck: () {
          if (u.hasMod(amsId)) {
            return false;
          }

          final matchingWeapons = u.weapons.where((weapon) {
            print(weapon.code);
            return allowedWeaponMatch.hasMatch(weapon.code);
          });
          print(matchingWeapons);
          if (matchingWeapons.isEmpty) {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait(name: 'AMS')),
          description: '+AMS');
  }
}

int _fieldArmorCost(int? armor) {
  int change = 0;

  if (armor == null) {
    return change;
  }

  if (armor > 0 && armor <= 6) {
    change = 1;
  } else if (armor == 7 || armor == 8) {
    change = 2;
  } else if (armor == 9 || armor == 10) {
    change = 3;
  } else if (armor == 11 || armor == 12) {
    change = 4;
  }
  return change;
}
