part of databinder_impl;

class DataBinderException implements Exception {
  final exception;
  final message;
  const DataBinderException(this.message, [this.exception]);
}