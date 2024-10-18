import 'package:gearforce/v3/models/mods/base_modification.dart';
import 'package:gearforce/v3/models/mods/modification_option.dart';
import 'package:gearforce/v3/models/rules/rule_types.dart';
import 'package:gearforce/v3/models/unit/unit_attribute.dart';

const _customIDBase = 'mod::custom';

const customPoints = '$_customIDBase::10';

class CustomModification extends BaseModification {
  CustomModification({
    required String name,
    required String id,
    required RequirementCheck requirementCheck,
    ModificationOption? options,
    final BaseModification Function()? refreshData,
    super.ruleType = RuleType.Custom,
  }) : super(
          name: name,
          id: id,
          requirementCheck: requirementCheck,
          options: options,
          refreshData: refreshData,
          modType: ModificationType.custom,
        );
  factory CustomModification.customPoints() {
    const minValue = -5;
    const maxValue = 5;

    final modOptions = ModificationOption(
      'Select a custom TV modifier for this unit.',
      subOptions: List.generate(
        maxValue - minValue + 1,
        (index) => ModificationOption((index + minValue).toString()),
      ),
    );

    final mod = CustomModification(
      name: 'Custom TV mod',
      id: customPoints,
      options: modOptions,
      requirementCheck: (rs, r, cg, u) => rs.settings.allowCustomPoints,
    );

    mod.addMod<int>(
      UnitAttribute.tv,
      (value) {
        final optionStr = mod.options?.selectedOption?.text;
        var newValue = 0;
        if (optionStr != null) {
          newValue = int.tryParse(optionStr) ?? 0;
        }

        return value + newValue;
      },
      dynamicDescription: () {
        return 'TV: ${mod.options?.selectedOption?.text ?? '-'}';
      },
    );
    return mod;
  }
}
