part of zumolla_controller;

/** Minimal controller implementation */
abstract class AbstractController implements Controller {
  
  final String mapping;
  RequestHandler _handler;
  
  AbstractController(this.mapping) {
    _handler = (connect) => handle(connect);
  }
  
  RequestHandler get handler => _handler;
  
  void install( StreamServer server ) => server.map( mapping, handler );
  
  Future handle( HttpConnect connect );

}
