import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/combat_group.dart';
import 'package:provider/provider.dart';

const double _tabBarHeight = 30.0;

class CombatGroupsDisplay extends StatefulWidget {
  CombatGroupsDisplay();

  @override
  _CombatGroupsDisplayState createState() => _CombatGroupsDisplayState();
}

class _CombatGroupsDisplayState extends State<CombatGroupsDisplay>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    final roster = Provider.of<UnitRoster>(context);
    final tabs = roster
        .getCGs()
        .map((e) => Tab(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(e.name),
              ),
            ))
        .toList()
      ..add(Tab(
        child: OutlinedButton(
          onPressed: () {
            context.read<UnitRoster>().createCG();
          },
          child: const Text('Add CG'),
        ),
      ));

    return Expanded(
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          primary: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(_tabBarHeight),
            child: TabBar(
              labelColor: Colors.blue[700],
              indicatorColor: Colors.deepPurple,
              tabs: tabs,
              isScrollable: true,
              labelPadding: EdgeInsets.zero,
            ),
          ),
          body: TabBarView(
            children: roster
                .getCGs()
                .map((e) => CombatGroupWidget(data, roster, name: e.name))
                .toList()
              ..add(
                CombatGroupWidget(
                  data,
                  roster,
                  name: 'add cg button',
                ),
              ),
          ),
        ),
      ),
    );
  }
}
