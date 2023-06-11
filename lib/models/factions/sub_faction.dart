import 'package:gearforce/models/rules/rule_set.dart';

class SubFaction {
  String get name => this.ruleSet.name;
  String? get description => this.ruleSet.description;
  final RuleSet ruleSet;
  const SubFaction({
    required this.ruleSet,
  });

  @override
  String toString() => this.name;
}
