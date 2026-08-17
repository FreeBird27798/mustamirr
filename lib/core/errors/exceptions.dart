/// Exceptions thrown by the data layer (data sources). The repository
/// catches them and converts them to Failures via `mapErrorToFailure`.

/// A general server/business error that already carries a user-facing
/// message (e.g. a mock data source, or a manually-thrown error).
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);

  @override
  String toString() => message;
}
