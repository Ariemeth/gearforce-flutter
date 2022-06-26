import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/peace_river.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/unit/unit.dart';

class FactionModification extends BaseModification {
  FactionModification({
    required String name,
    this.requirementCheck = _defaultRequirementsFunction,
    ModificationOption? options,
    required String id,
  }) : super(name: name, options: options, id: id);

  // function to ensure the modification can be applied to the unit
  final bool Function(CombatGroup, Unit) requirementCheck;

  static bool _defaultRequirementsFunction(CombatGroup cg, Unit u) => true;
}

FactionModification? factionModFromId(String id, Unit u) {
  switch (id) {
    case e_pexID:
      return PeaceRiverFactionMods.e_pex();
    case warriorEliteID:
      return PeaceRiverFactionMods.warriorElite();
    case crisisRespondersID:
      return PeaceRiverFactionMods.crisisResponders(u);
    case laserTechID:
      return PeaceRiverFactionMods.laserTech(u);
    case olTrustyID:
      return PeaceRiverFactionMods.olTrusty();
    case thunderFromTheSkyID:
      return PeaceRiverFactionMods.thunderFromTheSky();
    case eliteElmentsID:
      return PeaceRiverFactionMods.eliteElements();
    case highTechID:
      return PeaceRiverFactionMods.highTech();
  }
  return null;
}
