part of zumolla_http;

/** Extract the HTTP method used to make a request */
String getHttpMethod( HttpConnect connect ) {
  var method = connect.request.uri.queryParameters["__http-method"];
  if( method==null ) {
    method = connect.request.method;
  }
  return method;
}

/**
 * Return the Content-Type header of an HTTP request. It first looks for a query
 * parameter named __http-header-content-type which, if found, overrides any 
 * existing header. If parameter is not provided, the real header is returned. 
 */
String getHttpHeaderContentType(HttpConnect connect) {
  var contentType = connect.request.uri.queryParameters["__http-header-${HttpHeaders.CONTENT_TYPE}"];
  if( contentType==null ) {
    var headers = connect.request.headers[HttpHeaders.CONTENT_TYPE];
    if( headers!=null ) {
      contentType = headers[0];
    }
  }
  return contentType;  
}

/**
 * Get the body of an HTTP request. It first looks for a query parameter named
 * __http-body which, if found, overrides the real body. Otherwise, the real 
 * body is returned.
 */
Future<String> getHttpBody(HttpConnect connect) {
  var body = connect.request.uri.queryParameters["__http-body"];
  if( body==null ) {
    return IOUtil.readAsString( connect.request );
  } else {
    return new Future.value(body);
  }
}

