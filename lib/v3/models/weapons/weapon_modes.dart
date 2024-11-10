enum WeaponModes {
  direct('Direct', 'D'),
  indirect('Indirect', 'I'),
  melee('Melee', 'M');

  const WeaponModes(this.name, this.abbr);
  final String abbr;
  final String name;
}
