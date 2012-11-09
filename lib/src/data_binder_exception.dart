part of databinder_impl;

class DataBinderException implements Exception {
  final source;
  final message;

  const DataBinderException(this.message, [this.source]);

  String toString() => "DataBinderException: $message";
}