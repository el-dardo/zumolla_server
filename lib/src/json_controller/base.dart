part of zumolla_json_controller;

/**
 * A minimum implementation of [Controller] that uses JSON as input and output
 * data and routes the request to a  different method depending on the HTTP 
 * method used.
 */
abstract class JsonController<T extends JsonEntity> extends AbstractController { 

  final _getHttpMethod;
  final _renderMethodNotAllowed;
  final _getHttpHeaderContentType;
  final _getHttpBody;
  
  JsonController( String mapping ) : super(mapping),
      _getHttpMethod = getHttpMethod,
      _renderMethodNotAllowed = renderMethodNotAllowed,
      _getHttpHeaderContentType = getHttpHeaderContentType,
      _getHttpBody = getHttpBody
  ;

  JsonController.test( String mapping, this._getHttpMethod, 
      this._renderMethodNotAllowed, this._getHttpHeaderContentType, 
      this._getHttpBody ) : super(mapping);

  Future<T> parse( String contentType, String body ) => new Future.value();
  
  Future put( HttpConnect connect, T input ) => _renderMethodNotAllowed(connect);
  Future post( HttpConnect connect, T input ) => _renderMethodNotAllowed(connect);
  Future delete( HttpConnect connect ) => _renderMethodNotAllowed(connect);
  Future get( HttpConnect connect ) => _renderMethodNotAllowed(connect);
  Future head( HttpConnect connect ) => _renderMethodNotAllowed(connect);
  Future options( HttpConnect connect ) => _renderMethodNotAllowed(connect);
  
  Future handle( HttpConnect connect ) {
    var method = _getHttpMethod(connect);
    switch( method ) {
      case "GET": return get(connect);  
      case "DELETE": return delete(connect); 
      case "HEAD": return head(connect); 
      case "OPTIONS": return options(connect); 
      case "POST":   
      case "PUT":
        var contentType = _getHttpHeaderContentType(connect);
        return _getHttpBody(connect).then( (body) {
          return parse(contentType,body);
        }).then( (t) {
          return (method=="POST") ? post(connect,t) : put(connect,t);
        });
      default: return _renderMethodNotAllowed(connect);
    }
  }
  
}
