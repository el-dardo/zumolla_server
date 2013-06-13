library json_articles_controller;

import "dart:async" show Future;

import "package:stream/stream.dart" show HttpConnect;
import "package:zumolla_server/json.dart";
import "package:zumolla_server/json_controller.dart";

import "../json/entities.dart";
import "../service/services.dart";

class JsonArticlesController extends JsonController<Article> {
  
  final ArticlesService _service;
  
  JsonArticlesController( String mapping, this._service ) : super(mapping);

  Future<Article> parse( String contentType, String body ) 
    => new Future.value( new Article.fromJson(body) );

  Future get( HttpConnect connect ) 
    => _service.findAll().then( (articles)
        => renderJsonObject( connect, articles ) );
  
  Future post( HttpConnect connect, Article input ) 
    => _service.create(input);
  
}
