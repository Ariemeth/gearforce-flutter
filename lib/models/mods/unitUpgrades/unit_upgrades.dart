import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/unitUpgrades/north.dart' as north;

List<Modification> getUnitMods(String frameName) {
  switch (frameName.toLowerCase()) {
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
  }
  return [];
}
