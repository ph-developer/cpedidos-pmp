abstract class AdminFailure implements Exception {
  final String message;
  const AdminFailure(this.message);
}

class InvalidInput extends AdminFailure {
  const InvalidInput(super.message);
}
