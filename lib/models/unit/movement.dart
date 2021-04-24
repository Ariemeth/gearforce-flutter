class Movement {
  Movement(this.type, this.rate);

  String type;
  int rate;
  factory Movement.fromJson(dynamic json) => Movement(
        json.toString().split(":").first,
        int.parse(json.toString().split(":").last),
      );

  @override
  String toString() {
    return '${this.type}:${this.rate}';
  }
}
