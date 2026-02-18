class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class ConnectionException implements Exception {
  final String message;
  const ConnectionException(this.message);
}

class ParsingException implements Exception {
  final String message;
  const ParsingException(this.message);
}
