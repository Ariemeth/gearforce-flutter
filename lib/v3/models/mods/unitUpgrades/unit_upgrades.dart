import 'package:gearforce/v3/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/v3/models/mods/unitUpgrades/black_talon.dart'
    as blackTalon;
import 'package:gearforce/v3/models/mods/unitUpgrades/caprice.dart' as caprice;
import 'package:gearforce/v3/models/mods/unitUpgrades/cef.dart' as cef;
import 'package:gearforce/v3/models/mods/unitUpgrades/eden.dart' as eden;
import 'package:gearforce/v3/models/mods/unitUpgrades/north.dart' as north;
import 'package:gearforce/v3/models/mods/unitUpgrades/nucoal.dart' as nucoal;
import 'package:gearforce/v3/models/mods/unitUpgrades/peace_river.dart'
    as peaceRiver;
import 'package:gearforce/v3/models/mods/unitUpgrades/south.dart' as south;
import 'package:gearforce/v3/models/mods/unitUpgrades/universal.dart'
    as universal;
import 'package:gearforce/v3/models/mods/unitUpgrades/utopia.dart' as utopia;
import 'package:gearforce/v3/models/unit/unit.dart';

List<UnitModification> getUnitMods(Unit unit) {
  switch (unit.core.frame.toLowerCase()) {
    // Northern units
    case 'hunter':
      return [north.headHunter];
    case 'stripped-down hunter':
      return [north.headHunter];
    case 'para hunter':
      return [north.headHunter];
    case 'hunter xmg':
      return [north.meleeSpecialist1];
    case 'jaguar':
      return [north.thunderJaguar, north.seccom];
    case 'tiger':
      return [north.sabertooth];
    case 'weasel':
      return [north.tattletale];
    case 'hunter mp':
    case 'cheetah mp':
    case 'jaguar mp':
      return [north.mpCommand];
    case 'lynx':
      return [north.armored];
    case 'grizzly':
      return [north.thunderGrizzly];
    case 'koala':
      return [north.koalaCommand];
    case 'bear':
      return [north.denMother];
    case 'scimitar':
      return [north.gatlingLaser, north.crossbow, north.scimitarCommand];
    case 'mammoth':
      return [north.sledgehammer, north.aegis];
    case 'thunderhammer':
      return [north.bastion];
    case 'aller':
      return [north.allerCommand];
    case 'wolf':
      return [north.howler, north.flakJacketUpgrade];
    case 'panda':
      return [north.assaultUpgrade, north.vibro_axeUpgrade];

    // Southern units
    case 'jager':
      return [south.command];
    case 'stripped-down jager':
      return [south.command];
    case 'para jager':
      return [south.command];
    case 'sidewinder':
      return [south.mortarUpgrade, south.sidewinderCommand];
    case 'black mamba':
      return [south.razorFang];
    case 'anolis':
      return [south.ruggedTerrain];
    case 'copperhead':
      return [south.copperheadArenaPilot];
    case 'diamondback':
      return [south.longFang, south.diamondbackArenaPilot(unit)];
    case 'salamander':
      return [south.ruggedTerrain];
    case 'water viper':
      return [south.SRUpgrade];
    case 'desert viper':
      return [south.ruggedTerrain];
    case 'black adder':
      return [south.blackAdderArenaPilot];
    case 'cobra':
      return [south.cobraRazorFang];
    case 'boa':
      return [south.boasLongFang, south.meleeSwap, south.boasArenaPilot];
    case 'gila':
      return [south.barbed];
    case 'mamba mp':
    case 'cobra mp':
    case 'iguana mp':
      return [south.mpCommand];
    case 'drake':
      return [south.fang, south.drakeCommand];
    case 'naga':
      return [south.hooded, south.spark, south.flame];
    case 'caiman':
      return [south.caimanCommand];
    case 'lizard rider':
      return [south.team];
    case 'wasserjager':
      return [south.command, south.wasserjagerLongfang];

    // Peace River
    case 'warrior':
      return [peaceRiver.spectre, peaceRiver.chieftain];
    case 'warrior iv':
      return [
        peaceRiver.jetpack,
        peaceRiver.warriorIVSpecialForces,
        peaceRiver.warriorIVSpectre,
        peaceRiver.warriorIVChieftain
      ];
    case 'jackal':
      return [peaceRiver.meleeSpecialist];
    case 'gladiator':
      return [peaceRiver.meleeSpecialist1, peaceRiver.shield];
    case 'pit bull':
      return [peaceRiver.pitBullSpectre];
    case 'greyhound':
      return [peaceRiver.greyhoundChieftain];
    case 'harrier':
      return [peaceRiver.jetpack];
    case 'skirmisher':
      return [
        peaceRiver.skirmisherChieftain,
        peaceRiver.skirmisherTag,
        peaceRiver.SkirmisherSpecialForces
      ];
    case 'shinobi':
      return [
        peaceRiver.shinobiSpectre,
        peaceRiver.shinobiMeleeSpecialist,
        peaceRiver.shinobiChieftain
      ];
    case 'spartan':
      return [peaceRiver.spartanSpectre];
    case 'crusader iv':
      return [peaceRiver.crusaderV];
    case 'cataphract':
      return [peaceRiver.cataphractSarisa, peaceRiver.cataphractLord];
    case 'uhlan':
      return [peaceRiver.tankHunter, peaceRiver.uhlanLord];
    case 'hyene ii':
      return [peaceRiver.hyeneIISpectre];
    case 'coyote':
      return [peaceRiver.alphaDog];
    case 'red bull mk2':
      return [peaceRiver.arbalest];
    case 'hoplite':
      return [peaceRiver.herdLord];
    case 'black wind':
      return [peaceRiver.missile];

    // NuCoal
    case 'chasseur':
      return [nucoal.cv];
    case 'chasseur paratrooper':
      return [nucoal.cv];
    case 'chasseur mk2':
      return [nucoal.cv];
    case 'cuirassier':
      return [nucoal.cuirassierCv];
    case 'jerboa':
      return [nucoal.fragCannon, nucoal.rapidFireBazooka];
    case 'espion':
      return [nucoal.espionCv];
    case 'boa nucoal':
      return [nucoal.mfmBoa, south.meleeSwap, south.boasArenaPilot];
    case 'chevalier':
      return [nucoal.cv2];
    case 'lancier':
      return [nucoal.cv];
    case 'voltigeur':
      return [nucoal.voltigeurABM, nucoal.voltigeurAM, nucoal.voltigeurCv];
    case 'sampson':
      return [nucoal.sampsonCv];
    case 'sandrider':
      return [nucoal.koreshi, nucoal.squad];
    case 'lizard sandrider':
      return [south.team];

    // CEF
    case 'f6-16':
      return [cef.command, cef.mobilityPack6, cef.stealth];
    case 'bf2-21':
      return [cef.mobilityPack6];
    case 'bf2-19':
      return [cef.mobilityPack5];
    case 'bf2-25':
      return [cef.mrl];
    case 'lht-67':
      return [cef.grelCrew];
    case 'lht-71':
      return [cef.grelCrew];
    case 'mht-95':
      return [cef.grelCrew];
    case 'mht-68':
      return [cef.grelCrew4];
    case 'mht-72':
      return [cef.grelCrew4];
    case 'hc-3a':
      return [cef.grelCrew2];
    case 'hpc-64':
      return [cef.grelCrew3, cef.hpc64Command];
    case 'grel':
      return [cef.jan, cef.squad];
    case 'hoverbike grel':
      return [cef.jan, cef.team];
    case 'flail':
      return [cef.lpz, cef.team];
    case 'peregrine gunship':
      return [cef.tankHunter];

    // Caprice
    case 'bashan':
      return [caprice.command];
    case 'aphek':
      return [caprice.mortar];
    case 'kadesh':
      return [caprice.command2];
    case 'moab':
      return [caprice.command2];
    case 'f-55 zikru':
      return [caprice.command2, caprice.jammer];
    case 'f-112 rabbu':
      return [caprice.command3];

    // Utopia
    case 'commando armiger': //
      return [utopia.antiTank, utopia.vtol];
    case 'commando n-kidu': //
      return [utopia.rocket, utopia.nlil];
    case 'recce n-kidu': //
      return [utopia.rocket2];
    case 'support armiger': //
      return [utopia.sniper];
    case 'trooper ape':
      return [eden.wizard, utopia.specialOperations];
    case 'support ape':
      return [utopia.specialOperations];
    case 'mar-dk':
      return [utopia.pazu];
    case 'gilgamesh rear':
      return [utopia.gilgameshEngineering];

    // Black Talon
    case 'dark warrior':
      return [blackTalon.psi, ...blackTalon.hadesPack];
    case 'dark jaguar':
      return [
        blackTalon.darkJaguarPsi,
        blackTalon.phi,
        ...blackTalon.hadesPack,
      ];
    case 'dark mamba':
      return [blackTalon.darkMambaPsi, ...blackTalon.hadesPack];
    case 'dark cobra':
      return [blackTalon.xi, ...blackTalon.aresPack];
    case 'raptor':
      return [...blackTalon.aresPack];
    case 'dark naga':
      return [blackTalon.omi, blackTalon.zeta, blackTalon.pur];
    case 'dark coyote':
      return [blackTalon.darkCoyotePsi];
    case 'eagle':
      return [blackTalon.iota, ...blackTalon.hadesPack];
    case 'owl':
      return [blackTalon.iota, ...blackTalon.hadesPack];
    case 'dark kodiak':
      return [...blackTalon.aresPack];
    case 'vulture':
      return [blackTalon.theta, ...blackTalon.aresPack];
    case 'dark hyena ii':
      return [blackTalon.spectre];
    case 'dark hoplite':
      return [blackTalon.darkHoplitePsi];
    case 'talon infantry':
      return [nucoal.squad];
    case 'bt black wind':
      return [blackTalon.blackwindTheta];
    case 'dark wolf':
      return [
        blackTalon.darkWolfOmi,
        blackTalon.darkWolfTao,
        blackTalon.darkWolfApulu,
        north.howler,
        north.flakJacketUpgrade,
        ...blackTalon.hadesPack
      ];

    // Eden
    case 'constable':
      return [eden.wizard, eden.utopianSpecialOperations];
    case 'man at arms':
      return [eden.utopianSpecialOperations];
    case 'centaur':
      return [eden.dominus];
    case 'doppel':
      return [eden.halberd, eden.hydor, eden.doppelDominus];
    case 'warlock':
      return [eden.hydor];
    case 'animus':
      return [eden.dominus];
    case 'gargoyle':
      return [eden.saker];
    case 'sepentina':
      return [eden.lyddite, eden.serpentinaDominus];
    case 'huni riders':
      return [eden.team];

    // Universal
    case 'chargeur':
      return [universal.chainswordSwap, universal.clawSwap];
    case 'sapeur':
      return [universal.demolisher, universal.hammerSwap];
    case 'druid':
      return [eden.hydor];
    case 'valence':
      return [universal.maulerFistSwap, universal.valenceClawSwap];
    case 'bricklayer':
      return [universal.sawBladeSwap, universal.vibroswordSwap];
    case 'engineering grizzly':
      return [
        universal.destroyer,
        universal.demolisher,
        universal.heavyChainswordSwap
      ];
    case 'stonemason':
      return [universal.maulerFistSwap, universal.stonemasonChainswordSwap];
    case 'engineering cobra':
      return [
        universal.strike,
        universal.demolisher,
        universal.heavyChainswordSwap
      ];
    case 'haru':
      return [universal.azat, caprice.command3, cef.team];
    case 'saker':
      return [eden.dominus];
    case 'universal infantry':
      return [
        universal.paratrooper,
        universal.mountaineering,
        universal.frogmen,
        nucoal.squad
      ];
    case 'achillus exoskeleton':
      return [
        universal.paratrooper,
        universal.mountaineering,
        universal.frogmen,
        universal.achillusSquad,
      ];
    case 'arminius power armor':
      return [universal.arminiusParatrooper, universal.arminiusSquad];
    case 'sand spider':
      return [
        universal.sandSpiderComms,
        universal.sandSpiderAmphib,
        universal.sandSpiderStealth,
      ];
    case 'baxter':
      return [universal.hmg];
    case 'small vehicles':
      return [south.team];
    case 'dragonfly':
      return [universal.latm, universal.ecm];
    case 'varis':
      return [universal.latm];
    case 'trooper automaton':
      return [
        universal.trooperAutomationNode,
        universal.trooperAutomationSquad,
      ];
  }
  return [];
}
