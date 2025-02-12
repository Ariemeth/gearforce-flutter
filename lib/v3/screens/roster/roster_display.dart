import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/screens/roster/combatGroup/combat_groups_display.dart';
import 'package:gearforce/v3/screens/roster/header/roster_header_info.dart';
import 'package:provider/provider.dart';

class RosterDisplay extends StatelessWidget {
  const RosterDisplay({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final vScrollController = ScrollController(
      debugLabel: 'RosterDisplayVerticalScrollController',
    );

    final roster = context.watch<UnitRoster>();

    return Scrollbar(
      scrollbarOrientation: ScrollbarOrientation.left,
      trackVisibility: true,
      controller: vScrollController,
      interactive: true,
      child: SingleChildScrollView(
        controller: vScrollController,
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const RosterHeaderInfo(),
              CombatGroupsDisplay(roster),
            ],
          ),
        ),
      ),
    );
  }
}
