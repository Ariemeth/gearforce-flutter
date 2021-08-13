import 'package:flutter/material.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/upgrades/upgrade_options.dart';

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
          ...createModChanges(context, mod, isSelectable: isModSelectable),
        ],
      ),
    );
  }
}

List<Widget> createModChanges(
  BuildContext context,
  BaseModification mod, {
  bool isSelectable = true,
}) {
  List<Widget> results = [];

  if (mod.hasOptions) {
    results.add(
      IconButton(
        onPressed: () {
          showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return UpgradeOptions(
                  options: mod.options!,
                );
              });
        },
        icon: const Icon(Icons.add_link_sharp),
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
            decoration: isSelectable ? null : TextDecoration.lineThrough,
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
          decoration: isSelectable ? null : TextDecoration.lineThrough,
        ),
      );
    }).toList(),
  );
  return results;
}
