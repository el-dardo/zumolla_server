part of zumolla_controller;

// TODO: T parseXmlRequest( String xml );
// TODO: T parseFormUrlEncodedRequest( String queryString );
// TODO: Future renderXmlResponse(HttpRequest request, T data);
abstract class Controller<T extends RestEntity,ID> {
  List<String> get uris; // uris en las que escucha el controller

  ID getId( Uri uri ); // obtener el id REST de la URL

  T parseJsonRequest( String json ); // parsear body para PUT y POST
  
  Future processPut( ID id, T data ); // procesar put
  Future<ID> processPost( T data ); // procesar post
  Future processDelete( ID id ); // procesar delete
  Future<T> processGet( ID id ); // procesar get

  Future renderHtmlIdResponse(Request request, ID id); // devolver id como HTML
  Future renderHtmlEntityResponse(Request request, T data); // devolver entidad como HTML
  
  Future renderJsonIdResponse(Request request, ID id); // devolver id como JSON
  Future renderJsonEntityResponse(Request request, T data); // devolver entidad como JSON
}

// implementa valores vacios para Controller
abstract class DefaultController<T extends RestEntity,ID> implements Controller<T,ID> {
  ID getId( Uri uri ) => null; 

  T parseJsonRequest( String json ) => null;
  
  Future processPut( ID id, T data ) => new Future.value();
  Future<ID> processPost( T data ) => new Future.value(null);
  Future processDelete( ID id ) => new Future.value();
  Future<T> processGet( ID id ) => new Future.value(null);

  Future renderHtmlIdResponse(Request request, ID id) =>
      renderJsonIdResponse(request,id);
  Future renderHtmlEntityResponse(Request request, T data) =>
      renderJsonEntityResponse(request,data);
  
  Future renderJsonIdResponse(Request request, ID id) =>
      _renderJsonResponse(request,id);
  Future renderJsonEntityResponse(Request request, T data) => 
      _renderJsonResponse(request,data);

  Future _renderJsonResponse(Request request, object) =>
      new Future( () {
        request.response.add( stringify(object).codeUnits ); // TODO: handle response==null => 404 
      });
}



