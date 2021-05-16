class Role {
  const Role({required this.name, this.unlimited = false});

  final RoleType name;
  final bool unlimited;
  factory Role.fromJson(dynamic json) => Role(
        name: convertRoleType(json.toString().split("+").first),
        unlimited: json.toString().endsWith('+') ? true : false,
      );

  @override
  String toString() {
    return '${this.name.toString().split('.').last}${this.unlimited ? '+' : ''}';
  }
}

RoleType convertRoleType(String role) {
  //TODO: there must be an easier way instead of a string switch
  switch (role.toUpperCase()) {
    case "GP":
      return RoleType.GP;
    case "SK":
      return RoleType.SK;
    case "FS":
      return RoleType.FS;
    case "RC":
      return RoleType.RC;
    case "SO":
      return RoleType.SO;
    case "EG":
      return RoleType.EG;
    case "AS":
      return RoleType.AS;
    case "FT":
      return RoleType.FT;
  }

  throw new FormatException("Unknown role type", role);
}

class Roles {
  const Roles({required this.roles});

  final List<Role> roles;

  factory Roles.fromJson(dynamic json) {
    print(json);
    var r = Roles(
      // need to convert this to a list of roles, instead of a list of strings
      roles: List.from(json.toString().split(",")),
    );
    return r;
  }

  @override
  String toString() {
    return roles.toString();
  }
}

enum RoleType { GP, SK, FS, RC, SO, EG, AS, FT }
