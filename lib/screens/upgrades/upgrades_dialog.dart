import 'package:flutter/material.dart';
import 'package:gearforce/models/mods/modification.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_upgrades.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/upgrades/upgrade_display_line.dart';
import 'package:provider/provider.dart';

const double _upgradeSectionWidth = 500;
const double _upgradeSectionHeight = 40;
const double _maxVisibleUnitUpgrades = 2;

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
      clipBehavior: Clip.antiAlias,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Center(
        child: Column(
          children: [
            Text(
              'Upgrades available to this',
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
          // create listview with available upgrades
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            upgradeTitle('Unit Upgrades'),
            unitUpgrades(unitMods, unit),
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
    height: _upgradeSectionHeight *
        (mods.length > _maxVisibleUnitUpgrades
            ? _maxVisibleUnitUpgrades
            : mods.length.toDouble()),
    child: ListView.builder(
      itemCount: mods.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return UpgradeDisplayLine(
          mod: mods[index],
          unit: unit,
        );
      },
    ),
  );
}
