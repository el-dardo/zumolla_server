part of zumolla_json;

/** 
 * Render a JSON object to an HTTP response. The [object] parameter can be any 
 * object on which [stringify] can be called.
 */
Future renderJsonObject( HttpConnect connect, Object object ) => new Future.sync( () {
  if( object==null ) {
    return renderNotFound(connect); 
  } else {
    var charset = connect.response.encoding.name;
    connect.response.headers.add( HttpHeaders.CONTENT_TYPE, "application/json; charset=${charset}" );
    var json = stringify(object);
    connect.response.add( json.codeUnits ); 
  }
});

