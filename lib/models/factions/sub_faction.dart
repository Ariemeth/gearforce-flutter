import 'package:gearforce/models/rules/rule_set.dart';

class SubFaction {
  final String name;
  final String? description;
  final RuleSet ruleSet;
  const SubFaction(
    this.name, {
    this.description,
    required this.ruleSet,
  });

  @override
  String toString() => this.name;
}
