import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/mods/base_modification.dart';
import 'package:gearforce/v3/models/mods/modification_option.dart';
import 'package:gearforce/v3/models/mods/mods.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/rules/rule_types.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/unit/unit_attribute.dart';
import 'package:gearforce/v3/models/weapons/weapon.dart';
import 'package:gearforce/v3/models/weapons/weapon_modes.dart';
import 'package:gearforce/v3/models/weapons/weapons.dart';

const _vetIDBase = 'mod::vet';

const veteranId = '$_vetIDBase::10';
const improvedGunneryID = '$_vetIDBase::20';
const dualGunsId = '$_vetIDBase::30';
const eccmId = '$_vetIDBase::40';
const brawler1Id = '$_vetIDBase::50';
const brawler2Id = '$_vetIDBase::60';
const reachId = '$_vetIDBase::70';
const meleeUpgradeId = '$_vetIDBase::80';
const resistHId = '$_vetIDBase::90';
const resistFId = '$_vetIDBase::100';
const resistCId = '$_vetIDBase::110';
const fieldArmorId = '$_vetIDBase::120';
const amsId = '$_vetIDBase::130';
const vetPreciseId = '$_vetIDBase::140';

final Map<String, String> _vetModNames = {
  eccmId: 'ECCM',
  improvedGunneryID: 'Improved Gunnery',
  dualGunsId: 'Dual Guns',
  brawler1Id: 'Brawler 1',
  brawler2Id: 'Brawler 2',
  reachId: 'Reach',
  meleeUpgradeId: 'Melee Weapon Upgrade',
  resistHId: 'Resist Haywire',
  resistFId: 'Resist Fire',
  resistCId: 'Resist Corrosion',
  fieldArmorId: 'Field Armor',
  amsId: 'AMS'
};

final RegExp _handsMatch = RegExp(r'^Hands', caseSensitive: false);

class VeteranModification extends BaseModification {
  VeteranModification({
    required super.name,
    required super.id,
    required super.requirementCheck,
    super.options,
    super.refreshData,
    super.ruleType = RuleType.standard,
  }) : super(
          modType: ModificationType.veteran,
        );

  /// Checks if the [modId] is that of a Veteran Upgrade mod.  This will work
  /// if this [modId] is either an ID of a Veteran Upgrade mod, or the name
  /// of a Veteran Upgrade mod.
  static bool isVetMod(String modId) {
    if (modId.startsWith(_vetIDBase)) {
      return _vetModNames.keys.contains(modId);
    }
    return _vetModNames.values.contains(modId);
  }

  static String? vetModName(String modId) {
    return _vetModNames[modId];
  }

  static String? vetModId(String modName) {
    if (!_vetModNames.entries.any((e) => e.value == modName)) {
      return null;
    }
    return _vetModNames.entries.firstWhere((e) => e.value == modName).key;
  }

  static List<String> getAllVetModNames() {
    return _vetModNames.values.toList();
  }

  static List<String> getAllModIds() {
    return _vetModNames.keys.toList();
  }

  factory VeteranModification.makeVet(Unit u, CombatGroup cg) {
    final mod = VeteranModification(
        name: 'Veteran Upgrade',
        id: veteranId,
        requirementCheck:
            (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(cg != null);
          if (cg == null) {
            return false;
          }
          return rs.vetCheck(cg, u);
        });

    modCost() {
      const baseCost = 2;
      final rs = u.ruleset;

      if (rs == null) {
        return baseCost;
      }

      final modCostOverride = rs.modCostOverride(veteranId, u);

      return modCostOverride ?? baseCost;
    }

    mod.addMod<int>(UnitAttribute.tv, (value) {
      return value + modCost();
    }, dynamicDescription: () {
      return 'TV +${modCost()}';
    });

    mod.addMod(
      UnitAttribute.traits,
      createAddTraitToList(Trait.vet()),
      description: '+Vet',
    );
    return mod;
  }

  /*
  ECCM
  Add ECCM trait to a gear, vehicle, or strider for 1 TV.
  */
  factory VeteranModification.eccm(Unit u) {
    final modName = _vetModNames[eccmId];
    assert(modName != null);

    return VeteranModification(
        name: modName ?? eccmId,
        id: eccmId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);

          if (!(u.type == ModelType.gear ||
              u.type == ModelType.strider ||
              u.type == ModelType.vehicle)) {
            return false;
          }

          return rs!.veteranModCheck(u, cg!, modID: eccmId);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.eccm()),
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
    final modName = _vetModNames[reachId];
    assert(modName != null);

    final react = u.reactWeapons;
    final List<ModificationOption> options = [];
    final traitToAdd = Trait.reach(1);
    final allowedWeaponMatch = RegExp(r'^(VB|SG|CW|ICW)$');
    react.where((weapon) {
      return allowedWeaponMatch.hasMatch(weapon.code);
    }).forEach((weapon) {
      options.add(ModificationOption(weapon.toString()));
    });

    final modOptions = ModificationOption('Reach',
        subOptions: options,
        description: 'Choose one of the available weapons to add Reach:1');

    return VeteranModification(
        name: modName ?? reachId,
        id: reachId,
        options: modOptions,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);

          if (!u.reactWeapons
              .any((weapon) => allowedWeaponMatch.hasMatch(weapon.code))) {
            return false;
          }
          return rs!.veteranModCheck(u, cg!, modID: reachId);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod<List<Weapon>>(UnitAttribute.weapons, (value) {
        final newList = value.toList();

        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text)) {
          var existingWeapon = newList.firstWhere(
              (weapon) => weapon.toString() == modOptions.selectedOption?.text);
          if (existingWeapon.traits.any((t) => t.name == 'Reach')) {
            final existingTrait =
                existingWeapon.traits.firstWhere((t) => t.name == 'Reach');
            final currentIndex = newList.indexOf(existingWeapon);
            final newTrait = Trait.reach(existingTrait.level! + 1);
            final newWeapon = Weapon.fromWeapon(existingWeapon);
            if (newWeapon.baseTraits.any((t) => t.name == 'Reach')) {
              newWeapon.baseTraits.remove(existingTrait);
              newWeapon.baseTraits.add(newTrait);
            } else if (newWeapon.bonusTraits.any((t) => t.name == 'Reach')) {
              newWeapon.bonusTraits.remove(existingTrait);
              newWeapon.bonusTraits.add(newTrait);
            }
            newList.replaceRange(currentIndex, currentIndex + 1, [newWeapon]);
          } else {
            final index = newList.indexOf(existingWeapon);
            newList[index] =
                Weapon.fromWeapon(existingWeapon, addTraits: [traitToAdd]);
          }
        }
        return newList;
      },
          description: 'Add the Reach:1 trait to any Vibro Blade, Spike Gun ' +
              'or Combat Weapon with the React trait or increase the value ' +
              'by 1 if it already has reach.');
  }

  /*
  Field Armor
  Add the Field Armor trait to any model. The cost is
  determined by its Armor:
  > Armor 6 or lower for 1 TV
  > Armor 7–8 for 2 TV
  > Armor 9–10 for 3 TV
  > Armor 11–12 for 4 TV
  Terrain, area terrain, buildings, infantry, cavalry and
  airstrike counters cannot purchase field armor.
  */
  factory VeteranModification.fieldArmor(Unit u) {
    final modName = _vetModNames[fieldArmorId];
    assert(modName != null);
    return VeteranModification(
        name: modName ?? fieldArmorId,
        id: fieldArmorId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);
          if (u.type == ModelType.terrain ||
              u.type == ModelType.areaTerrain ||
              u.type == ModelType.building ||
              u.type == ModelType.infantry ||
              u.type == ModelType.cavalry ||
              u.type == ModelType.airstrikeCounter) {
            return false;
          }

          if (u.armor == null || u.armor! > 12) {
            return false;
          }

          if (u.traits
              .any((t) => t.name == 'Field Armor' && !u.hasMod(fieldArmorId))) {
            return false;
          }

          return rs!.veteranModCheck(u, cg!, modID: fieldArmorId);
        })
      ..addMod<int>(
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
        createAddTraitToList(Trait.fieldArmor()),
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
    final modName = _vetModNames[brawler1Id];
    assert(modName != null);

    return VeteranModification(
        name: modName ?? brawler1Id,
        id: brawler1Id,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);
          if (!(u.type == ModelType.infantry ||
              u.type == ModelType.cavalry ||
              u.type == ModelType.gear ||
              u.type == ModelType.strider)) {
            return false;
          }
          if (u.hasMod(brawler2Id)) {
            return false;
          }

          return rs!.veteranModCheck(u, cg!, modID: brawler1Id);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod<List<Trait>>(
        UnitAttribute.traits,
        createAddOrCombineTraitToList(Trait.brawl(1)),
        description: '+Brawl:1 or +1 to existing Brawl',
      );
  }

  /*
  Brawler
  For infantry, cavalry, gears and striders:
  > Or add the Brawl:2 trait or increase the Brawl trait by
  +2 for 2 TV.
  */
  factory VeteranModification.brawler2(Unit u) {
    final modName = _vetModNames[brawler2Id];
    assert(modName != null);

    return VeteranModification(
        name: modName ?? brawler2Id,
        id: brawler2Id,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);
          if (!(u.type == ModelType.infantry ||
              u.type == ModelType.cavalry ||
              u.type == ModelType.gear ||
              u.type == ModelType.strider)) {
            return false;
          }
          if (u.hasMod(brawler1Id)) {
            return false;
          }

          return rs!.veteranModCheck(u, cg!, modID: brawler2Id);
        },
        refreshData: () {
          return VeteranModification.brawler2(u);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
      ..addMod<List<Trait>>(
        UnitAttribute.traits,
        createAddOrCombineTraitToList(Trait.brawl(2)),
        description: '+Brawl:2 or +2 to existing Brawl',
      );
  }

  /*
  Resist:H
  Add the Resist:H trait or remove the Vuln:H trait for 1 TV.
  */
  factory VeteranModification.resistHaywire(Unit u) {
    final modName = _vetModNames[resistHId];
    assert(modName != null);

    final traits = u.traits.toList();
    final isVulnerable =
        traits.any((element) => element.name == 'Vuln' && element.type == 'H');
    return VeteranModification(
        name: modName ?? resistHId,
        id: resistHId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);

          if (traits.any(
              (element) => element.name == 'Resist' && element.type == 'H')) {
            return false;
          }

          return rs!.veteranModCheck(u, cg!, modID: resistHId);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod<List<Trait>>(
        UnitAttribute.traits,
        (value) {
          if (isVulnerable) {
            var oldTrait = traits.firstWhere(
                (element) => element.name == 'Vuln' && element.type == 'H');
            return createRemoveTraitFromList(oldTrait)(value);
          } else {
            return createAddTraitToList(Trait.resistH())(value);
          }
        },
        description: isVulnerable ? '-Vuln:H' : ' +Resist:H',
      );
  }

  /*
  Resist:F
  Add the Resist:F trait or remove the Vuln:F trait for 1 TV.
  */
  factory VeteranModification.resistFire(Unit u) {
    final modName = _vetModNames[resistFId];
    assert(modName != null);

    final traits = u.traits.toList();
    final isVulnerable =
        traits.any((element) => element.name == 'Vuln' && element.type == 'F');
    return VeteranModification(
        name: modName ?? resistFId,
        id: resistFId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);

          if (traits.any(
              (element) => element.name == 'Resist' && element.type == 'F')) {
            return false;
          }

          return rs!.veteranModCheck(u, cg!, modID: resistFId);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod<List<Trait>>(
        UnitAttribute.traits,
        (value) {
          if (isVulnerable) {
            var oldTrait = traits.firstWhere(
                (element) => element.name == 'Vuln' && element.type == 'F');
            return createRemoveTraitFromList(oldTrait)(value);
          } else {
            return createAddTraitToList(Trait.resistF())(value);
          }
        },
        description: isVulnerable ? '-Vuln:F' : ' +Resist:F',
      );
  }

  /*
  Resist:C
  Add the Resist:C trait or remove the Vuln:C trait for 1 TV.
  */
  factory VeteranModification.resistCorrosion(Unit u) {
    final modName = _vetModNames[resistCId];
    assert(modName != null);

    final traits = u.traits.toList();
    final isVulnerable =
        traits.any((element) => element.name == 'Vuln' && element.type == 'C');
    return VeteranModification(
        name: modName ?? resistCId,
        id: resistCId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);

          if (traits.any(
              (element) => element.name == 'Resist' && element.type == 'C')) {
            return false;
          }

          return rs!.veteranModCheck(u, cg!, modID: resistCId);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod<List<Trait>>(
        UnitAttribute.traits,
        (value) {
          if (isVulnerable) {
            var oldTrait = traits.firstWhere(
                (element) => element.name == 'Vuln' && element.type == 'C');
            return createRemoveTraitFromList(oldTrait)(value);
          } else {
            return createAddTraitToList(Trait.resistC())(value);
          }
        },
        description: isVulnerable ? '-Vuln:C' : ' +Resist:C',
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
    final modName = _vetModNames[improvedGunneryID];
    assert(modName != null);

    int? modCostOverride;

    final vm = VeteranModification(
        name: modName ?? improvedGunneryID,
        id: improvedGunneryID,
        requirementCheck:
            (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(cg != null);

          if (u.actions == null || u.gunnery == null) {
            return false;
          }

          modCostOverride = rs.modCostOverride(improvedGunneryID, u);
          return rs.veteranModCheck(u, cg!, modID: improvedGunneryID);
        });

    vm.addMod<int>(
      UnitAttribute.tv,
      (value) {
        if (modCostOverride != null) {
          return value + modCostOverride!;
        }
        return value + ((u.actions ?? 0) * 2);
      },
      dynamicDescription: () {
        if (modCostOverride != null) {
          return 'TV +$modCostOverride';
        }
        return 'TV +${(u.actions ?? 0) * 2}';
      },
    );

    vm.addMod<int>(
      UnitAttribute.gunnery,
      (value) {
        return value - 1;
      },
      description: 'Improve this model’s gunnery skill by one',
    );

    return vm;
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
    final modName = _vetModNames[dualGunsId];
    assert(modName != null);

    final RegExp weaponCheck = RegExp(r'^(P|SMG|AC|FC|FL|GL)');
    final react = u.reactWeapons;
    final List<ModificationOption> options = [];
    final traitToAdd = Trait.link();

    final allWeapons = react.toList();
    allWeapons
        .where((weapon) => weaponCheck.hasMatch(weapon.code) && !weapon.isCombo)
        .forEach((weapon) {
      options.add(ModificationOption(weapon.toString()));
    });

    var modOptions = ModificationOption('Dual Guns',
        subOptions: options,
        description: 'Add the Link trait to one Pistol, Submachine Gun, ' +
            'Autocannon, Frag Cannon, Flamer or Grenade ' +
            'Launcher with the React trait for 1 TV.');

    final vm = VeteranModification(
        name: modName ?? dualGunsId,
        id: dualGunsId,
        options: modOptions,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);

          if (!u.reactWeapons.any((weapon) =>
              weaponCheck.hasMatch(weapon.code) && !weapon.isCombo)) {
            return false;
          }

          return rs!.veteranModCheck(u, cg!, modID: dualGunsId);
        });

    vm.addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1');

    vm.addMod<List<Weapon>>(
      UnitAttribute.weapons,
      (value) {
        final newList = value.toList();

        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text)) {
          var existingWeapon = newList.firstWhere(
              (weapon) => weapon.toString() == modOptions.selectedOption?.text);
          final index = newList.indexOf(existingWeapon);
          newList[index] =
              Weapon.fromWeapon(existingWeapon, addTraits: [traitToAdd]);
        }
        return newList;
      },
      description: 'Add the Link trait to one Pistol, Submachine Gun, ' +
          'Autocannon, Frag Cannon, Flamer or Grenade ' +
          'Launcher with the React trait for 1 TV.',
    );

    return vm;
  }

  /*
  Veteran Melee Upgrade
  A gear with the Hands trait may receive one of the
  following for 1 TV:
  > LVB (React, Precise)
  > LCW (React, Brawl:1)
  */
  factory VeteranModification.meleeWeaponUpgrade(Unit u) {
    final modName = _vetModNames[meleeUpgradeId];
    assert(modName != null);

    final modOptions = ModificationOption('Melee Weapon Upgrade',
        subOptions: [
          ModificationOption('LVB (React Precise)'),
          ModificationOption('LCW (React Brawl:1)')
        ],
        description: 'A gear with the hands trait may add either  ' +
            'a LVB (React, Precise) or LCW (React, Brawl:1)');

    return VeteranModification(
        name: modName ?? meleeUpgradeId,
        id: meleeUpgradeId,
        options: modOptions,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);

          if (u.type != ModelType.gear) {
            return false;
          }

          if (!u.traits
              .toList()
              .any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          return rs!.veteranModCheck(u, cg!, modID: meleeUpgradeId);
        },
        refreshData: () {
          return VeteranModification.meleeWeaponUpgrade(u);
        })
      ..addMod(
        UnitAttribute.tv,
        createSimpleIntMod(1),
        description: 'TV +1',
      )
      ..addMod<List<Weapon>>(UnitAttribute.weapons, (value) {
        final newList =
            value.map((weapon) => Weapon.fromWeapon(weapon)).toList();

        // check if an option has been selected
        if (modOptions.selectedOption == null) {
          return newList;
        }

        final weaponToAdd =
            buildWeapon(modOptions.selectedOption!.text, hasReact: true);
        if (weaponToAdd != null) {
          newList.add(weaponToAdd);
        }

        return newList;
      },
          description: 'A gear with the hands trait may add either  ' +
              'a LVB (React, Precise) or LCW (React, Brawl:1)');
  }

  /*
  AMS
  Add the AMS trait to a model that has a frag cannon,
  autocannon, submachine gun, machine gun or rotary
  cannon for 1 TV.
  */
  factory VeteranModification.ams(Unit u) {
    final modName = _vetModNames[amsId];
    assert(modName != null);

    final allowedWeaponMatch = RegExp(r'^(FC|AC|SMG|MG|RC)$');
    return VeteranModification(
        name: modName ?? amsId,
        id: amsId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);

          final matchingWeapons = u.weapons.where((weapon) {
            return allowedWeaponMatch.hasMatch(weapon.code);
          });

          if (matchingWeapons.isEmpty) {
            return false;
          }

          return rs!.veteranModCheck(u, cg!, modID: amsId);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ams()),
          description: '+AMS');
  }

  /*
    Veteran Precise
    * Add the Precise trait to one weapon for 1 TV.
    * Or upgrade one weapon’s Precise trait to Precise+
    for 1 TV.
    If this is a combination weapon, this upgrade only applies
    to one of the component weapons.
  */
  factory VeteranModification.vetPrecise(Unit u) {
    final List<ModificationOption> options = [];
    final availableWeapons = u
        .attribute<List<Weapon>>(
          UnitAttribute.weapons,
          modIDToSkip: vetPreciseId,
        )
        .where((w) => w.modes.any((m) => m != WeaponModes.melee));
    for (var w in availableWeapons) {
      options.add(ModificationOption(w.toString()));
    }

    var modOptions = ModificationOption(
      'Veteran Precise',
      subOptions: options,
      description: 'Add the Precise trait to one weapon for 1 TV or' +
          ' upgrade one weapon’s Precise trait to Precise+ for 1 TV.',
    );

    final mod = VeteranModification(
      name: 'Veteran Precise',
      id: vetPreciseId,
      options: modOptions,
      ruleType: RuleType.alphaBeta,
      requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
        if (!rs.settings.isAlphaBetaAllowed) {
          return false;
        }

        final hasRangedWeapon =
            u.weapons.any((w) => w.modes.any((m) => m != WeaponModes.melee));
        if (!hasRangedWeapon) {
          return false;
        }
        return rs.veteranModCheck(u, cg!, modID: vetPreciseId);
      },
      refreshData: () => VeteranModification.vetPrecise(u),
    );

    mod.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(1),
      description: 'TV +1',
    );

    mod.addMod<List<Weapon>>(
      UnitAttribute.weapons,
      (value) {
        final newList =
            value.map((weapon) => Weapon.fromWeapon(weapon)).toList();

        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text)) {
          var existingWeapon = newList.firstWhere(
              (weapon) => weapon.toString() == modOptions.selectedOption?.text);

          final index = newList.indexOf(existingWeapon);

          if (existingWeapon.traits.any((t) => t.isSameType(Trait.precise()))) {
            newList[index] = Weapon.fromWeapon(
              existingWeapon,
              traitsToRemove: [Trait.precise()],
              addTraits: [Trait.precisePlus()],
            );
          } else {
            newList[index] = Weapon.fromWeapon(
              existingWeapon,
              addTraits: [Trait.precise()],
            );
          }
        }

        return newList;
      },
      description: 'Add the Precise trait to one weapon for 1 TV or' +
          ' upgrade one weapon’s Precise trait to Precise+ for 1 TV.' +
          ' If this is a combination weapon, this upgrade only applies' +
          ' to one of the component weapons.',
    );

    return mod;
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
