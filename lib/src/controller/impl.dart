part of zumolla_controller;

/**
 * Returns the result of reading the "fetch" argument value from the [params] 
 * map and splitting it using char ",". If no "fetch" argument is found and 
 * [defaults] is not null, the values inside [defaults] are returned. 
 */
Set<String> _extractFetchParam( Map<String,String> params, {List<String> defaults} ) {
  if( params["fetch"]==null ) {
    return (defaults==null ) ? null : new Set.from( defaults );
  } else {
    return new Set.from( params["fetch"].split(",") );
  }
}

/**
 * Return the Content-Type header of an HTTP request. It first looks for a query
 * parameter named __content-type which, if found, overrides any existing header.
 * If parameter is not provided, the real header is returned. 
 */
String _getContentType(Request request) {
  var contentType = request.queryParameters["__${HttpHeaders.CONTENT_TYPE}"];
  if( contentType==null ) {
    var headers = request.headers[HttpHeaders.CONTENT_TYPE];
    if( headers!=null ) {
      contentType = headers[0];
    }
  }
  return contentType;  
}

/**
 * Return the Accept header of an HTTP request. It first looks for a query
 * parameter named __accept which, if found, overrides any existing header.
 * If parameter is not provided, the real header is returned. If no header is
 * found "text/html" is returned.       
 */
String _getAccept(Request request) {
  var accept = request.queryParameters["__${HttpHeaders.ACCEPT}"];
  if( accept==null ) {
    var accepts = request.headers[HttpHeaders.ACCEPT];
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
          
// http://www.slideshare.net/guilhermecaelum/rest-in-practice
/**
 * An implementation of [Controller] to manage the instances of a REST resource. 
 * Defines a standard set of URIs for managing the resource via JSON REST 
 * interfaces or HTML. 
 * 
 * This class is to be used from [AbstractRestEntityController]. 
 * 
 * Example: if we are handling the Authors resource, we get the following URIs:
 * 
 * /authors/X -> supports GET (read the author with id=X), PUT (modify), DELETE
 * /authors/X/forms/Y -> supports GET (get HTML form with id=Y for author X, 
 *                      for example: /authors/7/forms/edit)
 * 
 */
class _RestInstanceController<T extends RestEntity> extends AbstractRestController<T> {

  /** The id of the entity instance */
  final String id;
  /** The function to render the entity instance when a GET is requested */
  final RenderInstanceFunction _renderInstance;
  
  final _forms = new Map<String,RenderInstanceFunction>();

  _RestInstanceController( Service<T> service, this.id, this._renderInstance ) : super(service);

  /**
   * Add a form to be serviced from the entity instance's "forms" URI. For 
   * example: /authors/7/forms/new.
   */
  void addForm( String formId, RenderInstanceFunction handler ) {
    _forms[formId] = handler;
  }

  /**
   * Get the virtual child [Controller]s. By default returns the "forms" 
   * controller (/authors/X/forms/Y) and null for any other URI.
   */
  Controller getVirtualChild(String uri) {
    switch( uri ) {
      case "forms": return new _RestFormsController( getFormController ); 
      default:      return null;
    }
  }

  /** Get a form renderer function given its id */
  RenderInstanceFunction getFormRenderer( String formId ) => _forms[formId];

  /** Get a form controller given its id */
  Controller getFormController( String formId ) {
    var form = getFormRenderer(formId);
    return (form==null) ? null : new _RestInstanceFormController( service, id, form );
  }
      
  /**
   * Service a GET request for the instance (f.e: GET /authors/X). The default 
   * implementation calls find in the associated [Service] with id=X as search
   * criteria and passes the result of the search to the 
   * [_renderInstance] method.
   */
  Future get( Request request ) => new Future.sync( () {
    // TODO: maybe redirect to a form
    return service.find( { "id": id } ).then( (entities) {
      if( entities.length==1 ) {
        return _renderInstance(request,entities[0]);
      } else {
        request.response.statusCode = HttpStatus.NOT_FOUND;
      }
    });
  });
  
  /**
   * Service a PUT request for the instance (f.e: PUT /authors/X). The default 
   * implementation calls update in the associated [Service] with the PUT 
   * content parsed as an object.
   */
  Future put( Request request, T input ) {
    // TODO: render Accept content -> maybe redirect to a form
    input.id = id;
    return service.update(input); 
  }

  /**
   * Service a DELETE request for the instance (f.e: DELETE /authors/X). The 
   * default implementation calls delete in the associated [Service] with the 
   * defined entity id.
   */
  // TODO: render Accept content
  Future delete( Request request ) => service.delete(id);
  
}

/**
 * An implementation of [Controller] to manage a map of forms to be returned
 * as children of the controller.
 */ 
class _RestFormsController<T extends RestEntity> extends AbstractController {
  
  /** The delegate function to be used for form lookup */
  final ControllerLookupFunction _formLookup;
  
  _RestFormsController(this._formLookup) : super(true);
  
  Controller getVirtualChild(String uri) => _formLookup(uri);
  
}

/**
 * An implementation of [Controller] to manage a form associated to an entity.
 */ 
class _RestEntityFormController<T extends RestEntity> extends AbstractController {

  final Service<T> service;
  final RenderInstanceFunction renderForm;

  _RestEntityFormController(this.service,this.renderForm) : super(false);
  
  /**
   * Calls newInstance on the associated [Service] giving it the parameters of
   * the request and then [renderForm] with the returned entity instance. 
   */
  Future get( Request request ) => new Future.sync( () {
    return service.newInstance( request.queryParameters ).then( (entity) {
      renderForm(request,entity);
    });
  });
  
}

/**
 * An implementation of [Controller] to manage a form associated to an entity
 * instance.
 */ 
class _RestInstanceFormController<T extends RestEntity> extends AbstractController {

  final Service<T> service;
  final String id;
  final RenderInstanceFunction renderForm;

  _RestInstanceFormController(this.service,this.id,this.renderForm) : super(false);
  
  /**
   * Calls find on the associated [Service] passing the instance id as search
   * criteria and then calls [renderForm] with the resulting instance.
   */
  Future get( Request request ) => new Future.sync( () {
    return service.find( { "id": id } ).then( (entities) {
      if( entities.length==1 ) {
        renderForm(request,entities[0]);
      } else {
        request.response.statusCode = HttpStatus.NOT_FOUND;
      }
    });
  });
  
}
