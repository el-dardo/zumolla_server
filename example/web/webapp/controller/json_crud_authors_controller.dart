library json_crud_authors_controller;

import "dart:async" show Future;

import "package:stream/stream.dart" show HttpConnect;
import "package:zumolla_server/json.dart";
import "package:zumolla_server/json_crud_controller.dart";

import "../json/entities.dart";
import "../service/services.dart";

class JsonCrudAuthorsController extends JsonCrudController<Author> {

  final AuthorsService _service;

  JsonCrudAuthorsController( String baseUrl, this._service ) : super(baseUrl);
  
  Future<Author> parse( String contentType, String body ) 
    => new Future.value( new Author.fromJson(body) );
  
  Future create( HttpConnect connect, Author input ) 
    => _service.create(input);
  
  Future find( HttpConnect connect ) 
    => _service.findAll().then( (authors)
      => renderJsonObject( connect, authors ) );
  
  Future get( HttpConnect connect, String id )
    => _service.getById(id).then( (author) 
      => renderJsonObject( connect, author ) );
  
  Future update( HttpConnect connect, Author input ) 
    => _service.update( input );
  
  Future delete( HttpConnect connect, String id ) 
    => _service.delete(id);

}
