// TODO(REFACTOR): move all exceptions here

class QuakeError {
  const QuakeError(this.message);

  const QuakeError.unknown() : message = 'unknown error';

  final String message;
}
