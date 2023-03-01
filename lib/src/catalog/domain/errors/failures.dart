abstract class CatalogFailure implements Exception {
  final String message;
  const CatalogFailure(this.message);
}

class InvalidInput extends CatalogFailure {
  const InvalidInput(super.message);
}

class ServiceNotFound extends CatalogFailure {
  const ServiceNotFound() : super('O serviço não foi encontrado.');
}

class MaterialNotFound extends CatalogFailure {
  const MaterialNotFound() : super('O material não foi encontrado.');
}

class UnknownError extends CatalogFailure {
  const UnknownError() : super('Ocorreu um erro desconhecido.');
}
