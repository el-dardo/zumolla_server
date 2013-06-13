library zumolla_server_example;

import "package:stream/stream.dart";

import "./service/services.dart";
import "./controller/controllers.dart";

void main() {
  var server = new StreamServer()
    ..port = 9000
  ;
  
  var authorsService = new AuthorsService();
  var articlesService = new ArticlesService(authorsService);
  
  new HtmlAuthorController("/author",authorsService).install(server);
  new JsonArticlesController("/articles",articlesService).install(server);
  new JsonCrudAuthorsController("/authors",authorsService).install(server);
  
  server.start();
}
