enum CommandLevel {
  none,
  cgl,
  secic,
  xo,
  co,
  tfc,
}

const String _none = 'none';
const String _cgl = 'CGL';
const String _2ic = '2iC';
const String _xo = 'XO';
const String _co = 'CO';
const String _tfc = 'TFC';

String commandLevelString(CommandLevel cl) {
  switch (cl) {
    case CommandLevel.none:
      return _none;
    case CommandLevel.cgl:
      return _cgl;
    case CommandLevel.secic:
      return _2ic;
    case CommandLevel.xo:
      return _xo;
    case CommandLevel.co:
      return _co;
    case CommandLevel.tfc:
      return _tfc;
  }
}

CommandLevel convertToCommand(String cl) {
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
    default:
      return CommandLevel.none;
  }
}

int commandTVCost(CommandLevel cl) {
  switch (cl) {
    case CommandLevel.none:
      return 0;
    case CommandLevel.cgl:
      return 0;
    case CommandLevel.secic:
      return 1;
    case CommandLevel.xo:
      return 3;
    case CommandLevel.co:
      return 3;
    case CommandLevel.tfc:
      return 5;
  }
}
