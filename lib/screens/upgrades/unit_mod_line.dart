import 'package:flutter/material.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/upgrades/mod_option_button.dart';

const int _maxUpgradeNameLines = 2;
const int _maxUpgradeDescriptionLines = 4;

class UnitModLine extends StatelessWidget {
  const UnitModLine({
    Key? key,
    required this.unit,
    required this.mod,
    required this.isModSelectable,
  }) : super(key: key);

  final Unit unit;
  final BaseModification mod;
  final bool isModSelectable;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: ScrollController(),
      clipBehavior: Clip.antiAlias,
      child: Row(
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
          ..._createModChanges(context, mod),
        ],
      ),
    );
  }

  List<Widget> _createModChanges(BuildContext context, BaseModification mod) {
    List<Widget> results = [];

    if (mod.hasOptions) {
      results.add(
        ModOptionButton(
          mod: mod,
          isSelectable: isModSelectable,
        ),
      );
    }

    results.addAll(
      mod.description.map((modChange) {
        if (mod.description[mod.description.length - 1] == modChange) {
          return Text(
            modChange,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
              decoration: isModSelectable ? null : TextDecoration.lineThrough,
            ),
            maxLines: _maxUpgradeDescriptionLines,
          );
        }
        return Text(
          '$modChange, ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
            decoration: isModSelectable ? null : TextDecoration.lineThrough,
          ),
        );
      }).toList(),
    );
    return results;
  }
}
