library controller_test;

import "dart:async" show Future;

import "package:unittest/unittest.dart";
import "package:unittest/mock.dart";
import "package:stream/stream.dart";
import "package:zumolla_server/controller.dart";

class MockStreamServer extends Mock implements StreamServer{}

class TestableAbstractController extends AbstractController {
  bool handleCalled;
  TestableAbstractController(mapping) : super(mapping);
  Future handle( HttpConnect connect ) => new Future.value( handleCalled=true );
}

void main() {

  group( "controller", () {
    
    group( "AbstractController", () {
  
      final server = new MockStreamServer();
      final mapping = "testmapping";
      TestableAbstractController controller;
      
      setUp( () {
        controller = new TestableAbstractController(mapping);
      });
  
  
      test( "the handler returned by get:handler calls AbstractController.handle(HttpConnect)", () {
        var handler = controller.handler;
        handler(null);
        expect( controller.handleCalled, isTrue );
      });
  
      test( "install() maps handler in given StreamServer", () {
        controller.install(server);
        
        server.calls( "map", equals(mapping), same(controller.handler) )
          .verify( happenedExactly(1) );
      });
  
    });

  });
  
}
