class FactionRule {
  FactionRule({
    required this.name,
    this.options = null,
    this.description = '',
    isEnabled = true,
    this.canBeToggled = false,
    this.requirementCheck = factionRuleAlwaysAvailable,
  }) {
    _isEnabled = isEnabled;
  }

  final String name;
  final List<FactionRule>? options;
  final String description;
  late bool _isEnabled;
  final bool canBeToggled;
  final bool Function() requirementCheck;

  bool get isEnabled => _isEnabled;
  void toggleEnabled() {
    if (canBeToggled) {
      _isEnabled = !_isEnabled;
    }
  }

  factory FactionRule.from(
    FactionRule original, {
    List<FactionRule>? options,
    bool? isEnabled,
    bool? canBeToggled,
  }) {
    return FactionRule(
      name: original.name,
      options: options != null ? options : original.options,
      isEnabled: isEnabled != null ? isEnabled : original.isEnabled,
      canBeToggled: canBeToggled != null ? canBeToggled : original.canBeToggled,
      description: original.description,
    );
  }
}

bool factionRuleAlwaysAvailable() => true;
