// TODO(REFACTOR): move all exceptions here

class QuakeError {
  final String message;

  const QuakeError(this.message);

  const QuakeError.unknown() : message = 'unknown error';
}
