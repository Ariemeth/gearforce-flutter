import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
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
  }) : super(name: name, id: id);

  // function to ensure the modification can be applied to the unit
  final bool Function() requirementCheck;
  final Unit? unit;
  final CombatGroup? group;

  static bool _defaultRequirementsFunction() => true;

  factory StandardModification.antiAir(Unit u, CombatGroup cg) {
    return StandardModification(
        name: 'Anti-Air',
        id: antiAirId,
        requirementCheck: () {
          if (u.hasMod(antiAirId)) {
            return false;
          }

          final RegExp exp = RegExp(r'^(([LMH])(AC|RC|LC|ATM))');

          // check to ensure the unit has an appropriate weapon that can be upgraded
          final hasMatchingWeapon = u.mountedWeapons
                  .any((element) => exp.hasMatch(element.abbreviation)) ||
              u.reactWeapons
                  .any((element) => exp.hasMatch(element.abbreviation));
          if (!hasMatchingWeapon) {
            return false;
          }

          // check to ensure this upgrade has not already been given to 2 or more units
          return cg.modCount(antiAirId) < 2;
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.mounted_weapons, (dynamic v) => v,
          description:
              'Add the Anti-Air trait to one AC, RC, or LC or upgrade any one ATM to AAM of the same class');
  }

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

  factory StandardModification.grenadeSwap(Unit u, CombatGroup cg) {
    return StandardModification(
        name: 'Grenade Swap',
        id: grenadeSwapId,
        requirementCheck: () {
          if (u.hasMod(grenadeSwapId)) {
            return false;
          }
          final RegExp exp = RegExp(
              r'^([[:space:]]|,|\[)*(([LMH])(HG|PZ))([[:space:]]|\])*($|,)');
          return exp.hasMatch(u.mountedWeapons.toString()) ||
              exp.hasMatch(u.reactWeapons.toString());
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(0),
          description:
              'swap their hand grenades for panzerfausts or vice versa. The swapped item must be of the same class, such as L, M, or H');
  }

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
