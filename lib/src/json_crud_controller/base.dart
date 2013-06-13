part of zumolla_json_crud_controller;

/**
 * An implementation of [Controller] that uses JSON as input and output
 * of a CRUD REST interface. Depending on the URI and HTTP method used the
 * request is routed to one of the CRUD methods. 
 */
class JsonCrudController<T extends JsonEntity> extends AbstractController {

  final String baseUrl;
  
  final _getHttpMethod;
  final _renderMethodNotAllowed;
  final _getHttpHeaderContentType;
  final _getHttpBody;
  final _getJsonUriId;

  JsonCrudController( String _baseUrl ) : super("${_baseUrl}.*"),
    baseUrl = _baseUrl,
    _getHttpMethod = getHttpMethod,
    _renderMethodNotAllowed = renderMethodNotAllowed,
    _getHttpHeaderContentType = getHttpHeaderContentType,
    _getHttpBody = getHttpBody,
    _getJsonUriId = getJsonUriId
  ;

  JsonCrudController.test( String _baseUrl, this._getHttpMethod, 
      this._renderMethodNotAllowed, this._getHttpHeaderContentType, 
      this._getHttpBody, this._getJsonUriId ) : super("${_baseUrl}.*"),
      baseUrl = _baseUrl
  ;
  
  Future<T> parse( String contentType, String body ) => new Future.value();
  
  Future create( HttpConnect connect, T input ) => _renderMethodNotAllowed(connect);
  Future find( HttpConnect connect ) => _renderMethodNotAllowed(connect);
  Future get( HttpConnect connect, String id ) => _renderMethodNotAllowed(connect);
  Future update( HttpConnect connect, T input ) => _renderMethodNotAllowed(connect);
  Future delete( HttpConnect connect, String id ) => _renderMethodNotAllowed(connect);

  Future handle( HttpConnect connect ) {
    var id = _getJsonUriId(connect,baseUrl);
    var method = _getHttpMethod(connect);
    if( id=="" ) {
      switch( method ) {
        case "GET": return find(connect);  
        case "POST": return _parse(connect).then( (input) => create(connect,input) );  
        default: return _renderMethodNotAllowed(connect);
      }
    } else {
      switch( method ) {
        case "GET": return get(connect,id);  
        case "DELETE": return delete(connect,id); 
        case "PUT": return _parse(connect).then( (input) {
          input.id = id;
          return update(connect,input);
        } );  
        default: return _renderMethodNotAllowed(connect);
      }
    }
  }
  
  Future<T> _parse( HttpConnect connect ) {
    var contentType = _getHttpHeaderContentType(connect);
    return _getHttpBody(connect).then( (body) {
      return parse(contentType,body);
    });
  }
}