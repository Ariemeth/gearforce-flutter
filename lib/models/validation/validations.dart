class Validation {
  final String? issue;
  final bool status;
  const Validation(this.status, {this.issue = null});

  @override
  String toString() {
    return issue ?? '';
  }

  bool isValid() {
    return status;
  }

  bool isNotValid() {
    return !status;
  }
}

class Validations {
  final List<Validation> _validations = [];
  List<Validation> get validations => _validations.toList();
  Validations({List<Validation> validations = const []}) {
    _validations.addAll(validations);
  }

  void add(Validation validation) {
    _validations.add(validation);
  }

  void addAll(List<Validation> validations) {
    _validations.addAll(validations);
  }

  @override
  String toString() {
    return _validations.toString();
  }

  bool isValid() {
    return _validations.isEmpty || _validations.every((v) => v.isValid());
  }

  bool isNotValid() {
    return _validations.any((v) => v.isNotValid());
  }
}
