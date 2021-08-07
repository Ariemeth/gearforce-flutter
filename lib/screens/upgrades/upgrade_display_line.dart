import 'package:flutter/material.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/standardUpgrades/standard_modification.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/upgrades/unit_mod_line.dart';

class UpgradeDisplayLine extends StatelessWidget {
  final BaseModification mod;
  final Unit unit;

  UpgradeDisplayLine({
    Key? key,
    required this.mod,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isModSelectable = true;
    if (mod is Modification) {
      isModSelectable =
          (mod as Modification).requirementCheck(unit) || unit.hasMod(mod.id);
    } else if (mod is StandardModification) {
      isModSelectable = (mod as StandardModification).requirementCheck() ||
          unit.hasMod(mod.id);
    } else if (mod is VeternModification) {
      isModSelectable =
          (mod as VeternModification).requirementCheck() || unit.hasMod(mod.id);
    }
    return UnitModLine(
      unit: unit,
      mod: mod,
      isModSelectable: isModSelectable,
    );
  }
}
