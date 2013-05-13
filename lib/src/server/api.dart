part of zumolla_server;

typedef void ServerConfigurator( Server server );

abstract class Server {
  set port( int port );
  void addController( Controller controller );
}

abstract class Request {
  Uri get uri;
  Response get response;
}

abstract class Response implements IOSink {
  Future renderStreamView( Future render(connect) );
}

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

