part of zumolla_controller;

/** Functions that return a [Controller] based on an string id. */
typedef Controller ControllerLookupFunction( String childUri );

/** Functions that can render a data object to a request */
typedef Future RenderInstanceFunction( Request request, dynamic instance );

/** Renders a JSON object as an HTTP response. */
Future renderJsonInstance(Request request, RestEntity entity) => new Future.sync( () {
  request.response.add( stringify(entity).codeUnits ); // TODO: handle response==null => 404
});

/** Renders a JSON list as an HTTP response. */
Future renderJsonList(Request request, List<RestEntity> entities) => new Future.sync( () {
  request.response.add("[\n".codeUnits);
  for( var i=0 ; i<entities.length ; i++ ) {
    if( i>0 ) request.response.add(",\n".codeUnits );
    var json = stringify(entities[i]);
    request.response.add( json.codeUnits );
    request.response.add( "\n".codeUnits );
  }
  request.response.add("]".codeUnits);
});

/** Send a "Not found" HTTP response */
Future notFound(Request request) => new Future.sync( () {
  request.response.statusCode = HttpStatus.NOT_FOUND;
});

/** Send a "Method not allowed" HTTP response */
Future methodNotAllowed(Request request) => new Future.sync( () {
  request.response.statusCode = HttpStatus.METHOD_NOT_ALLOWED;
});

/** Send an "Internal server error" HTTP response */
Future internalServerError(Request request) => new Future.sync( () {
  request.response.statusCode = HttpStatus.INTERNAL_SERVER_ERROR;
});

/** Send an "Unsupported media type" HTTP response */
Future unsupportedMediaType(Request request) => new Future.sync( () {
  request.response.statusCode = HttpStatus.UNSUPPORTED_MEDIA_TYPE;
});

/**
 * An interface for objects that hold a map of [Controller]s identified by 
 * string ids.
 */
abstract class ControllersMap {
  Controller operator[]( String childUri );
  operator []=( String childUri, Controller child );
}

/**
 * Interface to be implemented by all controllers. A [Controller] is an object
 * capable of servicing HTTP verbs for an URI inside the application. The type
 * argument [INPUT] refers to the type of object that can be POSTed or PUT to
 * the uri.
 */
abstract class Controller<INPUT> {
  
  ControllersMap get children;
  
  /** Returns false if this controller cannot have children */
  bool get managesChildren; 
  
  /**
   * Parse a POST or PUT request body to convert it to a higher level data 
   * object. The returned object is passed to [put] and [post] methods as
   * input.
   */
  Future<INPUT> parse( Request request ); 
  
  Future put( Request request, INPUT input );
  Future post( Request request, INPUT input );
  Future delete( Request request );
  Future get( Request request );
  Future head( Request request );
  Future options( Request request );
  
}

/**
 * A static implementation of [ControllersMap] interface. Static in this
 * context means that controllers can be retrieved and set, but not generated
 * on the fly.
 */
class StaticControllersMap implements ControllersMap {
  
  final Map<String,Controller> _children = new Map<String,Controller>();
  
  Controller operator[]( String childUri ) => 
      _children[childUri];
  
  operator []=( String childUri, Controller child ) => 
      _children[childUri]=child;
  
}

/**
 * A dynamic implementation of [ControllersMap] interface. Dynamic refers to 
 * the possibility of generating [Controller]s for virtual ids on the fly.
 */
class DynamicControllersMap implements ControllersMap {

  final StaticControllersMap _static = new StaticControllersMap();
  final ControllerLookupFunction _lookup;
  
  /**
   * Constructs a [DynamicControllersMap] with a given [ControllerLookupFunction]
   * used to generate virtual [Controller]s on the fly. 
   */
  DynamicControllersMap(this._lookup);
  
  Controller operator[]( String childUri ) { 
    var ctl = _static[childUri];
    if( ctl==null ) {
      ctl = _lookup(childUri);
    }
    return ctl;
  }
  
  operator []=( String childUri, Controller child ) => 
      _static[childUri]=child;

}

/**
 * Basic implementation of [Controller] interface. Provides functionality for
 * managing children [Controller]s, a framework method for parsing input, and
 * implements all HTTP verbs returning "Method not allowed".
 */
abstract class AbstractController<INPUT> implements Controller<INPUT> {
  
  DynamicControllersMap _children;
  
  AbstractController(bool managesChildren) {
    if( managesChildren ) {
      _children = new DynamicControllersMap( (uri) => getVirtualChild(uri) );
    }
  }
  
  /**
   * Helper method to be called upon constructor with the chaining operator
   * to add children to the [Controller].
   */
  void withChildren( Map<String,Controller> children ) { 
    children.keys.forEach( (uri) {
      _children[uri] = children[uri];      
    });
  }
  
  ControllersMap get children => _children;
  bool get managesChildren => _children!=null;  

  /**
   * Overridable method to generate virtual child [Controller]s. Returns no
   * children by default.
   */
  Controller getVirtualChild(String uri) => null;
  
  /**
   * Overridable method to parse request body. Returns null by default.
   */
  Future<INPUT> parse( Request request ) => new Future.value(null);
  
  Future put( Request request, INPUT input ) => methodNotAllowed(request);
  Future post( Request request, INPUT input ) => methodNotAllowed(request);
  Future delete( Request request ) => methodNotAllowed(request);
  Future get( Request request ) => methodNotAllowed(request);
  Future head( Request request ) => methodNotAllowed(request);
  Future options( Request request ) => methodNotAllowed(request);
    
}

/** A [Controller] that always return an immutable text for GET requests */ 
class StaticTextController extends AbstractController {
  
  String _text;
  
  StaticTextController(this._text) : super(false);

  Future get( Request request ) => new Future.sync( () {
    request.response.add( _text.codeUnits );
  });

}

/** A [Controller] that always return the contents of a file for GET requests */ 
class StaticFileController extends AbstractController {
  
  File _file;
  
  StaticFileController(this._file) : super(false);
  
  Future get( Request request ) =>
      request.response.addStream(_file.openRead());
  
}

/**
 * A base implementation of [Controller] for REST resources which delegates 
 * parsing to a [Service]. 
 */
abstract class AbstractRestController<T extends RestEntity> extends AbstractController<T> {
  
  final Service<T> service;
  
  AbstractRestController(this.service) : super(true);
  
  Future<T> parse( Request request ) => new Future.sync( () {
    var contentType = _getContentType(request);
    return _getBody(request).then( (body) {
      return ( body=="" ) ? new Future.value(null) : parseInput( contentType, body );
    });
  });
  
  Future<T> parseInput( String contentType, String body ) => 
    service.parse(contentType, body);

  Future<String> _getBody(Request request) {
    var body = request.queryParameters["__http-body"];
    if( body==null ) {
      return IOUtil.readAsString( request );
    } else {
      return new Future.value(body);
    }
  }
  
  String _getContentType(Request request) {
    var contentType = request.queryParameters["__${HttpHeaders.CONTENT_TYPE}"];
    if( contentType==null ) {
      contentType = request.headers[HttpHeaders.CONTENT_TYPE];
    }
    return contentType;
  } 
}

/**
 * A base implementation of [Controller] to manage REST resources. A resource
 * defines a standard set of URIs for managing it via JSON REST interfaces or 
 * HTML. 
 * 
 * For example, if we are handling the Authors resource, we get the following
 * URIs:
 * 
 * /authors -> supports GET (search), POST (creation), DELETE (batch removal)
 * /authors/forms/X -> supports GET (get HTML form with id=X, for example: 
 *                      /authors/forms/new)
 * /authors/X -> supports GET (read the author with id=X), PUT (modify), DELETE
 * /authors/X/forms/Y -> supports GET (get HTML form with id=Y for author X, 
 *                      for example: /authors/7/forms/edit)
 * 
 */
abstract class AbstractRestEntityController<T extends RestEntity> extends AbstractRestController<T> {
  
  final _listRenderers = new Map<String,RenderInstanceFunction>();
  final _instanceRenderers = new Map<String,RenderInstanceFunction>();
  final _entityForms = new Map<String,RenderInstanceFunction>();
  final _instanceForms = new Map<String,RenderInstanceFunction>();

  AbstractRestEntityController( Service<T> service ) : super(service);
  
  /**
   * Add a renderer function to be serviced from the entity's URI. For example: 
   * /authors?name=John. The [renderer] renders the list of objects in the 
   * requested [contentType].
   */
  void addListRenderer( String contentType, RenderInstanceFunction renderer ) {
    _listRenderers[contentType] = renderer;
  }
  
  /**
   * Add a renderer function to be serviced from an entity instance URI. For 
   * example: /authors/7. The [renderer] renders the object in the requested 
   * [contentType].
   */
  void addInstanceRenderer( String contentType, RenderInstanceFunction renderer ) {
    _instanceRenderers[contentType] = renderer;
  }
  
  /**
   * Add a form to be serviced from the entity's "forms" URI. For example: 
   * /authors/forms/new.
   */
  void addEntityForm( String formId, RenderInstanceFunction handler ) {
    _entityForms[formId] = handler;
  }

  /**
   * Add a form to be serviced from the entity instance's "forms" URI. For 
   * example: /authors/7/forms/new.
   */
  void addInstanceForm( String formId, RenderInstanceFunction handler ) {
    _instanceForms[formId] = handler;
  }

  /**
   * Get the virtual child [Controller]s. By default returns the "forms" 
   * controller (/authors/forms/X) and the instance [Controller]s (/authors/X).
   */
  Controller getVirtualChild(String uri) {
    switch( uri ) {
      case "forms": return new _RestFormsController( _getFormController ); 
      default:      
        var ctl = new _RestInstanceController(service,uri,_renderInstance);
        for( var formId in _instanceForms.keys ) {
          ctl.addForm( formId, _instanceForms[formId] );
        }
        return ctl;
    }
  }

  /**
   * Service a GET request for the entity (f.e: GET /authors?name=X). The default 
   * implementation calls find in the associated [Service] with the request
   * parameters as search criteria and passes the result of the search to the 
   * [renderList] method.
   */
  Future get( Request request ) => service.find( request.queryParameters ).then( (entities) {
    // TODO: maybe redirect to a form for HTML
    return _renderList(request,entities);
  });

  /**
   * Service a POST request for the entity (f.e: POST /authors). The default 
   * implementation calls create in the associated [Service] with the POSTed 
   * content parsed as an object. It then renders the resulting id as a JSON 
   * object.
   */
  Future post( Request request, T entity ) => service.create(entity).then( (id) {
    // TODO: honor Accept content and maybe redirect to a form for HTML
    request.response.add( '{"id":"${id}"}'.codeUnits );
  });
  
  /**
   * Service a DELETE request for the entity (f.e: DELETE /authors?name=X). The 
   * default implementation calls find in the associated [Service] with the 
   * request parameters as input and passes the resulting objects to the delete
   * method of the associated [Service].
   */
  Future delete( Request request ) => service.find( request.queryParameters ).then( (entities) {
    // TODO: render Accept header and maybe redirect to a form for HTML
    return Future.forEach( entities, (entity) {
      return service.delete(entity.id);
    });
  });

  /**
   * Render a list of instances. 
   */
  Future _renderList(Request request, List<T> entities) {
    var accept = _getAccept(request);
    var renderer = _listRenderers[accept];
    if( renderer==null ) {
      return unsupportedMediaType(request);
    } else {      
      return renderer(request,entities);
    }
  }
  
  /**
   * Render a single instance with the requested [contentType].
   */
  Future _renderInstance( Request request, T author ) {
    var accept = _getAccept(request);
    var renderer = _instanceRenderers[accept];
    if( renderer==null ) {
      return unsupportedMediaType(request);
    } else {      
      return renderer(request,author);
    }
  }
  
  /** Get a form controller given its id */
  Controller _getFormController( String formId ) {
    var form = _entityForms[formId];
    return (form==null) ? null : new _RestEntityFormController( service, form );
  }


}
  
