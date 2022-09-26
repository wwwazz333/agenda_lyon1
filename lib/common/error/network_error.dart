class DownloadError implements Exception {
  final String error;
  final int code;
  DownloadError(this.error, this.code);

  @override
  String toString() {
    return "$code : $error";
  }
}

class NetworkError implements Exception {
  final String error;
  NetworkError(this.error);

  @override
  String toString() {
    return error;
  }
}
