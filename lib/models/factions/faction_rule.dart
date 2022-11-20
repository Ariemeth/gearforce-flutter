class FactionRule {
  const FactionRule({
    required this.name,
    this.options = null,
    this.description = '',
    this.isAutoEnabled = true,
    this.canBeToggled = false,
  });

  final String name;
  final List<FactionRule>? options;
  final String description;
  final bool isAutoEnabled;
  final bool canBeToggled;

  factory FactionRule.from(
    FactionRule original, {
    List<FactionRule>? options,
    bool? isAutoEnabled,
    bool? canBeToggled,
  }) {
    return FactionRule(
      name: original.name,
      options: options != null ? options : original.options,
      isAutoEnabled:
          isAutoEnabled != null ? isAutoEnabled : original.isAutoEnabled,
      canBeToggled: canBeToggled != null ? canBeToggled : original.canBeToggled,
      description: original.description,
    );
  }
}
