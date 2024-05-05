import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/rules/rule.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/header/faction_rules_dialog.dart';
import 'package:gearforce/screens/roster/header/select_faction.dart';
import 'package:gearforce/screens/roster/header/select_force_leader.dart';
import 'package:gearforce/screens/roster/header/select_subfaction.dart';
import 'package:gearforce/screens/roster/roster_tv_totals_display_line.dart';
import 'package:gearforce/screens/upgrades/unit_upgrade_button.dart';
import 'package:gearforce/widgets/display_value.dart';
import 'package:provider/provider.dart';

const _editableSettingsIcon = Icons.settings_suggest;
const _settingsIcon = Icons.settings;

class RosterHeaderInfo extends StatelessWidget {
  RosterHeaderInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createInfoPanel(context),
        _createTVPanel(context),
      ],
    );
  }

  Widget _createInfoPanel(BuildContext context) {
    final roster = context.watch<UnitRoster>();

    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FixedColumnWidth(200.0),
        2: FixedColumnWidth(30.0),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 5,
              left: 5,
              top: 5,
              bottom: 5,
            ),
            child: Text(
              'Player name:',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
              left: 5,
              top: 5,
              bottom: 5,
            ),
            child: TextField(
                controller: TextEditingController(text: roster.player),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 5,
                  ),
                ),
                onChanged: (String value) async {
                  roster.player = value;
                },
                onSubmitted: (String value) async {
                  // TODO DEBUG use playername onSubmit to print the roster.
                  print(roster);
                },
                style: TextStyle(fontSize: 16),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-Z0-9 -':\(\)_]"))
                ]),
          ),
          Container(),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 5,
              left: 5,
              top: 5,
              bottom: 5,
            ),
            child: Text(
              'Force name:',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
              left: 5,
              top: 5,
              bottom: 5,
            ),
            child: TextField(
                controller: TextEditingController(text: roster.name),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 5,
                  ),
                ),
                onChanged: (String value) async {
                  roster.name = value;
                },
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-Z0-9 -'\(\)_]"))
                ]),
          ),
          Container(),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 5,
              left: 5,
              top: 5,
              bottom: 5,
            ),
            child: Text(
              'Faction:',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
              left: 5,
              top: 5,
              bottom: 5,
            ),
            child: SelectFaction(
              factions: Provider.of<Data>(context).factions(),
              selectedFaction: roster.factionNotifier,
            ),
          ),
          IconButton(
            onPressed: () => {
              _showSettingsDialog(
                context,
                roster.rulesetNotifer.value.factionRules,
                roster,
                true,
              )
            },
            icon: Icon(
              roster.rulesetNotifer.value.factionRules.any(
                (r) {
                  if (!r.canBeToggled) {
                    return false;
                  }

                  final options = r.options;
                  if (options == null) {
                    return false;
                  }
                  return options.any((o) => o.canBeToggled);
                },
              )
                  ? _editableSettingsIcon
                  : _settingsIcon,
              color: Colors.green,
            ),
            splashRadius: 20.0,
            padding: const EdgeInsets.only(),
            tooltip: 'Rules for ${roster.factionNotifier.value.name}',
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 5,
              left: 5,
              top: 5,
              bottom: 5,
            ),
            child: Text(
              'Sub-List:',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
              left: 5,
              top: 5,
              bottom: 5,
            ),
            child: SelectSubFaction(
              factions: Provider.of<Data>(context).factions(),
              selectedFaction: roster.factionNotifier,
              selectedSubFaction: roster.rulesetNotifer,
            ),
          ),
          IconButton(
            onPressed: () => {
              _showSettingsDialog(
                context,
                roster.rulesetNotifer.value.subFactionRules,
                roster,
                false,
              )
            },
            icon: Icon(
              roster.rulesetNotifer.value.subFactionRules.any(
                (r) {
                  if (!r.canBeToggled) {
                    return false;
                  }

                  final options = r.options;
                  if (options == null) {
                    return false;
                  }
                  return options.any((o) => o.canBeToggled);
                },
              )
                  ? _editableSettingsIcon
                  : _settingsIcon,
              color: Colors.green,
            ),
            splashRadius: 20.0,
            padding: const EdgeInsets.only(),
            tooltip: 'Rules for ${roster.rulesetNotifer.value.name}',
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 5,
              left: 5,
              top: 5,
              bottom: 5,
            ),
            child: Text(
              'Force Leader:',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
              left: 5,
              top: 5,
              bottom: 5,
            ),
            child: SelectForceLeader(),
          ),
          roster.selectedForceLeader != null
              ? UnitUpgradeButton(
                  roster.selectedForceLeader!,
                  roster.selectedForceLeader!.group!,
                  roster.selectedForceLeader!.group!.combatGroup!,
                  roster,
                )
              : Container(
                  width: 30,
                  height: 40,
                ),
        ]),
      ],
    );
  }

  void _showSettingsDialog(BuildContext context, List<Rule> upgrades,
      UnitRoster roster, bool isCore) {
    final settingsDialog = FactionRulesDialog(
      upgrades: upgrades,
      roster: roster,
      isCore: isCore,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return settingsDialog;
        });
  }

  Widget _createTVPanel(BuildContext context) {
    final roster = Provider.of<UnitRoster>(context);
    List<Widget> tvs = [];

    roster.getCGs().forEach((cg) {
      tvs.add(
        RosterTVTotalsDisplayLine(
          text: cg.name,
          value: cg.totalTV(),
        ),
      );
    });

    var tvPanel = Column(children: [
      DisplayValue(
          text: 'Total TV:', value: Provider.of<UnitRoster>(context).totalTV()),
      Flexible(
        flex: 1,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(1),
          child: Column(
            children: tvs,
          ),
          primary: true,
        ),
      ),
    ]);
    return SizedBox(
      width: 310,
      height: 210,
      child: tvPanel,
    );
  }
}
