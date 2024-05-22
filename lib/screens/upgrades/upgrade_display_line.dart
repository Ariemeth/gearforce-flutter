import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/upgrades/unit_mod_line.dart';

class UpgradeDisplayLine extends StatelessWidget {
  final BaseModification mod;
  final Unit unit;
  final CombatGroup cg;
  final UnitRoster ur;
  final RuleSet rs;

  UpgradeDisplayLine({
    Key? key,
    required this.mod,
    required this.unit,
    required this.cg,
    required this.ur,
    required this.rs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnitModLine(
      unit: unit,
      mod: mod,
      isModSelectable:
          mod.requirementCheck(rs, ur, cg, unit) || unit.hasMod(mod.id),
    );
  }
}
