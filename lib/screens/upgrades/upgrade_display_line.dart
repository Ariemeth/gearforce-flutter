import 'package:flutter/material.dart';
import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/unit/unit.dart';

const int _maxUpgradeNameLines = 2;
const int _maxUpgradeDescriptionLines = 4;

class UpgradeDisplayLine extends StatelessWidget {
  final Modification mod;
  final Unit unit;

  UpgradeDisplayLine({
    Key? key,
    required this.mod,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isModSelectable =
        this.mod.requirementCheck(this.unit) || this.unit.hasMod(this.mod.id);
    return Row(
      children: [
        Checkbox(
            value: unit.hasMod(mod.id),
            onChanged: isModSelectable
                ? (bool? newValue) {
                    if (newValue!) {
                      unit.addUnitMod(mod);
                    } else {
                      unit.removeUnitMod(mod.id);
                    }
                  }
                : null),
        Text(
          '${mod.name}: ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            decoration: isModSelectable ? null : TextDecoration.lineThrough,
          ),
          maxLines: _maxUpgradeNameLines,
        ),
        ...createModChanges(mod, isSelectable: isModSelectable),
      ],
    );
  }
}

List<Text> createModChanges(Modification mod, {bool isSelectable = true}) {
  return mod.description.map((modName) {
    if (mod.description[mod.description.length - 1] == modName) {
      return Text(
        modName,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.italic,
          decoration: isSelectable ? null : TextDecoration.lineThrough,
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
        decoration: isSelectable ? null : TextDecoration.lineThrough,
      ),
    );
  }).toList();
}
