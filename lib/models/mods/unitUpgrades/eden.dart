import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

final Modification wizard = Modification(name: 'Wizard Upgrade')
  ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
  ..addMod(UnitAttribute.name, createSimpleStringMod(true, 'Wizard'))
  ..addMod(UnitAttribute.ew, createSetIntMod(4), description: 'EW 4+')
  ..addMod(UnitAttribute.roles, createAddToList('RC'), description: '+RC')
  ..addMod(
      UnitAttribute.traits, createAddToList(Trait(name: 'ECM', isAux: true)),
      description: '+ECM (Aux)')
  ..addMod(
      UnitAttribute.traits, createAddToList(Trait(name: 'ECCM', isAux: true)),
      description: '+ECCM (Aux)');

final Modification utopianSpecialOperations =
    Modification(name: 'Utopian Special Operations Upgrade')
      ..addMod(UnitAttribute.tv, createSimpleIntMod(1), description: 'TV +1')
      ..addMod(UnitAttribute.name,
          createSimpleStringMod(false, 'Utopian Special Operations'))
      ..addMod(UnitAttribute.roles, createSetStringListMod(['SO']),
          description: 'SO')
      ..addMod(UnitAttribute.traits, createAddToList(Trait(name: 'Airdrop')),
          description: '+Airdrop')
      ..addMod(UnitAttribute.traits,
          createAddToList(Trait(name: 'Stealth', isAux: true)),
          description: '+Stealth (Aux)');
