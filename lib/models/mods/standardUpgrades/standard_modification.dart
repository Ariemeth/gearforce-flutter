import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapons.dart';

const _standardIDBase = 'mod::standard';

const antiAirTraitId = '$_standardIDBase::10';
const antiAirSwapId = '$_standardIDBase::20';
const meleeSwapId = '$_standardIDBase::30';
const grenadeSwapId = '$_standardIDBase::40';
const handGrenadeLId = '$_standardIDBase::50';
const handGrenadeMId = '$_standardIDBase::60';
const panzerfaustsLId = '$_standardIDBase::70';
const panzerfaustsMId = '$_standardIDBase::80';
const pistolsId = '$_standardIDBase::90';
const subMachineGunId = '$_standardIDBase::100';
const shapedExplosivesLId = '$_standardIDBase::110';
const shapedExplosivesMId = '$_standardIDBase::120';
const smokeId = '$_standardIDBase::130';

final RegExp _handsMatch = RegExp(r'^Hands', caseSensitive: false);
final RegExp _vtolMatch = RegExp(r'^VTOL', caseSensitive: false);

class StandardModification extends BaseModification {
  StandardModification({
    required String name,
    required RequirementCheck requirementCheck,
    required String id,
    ModificationOption? options,
    final BaseModification Function()? refreshData,
  }) : super(
          name: name,
          id: id,
          requirementCheck: requirementCheck,
          options: options,
          refreshData: refreshData,
          modType: ModificationType.standard,
        );

  /*
  > Add the AA trait to an autocannon, rotary cannon,
    laser cannon or rotary laser cannon for 1 TV.
  */
  factory StandardModification.antiAirTrait(Unit u, CombatGroup cg) {
    final List<ModificationOption> _options = [];
    final RegExp weaponMatch = RegExp(r'^(AC|RC|LC|RLC)');
    final traitToAdd = Trait.AA();

    final allWeapons = u.weapons;
    allWeapons
        .where((weapon) => weaponMatch.hasMatch(weapon.code))
        .forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Anti-Air',
        subOptions: _options,
        description: 'Choose a weapon to gain the AA trait.');

    return StandardModification(
        name: 'Anti-Air Trait',
        id: antiAirTraitId,
        options: modOptions,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          // can only have one of this mod or the anti air swap mod
          if (u.hasMod(antiAirSwapId)) {
            return false;
          }

          // check to ensure the unit has an appropriate weapon that can be upgraded
          return u.weapons.any((weapon) => weaponMatch.hasMatch(weapon.code));
        },
        refreshData: () {
          return StandardModification.antiAirTrait(u, cg);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod<List<Weapon>>(UnitAttribute.weapons, (value) {
        final newList =
            value.map((weapon) => Weapon.fromWeapon(weapon)).toList();
        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text)) {
          var existingWeapon = newList.firstWhere(
              (weapon) => weapon.toString() == modOptions.selectedOption?.text);

          existingWeapon.bonusTraits.add(traitToAdd);
        }
        return newList;
      }, description: 'Add the Anti-Air trait to one AC, RC, LC or RLC');
  }

  /*
  > Swap any Anti-Tank Missile (ATM) to an Anti-Air
    Missile (AAM) of the same class for 0 TV.
  */
  factory StandardModification.antiAirSwap(Unit u, CombatGroup cg) {
    final List<ModificationOption> _options = [];
    final RegExp weaponMatch = RegExp(r'^(ATM)');

    final allWeapons = u.weapons;
    allWeapons
        .where((weapon) => weaponMatch.hasMatch(weapon.code))
        .forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Anti-Air',
        subOptions: _options,
        description: 'Choose an ATM to be converted to an AAM.');

    return StandardModification(
        name: 'Anti-Air Swap',
        id: antiAirSwapId,
        options: modOptions,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          // can only have one of this mod or the anti air swap mod
          if (u.hasMod(antiAirTraitId)) {
            return false;
          }

          // check to ensure the unit has an appropriate weapon that can be upgraded
          return u
              .attribute<List<Weapon>>(UnitAttribute.weapons,
                  modIDToSkip: antiAirSwapId)
              .any((w) => weaponMatch.hasMatch(w.code));
        },
        refreshData: () {
          return StandardModification.antiAirSwap(u, cg);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV 0')
      ..addMod<List<Weapon>>(UnitAttribute.weapons, (value) {
        final newList =
            value.map((weapon) => Weapon.fromWeapon(weapon)).toList();
        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text)) {
          var existingWeapon = newList.firstWhere(
              (weapon) => weapon.toString() == modOptions.selectedOption?.text);

          final index = newList.indexWhere(
              (weapon) => weapon.toString() == modOptions.selectedOption?.text);
          if (index >= 0) {
            newList.removeAt(index);
            final aam = buildWeapon(
                '${existingWeapon.size}AAM ${existingWeapon.bonusString}',
                hasReact: existingWeapon.hasReact);
            if (aam != null) {
              newList.insert(index, aam);
            }
          }
        }
        return newList;
      }, description: 'Upgrade any one ATM to an AAM of the same class');
  }

  /*
  Melee Swap 0 TV
  One Light (L) or Medium (M) melee weapon with the
  React trait can be swapped for an equal class melee
  weapon for 0 TV, i.e. a LCW can be swapped for a
  LVB or a LSG. This upgrade does not include Shaped
  Explosives. It also does not include traits belonging to
  the previous weapons unless it was the React trait. I.e.
  A LCW (React, Brawl:1) will become LVB (React). The
  Brawl:X trait does not swap with it.
  */

  factory StandardModification.meleeSwap(Unit u) {
    final RegExp meleeCheck = RegExp(r'\b([LM])(VB|SG|CW)');
    final react = u.reactWeapons;
    final traits = u.traits.toList();

    final matchingWeapons =
        react.where((weapon) => meleeCheck.hasMatch(weapon.abbreviation));

    List<ModificationOption>? _options;
    if (matchingWeapons.isNotEmpty) {
      _options = [];
      matchingWeapons.forEach((item) {
        switch (item.code) {
          case 'VB':
            _options!.add(
              ModificationOption(
                '${item.toString()}',
                subOptions: [
                  ModificationOption('${item.size}SG'),
                  ModificationOption('${item.size}CW'),
                ],
              ),
            );
            break;
          case 'SG':
            _options!.add(
              ModificationOption(
                '${item.toString()}',
                subOptions: [
                  ModificationOption('${item.size}VB'),
                  ModificationOption('${item.size}CW'),
                ],
              ),
            );
            break;
          case 'CW':
            _options!.add(
              ModificationOption(
                '${item.toString()}',
                subOptions: [
                  ModificationOption('${item.size}SG'),
                  ModificationOption('${item.size}VB'),
                ],
              ),
            );
            break;
        }
      });
    }
    var modOptions = ModificationOption('Melee Swap',
        subOptions: _options,
        description:
            'One Light (L) or Medium (M) melee weapon with the React trait ' +
                'can be swapped for an equal class melee weapon for 0 TV,');

    return StandardModification(
        name: 'Melee Swap',
        id: meleeSwapId,
        options: modOptions,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (!traits.any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          if (!(u.core.type == ModelType.Gear ||
              u.core.type == ModelType.Strider)) {
            return false;
          }

          // check to ensure the unit has an appropriate weapon that can be upgraded
          return matchingWeapons.isNotEmpty;
        },
        refreshData: () {
          return StandardModification.meleeSwap(u);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(0),
          description:
              'TV +0, One Light (L) or Medium (M) melee weapon with the React trait ' +
                  'can be swapped for an equal class melee weapon for 0 TV,' +
                  'i.e. a LCW can be swapped for a LVB or a LSG')
      ..addMod<List<Weapon>>(UnitAttribute.weapons, (value) {
        // Grab the substring starting at position 1 to exclude the - or +
        if (modOptions.selectedOption == null ||
            modOptions.selectedOption!.selectedOption == null) {
          return value;
        }
        var remove = value.firstWhere(
            (weapon) => weapon.toString() == modOptions.selectedOption!.text);

        value = value.toList()..remove(remove);

        var add = buildWeapon(modOptions.selectedOption!.selectedOption!.text,
            hasReact: true);
        if (add != null) {
          value.add(add);
        }

        return value;
      });
  }

  /*
  GRENADE SWAP 0 TV
  Any number of models may swap their hand grenades
  for panzerfausts or vice versa. The swapped item must
  be of the same class, such as L, M, or H.
  */
  factory StandardModification.grenadeSwap(Unit u, CombatGroup cg) {
    final List<ModificationOption> _options = [];
    final RegExp weaponMatch = RegExp(r'^(HG|PZ)$');

    final availableWeapons = u.weapons;
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
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          return u.weapons.any((weapon) => weaponMatch.hasMatch(weapon.code));
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(0),
          description:
              'swap their hand grenades for panzerfausts or vice versa. The ' +
                  'swapped item must be of the same class, such as L, M, or H')
      ..addMod<List<Weapon>>(UnitAttribute.weapons, (value) {
        final newList =
            value.map((weapon) => Weapon.fromWeapon(weapon)).toList();
        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text)) {
          var existingWeapon = newList.firstWhere(
              (weapon) => weapon.toString() == modOptions.selectedOption?.text);

          var newWeaponAbb = '';

          if (existingWeapon.code == 'HG') {
            newWeaponAbb = '${existingWeapon.size}PZ';
          } else if (existingWeapon.code == 'PZ') {
            newWeaponAbb = '${existingWeapon.size}HG';
          } else {
            print('weapon code ${existingWeapon.toString()} is not a HG or PZ');
            return newList;
          }

          final newWeapon = buildWeapon(
            newWeaponAbb,
            hasReact: existingWeapon.hasReact,
          );
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
  */
  factory StandardModification.handGrenadeLHG(
      Unit u, CombatGroup cg, UnitRoster roster) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Hand Grenades (LHG)',
        id: handGrenadeLId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (!traits.any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          return !u.hasMod(handGrenadeMId);
        })
      ..addMod<int>(
        UnitAttribute.tv,
        (value) {
          return value + _twoForOneCost(handGrenadeLId, u, roster);
        },
        description: 'TV +1 per 2',
      )
      ..addMod(
        UnitAttribute.weapons,
        createAddWeaponToList(buildWeapon('LHG')!),
        description: '+LHG',
      );
  }

  /*
  HAND GRENADES 1–2 TV
  Only models with the Hands trait can purchase Hand
  Grenades. Choose one option:
  > Up to 2 models may purchase Medium Hand
  Grenades (MHG) for 1 TV each.
  */
  factory StandardModification.handGrenadeMHG(Unit u, CombatGroup cg) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Hand Grenades (MHG)',
        id: handGrenadeMId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (!traits.any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          return !u.hasMod(handGrenadeLId);
        })
      ..addMod(
        UnitAttribute.tv,
        createSimpleIntMod(1),
        description: 'TV +1',
      )
      ..addMod(
        UnitAttribute.weapons,
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
  factory StandardModification.panzerfaustsL(Unit u, UnitRoster roster) {
    return StandardModification(
        name: 'Panzerfausts (LPZ)',
        id: panzerfaustsLId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (!u.traits.any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          if (u.hasMod(panzerfaustsMId)) {
            return false;
          }

          return true;
        })
      ..addMod<int>(
        UnitAttribute.tv,
        (value) {
          return value + _twoForOneCost(panzerfaustsLId, u, roster);
        },
        description: 'TV +1 per 2',
      )
      ..addMod(
        UnitAttribute.weapons,
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
  factory StandardModification.panzerfaustsM() {
    return StandardModification(
        name: 'Panzerfausts (MPZ)',
        id: panzerfaustsMId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (!u.traits.any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          if (u.hasMod(panzerfaustsLId)) {
            return false;
          }

          return true;
        })
      ..addMod(
        UnitAttribute.tv,
        createSimpleIntMod(1),
        description: 'TV +1',
      )
      ..addMod(
        UnitAttribute.weapons,
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
  factory StandardModification.sidearmLP(
      Unit u, CombatGroup cg, UnitRoster roster) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Sidearm (LP)',
        id: pistolsId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (!traits.any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          // can only have eithe 1 pistol or 1 submachinegun
          if (u.hasMod(subMachineGunId)) {
            return false;
          }

          return true;
        })
      ..addMod<int>(
        UnitAttribute.tv,
        (value) {
          return value +
              _twoForOneCost(
                pistolsId,
                u,
                roster,
                modId2: subMachineGunId,
              );
        },
        description: 'TV +1 per 2 Sidearms',
      )
      ..addMod(
        UnitAttribute.weapons,
        createAddWeaponToList(buildWeapon('LP', hasReact: true)!),
        description: '+LP',
      );
  }

  /*
  Sidearms
  Only models with the Hands trait can purchase sidearms.
  These weapons come with the React trait.
  > Add a Light Pistol (LP) or a Light Submachine Gun
    (LSMG) to two models for 1 TV (total).
  */
  factory StandardModification.sidearmSMG(
      Unit u, CombatGroup cg, UnitRoster roster) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Sidearm (LSMG)',
        id: subMachineGunId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (!traits.any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          // can only have eithe 1 pistol or 1 submachinegun
          if (u.hasMod(pistolsId)) {
            return false;
          }

          return true;
        })
      ..addMod<int>(
        UnitAttribute.tv,
        (value) {
          return value +
              _twoForOneCost(
                pistolsId,
                u,
                roster,
                modId2: subMachineGunId,
              );
        },
        description: 'TV +1 per 2 Sidearms',
      )
      ..addMod(
        UnitAttribute.weapons,
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
  factory StandardModification.shapedExplosivesL(
      Unit u, CombatGroup cg, UnitRoster roster) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Shaped Explosives (LSE)',
        id: shapedExplosivesLId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (u.hasMod(shapedExplosivesMId)) {
            return false;
          }

          // Must have the hands trait or be infantry
          if (!(traits.any((element) => _handsMatch.hasMatch(element.name))) &&
              u.movement?.type != 'Infantry') {
            return false;
          }

          return true;
        })
      ..addMod<int>(
        UnitAttribute.tv,
        (value) {
          return value + _twoForOneCost(shapedExplosivesLId, u, roster);
        },
        description: 'TV +1 per 2',
      )
      ..addMod(
        UnitAttribute.weapons,
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
  > Or up to 1 models may purchase Medium Shaped
  Explosives (MSE) for 1 TV each
  */
  factory StandardModification.shapedExplosivesM(Unit u, CombatGroup cg) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Shaped Explosives (MSE)',
        id: shapedExplosivesMId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (u.hasMod(shapedExplosivesLId)) {
            return false;
          }

          // Must have the hands trait or be infantry
          if (!(traits.any((element) => _handsMatch.hasMatch(element.name))) &&
              u.movement?.type != 'Infantry') {
            return false;
          }

          return true;
        })
      ..addMod(
        UnitAttribute.tv,
        createSimpleIntMod(1),
        description: 'TV +1',
      )
      ..addMod(
        UnitAttribute.weapons,
        createAddWeaponToList(buildWeapon('MSE')!),
        description: '+MSE',
      );
  }

  /*
  Smoke
  Models may purchase the Smoke trait for 1 TV. Models
  with the VTOL trait cannot purchase smoke upgrades.
  */
  factory StandardModification.smoke(Unit u, CombatGroup cg) {
    final traits = u.traits.toList();
    return StandardModification(
        name: 'Smoke',
        id: smokeId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (traits.any((element) => _vtolMatch.hasMatch(element.name))) {
            return false;
          }

          return true;
        })
      ..addMod(
        UnitAttribute.tv,
        createSimpleIntMod(1),
        description: 'TV +1',
      )
      ..addMod(
        UnitAttribute.traits,
        createAddTraitToList(Trait.Smoke()),
        description: '+Smoke',
      );
  }
}

int _twoForOneCost(
  String modId,
  Unit u,
  UnitRoster roster, {
  String? modId2,
}) {
  final unitsWithMod = roster.unitsWithMod(modId);
  if (modId2 != null) {
    unitsWithMod.addAll(roster.unitsWithMod(modId2));
  }
  // if no units currently have this mod, the cost will be 1 since this
  // is the first
  if (unitsWithMod.isEmpty) {
    return 1;
  }

  // if this mod is attached to a unit already use the index within the
  // list to determine the cost
  if (unitsWithMod.any((unit) => unit == u)) {
    final index = unitsWithMod.indexOf(u);
    return index % 2 == 0 ? 1 : 0;
  }

  // this unit does not already have the mod
  return unitsWithMod.length % 2;
}
