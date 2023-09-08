import 'package:flutter/widgets.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/mods/duelist/duelist_upgrades.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/standardUpgrades/standard_modification.dart';
import 'package:gearforce/models/mods/standardUpgrades/standard_upgrades.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_modification.dart';
import 'package:gearforce/models/mods/unitUpgrades/unit_upgrades.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_upgrades.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/movement.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:gearforce/models/validation/validations.dart';
import 'package:gearforce/models/weapons/weapon.dart';

class Unit extends ChangeNotifier {
  final UnitCore core;
  Group? group;
  CombatGroup? get combatGroup => group?.combatGroup;
  UnitRoster? get roster => group?.combatGroup?.roster;
  RuleSet? get ruleset => group?.combatGroup?.roster?.rulesetNotifer.value;

  final List<BaseModification> _mods = [];

  final List<String> _tags = [];

  CommandLevel _commandLevel = CommandLevel.none;

  FactionType? factionOverride = null;

  List<String> _special = [];
  Unit({
    required this.core,
  });

  factory Unit.from(Unit original) {
    final newUnit = Unit(core: original.core);
    newUnit._commandLevel = original._commandLevel;
    original._mods.forEach((m) => newUnit.addUnitMod(m));
    newUnit._special = original.special;
    original._tags.forEach((t) => newUnit.addTag(t));
    newUnit.factionOverride = original.factionOverride;

    return newUnit;
  }

  factory Unit.fromJson(
    dynamic json,
    Faction faction,
    RuleSet ruleset,
    CombatGroup? cg,
    UnitRoster roster,
  ) {
    final List<Unit> core = [];
    ruleset.availableUnitFilters(cg?.options).forEach((sfilter) {
      core.addAll(ruleset.availableUnits(specialUnitFilter: sfilter));
    });
    final variant = json['variant'] as String;
    Unit u = Unit.from(core.firstWhere((unit) => unit.core.name == variant));

    u._commandLevel = CommandLevel.fromString(json['command']);

    final factionOver = json['factionOverride'];
    if (factionOver != null) {
      try {
        u.factionOverride = FactionType.fromName(factionOver);
      } catch (e) {
        print('Unable to parse faction override [$factionOver], $e');
      }
    }

    Map<BaseModification, Map<String, dynamic>> modsWithOptions = {};

    final modMap = json['mods'] as Map;
    if (modMap['unit'] != null) {
      final mods = modMap['unit'] as List;
      var availableUnitMods = getUnitMods(u.core.frame, u);
      mods.forEach((loadedMod) {
        try {
          var mod = availableUnitMods
              .firstWhere((unitMod) => unitMod.name == loadedMod['id']);
          u.addUnitMod(mod);
          final selected = loadedMod['selected'];
          if (selected != null) {
            modsWithOptions[mod] = selected;
          }
        } catch (e) {
          print('unit mod $loadedMod not found in available mods, $e');
        }
      });
    }
    if (modMap['standard'] != null && cg != null) {
      final mods = modMap['standard'] as List;

      mods.forEach((loadedMod) {
        try {
          final modId = loadedMod['id'];
          var mod = buildStandardUpgrade(modId, u, cg, roster);
          if (mod != null) {
            u.addUnitMod(mod);
            final selected = loadedMod['selected'];
            if (selected != null) {
              modsWithOptions[mod] = selected;
            }
          } else {
            print('Standard mod $modId not found');
          }
        } catch (e) {
          print('standard mod $loadedMod not found in available mods, $e');
        }
      });
    }
    if (modMap['vet'] != null && cg != null) {
      final mods = modMap['vet'] as List;

      mods.forEach((loadedMod) {
        try {
          final modId = loadedMod['id'];
          var mod = buildVetUpgrade(modId, u, cg);
          if (mod != null) {
            u.addUnitMod(mod);
            final selected = loadedMod['selected'];
            if (selected != null) {
              modsWithOptions[mod] = selected;
            }
          } else {
            print('Vet mod $modId not found');
          }
        } catch (e) {
          print('vet mod $loadedMod not found in available mods, $e');
        }
      });
    }
    if (modMap['duelist'] != null && cg != null) {
      final mods = modMap['duelist'] as List;

      mods.forEach((loadedMod) {
        try {
          final modId = loadedMod['id'];
          var mod = buildDuelistUpgrade(modId, u, cg, roster);
          if (mod != null) {
            u.addUnitMod(mod);
            final selected = loadedMod['selected'];
            if (selected != null) {
              modsWithOptions[mod] = selected;
            }
          } else {
            print('Duelist mod $modId not found');
          }
        } catch (e) {
          print('duelist mod $loadedMod not found in available mods, $e');
        }
      });
    }

    if (modMap['faction'] != null && cg != null) {
      final mods = modMap['faction'] as List;

      mods.forEach((loadedMod) {
        final modId = loadedMod['id'];

        var mod = factionModFromId(modId, roster, u);
        if (mod == null) {
          print('faction mod $modId could not be loaded');
          return;
        }
        u.addUnitMod(mod);
        final selected = loadedMod['selected'];
        if (selected != null) {
          modsWithOptions[mod] = selected;
        }
      });
    }

    var loadAttempts = 0;
    while (modsWithOptions.isNotEmpty && loadAttempts < 5) {
      modsWithOptions = _loadOptionsFromJSON(modsWithOptions,
          refreshOptions: loadAttempts != 0);
      loadAttempts++;
    }

    final tags = json['tags'] as List;
    tags.forEach((tag) =>
        u._tags.any((t) => t.toString() == tag) ? () {} : u._tags.add(tag));

    return u;
  }

  int? get actions {
    var value = this.core.actions;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.actions, value);
    }
    return value;
  }

  int? get armor {
    var value = this.core.armor;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.armor, value);
    }
    return value;
  }

  CommandLevel get commandLevel => _commandLevel;

  set commandLevel(CommandLevel cl) {
    if (_commandLevel == cl) {
      return;
    }
    // Note: Setting the command level on other units directly using prviate
    // fields to prevent the notifier from running.
    switch (cl) {
      case CommandLevel.none:
        break;
      case CommandLevel.bc:
        break;
      case CommandLevel.po:
        break;
      case CommandLevel.cgl:
        // Only 1 cgl, tfc, co, or xo can exist within a single Combat Group
        combatGroup?.getUnitWithCommand(CommandLevel.cgl)?._commandLevel =
            CommandLevel.none;
        combatGroup?.getUnitWithCommand(CommandLevel.tfc)?._commandLevel =
            CommandLevel.none;
        combatGroup?.getUnitWithCommand(CommandLevel.co)?._commandLevel =
            CommandLevel.none;
        combatGroup?.getUnitWithCommand(CommandLevel.xo)?._commandLevel =
            CommandLevel.none;
        break;
      case CommandLevel.secic:
        // only 1 second in command per combat group
        combatGroup?.getUnitWithCommand(CommandLevel.secic)?._commandLevel =
            CommandLevel.none;
        break;
      case CommandLevel.xo:
      case CommandLevel.co:
      case CommandLevel.tfc:
        // only 1 xo, co, tfc per task force
        combatGroup?.roster?.getFirstUnitWithCommand(cl)?._commandLevel =
            CommandLevel.cgl;
        // only 1 of xo, co, tfc, or cgl per combat group
        combatGroup?.getUnitWithCommand(CommandLevel.cgl)?._commandLevel =
            CommandLevel.none;
        combatGroup?.getUnitWithCommand(CommandLevel.tfc)?._commandLevel =
            CommandLevel.none;
        combatGroup?.getUnitWithCommand(CommandLevel.co)?._commandLevel =
            CommandLevel.none;
        combatGroup?.getUnitWithCommand(CommandLevel.xo)?._commandLevel =
            CommandLevel.none;
        break;
    }

    _commandLevel = cl;

    notifyListeners();
  }

  int? get ew {
    var value = this.core.ew;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.ew, value);
    }
    return value;
  }

  int? get gunnery {
    var value = this.core.gunnery;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.gunnery, value);
    }
    return value;
  }

  String get height {
    return this.core.height;
  }

  int? get hull {
    var value = this.core.hull;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.hull, value);
    }
    return value;
  }

  bool get isDuelist {
    return this.traits.any((t) => t.name == 'Duelist');
  }

  bool get isVeteran {
    return this.traits.any((t) => t.name == 'Vet');
  }

  List<String> get modNames => _mods.map((m) => m.name).toList();

  List<String> get modNamesWithCost => _mods
      .map((m) => '${m.name}(${m.applyMods(UnitAttribute.tv, 0)})')
      .toList();

  List<Weapon> get reactWeapons {
    return weapons.where((weapon) => weapon.hasReact).toList();
  }

  List<Weapon> get mountedWeapons {
    return weapons.where((weapon) => !weapon.hasReact).toList();
  }

  List<Weapon> get weapons {
    var newList =
        this.core.weapons.map((weapon) => Weapon.fromWeapon(weapon)).toList();

    for (var mod in this._mods) {
      newList = mod.applyMods(UnitAttribute.weapons, newList);
    }

    ruleset?.unitWeaponsModifier(newList);

    return newList;
  }

  Movement? get movement {
    var value = this.core.movement;

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.movement, value);
    }

    return value;
  }

  String get name {
    var value = this.core.name;

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.name, value);
    }

    return value;
  }

  int? get piloting {
    var value = this.core.piloting;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.piloting, value);
    }
    return value;
  }

  Roles? get role {
    var value = this.core.role;

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.roles, value);
    }

    return value;
  }

  List<String> get special {
    var value = this._special.toList();
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.special, value);
    }
    return value;
  }

  int? get structure {
    var value = this.core.structure;
    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.structure, value);
    }
    return value;
  }

  /// Retrieve the tags associated with this [Unit].
  List<String> get tags => _tags.toList();

  List<Trait> get traits {
    var newList =
        this.core.traits.map((trait) => Trait.fromTrait(trait)).toList();

    for (var mod in this._mods) {
      newList = mod.applyMods(UnitAttribute.traits, newList);
    }

    ruleset?.unitTraitsModifier(newList, this);

    return newList;
  }

  int get tv {
    var value = this.core.tv;
    value += ruleset?.commandTVCost(_commandLevel) ?? 0;

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.tv, value);
    }

    return value;
  }

  ModelType get type {
    var value = this.core.type;

    for (var mod in this._mods) {
      value = mod.applyMods(UnitAttribute.type, value);
    }

    return value;
  }

  FactionType get faction {
    var value = this.core.faction;

    return factionOverride ?? value;
  }

  int get commandPoints {
    var cp = 0;

    for (var mod in this._mods) {
      cp = mod.applyMods(UnitAttribute.cp, cp);
    }

    if (commandLevel != CommandLevel.none) {
      // all commanders get 1 base cp
      cp = cp + 1;
      cp = cp + _calculateSkillPoints();
    }

    return cp;
  }

  int get skillPoints {
    if (commandLevel != CommandLevel.none) {
      return 0;
    }

    return _calculateSkillPoints();
  }

  int _calculateSkillPoints() {
    var sp = core.attribute(UnitAttribute.sp);

    for (var mod in this._mods) {
      sp = mod.applyMods(UnitAttribute.sp, sp);
    }

    if (isVeteran) {
      sp += 1;
    }

    return sp;
  }

  addTag(String tag) {
    if (!_tags.any((s) => s == tag)) {
      _tags.add(tag);
    }
  }

  void addUnitMod(BaseModification mod) {
    // Duplicate mods are not allowed on the same unit
    if (_mods.any((m) => m.id == mod.id)) {
      return;
    }
    _mods.add(mod);
    if (mod.onAdd != null) {
      mod.onAdd!(this);
    }

    final ruleOverrides = ruleset
        ?.allEnabledRules(combatGroup?.options)
        .where((rule) => rule.onModAdded != null);
    ruleOverrides?.forEach((rule) {
      rule.onModAdded!(this, mod.id);
    });

    _mods.forEach((m) {
      final updatedMod = m.refreshData();
      updatedMod.options?.validate();
      if (updatedMod != m) {
        _mods[_mods.indexWhere((element) => element.id == updatedMod.id)];
      }
    });
    notifyListeners();
  }

  T attribute<T>(
    UnitAttribute att, {
    String? modIDToSkip,
  }) {
    assert(T == att.expected_type, 'Expected [${att.expected_type}], got [$T]');

    var value = this.core.attribute(att) as T;

    for (var mod in this
        ._mods
        .where((m) => modIDToSkip == null ? true : m.id != modIDToSkip)) {
      value = mod.applyMods(att, value);
    }

    return value;
  }

  void clearUnitMods() {
    _mods.clear();
    notifyListeners();
  }

  void forceNotify() {
    notifyListeners();
  }

  BaseModification? getMod(String id) {
    if (!this.hasMod(id)) {
      return null;
    }
    return this._mods.firstWhere((mod) => mod.id == id);
  }

  List<BaseModification> getMods() {
    return _mods.toList();
  }

  bool hasMod(String id) => _mods.any((mod) => mod.name == id || mod.id == id);

  bool hasTag(String tag) => _tags.any((t) => t == tag);

  int numTags() => _tags.length;

  int numUnitMods() => _mods.length;

  removeTag(String tag) {
    _tags.remove(tag);
  }

  void removeUnitMod(String id) {
    final mod = getMod(id);
    if (mod == null) {
      return;
    }
    _mods.remove(mod);
    if (mod.onRemove != null) {
      mod.onRemove!(this);
    }

    final ruleOverrides = ruleset
        ?.allEnabledRules(combatGroup?.options)
        .where((rule) => rule.onModRemoved != null);
    ruleOverrides?.forEach((rule) {
      rule.onModRemoved!(this, mod.id);
    });

    notifyListeners();
  }

  Validations validate({bool tryFix = false}) {
    Validations validationErrors = Validations();
    final g = this.group;
    if (g == null) {
      validationErrors.add(Validation(
        false,
        issue: "Unit does not have a group",
      ));
    }
    final cg = group?.combatGroup;
    if (cg == null) {
      validationErrors.add(Validation(
        false,
        issue: "Unit does not have a combat group",
      ));
    }
    final roster = cg?.roster;
    if (roster == null) {
      validationErrors.add(Validation(
        false,
        issue: "Unit does not have a roster",
      ));
    }

    if (validationErrors.isInValid()) {
      print('Validation errors found validating $name, $validationErrors');
      return validationErrors;
    }

    if (tryFix) {
      final modsToRemove = _mods.where((mod) {
        return !mod.requirementCheck(
          roster!.rulesetNotifer.value,
          roster,
          cg,
          this,
        );
      }).toList();

      modsToRemove.forEach((mod) {
        removeUnitMod(mod.id);
      });

      _mods.forEach((m) {
        final updatedMod = m.refreshData();
        updatedMod.options?.validate();
        if (updatedMod != m) {
          print('replacing mod ${m.id}\n');
          _mods[_mods.indexWhere((mod) => mod.id == updatedMod.id)];
        }
      });
    } else {
      _mods.forEach((mod) {
        if (!mod.requirementCheck(
          roster!.rulesetNotifer.value,
          roster,
          cg,
          this,
        )) {
          validationErrors.add(Validation(
            false,
            issue:
                'mod ${mod.id} does not met its requirement check during validation',
          ));
        }
      });
    }

    return validationErrors;
  }

  Map<String, dynamic> toJson() {
    Map<String, List<dynamic>> mods = {};
    _mods.forEach((mod) {
      if (mod is UnitModification) {
        if (mods['unit'] == null) {
          mods['unit'] = [];
        }
        mods['unit']!.add(mod.toJson());
      } else if (mod is StandardModification) {
        if (mods['standard'] == null) {
          mods['standard'] = [];
        }
        mods['standard']!.add(mod.toJson());
      } else if (mod is VeteranModification) {
        if (mods['vet'] == null) {
          mods['vet'] = [];
        }
        mods['vet']!.add(mod.toJson());
      } else if (mod is DuelistModification) {
        if (mods['duelist'] == null) {
          mods['duelist'] = [];
        }
        mods['duelist']!.add(mod.toJson());
      } else if (mod is FactionModification) {
        if (mods['faction'] == null) {
          mods['faction'] = [];
        }
        mods['faction']!.add(mod.toJson());
      }
    });

    return {
      'frame': core.frame,
      'variant': core.name,
      'mods': mods,
      'command': _commandLevel.name,
      'tags': this._tags,
      'factionOverride': factionOverride?.toString()
    };
  }

  @override
  String toString() {
    return 'Unit: $name, TV: $tv, Rank: ${commandLevel.name}, Mods: $modNames';
  }
}

Map<BaseModification, Map<String, dynamic>> _loadOptionsFromJSON(
    Map<BaseModification, Map<String, dynamic>> modsWithOptionsToLoad,
    {bool refreshOptions = false}) {
  /*
      {
        "text": "LAC",
        "selected": null
      }
      ////////////////////
      {
        "text": "LSG",
        "selected": {
          "text": "LCW",
          "selected": null
        }
      }
      */
  final Map<BaseModification, Map<String, dynamic>> failedToLoadOptions = {};
  modsWithOptionsToLoad.forEach((modWithOptions, modOptions) {
    final selectedOptionText = modOptions['text'];
    final seletedOptionSelection = modOptions['selected'];

    if (refreshOptions) {
      modWithOptions = modWithOptions.refreshData();
    }

    if (selectedOptionText != null) {
      final selectedOption =
          modWithOptions.options!.optionByText(selectedOptionText);
      if (selectedOption != null) {
        modWithOptions.options!.selectedOption = selectedOption;
        if (seletedOptionSelection != null) {
          final subOptionText = seletedOptionSelection['text'];
          if (subOptionText != null) {
            final selectedSubOption =
                selectedOption.optionByText(subOptionText);
            if (selectedSubOption != null) {
              selectedOption.selectedOption = selectedSubOption;
            } else {
              failedToLoadOptions[modWithOptions] = modOptions;
              print('was unable to find a sub option that matches the ' +
                  'selected text value of $subOptionText for mod ' +
                  '${modWithOptions.id}');
            }
          }
        }
      } else {
        failedToLoadOptions[modWithOptions] = modOptions;
        print('was unable to find an option that matches the selected text' +
            ' value of $selectedOptionText for mod ${modWithOptions.id}');
      }
    }
  });

  return failedToLoadOptions;
}
