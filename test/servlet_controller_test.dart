library servlet_controller_test;

import "dart:async" show Future;
import "dart:io" show HttpRequest, HttpStatus, HttpResponse;

import "package:unittest/unittest.dart";
import "package:unittest/mock.dart";
import "package:stream/stream.dart";
import "package:zumolla_server/servlet_controller.dart";

class MockHttpConnect extends Mock implements HttpConnect {}

class TestableServletController extends ServletController {
  var called = {};
  TestableServletController( mapping, mockGetHttpMethod,
      mockRenderMethodNotAllowed ) : 
      super.test( mapping, mockGetHttpMethod, mockRenderMethodNotAllowed );
  Future put( HttpConnect connect ) => new Future.value(called["PUT"]=true);
  Future post( HttpConnect connect ) => new Future.value(called["POST"]=true);
  Future delete( HttpConnect connect ) => new Future.value(called["DELETE"]=true);
  Future get( HttpConnect connect ) => new Future.value(called["GET"]=true);
  Future head( HttpConnect connect ) => new Future.value(called["HEAD"]=true);
  Future options( HttpConnect connect ) => new Future.value(called["OPTIONS"]=true);
}

void main() {

  group( "servlet_controller", () {
    
    group( "ServletController", () {
  
      MockHttpConnect connect;
  
      setUp( () {
        connect = new MockHttpConnect();
      });
  
      Future testRoutingOfMethod( String method ) {
        var controller = new TestableServletController(
            "mapping",
            (connect) => method,
            (connect) => new Future.value()
        );
  
        return controller.handle(connect).then( (_) {
          expect( controller.called[method], isTrue );
        });
      }
  
      test( "handle() routes GET correctly", () => testRoutingOfMethod("GET") );
      test( "handle() routes POST correctly", () => testRoutingOfMethod("POST") );
      test( "handle() routes PUT correctly", () => testRoutingOfMethod("PUT") );
      test( "handle() routes DELETE correctly", () => testRoutingOfMethod("DELETE") );
      test( "handle() routes HEAD correctly", () => testRoutingOfMethod("HEAD") );
      test( "handle() routes OPTIONS correctly", () => testRoutingOfMethod("OPTIONS") );
  
      test( "handle() calls renderMethodNotAllowed() for unknown HTTP method", () {
        var renderMethodNotAllowedCalled = false;
        var controller = new TestableServletController(
            "mapping",
            (connect) => "INVALID HTTP METHOD",
            (connect) => new Future.value(renderMethodNotAllowedCalled=true)
        );
  
        return controller.handle(connect).then( (_) {
          expect( renderMethodNotAllowedCalled, true );
        });
      });
      
    });

  });
  
}
