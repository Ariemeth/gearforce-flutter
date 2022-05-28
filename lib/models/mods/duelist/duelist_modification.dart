import 'package:gearforce/models/combatGroups/combat_group.dart';
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
const leadByExampleId = 'duelist: lead by example';
const advancedControlSystemId = 'duelist: advanced control system';
const stableId = 'duelist: stable';
const preciseId = 'duelist: precise';
const autoId = 'duelist: auto';
const aceGunnerId = 'duelist: ace gunner';
const trickShotId = 'duelist: trick shot';
const meleeUpgradeId = 'duelist: melee upgrade';
const dualMeleeWeaponsId = 'duelist: dual melee weapons';
const shieldId = 'duelist: shield';
const agileId = 'duelist: agile';
const ecmId = 'duelist: ecm';

class DuelistModification extends BaseModification {
  DuelistModification({
    required String name,
    required String id,
    this.requirementCheck = _defaultRequirementsFunction,
    this.unit,
    this.roster,
    final ModificationOption? options,
    final BaseModification Function()? refreshData,
  }) : super(name: name, id: id, options: options, refreshData: refreshData);

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
        requirementCheck: () {
          if (u.hasMod(independentOperatorId) || u.hasMod(leadByExampleId)) {
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
        createAddTraitToList(Trait(name: 'Independent Operator')),
        description:
            'Duelist is an Independent Operator and will be the sole ' +
                'model in a combat group',
      );
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
        requirementCheck: () {
          if (u.hasMod(independentOperatorId) || u.hasMod(leadByExampleId)) {
            return false;
          }

          return u.isDuelist;
        })
      ..addMod(
        UnitAttribute.traits,
        createAddTraitToList(Trait(name: 'Lead by Example')),
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
        requirementCheck: () {
          if (u.hasMod(advancedControlSystemId)) {
            return false;
          }

          if (u.actions != null && u.actions! >= 3) {
            return false;
          }
          return u.isDuelist;
        })
      ..addMod(UnitAttribute.tv, (value) {
        if (!(value is int)) {
          return value;
        }

        if (u.armor == null) {
          return value;
        }

        return value + (u.armor! >= 8 ? 3 : 2);
      }, dynamicDescription: () {
        return 'TV +${u.armor! >= 8 ? 3 : 2}';
      })
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
  Stable
  For ranged weapons:
  > Add the Stable trait to any one weapon for 2 TV.
  > Or, add the Stable trait to a combo weapon for 3 TV.
  */
  factory DuelistModification.stable(Unit u) {
    final react = u.reactWeapons;
    final mounted = u.mountedWeapons;
    final List<ModificationOption> _options = [];
    const traitToAdd = Trait(name: 'Stable');

    final allWeapons = react.toList()..addAll(mounted);
    allWeapons.forEach((weapon) {
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
        requirementCheck: () {
          if (u.hasMod(stableId)) {
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
  Precise
  > Add the Precise trait to one weapon for 1 TV.
  > Or, add the Precise trait to a combo weapon for 2 TV.
  */
  factory DuelistModification.precise(Unit u) {
    final react = u.reactWeapons;
    final mounted = u.mountedWeapons;
    final List<ModificationOption> _options = [];
    const traitToAdd = Trait(name: 'Precise');

    final allWeapons = react.toList()..addAll(mounted);
    allWeapons.forEach((weapon) {
      _options.add(ModificationOption('${weapon.toString()}'));
    });

    var modOptions = ModificationOption('Precise',
        subOptions: _options,
        description: 'Choose a weapon to gain the Precise trait.');

    final mod = DuelistModification(
        name: 'Precise',
        id: preciseId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(preciseId)) {
            return false;
          }
          return u.isDuelist;
        },
        refreshData: () {
          return DuelistModification.precise(u);
        })
      ..addMod(UnitAttribute.tv, (value) {
        if (!(value is int)) {
          return value;
        }

        return value +
            _comboNotComboCost(modOptions.selectedOption,
                comboCost: 2, nonComboCost: 1);
      },
          description:
              'TV +1/2, Add Precise to a weapon for TV +2 for combo weapons or +1 for regular weapons')
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
  Auto
  Add the Auto trait to one ranged weapon, or ranged
  combo weapon, that has the React trait for 1 TV.
  */
  factory DuelistModification.auto(Unit u) {
    final react = u.reactWeapons;
    final List<ModificationOption> _options = [];
    const traitToAdd = Trait(name: 'Auto');

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
        requirementCheck: () {
          if (u.hasMod(autoId)) {
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
        },
        refreshData: () {
          return DuelistModification.auto(u);
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
        requirementCheck: () {
          if (u.hasMod(aceGunnerId)) {
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

          return u.isDuelist;
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(
          UnitAttribute.traits, createAddTraitToList(Trait(name: 'Ace Gunner')))
      ..addMod(
          UnitAttribute.special,
          createAddStringToList(
              'This model does not suffer the -1D6 modifier when using the Split weapon trait'),
          description:
              'This model does not suffer the -1D6 modifier when using the Split weapon trait');
  }

  /*
  DUAL WIELD 1 TV
  Add the Link trait to any melee weapon other than
  Shaped Explosives. This adds a second weapon of the
  same type to the model. For example, a linked medium
  vibroblade becomes two medium vibroblades (ideally
  one in each hand).
  */
  factory DuelistModification.dualMeleeWeapons(Unit u) {
    final RegExp meleeCheck = RegExp(r'(VB|CW|SG)');
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
        id: dualMeleeWeaponsId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(dualMeleeWeaponsId)) {
            return false;
          }
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
  PUSH THE ENVELOPE 1 TV
  Add the Agile trait. Models with the Lumbering Trait
  cannot receive Agile.
  */
  factory DuelistModification.agile(Unit u) {
    final RegExp traitCheck = RegExp(r'(Agile|Lumbering)');
    final Trait newTrait = Trait(name: 'Agile');
    return DuelistModification(
        name: 'Push the Envelope',
        id: agileId,
        requirementCheck: () {
          if (u.hasMod(agileId)) {
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
  SHIELD-BEARER 1–2 TV
  Add the Shield trait to a model. This upgrade costs 1
  TV for models with an Armor of 7 or lower and 2 TV for
  models with an Armor of 8 or higher.
  */
  factory DuelistModification.shield(Unit u) {
    final Trait newTrait = Trait(name: 'Shield');
    final armor = u.armor;
    return DuelistModification(
        name: 'Shield-Bearer',
        id: shieldId,
        requirementCheck: () {
          if (u.hasMod(shieldId)) {
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
  factory DuelistModification.meleeUpgrade(Unit u) {
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
        id: meleeUpgradeId,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(meleeUpgradeId)) {
            return false;
          }
          return u.isDuelist;
        },
        refreshData: () {
          return DuelistModification.meleeUpgrade(u);
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
