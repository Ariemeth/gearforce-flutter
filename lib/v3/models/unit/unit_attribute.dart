import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:gearforce/v3/models/unit/movement.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/v3/models/weapons/weapon.dart';

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
  weapons(List<Weapon>),
  traits(List<Trait>),
  cp(int),
  sp(int),
  type(ModelType),
  height(String),
  special(List<String>);

  final Type expectedType;
  const UnitAttribute(this.expectedType);
}
