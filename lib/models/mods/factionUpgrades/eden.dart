import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/eden/eden.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';
import 'package:gearforce/models/weapons/weapon_modes.dart';
import 'package:gearforce/models/weapons/weapons.dart';

const _baseFactionModId = 'mod::faction::eden';
const lancersId = '$_baseFactionModId::10';

class EdenMods extends FactionModification {
  EdenMods({
    required super.name,
    required super.id,
    required super.requirementCheck,
    super.options,
    super.onAdd,
    super.onRemove,
  }) : super();

  /*
    Golems may have their melee weapon upgraded to a lance for +2 TV each. The
    lance is an MSG (React, Reach:2). Models with a lance gain the Brawl:2
     trait or add +2 to their existing Brawl:X trait if they have it.
  */
  factory EdenMods.lancers(Unit unit) {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleLancers.id)) {
        return false;
      }

      if (!(u.faction == FactionType.Eden && u.type == ModelType.Gear)) {
        return false;
      }

      if (u.weapons.any((w) => w.modes.any((m) => m == weaponModes.Melee))) {
        return true;
      }

      return false;
    };

    final fm = EdenMods(
      name: 'Lancers',
      requirementCheck: reqCheck,
      id: lancersId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(2),
      description: 'TV: +2',
    );

    final msg = buildWeapon('MSG', hasReact: true);
    assert(msg != null);
    final lance = Weapon.fromWeapon(
      msg!,
      name: 'Lance',
      addTraits: [Trait.Reach(2)],
    );

    fm.addMod<List<Weapon>>(
      UnitAttribute.weapons,
      (value) {
        var newList = new List<Weapon>.from(value);

        var index = newList
            .indexWhere((w) => w.modes.any((m) => m == weaponModes.Melee));

        if (index < 0) {
          print(
              'melee weapon was not found in list of weapons ${value.toString()}');
          return value;
        }

        newList.removeAt(index);

        if (!newList.any((w) => w == lance)) {
          newList.add(lance);
        }

        return newList;
      },
      description: '+Lance - MSG (React, Reach:2)',
    );

    final existingBrawls = unit
        .attribute<List<Trait>>(UnitAttribute.traits, modIDToSkip: lancersId)
        .where((t) => Trait.Brawl(1).isSameType(t))
        .toList();

    if (existingBrawls.isEmpty) {
      fm.addMod<List<Trait>>(
        UnitAttribute.traits,
        createAddTraitToList(Trait.Brawl(2)),
        description: '+Brawl:2',
      );
    } else {
      final existingBrawl = existingBrawls.first;
      final newBrawl =
          Trait.fromTrait(existingBrawl, level: existingBrawl.level! + 2);
      fm.addMod<List<Trait>>(
        UnitAttribute.traits,
        createReplaceTraitInList(oldValue: existingBrawl, newValue: newBrawl),
        description: '-Brawl:${existingBrawl.level}+Brawl:${newBrawl.level}',
      );
    }

    return fm;
  }
}
