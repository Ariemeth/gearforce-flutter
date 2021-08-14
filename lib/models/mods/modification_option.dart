class ModificationOption {
  ModificationOption(this.text, {this.subOptions, this.description = ''});
  final String text;
  final List<ModificationOption>? subOptions;
  ModificationOption? selectedOption;
  final String description;

  bool hasOptions() {
    return subOptions != null && subOptions!.isNotEmpty;
  }

  bool selectionComplete() {
    if (subOptions == null) {
      return true;
    }

    if (selectedOption == null) {
      return false;
    }

    return selectedOption!.selectionComplete();
  }
}
