import 'package:flutter/material.dart';
import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/unit/unit.dart';

const int _maxUpgradeNameLines = 2;
const int _maxUpgradeDescriptionLines = 4;

class UpgradeDisplayLine extends StatelessWidget {
  UpgradeDisplayLine({
    Key? key,
    required this.mod,
    required this.unit,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: unit.hasMod(mod.id),
          onChanged: (bool? newValue) {
            if (newValue!) {
              unit.addUnitMod(mod);
            } else {
              unit.removeUnitMod(mod.id);
            }
          },
        ),
        Text(
          '${mod.name}: ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),
          maxLines: _maxUpgradeNameLines,
        ),
        ...createModChanges(mod),
      ],
    );
  }

  final Modification mod;
  final Unit unit;
}

List<Text> createModChanges(Modification mod) {
  return mod.description.map((modName) {
    if (mod.description[mod.description.length - 1] == modName) {
      return Text(
        modName,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.italic,
        ),
        maxLines: _maxUpgradeDescriptionLines,
      );
    }
    return Text(
      '$modName, ',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
      ),
    );
  }).toList();
}
