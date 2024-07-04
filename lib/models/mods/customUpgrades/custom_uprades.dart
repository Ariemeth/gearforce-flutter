import 'package:gearforce/models/mods/customUpgrades/custom_modifiation.dart';
import 'package:gearforce/widgets/settings.dart';

List<CustomModification> getCustomMods(Settings settings) {
  return [
    if (settings.allowCustomPoints) CustomModification.customPoints(),
  ];
}

CustomModification? buildCustomUpgrade(String id) {
  switch (id) {
    case customPoints:
      return CustomModification.customPoints();
    default:
      return null;
  }
}
