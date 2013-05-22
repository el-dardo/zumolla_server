part of controllers;

/*
** GET /authors -> todos los autores                           -> List<T> find( Map<String,String> args ) map vacio
** GET /authors?name=Pepe -> todos los autores con nombre Pepe -> List<T> find( Map<String,String> args ) map con name==Pepe
** POST /authors -> dar de alta un autor                       -> String create( T obj ) devuelve el id del objeto creado 
** DELETE /authors -> borrar todos los autores                 -> void delete( Map<String,String> args ) map vacio
** DELETE /authors?name=Pepe -> borrar autores con nombre Pepe -> void delete( Map<String,String> args ) map con name==Pepe

 * GET /authors/7 -> ver autor 7                               -> T getById( String id ) una vista
 * PUT /authors/7 -> sobreescribir el autor 7                  -> void update( T obj )
 * DELETE /authors/7 -> borrar autor 7                         -> void delete( Map<String,String> args ) map con id==7
 * GET /authors/7/forms/edit -> editar autor 7                 -> T getById( String id ) otra vista

GET /authors/forms/new -> formulario de creacion                  -> controller hijo
GET /authors/forms/search -> formulario de busqueda               -> controller hijo
*/
class AuthorsController extends AbstractRestEntityController<Author> {
  
  AuthorsController(Service<Author> service) : super(service) {
    addListRenderer("application/json", renderJsonList);
    addListRenderer("text/html", renderHtmlList);
    addInstanceRenderer("application/json",renderJsonInstance);
    addInstanceRenderer("text/html",renderHtmlInstance);
    addEntityForm("new", create);
    addInstanceForm("edit", edit);
  }
  
  Future renderHtmlList( Request request, List<Author> authors ) 
    => authors_view(request.connect,authors:authors);

  Future renderHtmlInstance( Request request, Author author ) 
    => author_view(request.connect,author:author);
  
  Future create( Request request, Author author ) {
    request.response.add( "form create (${author.name})".codeUnits );
  }

  Future edit( Request request, Author author ) {
    request.response.add( "form edit (${author.name})".codeUnits );
  }

}
