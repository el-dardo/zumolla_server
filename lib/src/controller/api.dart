part of zumolla_controller;

/** Base controller interface */
abstract class Controller {
  String get mapping;
  RequestHandler get handler;
  void install( StreamServer server );
}
