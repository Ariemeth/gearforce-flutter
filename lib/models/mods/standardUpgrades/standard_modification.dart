import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapons.dart';
import 'package:uuid/uuid.dart';

final antiAirId = Uuid().v4();
final droneId = Uuid().v4();
final grenadeSwapId = Uuid().v4();
final handGrenadeLId = Uuid().v4();
final handGrenadeMId = Uuid().v4();
final panzerfaustsLId = Uuid().v4();
final panzerfaustsMId = Uuid().v4();
final pistolsId = Uuid().v4();
final subMachineGunId = Uuid().v4();
final shapedExplosivesLId = Uuid().v4();
final shapedExplosivesMId = Uuid().v4();
final smokeId = Uuid().v4();

final RegExp _handsMatch = RegExp(r'^Hands', caseSensitive: false);
final RegExp _vtolMatch = RegExp(r'^VTOL', caseSensitive: false);

class StandardModification extends BaseModification {
  StandardModification({
    required String name,
    this.requirementCheck = _defaultRequirementsFunction,
    this.unit,
    this.group,
    String? id,
    ModificationOption? options,
  }) : super(name: name, id: id, options: options);

  // function to ensure the modification can be applied to the unit
  final bool Function() requirementCheck;
  final Unit? unit;
  final CombatGroup? group;

  static bool _defaultRequirementsFunction() => true;

  /*
  ANTI-AIR 1–2 TV
  Up to 2 models may select one of the options below:
  > Add the Anti-Air trait to one autocannon, rotary
  cannon, or laser cannon for 1 TV each.
  > Upgrade any one Anti-Tank Missile (ATM) to an
  Anti-Air Missile (AAM) of the same class for 1 TV
  each.
  */
  factory StandardModification.antiAir(Unit u, CombatGroup cg) {
    final react = u.reactWeapons;
    final mounted = u.mountedWeapons;
    final List<ModificationOption> _options = [];
    final RegExp weaponMatch = RegExp(r'^(AC|RC|LC|ATM)');
    final traitToAdd = Trait(name: 'AA');

    final allWeapons = react.toList()..addAll(mounted);
    allWeapons
        .where((weapon) => weaponMatch.hasMatch(weapon.code))
        .forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Anti-Air',
        subOptions: _options,
        description: 'Choose a weapon to gain the AA trait or an ATM to be ' +
            'converted to an AAM.');

    return StandardModification(
        name: 'Anti-Air',
        id: antiAirId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(antiAirId)) {
            return false;
          }

          // check to ensure the unit has an appropriate weapon that can be upgraded
          final hasMatchingWeapon = u.mountedWeapons
                  .any((weapon) => weaponMatch.hasMatch(weapon.code)) ||
              u.reactWeapons.any((weapon) => weaponMatch.hasMatch(weapon.code));
          if (!hasMatchingWeapon) {
            return false;
          }

          // check to ensure this upgrade has not already been given to 2 or more units
          return cg.modCount(antiAirId) < 2;
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
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
          if (existingWeapon.code == 'ATM') {
            final index = newList.indexWhere((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text);
            if (index >= 0) {
              newList.removeAt(index);
              final aam = buildWeapon(
                  '${existingWeapon.size}AAM ${existingWeapon.bonusString}',
                  hasReact: true);
              if (aam != null) {
                newList.insert(index, aam);
              }
            }
          } else {
            existingWeapon.bonusTraits.add(traitToAdd);
          }
        }
        return newList;
      },
          description:
              'Add the Anti-Air trait to one AC, RC, or LC or upgrade any ' +
                  'one ATM to AAM of the same class')
      ..addMod(UnitAttribute.mounted_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }
        final newList =
            value.map((weapon) => Weapon.fromWeapon(weapon)).toList();
        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text &&
                !weapon.hasReact)) {
          var existingWeapon = newList.firstWhere((weapon) =>
              weapon.toString() == modOptions.selectedOption?.text &&
              !weapon.hasReact);
          if (existingWeapon.code == 'ATM') {
            final index = newList.indexWhere((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text);
            if (index >= 0) {
              newList.removeAt(index);
              final aam = buildWeapon(
                  '${existingWeapon.size}AAM ${existingWeapon.bonusString}');
              if (aam != null) {
                newList.insert(index, aam);
              }
            }
          } else {
            existingWeapon.bonusTraits.add(traitToAdd);
          }
        }
        return newList;
      });
  }

  /*
  DRONES 1–2 TV
  All Drones cost 1 TV each. Up to 2 Drones may be
  attached to models. A model with a Drone gains the
  trait Transport: 1 Drone if it doesn’t already have the
  Transport Trait. A Drone’s Action is not counted when
  constructing a force.
  */
  factory StandardModification.drones(Unit u, CombatGroup cg) {
    return StandardModification(
      name: 'Drones',
      id: droneId,
      requirementCheck: () {
        if (u.hasMod(droneId)) {
          return false;
        }

        return cg.modCount(droneId) < 2;
      },
    )
      ..addMod(UnitAttribute.tv, createSimpleIntMod(0),
          description: 'TV +1 per drone, Max 2 drones')
      ..addMod(
          UnitAttribute.traits,
          createAddTraitToList(
              Trait(name: 'Transport', level: 1, type: 'Drone')));
  }

  /*
  GRENADE SWAP 0 TV
  Any number of models may swap their hand grenades
  for panzerfausts or vice versa. The swapped item must
  be of the same class, such as L, M, or H.
  */
  factory StandardModification.grenadeSwap(Unit u, CombatGroup cg) {
    final react = u.reactWeapons;
    final mounted = u.mountedWeapons;
    final List<ModificationOption> _options = [];
    final RegExp weaponMatch = RegExp(r'^(HG|PZ)$');

    final availableWeapons = react.toList()..addAll(mounted);
    availableWeapons
        .where((weapon) => weaponMatch.hasMatch(weapon.code))
        .toList()
        .forEach(
      (weapon) {
        _options.add(ModificationOption(weapon.toString()));
      },
    );

    var modOptions = ModificationOption('Grenade Swap',
        subOptions: _options,
        description: 'Chose a grenade to swap for a panzerfaust or a ' +
            'panzerfaust to swap for a grenade');

    return StandardModification(
        name: 'Grenade Swap',
        id: grenadeSwapId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(grenadeSwapId)) {
            return false;
          }

          return u.mountedWeapons
                  .any((weapon) => weaponMatch.hasMatch(weapon.code)) ||
              u.reactWeapons.any((weapon) => weaponMatch.hasMatch(weapon.code));
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(0),
          description:
              'swap their hand grenades for panzerfausts or vice versa. The ' +
                  'swapped item must be of the same class, such as L, M, or H')
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

          var newWeaponAbb = '';

          if (existingWeapon.code == 'HG') {
            newWeaponAbb = '${existingWeapon.size}PZ';
          } else if (existingWeapon.code == 'PZ') {
            newWeaponAbb = '${existingWeapon.size}HG';
          } else {
            print('weapon code ${existingWeapon.toString()} is not a HG or PZ');
            return newList;
          }

          final newWeapon = buildWeapon(newWeaponAbb, hasReact: true);
          if (newWeapon != null) {
            final index = newList.indexWhere(
                (weapon) => weapon.toString() == existingWeapon.toString());
            if (index >= 0) {
              newList.removeAt(index);
              newList.insert(index, newWeapon);
            }
          }
        }
        return newList;
      })
      ..addMod(UnitAttribute.mounted_weapons, (value) {
        if (!(value is List<Weapon>)) {
          return value;
        }
        final newList =
            value.map((weapon) => Weapon.fromWeapon(weapon)).toList();
        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text &&
                !weapon.hasReact)) {
          var existingWeapon = newList.firstWhere((weapon) =>
              weapon.toString() == modOptions.selectedOption?.text &&
              !weapon.hasReact);

          var newWeaponAbb = '';

          if (existingWeapon.code == 'HG') {
            newWeaponAbb = '${existingWeapon.size}PZ';
          } else if (existingWeapon.code == 'PZ') {
            newWeaponAbb = '${existingWeapon.size}HG';
          } else {
            print('weapon code ${existingWeapon.toString()} is not a HG or PZ');
            return newList;
          }

          final newWeapon = buildWeapon(newWeaponAbb);
          if (newWeapon != null) {
            final index = newList.indexWhere(
                (weapon) => weapon.toString() == existingWeapon.toString());
            if (index >= 0) {
              newList.removeAt(index);
              newList.insert(index, newWeapon);
            }
          }
        }
        return newList;
      });
  }

  /*
  HAND GRENADES 1–2 TV
  Only models with the Hands trait can purchase Hand
  Grenades. Choose one option:
  > Up to 2 models may purchase Light Hand Grenades
  (LHG) for 1 TV total.
  > Up to 2 models may purchase Medium Hand
  Grenades (MHG) for 1 TV each.
  */
  factory StandardModification.handGrenadeLHG(Unit u, CombatGroup cg) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Hand Grenades (LHG)',
        id: handGrenadeLId,
        unit: u,
        group: cg,
        requirementCheck: () {
          if (!traits.any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          if (u.hasMod(handGrenadeLId) || u.hasMod(handGrenadeMId)) {
            return false;
          }

          // check to ensure this upgrade has not already been given to 2 or more units
          return cg.modCount(handGrenadeLId) < 2 &&
              cg.modCount(handGrenadeMId) == 0;
        })
      ..addMod(
        UnitAttribute.tv,
        (value) {
          var numMods = cg.modCount(handGrenadeLId);
          var change = 0;
          switch (numMods) {
            case 0:
              change = 1;
              break;
            case 1:
              if (u.hasMod(handGrenadeLId)) {
                change = 1;
              } else {
                change = 0;
              }
              break;
            case 2:
              var other = cg
                  .unitsWithMod(handGrenadeLId)
                  .firstWhere((unit) => unit != u);
              change = other.hashCode > u.hashCode ? 0 : 1;

              break;
          }
          return value + change;
        },
        description: 'TV +1 per 2',
      )
      ..addMod(
        UnitAttribute.mounted_weapons,
        createAddWeaponToList(buildWeapon('LHG')!),
        description: '+LHG',
      );
  }

  /*
  HAND GRENADES 1–2 TV
  Only models with the Hands trait can purchase Hand
  Grenades. Choose one option:
  > Up to 2 models may purchase Light Hand Grenades
  (LHG) for 1 TV total.
  > Up to 2 models may purchase Medium Hand
  Grenades (MHG) for 1 TV each.
  */
  factory StandardModification.handGrenadeMHG(Unit u, CombatGroup cg) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Hand Grenades (MHG)',
        id: handGrenadeMId,
        requirementCheck: () {
          if (!traits.any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          if (u.hasMod(handGrenadeLId) || u.hasMod(handGrenadeMId)) {
            return false;
          }

          // check to ensure this upgrade has not already been given to 2 or more units
          return cg.modCount(handGrenadeMId) < 2 &&
              cg.modCount(handGrenadeLId) == 0;
        })
      ..addMod(
        UnitAttribute.tv,
        createSimpleIntMod(1),
        description: 'TV +1',
      )
      ..addMod(
        UnitAttribute.mounted_weapons,
        createAddWeaponToList(buildWeapon('MHG')!),
        description: '+MHG',
      );
  }

  /*
  PANZERFAUSTS 1–2 TV
  Only models with the Hands trait can purchase
  panzerfausts. Choose one option:
  > Up to 2 models may purchase Light Panzerfausts
  (LPZ) for 1 TV total.
  > Or, up to 2 models may purchase Medium
  Panzerfausts (MPZ) for 1 TV each.
  */
  factory StandardModification.panzerfaustsL(Unit u, CombatGroup cg) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Panzerfausts (LPZ)',
        id: panzerfaustsLId,
        unit: u,
        group: cg,
        requirementCheck: () {
          if (!traits.any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          if (u.hasMod(panzerfaustsMId) || u.hasMod(panzerfaustsLId)) {
            return false;
          }

          // check to ensure this upgrade has not already been given to 2 or more units
          return cg.modCount(panzerfaustsLId) < 2 &&
              cg.modCount(panzerfaustsMId) == 0;
        })
      ..addMod(
        UnitAttribute.tv,
        (value) {
          var numMods = cg.modCount(panzerfaustsLId);
          var change = 0;
          switch (numMods) {
            case 0:
              change = 1;
              break;
            case 1:
              if (u.hasMod(panzerfaustsLId)) {
                change = 1;
              } else {
                change = 0;
              }
              break;
            case 2:
              var other = cg
                  .unitsWithMod(panzerfaustsLId)
                  .firstWhere((unit) => unit != u);
              change = other.hashCode > u.hashCode ? 0 : 1;

              break;
          }
          return value + change;
        },
        description: 'TV +1 per 2',
      )
      ..addMod(
        UnitAttribute.mounted_weapons,
        createAddWeaponToList(buildWeapon('LPZ')!),
        description: '+LPZ',
      );
  }

  /*
  PANZERFAUSTS 1–2 TV
  Only models with the Hands trait can purchase
  panzerfausts. Choose one option:
  > Up to 2 models may purchase Light Panzerfausts
  (LPZ) for 1 TV total.
  > Or, up to 2 models may purchase Medium
  Panzerfausts (MPZ) for 1 TV each.
  */
  factory StandardModification.panzerfaustsM(Unit u, CombatGroup cg) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Panzerfausts (MPZ)',
        id: panzerfaustsMId,
        requirementCheck: () {
          if (!traits.any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          if (u.hasMod(panzerfaustsMId) || u.hasMod(panzerfaustsLId)) {
            return false;
          }

          // check to ensure this upgrade has not already been given to 2 or more units
          return cg.modCount(panzerfaustsMId) < 2 &&
              cg.modCount(panzerfaustsLId) == 0;
        })
      ..addMod(
        UnitAttribute.tv,
        createSimpleIntMod(1),
        description: 'TV +1',
      )
      ..addMod(
        UnitAttribute.mounted_weapons,
        createAddWeaponToList(buildWeapon('MPZ')!),
        description: '+MPZ',
      );
  }

  /*
  SIDEARMS 1 TV
  Only models with the Hands trait can purchase
  sidearms. Up to 2 models may purchase Light Pistols
  (LP) or Light Submachine Guns (LSMGs) for 1 TV total.
  These weapons have the React trait.
  */
  factory StandardModification.sidearmLP(Unit u, CombatGroup cg) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Sidearm (LP)',
        id: pistolsId,
        unit: u,
        group: cg,
        requirementCheck: () {
          if (!traits.any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          // can only have eithe 1 pistol or 1 submachinegun
          if (u.hasMod(pistolsId) || u.hasMod(subMachineGunId)) {
            return false;
          }

          // check to ensure this upgrade has not already been given to 2 or more units
          return cg.modCount(pistolsId) + cg.modCount(subMachineGunId) < 2;
        })
      ..addMod(
        UnitAttribute.tv,
        (value) {
          var numMods = cg.modCount(pistolsId) + cg.modCount(subMachineGunId);
          var change = 0;
          switch (numMods) {
            case 0:
              change = 1;
              break;
            case 1:
              if (u.hasMod(pistolsId)) {
                change = 1;
              } else {
                change = 0;
              }
              break;
            case 2:
              var other = cg.unitsWithMod(pistolsId).firstWhere(
                    (unit) => unit != u,
                    orElse: () => cg
                        .unitsWithMod(subMachineGunId)
                        .firstWhere((unit) => unit != u),
                  );
              change = other.hashCode > u.hashCode ? 0 : 1;

              break;
          }
          return value + change;
        },
        description: 'TV +1 per 2 Sidearms',
      )
      ..addMod(
        UnitAttribute.react_weapons,
        createAddWeaponToList(buildWeapon('LP', hasReact: true)!),
        description: '+LP',
      );
  }

  /*
  SIDEARMS 1 TV
  Only models with the Hands trait can purchase
  sidearms. Up to 2 models may purchase Light Pistols
  (LP) or Light Submachine Guns (LSMGs) for 1 TV total.
  These weapons have the React trait.
  */
  factory StandardModification.sidearmSMG(Unit u, CombatGroup cg) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Sidearm (LSMG)',
        id: subMachineGunId,
        unit: u,
        group: cg,
        requirementCheck: () {
          if (!traits.any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          // can only have eithe 1 pistol or 1 submachinegun
          if (u.hasMod(pistolsId) || u.hasMod(subMachineGunId)) {
            return false;
          }

          // check to ensure this upgrade has not already been given to 2 or more units
          return cg.modCount(pistolsId) + cg.modCount(subMachineGunId) < 2;
        })
      ..addMod(
        UnitAttribute.tv,
        (value) {
          var numMods = cg.modCount(pistolsId) + cg.modCount(subMachineGunId);
          var change = 0;
          switch (numMods) {
            case 0:
              change = 1;
              break;
            case 1:
              if (u.hasMod(subMachineGunId)) {
                change = 1;
              } else {
                change = 0;
              }
              break;
            case 2:
              var other = cg.unitsWithMod(subMachineGunId).firstWhere(
                    (unit) => unit != u,
                    orElse: () => cg
                        .unitsWithMod(pistolsId)
                        .firstWhere((unit) => unit != u),
                  );
              change = other.hashCode > u.hashCode ? 0 : 1;

              break;
          }
          return value + change;
        },
        description: 'TV +1 per 2 Sidearms',
      )
      ..addMod(
        UnitAttribute.react_weapons,
        createAddWeaponToList(buildWeapon('LSMG', hasReact: true)!),
        description: '+LSMG',
      );
  }

  /*
  SHAPED EXPLOSIVES 1–2 TV
  Only models with the Hands trait or the infantry
  movement type can purchase shaped explosives.
  Choose one option:
  > Up to 2 models may purchase Light Shaped
  Explosives (LSE) for 1 TV total.
  > Or up to 2 models may purchase Medium Shaped
  Explosives (MSE) for 1 TV each
  */
  factory StandardModification.shapedExplosivesL(Unit u, CombatGroup cg) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Shaped Explosives (LSE)',
        id: shapedExplosivesLId,
        unit: u,
        group: cg,
        requirementCheck: () {
          if (u.hasMod(shapedExplosivesMId) || u.hasMod(shapedExplosivesLId)) {
            return false;
          }

          if (!(traits.any((element) => _handsMatch.hasMatch(element.name))) ||
              u.type == 'Infantry') {
            return false;
          }

          // check to ensure this upgrade has not already been given to 2 or more units
          return cg.modCount(shapedExplosivesLId) < 2 &&
              cg.modCount(shapedExplosivesMId) == 0;
        })
      ..addMod(
        UnitAttribute.tv,
        (value) {
          var numMods = cg.modCount(shapedExplosivesLId);
          var change = 0;
          switch (numMods) {
            case 0:
              change = 1;
              break;
            case 1:
              if (u.hasMod(shapedExplosivesLId)) {
                change = 1;
              } else {
                change = 0;
              }
              break;
            case 2:
              var other = cg
                  .unitsWithMod(shapedExplosivesLId)
                  .firstWhere((unit) => unit != u);
              change = other.hashCode > u.hashCode ? 0 : 1;

              break;
          }
          return value + change;
        },
        description: 'TV +1 per 2',
      )
      ..addMod(
        UnitAttribute.mounted_weapons,
        createAddWeaponToList(buildWeapon('LSE')!),
        description: '+LSE',
      );
  }

  /*
  SHAPED EXPLOSIVES 1–2 TV
  Only models with the Hands trait or the infantry
  movement type can purchase shaped explosives.
  Choose one option:
  > Up to 2 models may purchase Light Shaped
  Explosives (LSE) for 1 TV total.
  > Or up to 2 models may purchase Medium Shaped
  Explosives (MSE) for 1 TV each
  */
  factory StandardModification.shapedExplosivesM(Unit u, CombatGroup cg) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Shaped Explosives (MSE)',
        id: shapedExplosivesMId,
        requirementCheck: () {
          if (!(traits.any((element) => _handsMatch.hasMatch(element.name)) ||
              u.type == 'Infantry')) {
            return false;
          }

          if (u.hasMod(shapedExplosivesMId) || u.hasMod(shapedExplosivesLId)) {
            return false;
          }

          // check to ensure this upgrade has not already been given to 2 or more units
          return cg.modCount(shapedExplosivesMId) < 2 &&
              cg.modCount(shapedExplosivesLId) == 0;
        })
      ..addMod(
        UnitAttribute.tv,
        createSimpleIntMod(1),
        description: 'TV +1',
      )
      ..addMod(
        UnitAttribute.mounted_weapons,
        createAddWeaponToList(buildWeapon('MSE')!),
        description: '+MSE',
      );
  }

  /*
  SMOKE 1–2 TV
  Up to 2 models may purchase the smoke trait for 1
  TV each. Models with the VTOL Trait cannot purchase
  Smoke Upgrades
  */
  factory StandardModification.smoke(Unit u, CombatGroup cg) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Smoke',
        id: smokeId,
        requirementCheck: () {
          if (traits.any((element) => _vtolMatch.hasMatch(element.name))) {
            return false;
          }

          if (u.hasMod(smokeId)) {
            return false;
          }

          // check to ensure this upgrade has not already been given to 2 or more units
          return cg.modCount(smokeId) < 2;
        })
      ..addMod(
        UnitAttribute.tv,
        createSimpleIntMod(1),
        description: 'TV +1',
      )
      ..addMod(
        UnitAttribute.traits,
        createAddTraitToList(Trait(name: 'Smoke')),
        description: '+Smoke',
      );
  }
}
