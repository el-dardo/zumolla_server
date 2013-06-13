part of zumolla_servlet_controller;

/**
 * A minimum implementation of [Controller] that routes the request to a 
 * different method depending on the HTTP method used.
 */
abstract class ServletController extends AbstractController { 
  
  final _getHttpMethod;
  final _renderMethodNotAllowed;
  
  ServletController( String mapping ) : super(mapping), 
    _getHttpMethod = getHttpMethod,
    _renderMethodNotAllowed = renderMethodNotAllowed
  ;
  
  ServletController.test( String mapping, this._getHttpMethod, 
      this._renderMethodNotAllowed ) : super(mapping);
  
  Future put( HttpConnect connect ) => renderMethodNotAllowed(connect);
  Future post( HttpConnect connect ) => renderMethodNotAllowed(connect);
  Future delete( HttpConnect connect ) => renderMethodNotAllowed(connect);
  Future get( HttpConnect connect ) => renderMethodNotAllowed(connect);
  Future head( HttpConnect connect ) => renderMethodNotAllowed(connect);
  Future options( HttpConnect connect ) => renderMethodNotAllowed(connect);
  
  Future handle( HttpConnect connect ) {
    var method = _getHttpMethod(connect);
    switch( method ) {
      case "GET": return get(connect);  
      case "POST": return post(connect);  
      case "PUT": return put(connect); 
      case "DELETE": return delete(connect); 
      case "HEAD": return head(connect); 
      case "OPTIONS": return options(connect); 
      default: return _renderMethodNotAllowed(connect);
    }
  }
  
}
