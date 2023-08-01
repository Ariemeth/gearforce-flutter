import 'package:flutter/material.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/upgrades/mod_option_button.dart';

const int _maxUpgradeNameLines = 2;
const int _maxUpgradeDescriptionLines = 4;

class UnitModLine extends StatefulWidget {
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
  _UnitModLineState createState() => _UnitModLineState();
}

class _UnitModLineState extends State<UnitModLine> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: ScrollController(),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Checkbox(
              value: widget.unit.hasMod(widget.mod.id),
              onChanged: widget.isModSelectable
                  ? (bool? newValue) {
                      if (newValue!) {
                        widget.unit.addUnitMod(widget.mod);
                      } else {
                        widget.unit.removeUnitMod(widget.mod.id);
                      }
                    }
                  : null),
          Text(
            '${widget.mod.name}: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              decoration:
                  widget.isModSelectable ? null : TextDecoration.lineThrough,
            ),
            maxLines: _maxUpgradeNameLines,
          ),
          ..._createModChanges(context, widget.mod, () {
            // TODO This force notify is needed to update the options icon from
            // red to green in the unit upgrade dialogue.  Should be able to
            // have the options cause an update without using this force notify
            widget.unit.forceNotify();
          }),
        ],
      ),
    );
  }

  List<Widget> _createModChanges(
      BuildContext context, BaseModification mod, Function() onChanged) {
    List<Widget> results = [];

    if (mod.hasOptions) {
      results.add(
        ModOptionButton(
          mod: mod,
          isSelectable: widget.isModSelectable,
          onChanged: onChanged,
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
              decoration:
                  widget.isModSelectable ? null : TextDecoration.lineThrough,
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
            decoration:
                widget.isModSelectable ? null : TextDecoration.lineThrough,
          ),
        );
      }).toList(),
    );
    return results;
  }
}
