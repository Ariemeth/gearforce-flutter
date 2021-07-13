import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/unitUpgrades/north.dart' as north;
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
  }
  return [];
}
