import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/combat_group.dart';

class CombatGroupsDisplay extends StatefulWidget {
  CombatGroupsDisplay(this.data, this.roster);

  final Data data;
  final UnitRoster roster;
  @override
  _CombatGroupsDisplayState createState() => _CombatGroupsDisplayState();
}

class _CombatGroupsDisplayState extends State<CombatGroupsDisplay>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    Tab(text: 'CG 1'),
    Tab(text: 'CG 2'),
    Tab(text: 'CG 3'),
    Tab(text: 'CG 4'),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          primary: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: TabBar(
              labelColor: Colors.blue[700],
              indicatorColor: Colors.deepPurple,
              tabs: tabs,
              isScrollable: true,
            ),
          ),
          body: TabBarView(
            children: [
              CombatGroupWidget(widget.data, widget.roster, name: 'CG 1'),
              CombatGroupWidget(widget.data, widget.roster, name: 'CG 2'),
              CombatGroupWidget(widget.data, widget.roster, name: 'CG 3'),
              CombatGroupWidget(widget.data, widget.roster, name: 'CG 4'),
            ],
          ),
        ),
      ),
    );
  }
}
