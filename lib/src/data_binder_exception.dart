part of databinder_impl;

class DataBinderException implements Exception {
  final message;
  final exception;
  const DataBinderException(this.message, [this.exception]);
}