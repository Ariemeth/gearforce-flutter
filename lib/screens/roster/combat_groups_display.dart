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
    Tab(text: 'cg1'),
    Tab(text: 'cg2'),
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
              Center(
                child: CombatGroup(widget.data, widget.roster),
              ),
              Center(
                child: CombatGroup(widget.data, widget.roster),
              )
            ],
          ),
        ),
      ),
    );
  }
}
