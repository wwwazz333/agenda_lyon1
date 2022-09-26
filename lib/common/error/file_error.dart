class InvalideFormatException implements Exception {
  String msg;
  InvalideFormatException(this.msg);
  @override
  String toString() {
    return msg;
  }
}
