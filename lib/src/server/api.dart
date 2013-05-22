part of zumolla_server;

/** Callback method to be called to configure the [Server] */
typedef void ServerConfigurator( Server server );

/**
 * Start zumolla server using [homeDir] as context root and [configurator] as
 * callback configuration function.
 */
Future startServer( String homeDir, ServerConfigurator configurator ) {
  Completer completer = new Completer();
  
  var server = new StreamServer(homeDir:homeDir);
  _server = new _Server(server);
  configurator( _server );
  server.start().then( (streamServer) {
    completer.complete();
  }).catchError( (err) {
    completer.completeError( err );
  });
  
  return completer.future;
}

/** Interface exported by the server */
abstract class Server {
  ControllersMap get controllers;
  set port( int port );
}

/** Interface exported by zumolla server requests */
abstract class Request implements HttpRequest {
  
  /** 
   * Returns the Rikulo Stream [HttpConnect] object to be able to render RSP 
   * views. This method can return null if zumolla server is implemented with
   * a different underlying technology. 
   */
  dynamic get connect;
  
  /** Get the [Response] associated to this [Request] */
  Response get response;
}

/** Interface exported by zumolla server responses */
abstract class Response implements HttpResponse {
  Future renderStreamView( Future render(connect) );
}


