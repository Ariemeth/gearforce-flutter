import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/mods/base_modification.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/screens/upgrades/unit_mod_line.dart';

class UpgradeDisplayLine extends StatelessWidget {
  final BaseModification mod;
  final Unit unit;
  final CombatGroup cg;
  final UnitRoster ur;
  final RuleSet rs;

  const UpgradeDisplayLine({
    super.key,
    required this.mod,
    required this.unit,
    required this.cg,
    required this.ur,
    required this.rs,
  });

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
