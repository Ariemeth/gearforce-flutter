import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/unit/unit.dart';

List<VeternModification> getVeteranMods(Unit u, CombatGroup cg) {
  return [
    VeternModification.makeVet(u, cg),
    VeternModification.ewSpecialist(u, cg),
    VeternModification.fieldArmor(u, cg),
  ];
}
