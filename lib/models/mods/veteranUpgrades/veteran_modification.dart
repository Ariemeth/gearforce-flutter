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
const ewSpecId = 'vet: ew specialist';
const fieldArmorId = 'vet: field armor';
const inYourFaceId1 = 'vet: in your face 1';
const inYourFaceId2 = 'vet: in your face 2';
const insulatedId = 'vet: insulated';
const fireproofId = 'vet: fire proof';
const oldReliableId = 'vet: old reliable';
const stainlessSteelId = 'vet: stainless steel';
const sharpshooterId = 'vet: sharp shooter';
const trickShotId = 'vet: trick shot';
const meleeUpgrade = 'vet: melee upgrade';

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
  EW SPECIALIST 1 TV
  Add +1D6 to any EW rolls made by this model
  */
  factory VeteranModification.ewSpecialist(Unit u) {
    return VeteranModification(
        name: 'EW Specialist',
        id: ewSpecId,
        requirementCheck: () {
          if (u.hasMod(ewSpecId)) {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.special,
          createAddStringToList('Add +1d6 to any EW rolls made by this model'),
          description: 'Add +1d6 to any EW rolls made by this model');
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
  IN YOUR FACE 1–2 TV
  Add the Brawl:1 trait or increase an existing Brawl trait
  by +1 for 1 TV. Or this model may add the Brawl:2 trait
  or increase the Brawl trait by 2 for 2 TV.
  */
  factory VeteranModification.inYourFace1(Unit u) {
    final traits = u.traits.toList();
    return VeteranModification(
        name: 'In Your Face',
        id: inYourFaceId1,
        requirementCheck: () {
          if (u.hasMod(inYourFaceId1) || u.hasMod(inYourFaceId2)) {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        },
        refreshData: () {
          return VeteranModification.inYourFace1(u);
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
  IN YOUR FACE 1–2 TV
  Add the Brawl:1 trait or increase an existing Brawl trait
  by +1 for 1 TV. Or this model may add the Brawl:2 trait
  or increase the Brawl trait by 2 for 2 TV.
  */
  factory VeteranModification.inYourFace2(Unit u) {
    final traits = u.traits.toList();
    return VeteranModification(
        name: 'In Your Face',
        id: inYourFaceId2,
        requirementCheck: () {
          if (u.hasMod(inYourFaceId2) || u.hasMod(inYourFaceId1)) {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        },
        refreshData: () {
          return VeteranModification.inYourFace2(u);
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
  INSULATED 1 TV
  Add the Resist:Haywire trait or remove the Vuln:Haywire
  trait.
  */
  factory VeteranModification.insulated(Unit u) {
    final traits = u.traits.toList();
    final isVulnerable = traits
        .any((element) => element.name == 'Vuln' && element.type == 'Haywire');
    return VeteranModification(
        name: 'Insulated',
        id: insulatedId,
        requirementCheck: () {
          if (u.hasMod(insulatedId)) {
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
  FIREPROOF 1 TV
  Add the Resist:Fire trait or remove the Vuln:Fire trait.
  */
  factory VeteranModification.fireproof(Unit u) {
    final traits = u.traits.toList();
    final isVulnerable = traits
        .any((element) => element.name == 'Vuln' && element.type == 'Fire');
    return VeteranModification(
        name: 'Fireproof',
        id: fireproofId,
        requirementCheck: () {
          if (u.hasMod(fireproofId)) {
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
  STAINLESS STEEL 1 TV
  Add the Resist:Corrosion trait or remove the
  Vuln:Corrosion trait.
  */
  factory VeteranModification.stainlessSteel(Unit u) {
    final traits = u.traits.toList();
    final isVulnerable = traits.any(
        (element) => element.name == 'Vuln' && element.type == 'Corrosion');
    return VeteranModification(
        name: 'Stainless Steel',
        id: stainlessSteelId,
        requirementCheck: () {
          if (u.hasMod(stainlessSteelId)) {
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
  SHARPSHOOTER 2 TV
  Gunnery rolls made by this model have -1 TN
  (minimum 2+). This costs 2 TV for each action point
  that the models has. This cost increases by 2TV per
  additional action purchased via other upgrades.
  */
  factory VeteranModification.sharpShooter(Unit u) {
    final actions = u.actions;
    final gunnery = u.gunnery;

    return VeteranModification(
        name: 'Sharpshooter',
        id: sharpshooterId,
        requirementCheck: () {
          if (u.hasMod(sharpshooterId)) {
            return false;
          }

          if (u.actions == null) {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        })
      ..addMod(
        UnitAttribute.tv,
        createSimpleIntMod(actions != null ? actions * 2 : 0),
        description: 'TV +${actions != null ? actions * 2 : 0}',
      )
      ..addMod(
        UnitAttribute.gunnery,
        (value) {
          if (value is! int) {
            return value;
          }
          if (value <= 2) {
            return value;
          }
          return value - 1;
        },
        description:
            'Gunnery -1 TN to (${gunnery == null ? '-' : '${gunnery <= 2 ? 2 : gunnery - 1}+'}), min 2+',
      );
  }

  /*
  TRICK SHOT 1 TV
  This model does not suffer the -1D6 modifier when
  using the Split weapon trait.
  */
  factory VeteranModification.trickShot(Unit u) {
    return VeteranModification(
        name: 'Trick Shot',
        id: trickShotId,
        requirementCheck: () {
          if (u.hasMod(trickShotId)) {
            return false;
          }

          return u.traits.any((trait) => trait.name == 'Vet');
        })
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(
          UnitAttribute.special,
          createAddStringToList(
              'This model does not suffer the -1D6 modifier when using the Split weapon trait'),
          description:
              'This model does not suffer the -1D6 modifier when using the Split weapon trait');
  }

  /*
  MELEE WEAPON UPGRADE 1TV
  One gear with a melee weapon, that has the React trait,
  can upgrade it to one of the following:
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
        description: 'One gear with a melee weapon, that has the React ' +
            'trait, can upgrade it to either a LVB (React, ' +
            'Precise) or LCW (React, Brawl:1)');

    return VeteranModification(
        name: 'Melee Weapon Upgrade',
        id: meleeUpgrade,
        options: modOptions,
        requirementCheck: () {
          if (u.hasMod(meleeUpgrade)) {
            return false;
          }

          if (u.type != 'Gear') {
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

        var indexToRemove = newList.indexWhere(
            (weapon) => weapon.toString() == modOptions.selectedOption!.text);

        final weaponToAdd = buildWeapon(
            modOptions.selectedOption!.selectedOption!.text,
            hasReact: true);
        if (weaponToAdd != null) {
          newList.removeAt(indexToRemove);
          newList.insert(indexToRemove, weaponToAdd);
        }

        return newList;
      },
          description: 'One gear with a melee weapon, that has the React ' +
              'trait, can upgrade it to either a LVB (React, ' +
              'Precise) or LCW (React, Brawl:1)');
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
