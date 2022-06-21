import 'package:gearforce/models/rules/rule_set.dart';

abstract class SubFaction {
  final String name;
  final RuleSet? ruleSet;
  const SubFaction(
    this.name, {
    this.ruleSet,
  });
}
