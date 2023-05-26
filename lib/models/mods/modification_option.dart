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

  ModificationOption? optionByText(String text) {
    if (subOptions == null ||
        !subOptions!.any((option) => option.text == text)) {
      return null;
    }
    return subOptions?.firstWhere((option) => option.text == text,
        orElse: null);
  }

  bool validate() {
    final result = optionByText(text);
    if (result == null || false) {
      selectedOption = null;
      return false;
    }
    return true;
  }

  /*
Example json format for mods
{
	"duelist": [{
		"id": "duelist",
		"selected": null
	}, {
		"id": "duelist: independent",
		"selected": null
	}, {
		"id": "duelist: ace gunner",
		"selected": {
			"text": "LRP",
			"selected": {
				"text": null,
				"selected": null
			}
		}
	}]
}
*/

  Map<String, dynamic> toJson() {
    return {
      'text': this.text,
      'selected': this.selectedOption == null ? null : selectedOption!.toJson(),
    };
  }
}
