enum RuleType {
  Standard,
  Beta,
  ExtendedContent,
}

extension RuleTypeExtension on RuleType {
  String get name {
    return this.toString().split('.').last;
  }

  String get Summary {
    switch (this) {
      case RuleType.Standard:
        return 'Standard rules';
      case RuleType.Beta:
        return 'Beta rules';
      case RuleType.ExtendedContent:
        return 'Extended content rules';
    }
  }

  static RuleType ruleTypeFromString(String value) {
    switch (value) {
      case 'Standard':
        return RuleType.Standard;
      case 'Beta':
        return RuleType.Beta;
      case 'ExtendedContent':
        return RuleType.ExtendedContent;
      default:
        throw ArgumentError('Invalid RuleType: $value');
    }
  }
}
