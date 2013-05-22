library zumolla_server_example;

import 'package:zumolla_server/server.dart';
        
import './webapp/service/services.dart';
import './webapp/controller/controllers.dart';

void main() {
  
  // Create services
  //var articleService = new ArticleService();
  var authorsService = new AuthorsService();
  
  // Create controllers
  //var articleController = new ArticleController(articleService);
  var authorsController = new AuthorsController(authorsService);
  
  // Start server
  startServer( 
      "/Users/Ivan/Documents/Dart/eldardo.org/zumolla_server/example/web/webapp", 
      (Server server) {
        server.port = 9000;
        server.controllers["authors"] = authorsController;
      }
  );
}
