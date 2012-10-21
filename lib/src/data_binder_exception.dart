part of databinder;

class DataBinderException implements Exception {
  final message;
  const DataBinderException(this.message);
}