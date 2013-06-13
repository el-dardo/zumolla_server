part of zumolla_json_crud_controller;

/** 
 * Get the id part of a JSON request URI. The id is the full URI minus the 
 * [baseUrl].
 */
String getJsonUriId( HttpConnect connect, String baseUrl ) {
  var baseLen = baseUrl.length+1;
  var path = connect.request.uri.path;
  return baseLen<path.length ? path.substring(baseLen) : "";
}
