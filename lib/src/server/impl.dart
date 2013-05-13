part of zumolla_server;

var _server;

typedef Future _StreamServerHandler( HttpConnect connect );

class _Server implements Server {
  
  StreamServer _server;
  
  _Server(this._server);

  set port( int port ) {
    _server.port = port;
  }
  
  void addController( Controller controller ) {
    for( var uri in controller.uris ) {
      _server.map( uri, new _ControllerRouter(controller).streamServerHandler );
    }
  }
  
}

class _Request<ID> implements Request {
  
  final HttpConnect _connect;
  _Response _response;
  
  _Request(this._connect) {
    _response = new _Response(this);
  }
  
  Uri get uri => _connect.request.uri;
  Response get response => _response;
  
}

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

// TODO: routing por defecto y errores
class _ControllerRouter<T extends RestEntity,ID> {

  Controller<T,ID> _controller;
  
  _ControllerRouter(this._controller);

  _StreamServerHandler get streamServerHandler => (HttpConnect connect) => _handle(connect);

  ///////
  Future _handle( HttpConnect connect ) {
    var id = _controller.getId(connect.request.uri);
    return _parseRequest(connect).then( (data) {
      return _process(connect,id,data);
    }).then( (response) {
      return _render(connect,response);
    });
  }
  
  ///////
  // TODO: simulate body from query parameters
  Future<T> _parseRequest( HttpConnect connect ) {
    var contentType = _getContentType(connect);
    switch( connect.request.method ) {
      case "PUT": 
      case "POST":
        return IOUtil.readAsString( connect.request ).then( (body) {
          switch( contentType ) {
            case "application/json": return _controller.parseJsonRequest(body);
            //case "application/xml":
            //case "www/url-enconded":
          }
          return new Future.error( new UnsupportedError("Unsupported content type: ${contentType}") );
        });
    }
    return new Future.value(null);
  }
  
  ///////
  Future _process(HttpConnect connect, ID id, T data) {
    switch( connect.request.method ) {
      case "PUT": return _controller.processPut(id,data);
      case "POST": return _controller.processPost(data);
      case "DELETE": return _controller.processDelete(id);
      case "GET": return _controller.processGet(id);
    }
  }
  
  ///////
  Future _render(HttpConnect connect, dynamic response) {
    switch( connect.request.method ) {
      case "POST": return _renderId(connect,response);
      case "GET": return _renderEntity(connect,response);
    }
  }

  Future _renderId(HttpConnect connect, ID id) {
    var request = new _Request(connect);
    // TODO: set content type and encoding
    var accept = _getAccept(connect);
    switch( accept ) {
      case "application/json": return _controller.renderJsonIdResponse(request,id);
      case "text/html": return _controller.renderHtmlIdResponse(request,id);
    }
  }

  Future _renderEntity(HttpConnect connect, T data) {
    var request = new _Request(connect);
    // TODO: set content type and encoding
    var accept = _getAccept(connect);
    switch( accept ) {
      case "application/json": return _controller.renderJsonEntityResponse(request,data);
      case "text/html": return _controller.renderHtmlEntityResponse(request,data);
    }
  }

  ///////
  String _getContentType(HttpConnect connect) {
    var contentType = connect.request.queryParameters[HttpHeaders.CONTENT_TYPE];
    if( contentType==null ) {
      var headers = connect.request.headers[HttpHeaders.CONTENT_TYPE];
      if( headers!=null ) {
        contentType = headers[0];
      }
    }
    return contentType;  
  }

  String _getAccept(HttpConnect connect) {
    var accept = connect.request.queryParameters[HttpHeaders.ACCEPT];
    if( accept==null ) {
      var accepts = connect.request.headers[HttpHeaders.ACCEPT];
      if( accepts==null ) {
        accept = (accept==null) ? "text/html" : accept;
      } else {
        accept = accepts[0];
        var i = accept.indexOf(",");
        if( i!=-1 ) {
          accept = accept.substring(0, i);
        }
      }
    }
    return accept;
  }
}

