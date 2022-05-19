import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/mods/duelist/duelist_upgrades.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/mods/standardUpgrades/standard_modification.dart';
import 'package:gearforce/models/mods/standardUpgrades/standard_upgrades.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_upgrades.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_upgrades.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/upgrades/upgrade_display_line.dart';
import 'package:provider/provider.dart';

const double _upgradeSectionWidth = 620;
const double _upgradeSectionHeight = 33;
const double _maxVisibleUnitUpgrades = 3;

class UpgradesDialog extends StatelessWidget {
  UpgradesDialog({
    Key? key,
    required this.roster,
    required this.cg,
    required this.unit,
  }) : super(key: key) {
    unitMods = getUnitMods(unit.core.frame, unit);
    standardMods = getStandardMods(unit, cg);
    veteranMods = getVeteranMods(unit, cg);
    duelistMods = getDuelistMods(unit, roster);
  }

  final UnitRoster roster;
  final CombatGroup cg;
  final Unit unit;
  late final List<UnitModification> unitMods;
  late final List<StandardModification> standardMods;
  late final List<VeteranModification> veteranMods;
  late final List<DuelistModification> duelistMods;

  @override
  Widget build(BuildContext context) {
    context.watch<Unit>();

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
              '${unit.core.name} TV: ${unit.tv}',
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
            upgradeTitle('Standard Upgrades'),
            unitUpgrades(standardMods, unit),
            upgradeTitle('Veteran Upgrades'),
            unitUpgrades(veteranMods, unit),
            upgradeTitle('Duelist Upgrades'),
            unitUpgrades(duelistMods, unit),
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

Widget unitUpgrades(List<BaseModification> mods, Unit unit) {
  if (mods.isEmpty) {
    return const Center(
      child: Text(
        'no upgrades available',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();

  return Container(
    width: _upgradeSectionWidth,
    height: _upgradeSectionHeight *
        (mods.length > _maxVisibleUnitUpgrades
            ? _maxVisibleUnitUpgrades
            : mods.length.toDouble()),
    child: Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      interactive: true,
      child: ListView.builder(
        itemCount: mods.length,
        controller: _scrollController,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return UpgradeDisplayLine(
            // if the unit already has the mod, use that instance instead of a new one
            mod: unit.hasMod(mods[index].id)
                ? unit.getMod(mods[index].id)!
                : mods[index],
            unit: unit,
          );
        },
      ),
    ),
  );
}
