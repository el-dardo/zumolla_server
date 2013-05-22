part of services;

class AuthorsService implements Service<Author> {
  
  Map<String,Author> _db = new Map<String,Author>();
  int _nextId = 1;

  AuthorsService() {
    _db["A"] = new Author()
      ..id = "A"
      ..name = "Jorge Luis"
      ..surname = "Borges"
      ..email = "jlborges@gmail.com"
      ..moreInfoLink = "http://es.linkedin.com/jlborges";
    _db["B"] = new Author()
      ..id = "B"
      ..name = "Miguel"
      ..surname = "de Cervantes"
      ..email = "mcervantes@gmail.com"
      ..moreInfoLink = "http://es.linkedin.com/cervantes";
  }
  
  Future<Author> parse( String contentType, String body ) => new Future.sync( () {
    switch( contentType ) {
      case "application/json": return new Author.fromJson( body ); 
      // TODO: support xml and www/url-encoded
//      case "application/xml":
//      case "www/url-encoded":
    }
  });
  
  Future<Author> newInstance( Map<String,String> params ) => new Future.sync( () {
    Author author = new Author();
    author.name = params["name"];
    return author;
  });
  
  Future<String> create( Author obj ) => new Future.sync( () {
      obj.id = _nextId.toString();
      _db[_nextId.toString()] = obj;
      return (_nextId++).toString();
  });
  
  Future<List<Author>> find( Map<String,String> criteria, {Set<String> fetch} ) => new Future.sync( () {
    var list = new List<Author>();
    if( criteria.containsKey("id") ) {
      var obj = _db[criteria["id"]];
      if( obj!=null ) {
        list.add( obj );
      }
    } else {
      list.addAll( _db.values );
    }
    return list;
  });
  
  Future update( Author obj ) => new Future.sync( () {
    if( _db[obj.id]==null ) {
      throw "Author not found: ${obj.id}";
    } else {
      _db[obj.id] = obj;
    }
  });
  
  Future delete( String id ) => new Future.sync( () {
    _db.remove(id);
  });
  
}
