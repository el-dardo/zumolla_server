part of zumolla_service;

// TODO: usar mixins en vez de herencia

/**
 * Un servicio transforma de entidad de negocio en entidad rest
 */
abstract class Service<T extends RestEntity,ID> {
  Future<T> get( ID id ) => new Future.error(new UnsupportedError("GET"));
  Future<ID> create(T data) => new Future.error(new UnsupportedError("CREATE"));
  Future update(ID id,T data) => new Future.error(new UnsupportedError("UPDATE"));
  Future delete(ID id) => new Future.error(new UnsupportedError("DELETE"));
}