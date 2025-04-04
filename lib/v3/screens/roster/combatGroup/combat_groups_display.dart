import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/screens/roster/combatGroup/combat_group.dart';

const double _tabBarHeight = 30.0;
const double _addCGButtonHorizontalPadding = 10.0;
const double _addCGButtonCornerRadius = 10.0;

class CombatGroupsDisplay extends StatefulWidget {
  const CombatGroupsDisplay(this.roster, {super.key});

  final UnitRoster roster;

  @override
  State<CombatGroupsDisplay> createState() => _CombatGroupsDisplayState();
}

class _CombatGroupsDisplayState extends State<CombatGroupsDisplay>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = _getTabController(initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if ((_tabController.length - 1) != widget.roster.getCGs().length) {
      final oldController = _tabController;
      _tabController = _getTabController(initialIndex: _selectedIndex);
      oldController.dispose();
    }

    final cgTabButtons = widget.roster
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
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(_addCGButtonCornerRadius),
              ),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: _addCGButtonHorizontalPadding)),
        onPressed: () {
          setState(() {
            widget.roster.createCG();
          });
        },
        child: const Text('Add CG'),
      ),
    );

    final List<Tab> tabs = [addCGTabButton, ...cgTabButtons];

    final cgTabPanels = widget.roster
        .getCGs()
        .map((e) => CombatGroupWidget(widget.roster, name: e.name))
        .toList();

    final groupPanel = Scaffold(
      primary: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(_tabBarHeight),
        child: TabBar(
          padding: const EdgeInsets.only(left: 15.0),
          controller: _tabController,
          indicatorColor: Colors.deepPurple,
          tabs: tabs,
          isScrollable: true,
          labelPadding: EdgeInsets.zero,
          tabAlignment: TabAlignment.start,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Center(
            child: Text(
                'Should not be here!\nClick on any of the existing combat group tabs to go back'),
          ),
          ...cgTabPanels,
        ],
      ),
    );

    return Flexible(
      fit: FlexFit.loose,
      child: groupPanel,
    );
  }

  TabController _getTabController({int initialIndex = 0}) {
    final length = widget.roster.getCGs().length + 1;
    if (initialIndex >= length && initialIndex != 0) {
      initialIndex = length - 1;
    }

    final controller = TabController(
      initialIndex: initialIndex,
      length: length,
      vsync: this,
    );

    controller.addListener(() {
      setState(() {
        final currentIndex = _tabController.index;
        if (currentIndex == 0) {
          _selectedIndex = _tabController.previousIndex;
          _tabController.animateTo(_selectedIndex);
        } else {
          _selectedIndex = currentIndex > 0 ? currentIndex : 1;
        }

        final numberCGs = widget.roster.getCGs().length;
        final rosterIndex = min(max(_selectedIndex - 1, 0), numberCGs - 1);
        widget.roster.setActiveCG(widget.roster.getCGs()[rosterIndex].name);
      });
    });
    return controller;
  }
}
