class FactionUpgrade {
  const FactionUpgrade({
    required this.name,
    this.options = null,
    this.description = '',
    this.isAutoEnabled = true,
    this.canBeToggled = false,
  });

  final String name;
  final List<FactionUpgrade>? options;
  final String description;
  final bool isAutoEnabled;
  final bool canBeToggled;
}
