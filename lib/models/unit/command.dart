enum CommandLevel {
  none(_none),
  bc(_bc),
  po(_po),
  secic(_2ic),
  cgl(_cgl),
  xo(_xo),
  co(_co),
  tfc(_tfc);

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
      case _bc:
        return CommandLevel.bc;
      case _po:
        return CommandLevel.po;
      default:
        return CommandLevel.none;
    }
  }

  static CommandLevel GreaterOne(CommandLevel first, CommandLevel second) {
    if (first > second) {
      return first;
    }
    return second;
  }
}

extension EnumOperators on CommandLevel {
  bool operator >(CommandLevel current) {
    return index > current.index;
  }

  bool operator >=(CommandLevel current) {
    return index >= current.index;
  }

  bool operator <(CommandLevel current) {
    return index < current.index;
  }

  bool operator <=(CommandLevel current) {
    return index <= current.index;
  }
}

const String _none = 'none';
const String _cgl = 'CGL'; // Command Group Leader
const String _2ic = '2iC'; // Second in Command
const String _xo = 'XO';
const String _co = 'CO';
const String _tfc = 'TFC';
const String _bc = 'BC'; // Northern Battle Chaplain
const String _po = 'PO'; // Southern Political Officer
