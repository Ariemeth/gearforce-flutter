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

  static List<CommandLevel> allLevelsBelow(CommandLevel? cl) {
    final List<CommandLevel> results = [];

    switch (cl) {
      case CommandLevel.co:
        results.add(CommandLevel.xo);
        results.add(CommandLevel.cgl);
        results.add(CommandLevel.secic);
        results.add(CommandLevel.none);
        break;
      case CommandLevel.xo:
        results.add(CommandLevel.cgl);
        results.add(CommandLevel.secic);
        results.add(CommandLevel.none);
        break;
      case CommandLevel.cgl:
        results.add(CommandLevel.secic);
        results.add(CommandLevel.none);
        break;
      default:
        results.add(CommandLevel.none);
    }

    return results;
  }

  static CommandLevel GreaterOne(CommandLevel first, CommandLevel second) {
    if (first > second) {
      return first;
    }
    return second;
  }

  static CommandLevel NextGreater(CommandLevel cl) {
    switch (cl) {
      case CommandLevel.none:
        return CommandLevel.cgl;
      case CommandLevel.bc:
        return CommandLevel.cgl;
      case CommandLevel.po:
        return CommandLevel.cgl;
      case CommandLevel.secic:
        return CommandLevel.cgl;
      case CommandLevel.cgl:
        return CommandLevel.xo;
      case CommandLevel.xo:
        return CommandLevel.co;
      default:
        return CommandLevel.tfc;
    }
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
