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
  
  Future<String> create( Author obj ) => new Future.sync( () {
      obj.id = _nextId.toString();
      _db[_nextId.toString()] = obj;
      return (_nextId++).toString();
  });
  
  Future<Author> getById( String id, {Set<String> fetch} ) => new Future.sync( () {
    return _db[id];
  });
  
  Future<List<Author>> findAll( {Set<String> fetch} ) => new Future.sync( () {
    var list = new List<Author>();
    list.addAll( _db.values );
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
