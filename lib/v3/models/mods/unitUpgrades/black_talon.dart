import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/v3/models/mods/mods.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/unit/unit_attribute.dart';
import 'package:gearforce/v3/models/weapons/weapon.dart';
import 'package:gearforce/v3/models/weapons/weapons.dart';

final UnitModification psi = UnitModification(name: 'Psi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Psi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms');

final UnitModification darkJaguarPsi = UnitModification(name: 'Psi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Psi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.satUp(isAux: true)),
    description: '+SatUp (Aux)',
  );

final UnitModification phi = UnitModification(name: 'Phi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Phi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.eccm()),
      description: '+ECCM');

final UnitModification darkMambaPsi = UnitModification(name: 'Psi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Psi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.satUp()),
      description: '+SatUp');

final UnitModification xi = UnitModification(name: 'Xi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Xi'))
  ..addMod(UnitAttribute.weapons, createAddWeaponToList(buildWeapon('MGM')!),
      description: '+MGM');

final UnitModification twinXi = UnitModification(name: 'Twin Xi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Twin Xi'))
  ..addMod(
      UnitAttribute.weapons, createAddWeaponToList(buildWeapon('MGM (Link)')!),
      description: '+MGM (Link)');

final UnitModification omi = UnitModification(
    name: 'Omi Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasHMG = u
          .attribute<List<Weapon>>(UnitAttribute.weapons, modIDToSkip: omi.id)
          .any((w) =>
              w.abbreviation == 'HMG' &&
              w.traits.any((t) => Trait.apex().isSameType(t)));

      return hasHMG;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Omi'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('HMG (Apex)', hasReact: true)!,
          newValue: buildWeapon('LLC', hasReact: true)!),
      description: '-HMG (Apex), +LLC');

final UnitModification zeta = UnitModification(
    name: 'Zeta Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasHMG = u
          .attribute<List<Weapon>>(UnitAttribute.weapons, modIDToSkip: zeta.id)
          .any((w) =>
              w.abbreviation == 'HMG' &&
              w.traits.any((t) => Trait.apex().isSameType(t)));

      return hasHMG;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Zeta'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('HMG (Apex)', hasReact: true)!,
          newValue: buildWeapon('LPA', hasReact: true)!),
      description: '-HMG (Apex), +LPA');

final UnitModification pur = UnitModification(
    name: 'Pur Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasHMG = u
          .attribute<List<Weapon>>(UnitAttribute.weapons, modIDToSkip: pur.id)
          .any((w) =>
              w.abbreviation == 'HMG' &&
              w.traits.any((t) => Trait.apex().isSameType(t)));

      return hasHMG;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV 0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Pur'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('HMG (Apex)', hasReact: true)!,
          newValue: buildWeapon('MFL', hasReact: true)!),
      description: '-HMG (Apex), +MFL');

final UnitModification darkCoyotePsi = UnitModification(name: 'Psi Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Psi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddOrCombineTraitToList(Trait.sp(1)),
      description: '+SP:+1')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.satUp()),
      description: '+SatUp')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.eccm()),
      description: '+ECCM');

final UnitModification iota = UnitModification(name: 'Iota Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Iota'))
  ..addMod(
      UnitAttribute.weapons, createRemoveWeaponFromList(buildWeapon('MRP')!),
      description: '-MRP')
  ..addMod(UnitAttribute.weapons, createAddWeaponToList(buildWeapon('LAPR')!),
      description: '+LAPR');

final UnitModification theta = UnitModification(name: 'Theta Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Theta'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MGM')!, newValue: buildWeapon('MATM')!),
      description: '-MGM, +MATM');

final UnitModification spectre = UnitModification(name: 'Spectre Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Spectre'))
  ..addMod(UnitAttribute.ew, createSetIntMod(3), description: 'EW 3+')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.ecmPlus()),
      description: '+ECM+');

final UnitModification darkHoplitePsi = UnitModification(
    name: 'Psi Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      return !u.name.toLowerCase().contains('kappa');
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Psi'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.traits, createAddOrCombineTraitToList(Trait.sp(1)),
      description: '+SP:+1')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.comms()),
      description: '+Comms')
  ..addMod(UnitAttribute.traits, createAddTraitToList(Trait.satUp()),
      description: '+SatUp');

final UnitModification blackwindTheta = UnitModification(name: 'Theta Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Theta'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('MRP (Link)')!,
          newValue: buildWeapon('LATM (Link)')!),
      description: '-MRP (Link), +LATM (Link)');

final UnitModification darkWolfOmi = UnitModification(
    name: 'Omi Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasLFC = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: darkWolfOmi.id)
          .any((w) => w.combo != null && w.combo?.abbreviation == 'LFC');

      return hasLFC;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(0), description: 'TV +0')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Omi'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LAC/LFC', hasReact: true)!,
          newValue: buildWeapon('LAC/LFL', hasReact: true)!),
      description: '-LAC/LFC, +LAC/LFL');

final UnitModification darkWolfTao = UnitModification(
    name: 'Tao Upgrade',
    requirementCheck: (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      final hasLFC = u
          .attribute<List<Weapon>>(UnitAttribute.weapons,
              modIDToSkip: darkWolfTao.id)
          .any((w) => w.combo != null && w.combo?.abbreviation == 'LFC');

      return hasLFC;
    })
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Tao'))
  ..addMod(
      UnitAttribute.weapons,
      createReplaceWeaponInList(
          oldValue: buildWeapon('LAC/LFC', hasReact: true)!,
          newValue: buildWeapon('LAC/LGL', hasReact: true)!),
      description: '-LAC/LFC, +LAC/LGL');

final UnitModification darkWolfApulu = UnitModification(name: 'Apulu Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Apulu'))
  ..addMod(
      UnitAttribute.traits, createAddTraitToList(Trait.jetpack(6, isAux: true)),
      description: '+Jetpack:6 (Aux)');

final List<UnitModification> hadesPack = [
  hadesPackAlpha,
  hadesPackTao,
  hadesPackOmicron,
  hadesPackNu,
  hadesPackZeta,
  hadesPackTheta
];

final List<UnitModification> aresPack = [
  aresPackOmega,
  aresPackOmicron,
  aresPackNu,
  aresPackZeta,
  aresPackTheta
];

final List<UnitModification> zeusPack = [
  zeusOmegaPack,
  zeusZetaPack,
  zeusTaoPack,
  zeusNuPack,
  zeusTwinUpsilonPack,
  zeusTwinZetaPack,
  zeusTwinOmegaPack,
  zeusTwinTaoPack,
  zeusTwinNuPack
];

final UnitModification hadesPackAlpha = UnitModification(
  name: 'Hades Pack Alpha',
  id: 'hadesPackAlpha',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherHadesModIds = _hadesPackOtherModIds(hadesPackAlpha.id);
    return !otherHadesModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForPacks('MRF', 'LRP'),
    description: '+MRF, +LRP, -Other mounted weapons',
  )
  ..addMod<List<Trait>>(
    UnitAttribute.traits,
    _createRemoveJetpackModForPacks(),
    description: '-Jetpack',
  );

final UnitModification hadesPackTao = UnitModification(
  name: 'Hades Pack Tao',
  id: 'hadesPackTao',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherHadesModIds = _hadesPackOtherModIds(hadesPackTao.id);
    return !otherHadesModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForPacks('MSC', 'LRP'),
    description: '+MSC, +LRP, -Other mounted weapons',
  )
  ..addMod<List<Trait>>(
    UnitAttribute.traits,
    _createRemoveJetpackModForPacks(),
    description: '-Jetpack',
  );

final UnitModification hadesPackOmicron = UnitModification(
  name: 'Hades Pack Omicron',
  id: 'hadesPackOmicron',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherHadesModIds = _hadesPackOtherModIds(hadesPackOmicron.id);
    return !otherHadesModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForPacks('LLC', 'LRP'),
    description: '+LLC, +LRP, -Other mounted weapons',
  )
  ..addMod<List<Trait>>(
    UnitAttribute.traits,
    _createRemoveJetpackModForPacks(),
    description: '-Jetpack',
  );

final UnitModification hadesPackNu = UnitModification(
  name: 'Hades Pack Nu',
  id: 'hadesPackNu',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherHadesModIds = _hadesPackOtherModIds(hadesPackNu.id);
    return !otherHadesModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForPacks('LRL', 'LRP'),
    description: '+LRL, +LRP, -Other mounted weapons',
  )
  ..addMod<List<Trait>>(
    UnitAttribute.traits,
    _createRemoveJetpackModForPacks(),
    description: '-Jetpack',
  );

final UnitModification hadesPackZeta = UnitModification(
  name: 'Hades Pack Zeta',
  id: 'hadesPackZeta',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherHadesModIds = _hadesPackOtherModIds(hadesPackZeta.id);
    return !otherHadesModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForPacks('LPA', 'LRP'),
    description: '+LPA, +LRP, -Other mounted weapons',
  )
  ..addMod<List<Trait>>(
    UnitAttribute.traits,
    _createRemoveJetpackModForPacks(),
    description: '-Jetpack',
  );

final UnitModification hadesPackTheta = UnitModification(
  name: 'Hades Pack Theta',
  id: 'hadesPackTheta',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherHadesModIds = _hadesPackOtherModIds(hadesPackTheta.id);
    return !otherHadesModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForPacks('LATM', 'LRP'),
    description: '+LATM, +LRP, -Other mounted weapons',
  )
  ..addMod<List<Trait>>(
    UnitAttribute.traits,
    _createRemoveJetpackModForPacks(),
    description: '-Jetpack',
  );

List<String> _hadesPackOtherModIds(String id) {
  final allIds = [
    hadesPackAlpha.id,
    hadesPackTao.id,
    hadesPackOmicron.id,
    hadesPackNu.id,
    hadesPackZeta.id,
    hadesPackTheta.id
  ];

  allIds.remove(id);
  return allIds;
}

final UnitModification aresPackOmega = UnitModification(
  name: 'Ares Pack Omega',
  id: 'aresPackOmega',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherAresModIds = _aresPackOtherModIds(aresPackOmega.id);
    return !otherAresModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForPacks('LRG', 'MRP'),
    description: '+LRG, +MRP, -Other mounted weapons',
  )
  ..addMod<List<Trait>>(
    UnitAttribute.traits,
    _createRemoveJetpackModForPacks(),
    description: '-Jetpack',
  );

final UnitModification aresPackOmicron = UnitModification(
  name: 'Ares Pack Omicron',
  id: 'aresPackOmicron',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherAresModIds = _aresPackOtherModIds(aresPackOmicron.id);
    return !otherAresModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForPacks('MLC', 'MRP'),
    description: '+MLC, +MRP, -Other mounted weapons',
  )
  ..addMod<List<Trait>>(
    UnitAttribute.traits,
    _createRemoveJetpackModForPacks(),
    description: '-Jetpack',
  );

final UnitModification aresPackNu = UnitModification(
  name: 'Ares Pack Nu',
  id: 'aresPackNu',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherAresModIds = _aresPackOtherModIds(aresPackNu.id);
    return !otherAresModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForPacks('MRL', 'MRP'),
    description: '+MRL, +MRP, -Other mounted weapons',
  )
  ..addMod<List<Trait>>(
    UnitAttribute.traits,
    _createRemoveJetpackModForPacks(),
    description: '-Jetpack',
  );

final UnitModification aresPackZeta = UnitModification(
  name: 'Ares Pack Zeta',
  id: 'aresPackZeta',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherAresModIds = _aresPackOtherModIds(aresPackZeta.id);
    return !otherAresModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForPacks('MPA', 'MRP'),
    description: '+MPA, +MRP, -Other mounted weapons',
  )
  ..addMod<List<Trait>>(
    UnitAttribute.traits,
    _createRemoveJetpackModForPacks(),
    description: '-Jetpack',
  );

final UnitModification aresPackTheta = UnitModification(
  name: 'Ares Pack Theta',
  id: 'aresPackTheta',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherAresModIds = _aresPackOtherModIds(aresPackTheta.id);
    return !otherAresModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(2), description: 'TV +2')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForPacks('MATM', 'MRP'),
    description: '+MATM, +MRP, -Other mounted weapons',
  )
  ..addMod<List<Trait>>(
    UnitAttribute.traits,
    _createRemoveJetpackModForPacks(),
    description: '-Jetpack',
  );

List<String> _aresPackOtherModIds(String id) {
  final allIds = [
    aresPackOmega.id,
    aresPackOmicron.id,
    aresPackNu.id,
    aresPackZeta.id,
    aresPackTheta.id
  ];

  allIds.remove(id);
  return allIds;
}

List<Weapon> Function(List<Weapon>) _createWeaponModForPacks(
  String weaponCodeToAdd,
  String weaponCodeToAdd2,
) {
  return (weapons) {
    final newWeapons = weapons.toList();
    // remove all mounted weapons except PZs, HGs, MGs and FCs
    newWeapons.removeWhere(
        (w) => !w.hasReact && !['PZ', 'HG', 'MG', 'FC'].contains(w.code));
    final weapon1 = buildWeapon(weaponCodeToAdd);
    assert(weapon1 != null);
    newWeapons.add(weapon1!);

    final weapon2 = buildWeapon(weaponCodeToAdd2);
    assert(weapon2 != null);
    newWeapons.add(weapon2!);

    return newWeapons;
  };
}

List<Trait> Function(List<Trait>) _createRemoveJetpackModForPacks() {
  return (traits) {
    final newTraits = traits.toList();
    newTraits.removeWhere((t) => t.isSameType(Trait.jetpack(0)));
    return newTraits;
  };
}

List<String> _zeusPackOtherModIds(String id) {
  final List<String> allIds = [
    zeusOmegaPack.id,
    zeusZetaPack.id,
    zeusTaoPack.id,
    zeusNuPack.id,
    zeusTwinUpsilonPack.id,
    zeusTwinZetaPack.id,
    zeusTwinOmegaPack.id,
    zeusTwinTaoPack.id,
    zeusTwinNuPack.id,
  ];

  allIds.remove(id);
  return allIds;
}

final UnitModification zeusOmegaPack = UnitModification(
  name: 'Zeus Omega Pack',
  id: 'zeusOmegaPack',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherZeusModIds = _zeusPackOtherModIds(zeusOmegaPack.id);
    return !otherZeusModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(5), description: 'TV +5')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForZeusPacks('HRG (Apex)', 'HRP (Apex)'),
    description: '+HRG (Apex), +HRP (Apex), -LATM (Precise)',
  );

final UnitModification zeusZetaPack = UnitModification(
  name: 'Zeus Zeta Pack',
  id: 'zeusZetaPack',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherZeusModIds = _zeusPackOtherModIds(zeusZetaPack.id);
    return !otherZeusModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(5), description: 'TV +5')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForZeusPacks('HPA (Apex)', 'HRP (Apex)'),
    description: '+HPA (Apex), +HRP (Apex), -LATM (Precise)',
  );

final UnitModification zeusTaoPack = UnitModification(
  name: 'Zeus Tao Pack',
  id: 'zeusTaoPack',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherZeusModIds = _zeusPackOtherModIds(zeusTaoPack.id);
    return !otherZeusModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(3), description: 'TV +3')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForZeusPacks('HSC (Apex)', 'HRP (Apex)'),
    description: '+HSC (Apex), +HRP (Apex), -LATM (Precise)',
  );

final UnitModification zeusNuPack = UnitModification(
  name: 'Zeus Nu Pack',
  id: 'zeusNuPack',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherZeusModIds = _zeusPackOtherModIds(zeusNuPack.id);
    return !otherZeusModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(5), description: 'TV +5')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForZeusPacks('HRL (Apex)', 'HRP (Apex)'),
    description: '+HRL (Apex), +HRP (Apex), -LATM (Precise)',
  );

final UnitModification zeusTwinUpsilonPack = UnitModification(
  name: 'Zeus Twin Upsilon Pack',
  id: 'zeusTwinUpsilonPack',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherZeusModIds = _zeusPackOtherModIds(zeusTwinUpsilonPack.id);
    return !otherZeusModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(4), description: 'TV +4')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForZeusPacks('HRP (Apex Link)', null),
    description: '+HRP (Apex, Link), -LATM (Precise)',
  );

final UnitModification zeusTwinZetaPack = UnitModification(
  name: 'Zeus Twin Zeta Pack',
  id: 'zeusTwinZetaPack',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherZeusModIds = _zeusPackOtherModIds(zeusTwinZetaPack.id);
    return !otherZeusModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(7), description: 'TV +7')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForZeusPacks('HPA (Apex Link)', null),
    description: '+HPA (Apex, Link), -LATM (Precise)',
  );

final UnitModification zeusTwinOmegaPack = UnitModification(
  name: 'Zeus Twin Omega Pack',
  id: 'zeusTwinOmegaPack',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherZeusModIds = _zeusPackOtherModIds(zeusTwinOmegaPack.id);
    return !otherZeusModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(7), description: 'TV +7')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForZeusPacks('HRG (Apex Link)', null),
    description: '+HRG (Apex, Link), -LATM (Precise)',
  );

final UnitModification zeusTwinTaoPack = UnitModification(
  name: 'Zeus Twin Tao Pack',
  id: 'zeusTwinTaoPack',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherZeusModIds = _zeusPackOtherModIds(zeusTwinTaoPack.id);
    return !otherZeusModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(4), description: 'TV +4')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForZeusPacks('HSC (Apex Link)', null),
    description: '+HSC (Apex, Link), -LATM (Precise)',
  );

final UnitModification zeusTwinNuPack = UnitModification(
  name: 'Zeus Twin Nu Pack',
  id: 'zeusTwinNuPack',
  requirementCheck: (RuleSet rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
    final otherZeusModIds = _zeusPackOtherModIds(zeusTwinNuPack.id);
    return !otherZeusModIds.any((modId) => u.hasMod(modId));
  },
)
  ..addMod(UnitAttribute.tv, createSimpleIntMod(7), description: 'TV +7')
  ..addMod(
    UnitAttribute.traits,
    createAddTraitToList(Trait.vtol()),
    description: '+VTOL',
  )
  ..addMod<List<Weapon>>(
    UnitAttribute.weapons,
    _createWeaponModForZeusPacks('HRL (Apex Link)', null),
    description: '+HRL (Apex, Link), -LATM (Precise)',
  );

List<Weapon> Function(List<Weapon>) _createWeaponModForZeusPacks(
  String weaponCodeToAdd,
  String? weaponCodeToAdd2,
) {
  return (weapons) {
    final newWeapons = weapons.toList();
    // remove the LATM
    newWeapons.removeWhere((w) => !w.hasReact && w.code == 'ATM');
    final weapon1 = buildWeapon(weaponCodeToAdd);
    assert(weapon1 != null);
    newWeapons.add(weapon1!);

    if (weaponCodeToAdd2 != null) {
      final weapon2 = buildWeapon(weaponCodeToAdd2);
      assert(weapon2 != null);
      newWeapons.add(weapon2!);
    }
    return newWeapons;
  };
}
