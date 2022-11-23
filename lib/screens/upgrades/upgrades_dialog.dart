import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/mods/duelist/duelist_upgrades.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/standardUpgrades/standard_modification.dart';
import 'package:gearforce/models/mods/standardUpgrades/standard_upgrades.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_upgrades.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_upgrades.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/upgrades/upgrade_display_line.dart';
import 'package:gearforce/widgets/options_section_title.dart';
import 'package:provider/provider.dart';

const double _upgradeSectionWidth = 620;
const double _upgradeSectionHeight = 33;
const int _maxVisibleUnitUpgrades = 3;

class UpgradesDialog extends StatelessWidget {
  const UpgradesDialog({
    Key? key,
    required this.roster,
    required this.cg,
    required this.unit,
  }) : super(key: key);

  final UnitRoster roster;
  final CombatGroup cg;
  final Unit unit;

  @override
  Widget build(BuildContext context) {
    context.watch<Unit>();

    final rs = roster.subFaction.value.ruleSet;
    final unitMods = getUnitMods(unit.core.frame, unit);
    final standardMods = getStandardMods(unit, cg, roster);
    final veteranMods = getVeteranMods(unit, cg);
    final duelistMods = getDuelistMods(unit, cg, roster);
    final factionMods = rs.availableFactionMods(roster, cg, unit);

    unit.getMods().forEach((mod) {
      switch (mod.modType) {
        case ModificationType.unit:
          unitMods[unitMods.indexWhere((m) => m.id == mod.id)] =
              mod as UnitModification;
          break;
        case ModificationType.standard:
          standardMods[standardMods.indexWhere((m) => m.id == mod.id)] =
              mod as StandardModification;
          break;
        case ModificationType.veteran:
          veteranMods[veteranMods.indexWhere((m) => m.id == mod.id)] =
              mod as VeteranModification;
          break;
        case ModificationType.duelist:
          duelistMods[duelistMods.indexWhere((m) => m.id == mod.id)] =
              mod as DuelistModification;
          break;
        case ModificationType.faction:
          factionMods[factionMods.indexWhere((m) => m.id == mod.id)] =
              mod as FactionModification;
          break;
      }
    });

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
            optionsSectionTitle('Unit Upgrades'),
            unitUpgrades(unitMods, unit, cg, roster, rs),
            optionsSectionTitle('Standard Upgrades'),
            unitUpgrades(standardMods, unit, cg, roster, rs),
            optionsSectionTitle('Faction Upgrades'),
            unitUpgrades(factionMods, unit, cg, roster, rs),
            optionsSectionTitle('Veteran Upgrades'),
            unitUpgrades(veteranMods, unit, cg, roster, rs),
            optionsSectionTitle('Duelist Upgrades'),
            unitUpgrades(duelistMods, unit, cg, roster, rs),
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

Widget unitUpgrades(List<BaseModification> mods, Unit unit, CombatGroup cg,
    UnitRoster ur, RuleSet rs) {
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
      trackVisibility: true,
      controller: _scrollController,
      interactive: true,
      child: ListView.builder(
        itemCount: mods.length,
        controller: _scrollController,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          context.watch<Unit>();
          return UpgradeDisplayLine(
            mod: mods[index],
            unit: unit,
            cg: cg,
            ur: ur,
            rs: rs,
          );
        },
      ),
    ),
  );
}
