import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart'
    as vetMod;
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/command.dart';
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

final Map<String, String> _duelistModNames = {
  independentOperatorId: 'Independent Operator',
  leadByExampleId: 'Lead by Example',
  advancedControlSystemId: 'Advanced Control System',
  stableId: 'Stable',
  preciseId: 'Precise',
  autoId: 'Auto',
  aceGunnerId: 'Ace Gunner',
  trickShotId: 'Trick Shot',
  meleeUpgradeId: 'Duelist Melee Upgrade',
  dualMeleeWeaponsId: 'Dual Melee Weapons',
  shieldId: 'Shield',
  agileId: 'Agile',
  ecmId: 'ECM',
};

final RegExp _handsMatch = RegExp(r'^Hands', caseSensitive: false);

class DuelistModification extends BaseModification {
  DuelistModification({
    required String name,
    required String id,
    required RequirementCheck requirementCheck,
    final ModificationOption? options,
    final BaseModification Function()? refreshData,
    super.onAdd,
    super.onRemove,
  }) : super(
          name: name,
          id: id,
          requirementCheck: requirementCheck,
          options: options,
          refreshData: refreshData,
          modType: ModificationType.duelist,
        );

  /// Checks if the [modId] is that of a Duelist Upgrade mod.  This will work
  /// if this [modId] is either an ID of a Duelist Upgrade mod, or the name
  /// of a Duelist Upgrade mod.
  static bool isDuelistMod(String modId) {
    if (modId.startsWith(_duelistIDBase)) {
      return _duelistModNames.keys.contains(modId);
    }
    return _duelistModNames.values.contains(modId);
  }

  factory DuelistModification.makeDuelist(Unit u, UnitRoster roster) {
    final isVet = u.isVeteran;
    final mod = DuelistModification(
        name: 'Duelist Upgrade',
        id: duelistId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(cg != null);
          if (u.hasMod(duelistId)) {
            return true;
          }
          if (cg == null) {
            return false;
          }
          return roster.rulesetNotifer.value.duelistCheck(roster, cg, u);
        });
    mod.addMod<int>(
      UnitAttribute.tv,
      (value) {
        return createSimpleIntMod(
          u.core.traits.any((trait) => trait.name == 'Vet') ||
                  u.hasMod(vetMod.veteranId)
              ? 0
              : 2,
        )(value);
      },
      description: 'TV +${isVet ? 0 : 2}',
    );
    mod.addMod<List<Trait>>(
      UnitAttribute.traits,
      createAddTraitToList(Trait.Duelist()),
      description: '+Duelist',
    );

    mod.addMod(
      UnitAttribute.traits,
      createAddTraitToList(Trait.Vet()),
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
    final modName = _duelistModNames[independentOperatorId];
    assert(modName != null);

    final independentOperator = DuelistModification(
      name: modName ?? independentOperatorId,
      id: independentOperatorId,
      requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
        assert(rs != null);
        assert(ur != null);

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

        return rs!.duelistModCheck(u, cg, modID: independentOperatorId);
      },
      onAdd: (u) {
        switch (u?.commandLevel) {
          case CommandLevel.secic:
          case CommandLevel.cgl:
            u?.commandLevel = CommandLevel.none;
            break;
          default:
            break;
        }
      },
    );

    independentOperator.addMod(
      UnitAttribute.traits,
      createAddTraitToList(const Trait(
          name: 'Independent Operator',
          description: 'Duelist is an Independent Operator and will be the' +
              ' sole model in a combat group')),
      description: 'Duelist is an Independent Operator and will be the sole ' +
          'model in a combat group',
    );

    independentOperator.addMod(
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

    return independentOperator;
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
    final modName = _duelistModNames[leadByExampleId];
    assert(modName != null);

    return DuelistModification(
        name: modName ?? leadByExampleId,
        id: leadByExampleId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);

          if (u.hasMod(independentOperatorId)) {
            return false;
          }

          return rs!.duelistModCheck(u, cg!, modID: leadByExampleId);
        })
      ..addMod(
        UnitAttribute.traits,
        createAddTraitToList(const Trait(
            name: 'Lead by Example',
            description: 'duelist will gain the following ability during the ' +
                ' game. Once per round, for each duelist, whenever a duelist ' +
                ' damages an enemy model, give one SP to one model in formation with the duelist.')),
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
    final modName = _duelistModNames[advancedControlSystemId];
    assert(modName != null);

    return DuelistModification(
        name: modName ?? advancedControlSystemId,
        id: advancedControlSystemId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);

          final actionLimit = u.hasMod(advancedControlSystemId) ? 4 : 3;

          if (u.actions != null && u.actions! >= actionLimit) {
            return false;
          }
          return rs!.duelistModCheck(u, cg!, modID: advancedControlSystemId);
        })
      ..addMod<int>(UnitAttribute.tv, (value) {
        if (u.armor == null) {
          return value;
        }

        return value + (u.armor! >= 8 ? 3 : 2);
      }, dynamicDescription: () {
        return 'TV +${u.armor != null ? u.armor! >= 8 ? 3 : 2 : 0}';
      })
      ..addMod<int>(
        UnitAttribute.actions,
        (value) {
          if (value >= 3) {
            return value;
          }
          return value + 1;
        },
        description:
            'Gain +1 action point. All models have a maximum of 3 actions',
      );
  }

  /*
  Stable
  For ranged weapons:
  > Add the Stable trait to any one weapon for 2 TV.
  > Or, add the Stable trait to a combo weapon for 3 TV.
  */
  factory DuelistModification.stable(Unit u) {
    final modName = _duelistModNames[stableId];
    assert(modName != null);

    final List<ModificationOption> _options = [];
    final traitToAdd = Trait.Stable();

    u.weapons
        .where((weapon) => !weapon.modes.every((wm) => wm == weaponModes.Melee))
        .forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Stable',
        subOptions: _options,
        description: 'Choose a weapon to gain the Stable trait.');

    final mod = DuelistModification(
        name: modName ?? stableId,
        id: stableId,
        options: modOptions,
        refreshData: () {
          return DuelistModification.stable(u);
        },
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);
          // if a unit has the stable trait, no point to include it on any weapons
          if (u.traits.any((t) => t.isSameType(Trait.Stable()))) {
            return false;
          }
          return rs!.duelistModCheck(u, cg!, modID: stableId);
        })
      ..addMod<int>(
        UnitAttribute.tv,
        (value) {
          return value +
              _comboNotComboCost(modOptions.selectedOption,
                  comboCost: 3, nonComboCost: 2);
        },
        description: 'TV +2/3, Add Stable to a weapon for TV +3 for combo' +
            ' weapons or +2 for regular weapons',
      )
      ..addMod<List<Weapon>>(UnitAttribute.weapons, (value) {
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
      });

    return mod;
  }

  /*
  Precise
  > Add the Precise trait to one weapon for 1 TV.
  > Or, add the Precise trait to a combo weapon for 2 TV.
  */
  factory DuelistModification.precise(Unit u) {
    final modName = _duelistModNames[preciseId];
    assert(modName != null);

    final List<ModificationOption> _options = [];
    final traitToAdd = Trait.Precise();

    u.weapons.forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Precise',
        subOptions: _options,
        description: 'Choose a weapon to gain the Precise trait.');

    final mod = DuelistModification(
        name: modName ?? preciseId,
        id: preciseId,
        options: modOptions,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);
          return rs!.duelistModCheck(u, cg!, modID: preciseId);
        },
        refreshData: () {
          return DuelistModification.precise(u);
        })
      ..addMod<int>(UnitAttribute.tv, (value) {
        return value +
            _comboNotComboCost(modOptions.selectedOption,
                comboCost: 2, nonComboCost: 1);
      },
          description: 'TV +1/2, Add Precise to a weapon for TV +2 for' +
              ' combo weapons or +1 for regular weapons')
      ..addMod<List<Weapon>>(UnitAttribute.weapons, (value) {
        final newList = value.toList();

        if (modOptions.selectedOption != null &&
            newList.any((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text)) {
          final existingWeapon = newList.firstWhere(
              (weapon) => weapon.toString() == modOptions.selectedOption?.text);
          final index = newList.indexOf(existingWeapon);
          newList[index] =
              Weapon.fromWeapon(existingWeapon, addTraits: [traitToAdd]);
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
    final modName = _duelistModNames[autoId];
    assert(modName != null);

    final react = u.reactWeapons;
    final List<ModificationOption> _options = [];
    final traitToAdd = Trait.Auto();

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
        name: modName ?? autoId,
        id: autoId,
        options: modOptions,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);
          if (u.reactWeapons
              .where((weapon) =>
                  weapon.modes.any((mode) => mode != weaponModes.Melee) ||
                  weapon.isCombo)
              .isEmpty) {
            return false;
          }
          return rs!.duelistModCheck(u, cg!, modID: autoId);
        },
        refreshData: () {
          return DuelistModification.auto(u);
        })
      ..addMod<int>(UnitAttribute.tv, createSimpleIntMod(1),
          description: 'TV +1')
      ..addMod<List<Weapon>>(
        UnitAttribute.weapons,
        (value) {
          final newList = value.toList();

          if (modOptions.selectedOption != null &&
              newList.any((weapon) =>
                  weapon.toString() == modOptions.selectedOption?.text)) {
            var existingWeapon = newList.firstWhere((weapon) =>
                weapon.toString() == modOptions.selectedOption?.text);
            final index = newList.indexOf(existingWeapon);
            newList[index] =
                Weapon.fromWeapon(existingWeapon, addTraits: [traitToAdd]);
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
    final modName = _duelistModNames[aceGunnerId];
    assert(modName != null);

    final RegExp allowedWeaponMatch = RegExp(r'(AC)');
    return DuelistModification(
        name: modName ?? aceGunnerId,
        id: aceGunnerId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);
          final matchingWeapons = u.weapons
              .where((weapon) => allowedWeaponMatch.hasMatch(weapon.code));

          if (matchingWeapons.isEmpty) {
            return false;
          }

          return rs!.duelistModCheck(u, cg!, modID: aceGunnerId);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(
          UnitAttribute.traits,
          createAddTraitToList(const Trait(
            name: 'Ace Gunner',
            description:
                'When using an autocannon this model does not suffer the -1D6 modifier when' +
                    ' using the Split weapon trait',
          )))
      ..addMod(
          UnitAttribute.special,
          createAddStringToList(
              'When using an autocannon this model does not suffer the -1D6 modifier when using the Split weapon trait'),
          description:
              'When using an autocannon this model does not suffer the -1D6 modifier when using the Split weapon trait');
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
    final modName = _duelistModNames[trickShotId];
    assert(modName != null);

    final range = Range(0, 24, 48);
    final trickPistol = Weapon.fromWeapon(
      buildWeapon('LP (Link Split)', hasReact: true)!,
      range: range,
    );

    return DuelistModification(
        name: modName ?? trickShotId,
        id: trickShotId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);

          if (!u.traits.any((element) => _handsMatch.hasMatch(element.name))) {
            return false;
          }

          return rs!.duelistModCheck(u, cg!, modID: trickShotId);
        })
      ..addMod(
        UnitAttribute.tv,
        createSimpleIntMod(1),
        description: 'TV +1',
      )
      ..addMod(
        UnitAttribute.weapons,
        createAddWeaponToList(trickPistol),
        description: '+LP (Link, Split)',
      )
      ..addMod(
          UnitAttribute.special,
          createAddStringToList(
              'When using the LP (Link, Split) this model does not suffer the -1D6 modifier when using the Split weapon trait'),
          description:
              'When using the LP (Link, Split) this model does not suffer the -1D6 modifier when using the Split weapon trait');
  }

  /*
  Dual Melee Weapons
  Add the Link trait to a vibro-blade, combat weapon, or
  spike gun for 1 TV.
  */
  factory DuelistModification.dualMeleeWeapons(Unit u) {
    final modName = _duelistModNames[dualMeleeWeaponsId];
    assert(modName != null);

    final RegExp meleeCheck = RegExp(r'(VB|CW|SG)');
    final List<ModificationOption> _options = [];
    final traitToAdd = Trait.Link();

    final allWeapons = u.weapons;
    allWeapons
        .where((weapon) => meleeCheck.hasMatch(weapon.code))
        .forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Dual Melee Weapons',
        subOptions: _options,
        description: 'Choose a melee weapon to have the Link trait added');

    return DuelistModification(
        name: modName ?? dualMeleeWeaponsId,
        id: dualMeleeWeaponsId,
        options: modOptions,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);
          return rs!.duelistModCheck(u, cg!, modID: dualMeleeWeaponsId);
        },
        refreshData: () {
          return DuelistModification.dualMeleeWeapons(u);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1),
          description:
              'TV +1, Add the Link trait to any melee weapon other than ' +
                  'Shaped Explosives. This adds a second weapon of the ' +
                  'same type to the model for modeling purposes.')
      ..addMod<List<Weapon>>(UnitAttribute.weapons, (value) {
        final newList =
            value.map((weapon) => Weapon.fromWeapon(weapon)).toList();
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
      });
  }

  /*
  Agile
  Add the Agile trait for 1 TV. Models with the Lumbering
  trait cannot receive the Agile trait.
  */
  factory DuelistModification.agile() {
    final modName = _duelistModNames[agileId];
    assert(modName != null);

    final RegExp traitCheck = RegExp(r'(Lumbering)');
    final Trait newTrait = Trait.Agile();
    return DuelistModification(
        name: modName ?? agileId,
        id: agileId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);

          if (u.traits.any((trait) => traitCheck.hasMatch(trait.name))) {
            return false;
          }
          return rs!.duelistModCheck(u, cg!, modID: agileId);
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
    final modName = _duelistModNames[shieldId];
    assert(modName != null);

    final Trait newTrait = Trait.Shield();

    return DuelistModification(
        name: modName ?? shieldId,
        id: shieldId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);
          return rs!.duelistModCheck(u, cg!, modID: shieldId);
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
    final modName = _duelistModNames[meleeUpgradeId];
    assert(modName != null);

    final weaponOption1 = buildWeapon('MVB', hasReact: true);
    final weaponOption2 = buildWeapon('MCW (Demo:4)', hasReact: true);

    var modOptions = ModificationOption('Duelist Melee Upgrade',
        subOptions: [
          ModificationOption(weaponOption1.toString()),
          ModificationOption(weaponOption2.toString()),
        ],
        description: 'Choose a weapon to add');

    return DuelistModification(
        name: modName ?? meleeUpgradeId,
        id: meleeUpgradeId,
        options: modOptions,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);
          final hasHands =
              u.traits.any((trait) => trait.isSameType(Trait.Hands()));
          if (!hasHands) {
            return false;
          }
          return rs!.duelistModCheck(u, cg!, modID: meleeUpgradeId);
        },
        refreshData: () {
          return DuelistModification.meleeUpgrade(u);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod<List<Weapon>>(UnitAttribute.weapons, (value) {
        final newList = value.toList();
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
          description:
              'Add one of the following: MVB (React), or MCW (React Demo:4)');
  }

  /*
  ECM Upgrade
  A model with an ECM trait may upgrade their ECM to an
  ECM+ for 1 TV.
  */
  factory DuelistModification.ecm() {
    final modName = _duelistModNames[ecmId];
    assert(modName != null);

    final RegExp traitCheckWithoutMod = RegExp(r'^ECM$', caseSensitive: false);
    final RegExp traitCheckWithMod = RegExp(r'^ECM\+$', caseSensitive: false);
    return DuelistModification(
        name: modName ?? ecmId,
        id: ecmId,
        requirementCheck:
            (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
          assert(rs != null);
          assert(cg != null);
          final traitCheck =
              u.hasMod(ecmId) ? traitCheckWithMod : traitCheckWithoutMod;

          if (!u.traits.any((trait) => traitCheck.hasMatch(trait.name))) {
            return false;
          }
          return rs!.duelistModCheck(u, cg!, modID: ecmId);
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod<List<Trait>>(UnitAttribute.traits, (value) {
        var newList = new List<Trait>.from(value);

        if (!newList.any((trait) => trait.isSameType(Trait.ECM()))) {
          return newList;
        }

        final oldTrait = newList.firstWhere((t) => t.isSameType(Trait.ECM()));
        final oldIndex = newList.indexOf(oldTrait);
        newList.remove(oldTrait);

        if (!newList.any((t) => t.isSameType(Trait.ECMPlus()))) {
          newList.insert(oldIndex, Trait.ECMPlus(isAux: oldTrait.isAux));
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
