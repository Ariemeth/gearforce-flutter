import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/unitUpgrades/caprice.dart' as caprice;
import 'package:gearforce/models/mods/unitUpgrades/cef.dart' as cef;
import 'package:gearforce/models/mods/unitUpgrades/north.dart' as north;
import 'package:gearforce/models/mods/unitUpgrades/nucoal.dart' as nucoal;
import 'package:gearforce/models/mods/unitUpgrades/peace_river.dart'
    as peaceRiver;
import 'package:gearforce/models/mods/unitUpgrades/south.dart' as south;

List<Modification> getUnitMods(String frameName) {
  switch (frameName.toLowerCase()) {
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
    case 'mp gears':
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
      return [north.rotaryLaser, north.scimitarCommand];
    case 'mammoth':
      return [north.sledgehammer, north.aegis];
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
      return [south.longFang, south.diamondbackArenaPilot];
    case 'salamander':
      return [south.ruggedTerrain];
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
    case 'mp gears':
      return [south.mpCommand];
    case 'drake':
      return [south.antiGear];
    case 'naga':
      return [south.spark, south.flame];
    case 'hetairoi':
      return [south.hetairoiCommand];
    case 'caiman':
      return [south.caimanCommand];
    case 'lizard rider':
      return [south.single];
    // Peace River
    case 'warrior':
      return [peaceRiver.chieftain];
    case 'warrior iv':
      return [peaceRiver.jetpack, peaceRiver.chieftainIV];
    case 'jackal':
      return [peaceRiver.meleeSpecialist];
    case 'gladiator':
      return [peaceRiver.meleeSpecialist1];
    case 'greyhound':
      return [peaceRiver.greyhoundChieftain];
    case 'harrier':
      return [peaceRiver.jetpack];
    case 'skirmisher':
      return [
        peaceRiver.skirmisherChieftain,
        peaceRiver.skirmisherTag,
        peaceRiver.specialForces
      ];
    case 'shinobi':
      return [peaceRiver.shinobiMeleeSpecialist, peaceRiver.shinobiChieftain];
    case 'crusader iv':
      return [peaceRiver.crusaderV];
    case 'cataphract':
      return [peaceRiver.cataphractLord];
    case 'uhlan':
      return [peaceRiver.tankHunter, peaceRiver.uhlanLord];
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
      return [nucoal.cv2];
    case 'grel':
      return [cef.jan, nucoal.team];
    case 'hoverbike grel':
      return [cef.jan, south.single];
    case 'sandrider':
      return [nucoal.koreshi, nucoal.team];
    case 'lizard sandrider':
      return [south.single];
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
      return [cef.flailCrew];
    case 'lht-71':
      return [cef.flailCrew];
    case 'mht-95':
      return [cef.flailCrew];
    case 'mht-68':
      return [cef.flailCrew];
    case 'mht-72':
      return [cef.flailCrew];
    case 'hpc-64':
      return [cef.command2];
    case 'flail':
      return [cef.lpz, south.single];
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
  }
  return [];
}
