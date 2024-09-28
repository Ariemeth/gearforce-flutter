class Movement {
  const Movement({required this.type, required this.rate});

  final String type;
  final int rate;
  factory Movement.fromJson(dynamic json) => Movement(
        type: json.toString().split(":").first,
        rate: int.parse(json.toString().split(":").last),
      );

  @override
  String toString() {
    return '${this.type}:${this.rate}';
  }
}
