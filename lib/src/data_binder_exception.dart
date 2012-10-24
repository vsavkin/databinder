part of databinder;

class DataBinderException implements Exception {
  final message;
  final exception;
  const DataBinderException(this.message, [this.exception]);
}