import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/north/north.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapons.dart';

const _northernIDBase = 'mod::faction::northern';

const taskBuiltID = '$_northernIDBase::10';
const hammersOfTheNorth = '$_northernIDBase::20';

class NorthernFactionMods extends FactionModification {
  NorthernFactionMods({
    required String name,
    required RequirementCheck requirementCheck,
    ModificationOption? options,
    required String id,
  }) : super(
          name: name,
          requirementCheck: requirementCheck,
          options: options,
          id: id,
        );
  /*
    Task Built: Each Northern gear may swap its rocket pack for a Heavy 
    Machinegun (HMG) for 0 TV. Each Northern gear without a rocket pack may add
    an HMG for 1 TV. Each Bricklayer, Engineering Grizzly, Camel Truck and 
    Stinger may also add an HMG for 1 TV.
  */
  factory NorthernFactionMods.taskBuilt(Unit unit) {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      final isNorthernGear =
          u.faction == FactionType.North && u.type == ModelType.Gear;

      if (!(isNorthernGear ||
          u.core.name == 'Bricklayer' ||
          u.core.name == 'Engineering Grizzly' ||
          u.core.name == 'Camel Truck*' ||
          u.core.name == 'Stinger')) {
        return false;
      }

      if (rs == null || !rs.isRuleEnabled(ruleTaskBuilt.id)) {
        return false;
      }

      return true;
    };

    final swapHMG = unit.weapons.any((w) => w.code == 'RP');
    final cost = swapHMG ? 0 : 1;
    var hmg = buildWeapon('HMG');
    assert(hmg != null);

    final fm = NorthernFactionMods(
      name: 'Task Built',
      requirementCheck: reqCheck,
      id: taskBuiltID,
    );
    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(cost),
      description: 'TV: +$cost',
    );

    if (swapHMG) {
      final modOptions = ModificationOption(
        'Task Built',
        subOptions: unit.weapons
            .where((w) => w.code == 'RP')
            .map((w) => ModificationOption(w.abbreviation))
            .toList(),
        description: 'Swap a RP for a HMG',
      );
      fm.options = modOptions;
      fm.addMod<List<Weapon>>(UnitAttribute.weapons, (value) {
        final newList =
            value.map((weapon) => Weapon.fromWeapon(weapon)).toList();

        // check if an option has been selected
        if (modOptions.selectedOption == null) {
          return newList;
        }

        // make sure the selected weapon is in the list
        final isInList = newList
            .any((w) => w.abbreviation == modOptions.selectedOption?.text);

        if (!isInList) {
          return newList;
        }

        final weaponToRemove = newList.firstWhere(
          (w) => w.abbreviation == modOptions.selectedOption?.text,
        );

        if (weaponToRemove.hasReact != hmg!.hasReact) {
          hmg = Weapon.fromWeapon(hmg!, hasReact: weaponToRemove.hasReact);
        }

        newList.remove(weaponToRemove);
        newList.add(hmg!);
        return newList;
      }, description: 'Swap a RP for a HMG');
    } else {
      fm.addMod<List<Weapon>>(
        UnitAttribute.weapons,
        createAddWeaponToList(hmg!),
        description: 'Add a HMG',
      );
    }

    return fm;
  }
}
