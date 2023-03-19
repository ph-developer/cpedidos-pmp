abstract class IErrorHandler {
  Future<void> reportException(Object exception, StackTrace? stackTrace);
}
