class FactionRule {
  FactionRule({
    required this.name,
    required this.id,
    this.options = null,
    this.description = '',
    isEnabled = true,
    this.canBeToggled = false,
    this.requirementCheck = factionRuleAlwaysAvailable,
  }) {
    _isEnabled = isEnabled;
  }

  final String name;
  final String id;
  final List<FactionRule>? options;
  final String description;
  late bool _isEnabled;
  final bool canBeToggled;
  final bool Function(List<FactionRule>) requirementCheck;

  bool get isEnabled => _isEnabled;
  void toggleIsEnabled(List<FactionRule> rules) {
    if (canBeToggled && this.requirementCheck(rules)) {
      _isEnabled = !_isEnabled;
    }
  }

  static bool isRuleEnabled(List<FactionRule> rules, String ruleID) {
    // TODO might be more optimal to use wheres
    for (final r in rules) {
      if (r.id == ruleID) {
        return r.isEnabled;
      }
      if (r.options != null) {
        final isFound = isRuleEnabled(r.options!, ruleID);
        if (isFound) {
          return true;
        }
      }
    }
    return false;
  }

  static bool factionRuleAlwaysAvailable(List<FactionRule> rules) => true;

  static bool Function(List<FactionRule> rules) thereCanBeOnlyOne(
      List<String> excludedIDs) {
    return (List<FactionRule> rules) {
      for (final ID in excludedIDs) {
        // if a rule that is on the exclude list is already enabled
        // this rule cannot be.
        if (isRuleEnabled(rules, ID)) {
          return false;
        }
      }
      return true;
    };
  }

  factory FactionRule.from(
    FactionRule original, {
    List<FactionRule>? options,
    bool? isEnabled,
    bool? canBeToggled,
    bool Function(List<FactionRule>)? requirementCheck,
  }) {
    return FactionRule(
      name: original.name,
      id: original.id,
      options: options != null ? options : original.options?.toList(),
      isEnabled: isEnabled != null ? isEnabled : original.isEnabled,
      canBeToggled: canBeToggled != null ? canBeToggled : original.canBeToggled,
      description: original.description,
      requirementCheck: requirementCheck != null
          ? requirementCheck
          : original.requirementCheck,
    );
  }
}
