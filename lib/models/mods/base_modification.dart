import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:uuid/uuid.dart';

abstract class BaseModification {
  BaseModification({
    required this.name,
    String? id,
    this.options,
  }) {
    _id = id ?? Uuid().v4();
  }

  final String name;
  final List<String> _description = [];
  late final String _id;
  String get id => _id;
  ModificationOption? options;
  bool get hasOptions => this.options != null && this.options!.hasOptions();

  List<String> get description => this._description.toList();

  final Map<UnitAttribute, List<dynamic Function(dynamic)>> _mods = Map();

  void addMod(UnitAttribute att, dynamic Function(dynamic) mod,
      {String? description}) {
    if (this._mods[att] == null) {
      this._mods[att] = [];
    }
    this._mods[att]!.add(mod);
    if (description != null) {
      this._description.add(description);
    }
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
    final Map<String, dynamic> result = {
      'id': _id,
    };
    if (options != null) {
      result['selected'] = options!.selectedOption?.toJson();
    }

    return result;
  }

  dynamic applyMods(UnitAttribute att, dynamic startingValue) {
    var mods = this._mods[att];
    if (mods == null) {
      return startingValue;
    }
    dynamic result = startingValue;
    mods.forEach((element) {
      result = element(result);
    });

    return result;
  }
}

class ModInfo {
  const ModInfo({required this.id, this.selected});
  final String id;
  final ModSelectInfo? selected;

  factory ModInfo.fromJson(dynamic json) {
    //TODO flesh out the fromJson method
    String modId = '';
    if (json['id'] != null) {
      modId = json['id'];
    }

    var selectedModInfo = json['selected'] == null
        ? null
        : ModSelectInfo.fromJson(json['selected']);

    return ModInfo(id: modId, selected: selectedModInfo);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {
      'id': this.id,
    };
    if (selected != null) {
      result['selected'] = selected!.toJson();
    }

    return result;
  }
}
