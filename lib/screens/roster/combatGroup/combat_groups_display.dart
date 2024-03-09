import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/combatGroup/combat_group.dart';
import 'package:provider/provider.dart';

const double _tabBarHeight = 30.0;
const double _addCGButtonHorizontalPadding = 10.0;
const double _addCGButtonCornerRadius = 10.0;

class CombatGroupsDisplay extends StatefulWidget {
  CombatGroupsDisplay();

  @override
  _CombatGroupsDisplayState createState() => _CombatGroupsDisplayState();
}

class _CombatGroupsDisplayState extends State<CombatGroupsDisplay>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final data = context.watch<Data>();
    final roster = context.watch<UnitRoster>();
    final cgTabButtons = roster
        .getCGs()
        .map((e) => Tab(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(e.name),
              ),
            ))
        .toList();

    final addCGTabButton = Tab(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(_addCGButtonCornerRadius),
              ),
            ),
            padding: EdgeInsets.symmetric(
                horizontal: _addCGButtonHorizontalPadding)),
        onPressed: () {
          context.read<UnitRoster>().createCG();
        },
        child: const Text('Add CG'),
      ),
    );

    final List<Tab> tabs = [addCGTabButton, ...cgTabButtons];

    return Container(
      child: DefaultTabController(
        length: tabs.length,
        child: Builder(
          builder: (BuildContext context) {
            final TabController tabController =
                DefaultTabController.of(context);

            if (tabController.index == 0 && tabs.length >= 1) {
              tabController.animateTo(1);
            }

            tabController.addListener(
              () {
                var tabIndex = tabController.index;
                tabIndex = max(tabIndex, 1);
                tabIndex = min(tabIndex, tabs.length - 1);
                tabController.animateTo(tabIndex);
                final rosterIndex = min(tabIndex, roster.getCGs().length - 1);
                roster.setActiveCG(roster.getCGs()[rosterIndex].name);
              },
            );

            final cgTabPanels = roster
                .getCGs()
                .map((e) => CombatGroupWidget(data, roster, name: e.name))
                .toList();

            return Flexible(
              fit: FlexFit.loose,
              child: Scaffold(
                primary: false,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(_tabBarHeight),
                  child: TabBar(
                    indicatorColor: Colors.deepPurple,
                    tabs: tabs,
                    isScrollable: true,
                    labelPadding: EdgeInsets.zero,
                    tabAlignment: TabAlignment.start,
                  ),
                ),
                body: TabBarView(
                  controller: tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Center(
                      child: Text(
                          'Should not be here!\nClick on any of the existing combat group tabs to go back'),
                    ),
                    ...cgTabPanels,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
