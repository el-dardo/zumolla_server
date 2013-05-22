part of controllers;
/*
// invocation: /article/<id>
// example:    /article/D40682E0-D676-4443-AF97-5AA15003D999
class ArticleController extends DefaultController<Article,String> {
  
  const uris = const ["/articles/.*"];
  final ArticleService _articleService;
  
  ArticleController(this._articleService);
  
  String getId( Uri uri ) {
    var parts = uri.path.toString().split("/");
    return parts[2];
  }

  Article parseJsonRequest( String json ) => new Article.fromJson(json);
  
  Future<Article> processGet( String id, Map<String,String> params ) => 
      _articleService.get( id, fetch: extractFetchParam(params, defaults:["author"] ) );

  Future renderHtmlEntityResponse(Request request, Article data) {
    request.response.renderStreamView( (connect) =>
        article_view(connect,
            articleId: data.id,
            article: data
        )
    );
  }

}
*/