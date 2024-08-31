enum weaponModes {
  Direct('Direct', 'D'),
  Indirect('Indirect', 'I'),
  Melee('Melee', 'M');

  const weaponModes(this.name, this.abbr);
  final String abbr;
  final String name;
}
