abstract class IErrorService {
  Future<void> reportException(Object exception, StackTrace? stackTrace);
}
