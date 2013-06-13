import "http_test.dart" as http;
import "json_test.dart" as json;
import "controller_test.dart" as controller;
import "servlet_controller_test.dart" as servlet_controller;
import "json_controller_test.dart" as json_controller;
import "json_crud_controller_test.dart" as json_crud_controller;

void main() {
  http.main();
  json.main();
  controller.main();
  servlet_controller.main();
  json_controller.main();
  json_crud_controller.main();
}
