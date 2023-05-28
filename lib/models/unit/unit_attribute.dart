import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/movement.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/weapons/weapon.dart';

enum UnitAttribute {
  name(String),
  tv(int),
  roles(Roles),
  movement(Movement),
  armor(int),
  hull(int),
  structure(int),
  actions(int),
  gunnery(int),
  piloting(int),
  ew(int),
  react_weapons(List<Weapon>),
  mounted_weapons(List<Weapon>),
  traits(List<Trait>),
  sp(int),
  type(ModelType),
  height(String),
  special(List<String>);

  final Type expected_type;
  const UnitAttribute(this.expected_type);
}
