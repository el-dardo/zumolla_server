library json_controller_test;

import "dart:async" show Future;
import "dart:io" show HttpRequest, HttpStatus, HttpResponse;

import "package:unittest/unittest.dart";
import "package:unittest/mock.dart";
import "package:stream/stream.dart";
import "package:zumolla_server/json.dart";
import "package:zumolla_server/json_controller.dart";

class MockHttpConnect extends Mock implements HttpConnect {}

class TestJsonEntity extends AbstractJsonEntity {
  TestJsonEntity();
  factory TestJsonEntity.fromJson( String json ) => 
      new AbstractJsonEntity.fromJson(json,new TestJsonEntity());
}

class TestableJsonController extends JsonController<TestJsonEntity> {
  var called = {};
  
  TestableJsonController( mapping, _getHttpMethod, _renderMethodNotAllowed,
      _getHttpHeaderContentType, _getHttpBody ) : super.test( mapping,
      _getHttpMethod, _renderMethodNotAllowed, _getHttpHeaderContentType, 
      _getHttpBody );

  Future<TestJsonEntity> parse( String contentType, String body ) 
    => new Future.value( new TestJsonEntity.fromJson(body) );

  Future put( HttpConnect connect, TestJsonEntity input ) => new Future.value(called["PUT"]=input);
  Future post( HttpConnect connect, TestJsonEntity input ) => new Future.value(called["POST"]=input);
  Future delete( HttpConnect connect ) => new Future.value(called["DELETE"]=true);
  Future get( HttpConnect connect ) => new Future.value(called["GET"]=true);
  Future head( HttpConnect connect ) => new Future.value(called["HEAD"]=true);
  Future options( HttpConnect connect ) => new Future.value(called["OPTIONS"]=true);
}

void main() {

  group( "json_controller", () {
    
    group( "JsonController", () {
  
      MockHttpConnect connect;
  
      setUp( () {
        connect = new MockHttpConnect();
      });
  
      Future testRoutingOfMethod( String method ) {
        var controller = new TestableJsonController(
            "mapping",
            (connect) => method,
            (connect) => new Future.value(),
            (connect) => "",
            (connect) => new Future.value()
        );
  
        return controller.handle(connect).then( (_) {
          expect( controller.called[method], isTrue );
        });
      }

      test( "handle() routes GET correctly", () => testRoutingOfMethod("GET") );
      test( "handle() routes DELETE correctly", () => testRoutingOfMethod("DELETE") );
      test( "handle() routes HEAD correctly", () => testRoutingOfMethod("HEAD") );
      test( "handle() routes OPTIONS correctly", () => testRoutingOfMethod("OPTIONS") );

      Future testParsingAndRoutingOfMethod( String method ) {
        var controller = new TestableJsonController(
            "mapping",
            (connect) => method,
            (connect) => new Future.value(),
            (connect) => "application/json",
            (connect) => new Future.value('{"gretting":"ola k ase"}')
        );
  
        return controller.handle(connect).then( (_) {
          var input = controller.called[method];
          expect( input, isNotNull );
          expect( input, new isInstanceOf<TestJsonEntity>("TestJsonEntity") );
          expect( input.gretting, equals("ola k ase") );
        });
      }

      test( "handle() parses and routes PUT correctly", () => testParsingAndRoutingOfMethod("PUT") );
      test( "handle() parses and routes POST correctly", () => testParsingAndRoutingOfMethod("POST") );

      test( "handle() calls renderMethodNotAllowed() for unknown HTTP method", () {
        var renderMethodNotAllowedCalled = false;
        var controller = new TestableJsonController(
            "mapping",
            (connect) => "INVALID HTTP METHOD",
            (connect) => new Future.value(renderMethodNotAllowedCalled=true),
            (connect) => "",
            (connect) => new Future.value()
        );
  
        return controller.handle(connect).then( (_) {
          expect( renderMethodNotAllowedCalled, true );
        });
      });
      
    });

  });
  
}
