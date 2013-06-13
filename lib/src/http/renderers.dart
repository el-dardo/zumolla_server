part of zumolla_http;

/** Send a "Method not allowed" HTTP response */
Future renderMethodNotAllowed( HttpConnect connect ) => new Future.sync( () {
  connect.response.statusCode = HttpStatus.METHOD_NOT_ALLOWED;
});

/** Send a "Not found" HTTP response */
Future renderNotFound( HttpConnect connect ) => new Future.sync( () {
  connect.response.statusCode = HttpStatus.NOT_FOUND;
});

