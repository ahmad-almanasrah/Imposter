/// High-level failure models passed to presentation / UI layers
abstract class AppFailure {
  final String message;
  final int? code;

  const AppFailure({required this.message, this.code});

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

class ServerFailure extends AppFailure {
  const ServerFailure({required super.message, super.code});
}

class NetworkFailure extends AppFailure {
  const NetworkFailure({required super.message, super.code});
}

class CacheFailure extends AppFailure {
  const CacheFailure({required super.message, super.code});
}

class UnknownFailure extends AppFailure {
  const UnknownFailure({required super.message, super.code});
}
