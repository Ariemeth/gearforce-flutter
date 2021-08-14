class ModificationOption {
  ModificationOption(this.text, {this.subOptions});
  final String text;
  final List<ModificationOption>? subOptions;
  ModificationOption? selectedOption;

  bool hasOptions() {
    return subOptions != null && subOptions!.isNotEmpty;
  }
}
