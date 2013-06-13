library services;

import "dart:async";

import "package:zumolla_server/json.dart";

import "../json/entities.dart";

part "articles_service.dart";
part "authors_service.dart";

abstract class Service<T extends JsonEntity> {
  Future<String> create( T obj );
  Future<T> getById( String id, {Set<String> fetch} );
  Future<List<T>> findAll( {Set<String> fetch} );
  Future update( T obj );
  Future delete( String id );
}