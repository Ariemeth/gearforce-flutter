import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

typedef RequirementCheck = bool Function(
    RuleSet?, UnitRoster?, CombatGroup?, Unit);

abstract class BaseModification {
  BaseModification({
    required this.name,
    required this.requirementCheck,
    required String this.id,
    required this.modType,
    this.options,
    BaseModification Function()? refreshData,
    this.onAdd,
    this.onRemove,
  }) {
    _refreshData = refreshData;
  }

  final String name;
  final ModificationType modType;
  final List<String> _descriptions = [];
  final List<String Function()> _dynamicDescriptions = [];
  late final BaseModification Function()? _refreshData;
  BaseModification refreshData() =>
      _refreshData == null ? this : _refreshData!();
  // function to ensure the modification can be applied to the unit
  final RequirementCheck requirementCheck;

  final Function(Unit? u)? onAdd;
  final Function(Unit? u)? onRemove;

  final String id;

  ModificationOption? options;
  bool get hasOptions => this.options != null && this.options!.hasOptions();

  List<String> get description {
    List<String> results = _descriptions.toList();

    _dynamicDescriptions.forEach((element) {
      results.add(element());
    });

    return results;
  }

  final _mods = Map();

  void addMod<T>(UnitAttribute att, T Function(T) mod,
      {String? description, String Function()? dynamicDescription}) {
    if (this._mods[att] == null) {
      this._mods[att] = [];
    }

    assert(att.expected_type == T,
        'Mod ${name} type: [$T] does not match expected attribute type: [${att.expected_type}]');

    this._mods[att]!.add(mod);
    if (description != null) {
      this._descriptions.add(description);
    }
    if (dynamicDescription != null) {
      this._dynamicDescriptions.add(dynamicDescription);
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
      'id': id,
    };
    if (options != null) {
      result['selected'] = options!.selectedOption?.toJson();
    }

    return result;
  }

  T applyMods<T>(UnitAttribute att, T startingValue) {
    var mods = this._mods[att];
    if (mods == null) {
      return startingValue;
    }
    T result = startingValue;
    mods.forEach((element) {
      result = element(result);
    });

    return result;
  }
}

enum ModificationType {
  duelist,
  faction,
  standard,
  unit,
  veteran,
}
