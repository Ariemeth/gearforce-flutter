import 'package:flutter/material.dart';
import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/unit_upgrades.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:provider/provider.dart';

const int _maxUpgradeNameLines = 2;
const int _maxUpgradeDescriptionLines = 4;
const double _upgradeSectionWidth = 400;
const double _upgradeSectionHeight = 40;

class UpgradesDialog extends StatelessWidget {
  UpgradesDialog({
    Key? key,
    required this.roster,
  }) : super(key: key);

  final UnitRoster roster;

  @override
  Widget build(BuildContext context) {
    final unit = Provider.of<Unit>(context);
    final unitMods = getUnitMods(unit.core.frame);

    var dialog = SimpleDialog(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Center(
        child: Row(
          children: [
            Text(
              'Upgrades available to this ',
              style: TextStyle(fontSize: 24),
              maxLines: 2,
            ),
            Text(
              unit.core.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      children: [
        Column(
          children: [
            Column(
              // create listview with available upgrades
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                upgradeTitle('Unit Upgrades'),
                unitUpgrades(unitMods, unit),
              ],
            ),
          ],
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Center(
            child: Text(
              'Done',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
          ),
        ),
      ],
    );
    return dialog;
  }

  Container upgradeTitle(String title) {
    return Container(
      color: Color.fromARGB(255, 187, 222, 251),
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget unitUpgrades(List<Modification> mods, Unit unit) {
    if (mods.isEmpty) {
      const Center(child: Text('no upgrades available'));
    }

    return Container(
      width: _upgradeSectionWidth,
      height: _upgradeSectionHeight,
      child: ListView.builder(
          itemCount: mods.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                Checkbox(
                    value: unit.hasMod(mods[index].id),
                    onChanged: (bool? newValue) {
                      if (newValue!) {
                        unit.addUnitMod(mods[index]);
                      } else {
                        unit.removeUnitMod(mods[index].id);
                      }
                    }),
                Text(
                  '${mods[index].name}: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                  maxLines: _maxUpgradeNameLines,
                ),
                ...mods[index].description.map((modName) {
                  if (mods[index]
                          .description[mods[index].description.length - 1] ==
                      modName) {
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
                }).toList()
              ],
            );
          }),
    );
  }
}
