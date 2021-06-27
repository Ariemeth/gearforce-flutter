import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/select_faction.dart';
import 'package:gearforce/screens/roster/select_subfaction.dart';
import 'package:gearforce/widgets/display_value.dart';
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
      ],
    );
  }

  Widget _createInfoPanel(BuildContext context) {
    final roster = context.watch<UnitRoster>();

    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FixedColumnWidth(200.0),
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
        ]),
      ],
    );
  }

  Widget _createTVPanel(BuildContext context) {
    final roster = Provider.of<UnitRoster>(context);
    List<Widget> tvs = [];

    roster.getCGs().forEach((cg) {
      tvs.add(DisplayValue(text: '${cg.name} TV:', value: cg.totalTV()));
    });
    var tvAllCGs = GridView.count(
      crossAxisCount: 2,
      children: tvs,
      shrinkWrap: true,
      childAspectRatio: 270 / 75,
      clipBehavior: Clip.antiAlias,
    );

    var tvPanel = Column(children: [
      DisplayValue(
          text: 'Total TV:', value: Provider.of<UnitRoster>(context).totalTV()),
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
