import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/combat_group_tv.dart';
import 'package:gearforce/screens/roster/select_faction.dart';
import 'package:gearforce/screens/roster/select_subfaction.dart';
import 'package:provider/provider.dart';

class RosterHeaderInfo extends StatelessWidget {
  RosterHeaderInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createInfoPanel(context),
        _createTVPanel(context),
        Expanded(
          child: Container(),
        )
      ],
    );
  }

  Widget _createInfoPanel(BuildContext context) {
    final roster = context.watch<UnitRoster>();

    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FixedColumnWidth(200.0),
        2: FlexColumnWidth(1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(children: [
          Padding(
            padding: EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
            child: Text(
              'Player name:',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
            child: TextField(
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
                // DEBUG use playername onSubmit to print the roster.
                print(roster);
              },
              style: TextStyle(fontSize: 16),
              strutStyle: StrutStyle.disabled,
            ),
          ),
          Container(),
        ]),
        TableRow(children: [
          Padding(
            padding: EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
            child: Text(
              'Force name:',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
            child: TextField(
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
            ),
          ),
          Container(),
        ]),
        TableRow(children: [
          Padding(
            padding: EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
            child: Text(
              'Faction:',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
            child: SelectFaction(
              factions: Provider.of<Data>(context).factions(),
              selectedFaction: roster.faction,
            ),
          ),
          Container(),
        ]),
        TableRow(children: [
          Padding(
            padding: EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
            child: Text(
              'Sub-Faction:',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
            child: SelectSubFaction(
              factions: Provider.of<Data>(context).factions(),
              selectedFaction: roster.faction,
              selectedSubFaction: roster.subFaction,
            ),
          ),
          Container(),
        ]),
      ],
    );
  }

  Widget _createTVPanel(BuildContext context) {
    final roster = Provider.of<UnitRoster>(context);
    List<Widget> tvs = [];

    roster.getCGs().forEach((cg) {
      tvs.add(
        SizedBox(
          height: 30,
          width: 81,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
              child: Text(
                '${cg.name} TV:',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              width: 50,
              child: Padding(
                padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
                child: ChangeNotifierProvider.value(
                  value: cg,
                  child: CombatGroupTVTotal(totalTV: cg.totalTV()),
                ),
              ),
            ),
          ]),
        ),
      );
    });
    var tvAllCGs = GridView.count(
      crossAxisCount: 2,
      children: tvs,
      shrinkWrap: true,
      childAspectRatio: 270 / 75,
      clipBehavior: Clip.antiAlias,
    );

    var tvTotal = SizedBox(
      height: 35,
      child: Align(
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
              child: Text(
                'Total TV:',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              width: 60,
              child: Padding(
                padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
                child: CombatGroupTVTotal(
                    totalTV: Provider.of<UnitRoster>(context).totalTV()),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );

    var tvPanel = Column(children: [
      tvTotal,
      Flexible(
        flex: 1,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(1),
          child: Column(
            children: [
              tvAllCGs,
            ],
          ),
          primary: true,
        ),
      ),
    ]);
    return SizedBox(
      width: 270,
      height: 150,
      child: tvPanel,
    );
  }
}
