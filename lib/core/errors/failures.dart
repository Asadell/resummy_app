abstract class Failure {
  final String message;
  const Failure(this.message);
}

// Error yang terjadi saat hit ke Gemini atau API Server
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Error yang terjadi jika internet mati
class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

// Error spesifik untuk parsing teks PDF atau JSON yang korup
class ParsingFailure extends Failure {
  const ParsingFailure(super.message);
}
