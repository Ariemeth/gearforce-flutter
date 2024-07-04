import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/customUpgrades/custom_modifiation.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/standardUpgrades/standard_modification.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/unit/unit_card.dart';
import 'package:gearforce/screens/upgrades/upgrade_display_line.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:provider/provider.dart';

const double _upgradeSectionWidth = 450;

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

    final rs = roster.rulesetNotifer.value;
    final unitMods = rs.availableUnitMods(unit);
    final standardMods = rs.availableStandardMods(roster, cg, unit);
    final veteranMods = rs.availableVeteranMods(roster, cg, unit);
    final duelistMods = rs.availableDuelistMods(roster, cg, unit);
    final factionMods = rs.availableFactionMods(roster, cg, unit);
    final customMods = rs.availableCustomUpgrades();

    unit.getMods().forEach((mod) {
      switch (mod.modType) {
        case ModificationType.unit:
          final modIndex = unitMods.indexWhere((m) => m.id == mod.id);
          if (modIndex >= 0) {
            unitMods[modIndex] = mod as UnitModification;
          }
          break;
        case ModificationType.standard:
          final modIndex = standardMods.indexWhere((m) => m.id == mod.id);
          if (modIndex >= 0) {
            standardMods[modIndex] = mod as StandardModification;
          }
          break;
        case ModificationType.veteran:
          final modIndex = veteranMods.indexWhere((m) => m.id == mod.id);
          if (modIndex >= 0) {
            veteranMods[modIndex] = mod as VeteranModification;
          }
          break;
        case ModificationType.duelist:
          final modIndex = duelistMods.indexWhere((m) => m.id == mod.id);
          if (modIndex >= 0) {
            duelistMods[modIndex] = mod as DuelistModification;
          }
          break;
        case ModificationType.faction:
          final modIndex = factionMods.indexWhere((m) => m.id == mod.id);
          if (modIndex >= 0) {
            factionMods[modIndex] = mod as FactionModification;
          }
          break;
        case ModificationType.custom:
          final modIndex = customMods.indexWhere((m) => m.id == mod.id);
          if (modIndex >= 0) {
            customMods[modIndex] = mod as CustomModification;
          }
      }
    });

    var dialog = SimpleDialog(
      contentPadding: EdgeInsets.all(5.0),
      clipBehavior: Clip.antiAlias,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      children: [
        UnitCard(unit),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Center(
            child: Text(
              'Upgrades available to this unit.',
              style: TextStyle(fontSize: 24),
              maxLines: 2,
            ),
          ),
        ),
        UpgradePanels(
          cg,
          roster,
          rs,
          unit,
          unitMods: unitMods,
          standardMods: standardMods,
          vetMods: veteranMods,
          duelistMods: duelistMods,
          factionMods: factionMods,
          customMods: customMods,
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

class UpgradePanels extends StatefulWidget {
  final CombatGroup cg;
  final UnitRoster roster;
  final RuleSet rs;
  final Unit unit;
  final List<UnitModification> unitMods;
  final List<StandardModification> standardMods;
  final List<VeteranModification> vetMods;
  final List<DuelistModification> duelistMods;
  final List<FactionModification> factionMods;
  final List<CustomModification> customMods;

  UpgradePanels(
    this.cg,
    this.roster,
    this.rs,
    this.unit, {
    super.key,
    required this.unitMods,
    required this.standardMods,
    required this.vetMods,
    required this.duelistMods,
    required this.factionMods,
    required this.customMods,
  });

  @override
  State<UpgradePanels> createState() => _UpgradePanelsState();
}

class _UpgradePanelsState extends State<UpgradePanels> {
  final List<bool> panelExpandedList = [
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    final settings = context.read<Settings>();
    if (settings.allowCustomPoints) {
      panelExpandedList.add(false);
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                this.panelExpandedList[panelIndex] = isExpanded;
              });
            },
            children: [
              _buildPanel('Unit Upgrades', widget.unitMods, 0),
              _buildPanel('Standard Upgrades', widget.standardMods, 1),
              _buildPanel('Veteran Upgrades', widget.vetMods, 2),
              _buildPanel('Duelist Upgrades', widget.duelistMods, 3),
              _buildPanel('Faction Upgrades', widget.factionMods, 4),
              if (settings.allowCustomPoints)
                _buildPanel('Custom Upgrades', widget.customMods, 5),
            ],
            expandedHeaderPadding: EdgeInsets.zero,
            materialGapSize: 4.0,
          ),
        ],
      ),
    );
  }

  ExpansionPanel _buildPanel(
    String text,
    List<BaseModification> mods,
    int panelIndex,
  ) {
    final numAvailable = mods
        .where((m) => m.requirementCheck(
            widget.rs, widget.roster, widget.cg, widget.unit))
        .length;
    final numEnabled = mods.where((m) => widget.unit.hasMod(m.id)).length;
    final panel = ExpansionPanel(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      canTapOnHeader: true,
      headerBuilder: (context, isExpanded) {
        return Container(
          padding: EdgeInsets.fromLTRB(4.0, 0.0, 6.0, 0.0),
          color: Theme.of(context).colorScheme.inversePrimary,
          child: Row(
            children: [
              SizedBox(
                child: Text(text),
                width: 200.0,
              ),
              Text('Available: $numAvailable'),
              Spacer(),
              Text('Enabled: $numEnabled')
            ],
            //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        );
      },
      body: Container(
        width: _upgradeSectionWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: mods
              .map((m) => UpgradeDisplayLine(
                    mod: m,
                    unit: widget.unit,
                    cg: widget.cg,
                    ur: widget.roster,
                    rs: widget.rs,
                  ))
              .toList(),
        ),
      ),
      isExpanded: this.panelExpandedList[panelIndex],
    );

    return panel;
  }
}
