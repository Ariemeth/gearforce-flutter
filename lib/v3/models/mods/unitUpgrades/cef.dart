import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/v3/models/mods/mods.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/unit/unit_attribute.dart';
import 'package:gearforce/v3/models/weapons/weapon.dart';
import 'package:gearforce/v3/models/weapons/weapons.dart';

final UnitModification command = UnitModification(name: 'Command Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.satUp()),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.eccm(isAux: true)),
      description: '+ECCM (Aux)');

final UnitModification mobilityPack6 = UnitModification(
    name: 'Mobility Pack Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Mobility Pack'))
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.airdrop()),
      description: '+Airdrop')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(Trait.jetpack(6, isAux: true)),
      description: '+Jetpack:6 (Aux)');

final UnitModification stealth = UnitModification(name: 'Stealth Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Stealth'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(
      UnitAttribute.roles, createAddRoleToList(const Role(name: RoleType.so)),
      description: '+SO')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(Trait.stealth(isAux: true)),
      description: '+Stealth (Aux)');

final UnitModification mobilityPack5 = UnitModification(
    name: 'Mobility Pack Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createSimpleStringMod(false, 'with Mobility Pack'))
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.airdrop()),
      description: '+Airdrop')
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(Trait.jetpack(5, isAux: true)),
      description: '+Jetpack:5 (Aux)');

final UnitModification mrl = UnitModification(name: 'MRL Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with MRL'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LLC', hasReact: true)!,
          newValue: buildWeapon('MRL', hasReact: true)!),
      description: '-LLC, +MRL');

final UnitModification grelCrew = UnitModification(name: 'GREL Crew Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with GREL Crew'))
  ..addMod(UnitAttribute.gunnery, createSetIntMod(3), description: 'GU 3+')
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI 3+')
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+');

final UnitModification grelCrew2 = UnitModification(name: 'GREL Crew Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with GREL Crew'))
  ..addMod(UnitAttribute.gunnery, createSetIntMod(3), description: 'GU 3+')
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI 3+')
  ..addMod(UnitAttribute.ew, createSetIntMod(3), description: 'EW 3+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.reactPlus()),
      description: '+React+');

final UnitModification grelCrew3 = UnitModification(name: 'GREL Crew Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with GREL Crew'))
  ..addMod(UnitAttribute.gunnery, createSetIntMod(3), description: 'GU 3+')
  ..addMod(UnitAttribute.piloting, createSetIntMod(3), description: 'PI 3+')
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.reactPlus()),
      description: '+React+');

final UnitModification grelCrew4 = UnitModification(name: 'GREL Crew Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with GREL Crew'))
  ..addMod(UnitAttribute.gunnery, createSetIntMod(3), description: 'GU 3+')
  ..addMod(UnitAttribute.piloting, createSetIntMod(4), description: 'PI 4+')
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+');

final UnitModification hpc64Command = UnitModification(
    name: 'Command Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return !u.name.toLowerCase().contains('medic');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Command'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.satUp()),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ecm()),
      description: '+ECM');

final UnitModification jan = UnitModification(name: 'Jan Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Jan'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms');

final UnitModification squad = UnitModification(name: 'Squad')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
      UnitAttribute.name, createReplaceStringMod(old: 'Team', change: 'Squad'))
  ..addMod(UnitAttribute.hull, createSetIntMod(4), description: 'H/S 4/2')
  ..addMod(UnitAttribute.structure, createSetIntMod(2));

final UnitModification team = UnitModification(name: 'Team')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'Team'))
  ..addMod(UnitAttribute.hull, createSetIntMod(4), description: 'H/S 4/2')
  ..addMod(UnitAttribute.structure, createSetIntMod(2));

final UnitModification lpz = UnitModification(name: 'LPZ Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(false, 'with LPZ'))
  ..addMod(UnitAttribute.weapons, createAddWeaponToList(buildWeapon('LPZ')!),
      description: '+LPZ');

final UnitModification tankHunter =
    UnitModification(name: 'Tank Hunter Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Tank Hunter'))
      ..addMod(
          UnitAttribute.weapons,
          createReplaceWeaponInList(
              oldValue: buildWeapon('MRP (Link)')!,
              newValue: buildWeapon('LATM (Link)')!),
          description: '-MRP (Link), +LATM (Link)');

final UnitModification oannesGunglaiveUpgrade = UnitModification(
  name: 'Gunglaive Upgrade',
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Gunglaive'))
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    (weapons) {
      final newWeapons = weapons.toList();
      newWeapons.removeWhere((w) => w.hasReact);

      final newWeapon = buildWeapon('HICW (AP:2)/HIS (AP:2)', hasReact: true);
      assert(newWeapon != null);
      newWeapons.add(newWeapon!);

      return newWeapons;
    },
  )
  ..addMod(
    UnitAttribute.traits,
    createAddOrCombineTraitToList(Trait.brawl(2)),
    description: '+Brawl:2',
  );

final UnitModification oannesVolatusUpgrade = UnitModification(
    name: 'Volatus Upgrade',
    requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return !u.hasMod(oannesHydorUpgrade.id);
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Volatus'))
  ..addMod(
    UnitAttribute.weapons,
    createAddWeaponToList(buildWeapon('HIM')!),
    description: '+HIM',
  )
  ..addMod(
    UnitAttribute.traits,
    createAddOrReplaceSameTraitInList(Trait.jetpack(5)),
    description: '+Jetpack:5',
  );

final UnitModification oannesHydorUpgrade = UnitModification(
    name: 'Hydor Upgrade',
    requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return !u.hasMod(oannesVolatusUpgrade.id);
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Hydor'))
  ..addMod(
    UnitAttribute.weapons,
    createAddWeaponToList(buildWeapon('HAVM (LA:2)')!),
    description: '+HAVM (LA:2)',
  )
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.sub()),
    description: '+Sub',
  );

final UnitModification oannesDominusUpgrade = UnitModification(
  name: 'Dominus Upgrade',
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Dominus'))
  ..addMod(UnitAttribute.ew, createSetIntMod(5), description: 'EW 5+')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.comms()),
    description: '+Comms',
  );

final UnitModification emberAnzuUpgrade = UnitModification(
  name: 'ANZU Upgrade',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    return !u.hasMod(emberNKIUpgrade.id);
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'ANZU'))
  ..addMod(
    UnitAttribute.weapons,
    createAddWeaponToList(buildWeapon('HIM')!),
    description: '+HIM',
  )
  ..addMod(
    UnitAttribute.traits,
    createAddOrReplaceSameTraitInList(Trait.jetpack(5)),
    description: '+Jetpack:5',
  );

final UnitModification emberNKIUpgrade = UnitModification(
  name: 'N-KI Upgrade',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    return !u.hasMod(emberAnzuUpgrade.id);
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'N-KI'))
  ..addMod(
    UnitAttribute.weapons,
    createAddWeaponToList(buildWeapon('HAVM (LA:2)')!),
    description: '+HAVM (LA:2)',
  )
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.sub()),
    description: '+Sub',
  );

final UnitModification emberNodeUpgrade = UnitModification(name: 'Node Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Node'))
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.satUp()),
    description: '+SatUp',
  );
