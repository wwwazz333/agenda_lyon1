class ParmettreError implements Exception {
  final String error;
  final int code = 56;
  ParmettreError(this.error);

  @override
  String toString() {
    return "$code : $error";
  }
}
