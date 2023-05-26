import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/range.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';
import 'package:gearforce/models/weapons/weapons.dart';

const _duelistIDBase = 'mod::duelist';

const duelistId = '$_duelistIDBase::10';
const independentOperatorId = '$_duelistIDBase::20';
const leadByExampleId = '$_duelistIDBase::30';
const advancedControlSystemId = '$_duelistIDBase::40';
const stableId = '$_duelistIDBase::50';
const preciseId = '$_duelistIDBase::60';
const autoId = '$_duelistIDBase::70';
const aceGunnerId = '$_duelistIDBase::80';
const trickShotId = '$_duelistIDBase::90';
const meleeUpgradeId = '$_duelistIDBase::100';
const dualMeleeWeaponsId = '$_duelistIDBase::110';
const shieldId = '$_duelistIDBase::120';
const agileId = '$_duelistIDBase::130';
const ecmId = '$_duelistIDBase::140';

final RegExp _handsMatch = RegExp(r'^Hands', caseSensitive: false);

class DuelistModification extends BaseModification {
  DuelistModification({
    required String name,
    required String id,
    required RequirementCheck requirementCheck,
    final ModificationOption? options,
    final BaseModification Function()? refreshData,
  }) : super(
          name: name,
          id: id,
          requirementCheck: requirementCheck,
          options: options,
          refreshData: refreshData,
          modType: ModificationType.duelist,
        );

  factory DuelistModification.makeDuelist(Unit u, UnitRoster roster) {
    final traits = u.traits.toList();
    final isVet =
        traits.any((element) => element.name == 'Vet') || u.hasMod(veteranId);
    var mod = DuelistModification(
        name: 'Duelist Upgrade',
        id: duelistId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (u.hasMod(duelistId)) {
            return true;
          }
          if (!roster.subFaction.value.ruleSet.duelistCheck(roster, u)) {
            return false;
          }

          return !traits.any((trait) => trait.name == 'Duelist');
        });
    mod.addMod<int>(
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
    mod.addMod<List<Trait>>(
      UnitAttribute.traits,
      createAddTraitToList(const Trait(name: 'Duelist')),
      description: '+Duelist',
    );

    mod.addMod(
      UnitAttribute.traits,
      createAddTraitToList(const Trait(name: 'Vet')),
      description: '+Vet',
    );

    return mod;
  }

/*
  Independent Operator
  If you select the Independent Operator option, the duelist
  will be in a combat group all by itself.
  > Select a role to be used as you would normally do for
  a primary unit of a combat group. This role may be
  used to select objectives.
  > The independent operator may not be a CGL or 2iC.
  However, they may be upgraded to a XO, CO, or TFC.
*/
  factory DuelistModification.independentOperator(Unit u, CombatGroup cg) {
    return DuelistModification(
        name: 'Independent Operator',
        id: independentOperatorId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (u.hasMod(leadByExampleId)) {
            return false;
          }

          assert(cg != null);

          if (cg == null) {
            return false;
          }

          // The independent operator must be in a CG alone
          if (cg.numberOfUnits() > 1) {
            return false;
          }

          return u.isDuelist;
        })
      ..addMod(
        UnitAttribute.traits,
        createAddTraitToList(const Trait(name: 'Independent Operator')),
        description:
            'Duelist is an Independent Operator and will be the sole ' +
                'model in a combat group',
      )
      ..addMod(
          UnitAttribute.roles,
          createReplaceRoles(Roles(
            roles: [
              Role(name: RoleType.FS),
              Role(name: RoleType.FT),
              Role(name: RoleType.GP),
              Role(name: RoleType.RC),
              Role(name: RoleType.SK),
              Role(name: RoleType.SO),
            ],
          )));
  }

/*
  Lead by Example
  If you select the Lead by Example option, your duelist will
  gain the following ability during the game.
  > Once per round, for each duelist, whenever a duelist
  damages an enemy model, give one SP to one model
  in formation with the duelist.
  > This SP does not convert to a CP. If not used, this SP
  is removed during cleanup.
*/
  factory DuelistModification.leadByExample(Unit u, UnitRoster roster) {
    return DuelistModification(
        name: 'Lead by Example',
        id: leadByExampleId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (u.hasMod(independentOperatorId)) {
            return false;
          }

          return u.isDuelist;
        })
      ..addMod(
        UnitAttribute.traits,
        createAddTraitToList(const Trait(name: 'Lead by Example')),
        description:
            'duelist will gain the following ability during the game. Once ' +
                'per round, for each duelist, whenever a duelist damages an enemy ' +
                ' model, give one SP to one model in formation with the duelist.',
      );
  }

  /*
  Advanced Control System
  Gain +1 action point. This upgrade costs 2 TV for models
  with an armor of 7 or lower and 3 TV for models with an
  armor of 8 or higher. Models may not upgrade to having
  more than 3 action points.
  */
  factory DuelistModification.advancedControlSystem(Unit u) {
    return DuelistModification(
        name: 'Advanced Control System',
        id: advancedControlSystemId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (u.actions != null && u.actions! >= 3) {
            return false;
          }
          return u.isDuelist;
        })
      ..addMod<int>(UnitAttribute.tv, (value) {
        if (u.armor == null) {
          return value;
        }

        return value + (u.armor! >= 8 ? 3 : 2);
      }, dynamicDescription: () {
        return 'TV +${u.armor != null ? u.armor! >= 8 ? 3 : 2 : 0}';
      })
      ..addMod<int>(UnitAttribute.actions, (value) {
        if (value >= 3) {
          return value;
        }
        return value + 1;
      },
          description:
              'Gain +1 action point. All models have a maximum of 3 actions');
  }

  /*
  Stable
  For ranged weapons:
  > Add the Stable trait to any one weapon for 2 TV.
  > Or, add the Stable trait to a combo weapon for 3 TV.
  */
  factory DuelistModification.stable(Unit u) {
    final List<ModificationOption> _options = [];
    const traitToAdd = const Trait(name: 'Stable');

    u.weapons.forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Stable',
        subOptions: _options,
        description: 'Choose a weapon to gain the Stable trait.');

    final mod = DuelistModification(
        name: 'Stable',
        id: stableId,
        options: modOptions,
        refreshData: () {
          return DuelistModification.stable(u);
        },
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          return u.isDuelist;
        })
      ..addMod<int>(UnitAttribute.tv, (value) {
        return value +
            _comboNotComboCost(modOptions.selectedOption,
                comboCost: 3, nonComboCost: 2);
      },
          description:
              'TV +2/3, Add Stable to a weapon for TV +3 for combo weapons or +2 for regular weapons')
      ..addMod<List<Weapon>>(UnitAttribute.react_weapons, (value) {
        final newList = value.toList();

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
      ..addMod<List<Weapon>>(UnitAttribute.mounted_weapons, (value) {
        final newList = value.toList();

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
  Precise
  > Add the Precise trait to one weapon for 1 TV.
  > Or, add the Precise trait to a combo weapon for 2 TV.
  */
  factory DuelistModification.precise(Unit u) {
    final List<ModificationOption> _options = [];
    const traitToAdd = const Trait(name: 'Precise');

    u.weapons.forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Precise',
        subOptions: _options,
        description: 'Choose a weapon to gain the Precise trait.');

    final mod = DuelistModification(
        name: 'Precise',
        id: preciseId,
        options: modOptions,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          return u.isDuelist;
        },
        refreshData: () {
          return DuelistModification.precise(u);
        })
      ..addMod<int>(UnitAttribute.tv, (value) {
        return value +
            _comboNotComboCost(modOptions.selectedOption,
                comboCost: 2, nonComboCost: 1);
      },
          description:
              'TV +1/2, Add Precise to a weapon for TV +2 for combo weapons or +1 for regular weapons')
      ..addMod<List<Weapon>>(UnitAttribute.react_weapons, (value) {
        final newList = value.toList();

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
      ..addMod<List<Weapon>>(UnitAttribute.mounted_weapons, (value) {
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
  Auto
  Add the Auto trait to one ranged weapon, or ranged
  combo weapon, that has the React trait for 1 TV.
  */
  factory DuelistModification.auto(Unit u) {
    final react = u.reactWeapons;
    final List<ModificationOption> _options = [];
    const traitToAdd = const Trait(name: 'Auto');

    final availableWeapons = react.where((weapon) =>
        weapon.modes.any((mode) => mode != weaponModes.Melee) ||
        weapon.isCombo);

    availableWeapons.forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Auto',
        subOptions: _options,
        description: 'Choose an available weapon to have the Auto trait added');

    return DuelistModification(
        name: 'Auto',
        id: autoId,
        options: modOptions,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (u.reactWeapons
              .where((weapon) =>
                  weapon.modes.any((mode) => mode != weaponModes.Melee) ||
                  weapon.isCombo)
              .isEmpty) {
            return false;
          }
          return u.isDuelist;
        },
        refreshData: () {
          return DuelistModification.auto(u);
        })
      ..addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
          description: 'TV +1')
      ..addMod<List<Weapon>>(
        UnitAttribute.react_weapons,
        (value) {
          final newList = value.toList();

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
  Ace Gunner
  For 1 TV, when using an autocannon, this model does
  not suffer the -1D6 modifier when using the Split trait for
  attacks against multiple models.
  */
  factory DuelistModification.aceGunner(Unit u) {
    final RegExp allowedWeaponMatch = RegExp(r'(AC)');
    return DuelistModification(
        name: 'Ace Gunner',
        id: aceGunnerId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          final matchingWeapons = u.weapons
              .where((weapon) => allowedWeaponMatch.hasMatch(weapon.code));

          if (matchingWeapons.isEmpty) {
            return false;
          }

          return u.isDuelist;
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.traits,
          createAddTraitToList(const Trait(name: 'Ace Gunner')))
      ..addMod(
          UnitAttribute.special,
          createAddStringToList(
              'This model does not suffer the -1D6 modifier when using the Split weapon trait'),
          description:
              'This model does not suffer the -1D6 modifier when using the Split weapon trait');
  }

  /*
  Trick Shot
  Gears with the Hands trait may add LP (Link, Split) for 1
  TV. This model does not suffer the -1D6 modifier when
  using the Split trait for attacks made with this weapon.
  The range for this weapon is doubled (0-24/48).
  For modeling purposes, this adds two light pistols to the
  model. Linked weapons on a gear is normally represented
  as having two of the same weapon, one in each hand.
  */
  factory DuelistModification.trickShot(Unit u) {
    final range = Range(0, 24, 48);
    final trickPistol = Weapon.fromWeapon(
      buildWeapon('LP (Link Split)', hasReact: true)!,
      range: range,
    );

    return DuelistModification(
        name: 'Trick Shot',
        id: trickShotId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (!u.traits.any((element) => _handsMatch.hasMatch(element.name))) {
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
        UnitAttribute.react_weapons,
        createAddWeaponToList(trickPistol),
        description: '+LP (Link, Split)',
      );
  }

  /*
  Dual Melee Weapons
  Add the Link trait to a vibro-blade, combat weapon, or
  spike gun for 1 TV.
  */
  factory DuelistModification.dualMeleeWeapons(Unit u) {
    final RegExp meleeCheck = RegExp(r'(VB|CW|SG)');
    final react = u.reactWeapons;
    final mounted = u.mountedWeapons;
    final List<ModificationOption> _options = [];
    const traitToAdd = const Trait(name: 'Link');

    final allWeapons = react.toList()..addAll(mounted);
    allWeapons
        .where((weapon) => meleeCheck.hasMatch(weapon.code))
        .forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Dual Melee Weapons',
        subOptions: _options,
        description: 'Choose a melee weapon to have the Link trait added');

    return DuelistModification(
        name: 'Dual Melee Weapons',
        id: dualMeleeWeaponsId,
        options: modOptions,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          return u.isDuelist;
        },
        refreshData: () {
          return DuelistModification.dualMeleeWeapons(u);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1),
          description:
              'TV +1, Add the Link trait to any melee weapon other than ' +
                  'Shaped Explosives. This adds a second weapon of the ' +
                  'same type to the model.')
      ..addMod<List<Weapon>>(UnitAttribute.react_weapons, (value) {
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
      ..addMod<List<Weapon>>(UnitAttribute.mounted_weapons, (value) {
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
  Agile
  Add the Agile trait for 1 TV. Models with the Lumbering
  trait cannot receive the Agile trait.
  */
  factory DuelistModification.agile() {
    final RegExp traitCheck = RegExp(r'(Agile|Lumbering)');
    final Trait newTrait = const Trait(name: 'Agile');
    return DuelistModification(
        name: 'Agile',
        id: agileId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
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
  Shield
  Add the Shield trait to a model. This upgrade costs 1
  TV for models with an armor of 7 or lower and 2 TV for
  models with an armor of 8 or higher.
  */
  factory DuelistModification.shield(Unit u) {
    final Trait newTrait = const Trait(name: 'Shield');

    return DuelistModification(
        name: 'Shield',
        id: shieldId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          return u.isDuelist;
        })
      ..addMod<int>(
        UnitAttribute.tv,
        ((value) {
          final armor = u.armor;

          if (armor == null) {
            return value;
          }

          return value + (armor <= 7 ? 1 : 2);
        }),
        dynamicDescription: () {
          final armor = u.armor;
          return 'TV +${armor != null ? armor <= 7 ? 1 : 2 : 0}';
        },
      )
      ..addMod(UnitAttribute.traits, createAddTraitToList(newTrait),
          description:
              'Add the Shield trait to a model. This upgrade costs 1 ' +
                  'TV for models with an Armor of 7 or lower and 2 TV for ' +
                  'models with an Armor of 8 or higher.');
  }

  /*
  Duelist Melee Upgrade
  A duelist with the Hands trait may receive one of the
  following for 1 TV:
  > MVB (React)
  > MCW (React, Demo:4)
  */
  factory DuelistModification.meleeUpgrade(Unit u) {
    final weaponOption1 = buildWeapon('MVB', hasReact: true);
    final weaponOption2 = buildWeapon('MCW (Demo:4)', hasReact: true);

    var modOptions = ModificationOption('Duelist Melee Upgrade',
        subOptions: [
          ModificationOption(weaponOption1.toString()),
          ModificationOption(weaponOption2.toString()),
        ],
        description: 'Choose a weapon to add');

    return DuelistModification(
        name: 'Duelist Melee Upgrade',
        id: meleeUpgradeId,
        options: modOptions,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          return u.isDuelist;
        },
        refreshData: () {
          return DuelistModification.meleeUpgrade(u);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod<List<Weapon>>(UnitAttribute.react_weapons, (value) {
        // check if an option has been selected
        if (modOptions.selectedOption == null) {
          return value;
        }

        final weaponToAdd =
            buildWeapon(modOptions.selectedOption!.text, hasReact: true);
        if (weaponToAdd != null) {
          value.add(weaponToAdd);
        }

        return value;
      },
          description: 'Upgrade one melee weapon with the React trait to one ' +
              'of the following with react: MVB, MCW (Demo:4)');
  }

  /*
  ECM Upgrade
  A model with an ECM trait may upgrade their ECM to an
  ECM+ for 1 TV.
  */
  factory DuelistModification.ecm() {
    final RegExp traitCheck = RegExp(r'^ECM$', caseSensitive: false);
    return DuelistModification(
        name: 'ECM',
        id: ecmId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          if (!u.traits.any((trait) => traitCheck.hasMatch(trait.name))) {
            return false;
          }
          return u.isDuelist;
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod<List<Trait>>(UnitAttribute.traits, (value) {
        var newList = new List<Trait>.from(value);

        final oldTrait =
            newList.firstWhere((t) => t.name.toLowerCase() == 'ecm');
        newList.remove(oldTrait);

        if (!newList.any((t) => t.name.toLowerCase() == 'ecm+')) {
          newList.add(Trait.fromTrait(oldTrait, name: 'ECM+'));
        }

        return newList;
      }, description: '-ECM, +ECM+');
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
