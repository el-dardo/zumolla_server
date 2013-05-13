library zumolla_server_example;

import "../../lib/server.dart";

import "./service/services.dart";
import "./controller/controllers.dart";

void main() {
  
  // Create services
  var monthService = new MonthService();
  
  // Create controllers
  var monthController = new MonthController(monthService);
  
  // Start server
  startServer( 
      "/Users/Ivan/Documents/Dart/eldardo.org/zumolla_server/example/webapp", 
      (Server server) {
        server.port = 9000;
        server.addController( monthController );
      }
  );
}
