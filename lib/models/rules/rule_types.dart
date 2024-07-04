enum RuleType {
  Standard,
  AlphaBeta,
  ExtendedContent,
  Custom,
}

extension RuleTypeExtension on RuleType {
  String get name {
    return this.toString().split('.').last;
  }

  String get Summary {
    switch (this) {
      case RuleType.Standard:
        return 'Standard rules';
      case RuleType.AlphaBeta:
        return 'Alpha/Beta rules';
      case RuleType.ExtendedContent:
        return 'Extended content rules';
      case RuleType.Custom:
        return 'Custom rules';
    }
  }

  static RuleType ruleTypeFromString(String value) {
    switch (value) {
      case 'Standard':
        return RuleType.Standard;
      case 'AlphaBeta':
        return RuleType.AlphaBeta;
      case 'ExtendedContent':
        return RuleType.ExtendedContent;
      case 'Custom':
        return RuleType.Custom;
      default:
        throw ArgumentError('Invalid RuleType: $value');
    }
  }
}
