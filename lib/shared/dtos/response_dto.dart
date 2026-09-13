class ResponseDto<T> {
  final bool success;
  final T response;
  const ResponseDto({required this.success, required this.response});
}