enum CommandLevel {
  none(_none),
  cgl(_cgl),
  secic(_2ic),
  xo(_xo),
  co(_co),
  tfc(_tfc),
  bc(_3ic);

  final String name;
  const CommandLevel(this.name);
  static CommandLevel fromString(String? cl) {
    switch (cl) {
      case _cgl:
        return CommandLevel.cgl;
      case _2ic:
        return CommandLevel.secic;
      case _xo:
        return CommandLevel.xo;
      case _co:
        return CommandLevel.co;
      case _tfc:
        return CommandLevel.tfc;
      case _3ic:
        return CommandLevel.bc;
      default:
        return CommandLevel.none;
    }
  }
}

const String _none = 'none';
const String _cgl = 'CGL';
const String _2ic = '2iC';
const String _xo = 'XO';
const String _co = 'CO';
const String _tfc = 'TFC';
const String _3ic = 'BC';
