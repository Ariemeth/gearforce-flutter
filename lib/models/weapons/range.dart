class Range {
  const Range({
    required this.min,
    required this.short,
    required this.long,
    this.hasReach = false,
    this.increasableReach = false,
    this.isProximity = false,
  });
  final int min;
  final int? short;
  final int? long;
  final bool hasReach;
  final bool increasableReach;
  final bool isProximity;

  @override
  String toString() {
    // examples:
    // 12-36/72
    // 0+
    // 0
    // Radius 3

    if (isProximity) {
      return 'Radius $min';
    }

    var result = '$min';

    if (hasReach) {
      result = 'Reach $result';
    }

    if (increasableReach) {
      result = '$result+';
    }

    if (short != null) {
      result = '$result-$short';
    }

    if (long != null) {
      result = '$result/$long';
    }

    return result;
  }
}
