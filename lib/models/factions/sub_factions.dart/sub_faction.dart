import 'package:gearforce/models/rules/rule_set.dart';

class SubFaction {
  final String name;
  final RuleSet ruleSet;
  const SubFaction(
    this.name, {
    required this.ruleSet,
  });

  @override
  String toString() => this.name;
}
