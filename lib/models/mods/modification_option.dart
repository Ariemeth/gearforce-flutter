class ModificationOption {
  ModificationOption(this.text, {this.options});
  final String text;
  final List<ModificationOption>? options;
  ModificationOption? selectedOption;

  @override
  String toString() {
    return text;
  }
}
