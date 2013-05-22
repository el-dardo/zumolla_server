part of services;
/*
class ArticleService extends Service<Article,String> {

  Future<Article> get( String id, {Set<String> fetch} ) {
    var article = new Article()
      ..id = id
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
    if( fetch.contains("author") ) {
      article.author = new Author()
        ..id = "D40682E0-D676-4443-AF97-5AA15003D999"
        ..name = "Juan Ramon"
        ..surname = "Jimenez"
        ..email = "jrjimenez@gmail.com"
        ..moreInfoLink = "http://es.linkedin.com/jrjimenez"
      ;
    } else {
      article.author = new Author()
        ..id = "D40682E0-D676-4443-AF97-5AA15003D999"
      ;
    }
    return new Future.value(article);
  }
  
}
*/