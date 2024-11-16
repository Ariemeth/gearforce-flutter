enum RuleType {
  standard,
  alphaBeta,
  extendedContent,
  custom,
}

extension RuleTypeExtension on RuleType {
  String get name {
    return toString().split('.').last;
  }

  String get summary {
    switch (this) {
      case RuleType.standard:
        return 'Standard rules';
      case RuleType.alphaBeta:
        return 'Alpha/Beta rules';
      case RuleType.extendedContent:
        return 'Extended content rules';
      case RuleType.custom:
        return 'Custom rules';
    }
  }

  static RuleType ruleTypeFromString(String value) {
    switch (value) {
      case 'Standard':
        return RuleType.standard;
      case 'AlphaBeta':
        return RuleType.alphaBeta;
      case 'ExtendedContent':
        return RuleType.extendedContent;
      case 'Custom':
        return RuleType.custom;
      default:
        throw ArgumentError('Invalid RuleType: $value');
    }
  }
}
