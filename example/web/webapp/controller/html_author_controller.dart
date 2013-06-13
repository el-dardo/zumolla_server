library html_author_controller;

import "dart:async" show Future;

import "package:stream/stream.dart" show HttpConnect;
import "package:zumolla_server/servlet_controller.dart";

import "../view/views.dart";
import "../service/services.dart";

class HtmlAuthorController extends ServletController {

  final AuthorsService _service;
  
  HtmlAuthorController( String mapping, this._service ) : super(mapping);
  
  Future get( HttpConnect connect ) 
    => _service.getById("A").then( (author) 
        => author_view(connect, author: author ) );
  
}
