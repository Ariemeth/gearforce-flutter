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
    return subOptions?.firstWhere((option) => option.text == text);
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

class ModSelectInfo {
  const ModSelectInfo({required this.text, this.selected});
  final String text;
  final ModSelectInfo? selected;

  factory ModSelectInfo.fromJson(dynamic json) {
    //TODO flesh out the fromJson method
    String modText = '';
    if (json['text'] != null) {
      modText = json['text'];
    }

    var selectedModInfo = json['selected'] == null
        ? null
        : ModSelectInfo.fromJson(json['selected']);

    return ModSelectInfo(text: modText, selected: selectedModInfo);
  }

  Map<String, dynamic> toJson() {
    return {
      'text': this.text,
      'selected': this.selected == null ? null : this.selected!.toJson(),
    };
  }
}
