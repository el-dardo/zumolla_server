part of zumolla_server;

/** The global zumolla server object */
var _server;

/**
 * Implementation of interface [Server] using Rikulo Stream server.
 */
class _Server implements Server {
  
  StreamServer _server;
  ControllersMap _controllers;
  
  _Server(this._server) {
    _controllers = new _ServerControllersMap(this);
  }
  
  ControllersMap get controllers => _controllers;

  set port( int port ) {
    _server.port = port;
  }

  void _mapController( String childUri, Controller child) {
    var uri = child.managesChildren ? "/${childUri}.*" : "/${childUri}"; 
    _server.map( uri, (HttpConnect connect) => _handleRequest(connect,child) );
  }
  
  Future _handleRequest( HttpConnect connect, Controller rootController ) {
    var controller = _findController( connect.request.uri, rootController );
    if( controller==null ) {
      connect.response.statusCode = HttpStatus.NOT_FOUND;
      return new Future.value();
    } else {
      return _routeRequest( connect, controller );
    }
  }
  
  Future _routeRequest( HttpConnect connect, Controller controller) {
    var request = new _Request(connect);
    return controller.parse(request).then( (input) {
      var method = connect.request.queryParameters["__http-method"];
      if( method==null ) {
        method = request.method;
      }
      switch( method ) {
        case "GET": return controller.get(request);  
        case "POST": return controller.post(request,input);  
        case "PUT": return controller.put(request,input); 
        case "DELETE": return controller.delete(request); 
        case "HEAD": return controller.head(request); 
        case "OPTIONS": return controller.options(request); 
      }
    });
  }

  Controller _findController(Uri uri, Controller rootController) {
    var controller = rootController;
    var nodes = uri.path.split("/");
    for( var i=2 ; i<nodes.length && controller!=null ; i++ ) {
      controller = controller.children[nodes[i]];
    }
    return controller;
  }

}

/**
 * A class to hold the map of root controllers for a [_Server]
 */
class _ServerControllersMap extends StaticControllersMap {

  _Server _server;
  
  _ServerControllersMap(this._server);
  
  operator []=( String childUri, Controller child ) {
      _server._mapController(childUri,child);
      return super[childUri] = child;
  }

}

/**
 * An implementation of [Request] that wraps the original [HttpConnect] object
 * from Rikulo Stream.
 */
class _Request implements Request {
  
  final HttpConnect _connect;
  _Response _response;
  InstanceMirror _delegate;
  
  _Request(this._connect) {
    _response = new _Response(this);
    _delegate = reflect(_connect.request);
  }

  dynamic get connect => _connect;

  Response get response => _response;
  
  noSuchMethod( Invocation invocation ) {
    return _delegate.delegate(invocation);
  }
}

/**
 * An implementation of [Response] that wraps the original [HttpConnect] object
 * from Rikulo Stream.
 */
class _Response implements Response {
  
  _Request _request;
  InstanceMirror _delegate;
  
  _Response(this._request) {
    _delegate = reflect(_request._connect.response);
  }

  Future renderStreamView( Future render(connect) ) {
    return render(_request._connect);
  }
  
  noSuchMethod( Invocation invocation ) {
    return _delegate.delegate(invocation);
  }

}

