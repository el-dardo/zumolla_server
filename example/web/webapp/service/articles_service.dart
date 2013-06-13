part of services;

class ArticlesService implements Service<Article> {
  
  Map<String,Article> _db = new Map<String,Article>();
  int _nextId = 1;

  ArticlesService( AuthorsService authorsService ) {
    _db["A"] = new Article()
      ..id = "A"
      ..author = authorsService._db["A"]
      ..title = "La cría del berberecho salvaje"
      ..intro = "En este artículo explicaremos como se cría el berberecho salvaje, tanto en libertad como en cautividad."
      ..content = "Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum "
      "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum "
      "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum "
      "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum "
      "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum "
      "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum "
      "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum "
      "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum."
    ;

  }
  
  Future<String> create( Article obj ) => new Future.sync( () {
      obj.id = _nextId.toString();
      _db[_nextId.toString()] = obj;
      return (_nextId++).toString();
  });
  
  Future<Article> getById( String id, {Set<String> fetch} ) => new Future.sync( () {
    return _db[id];
  });

  Future<List<Article>> findAll( {Set<String> fetch} ) => new Future.sync( () {
    var list = new List<Article>();
    list.addAll( _db.values );
    
    if( fetch==null || !fetch.contains("author") ) {
      var oldList = new List<Article>.from(list);
      list = new List<Article>();
      for( var oldArticle in oldList ) {
        var article = new Article.fromArticle(oldArticle);
        article.author = new Author()..id = oldArticle.author.id;
        list.add( article );
      }
    }
    
    return list;
  });
  
  Future update( Article obj ) => new Future.sync( () {
    if( _db[obj.id]==null ) {
      throw "Article not found: ${obj.uniqueId}";
    } else {
      _db[obj.id] = obj;
    }
  });
  
  Future delete( String id ) => new Future.sync( () {
    _db.remove(id);
  });
  
}
