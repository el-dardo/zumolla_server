library json_crud_controller_test;

import "dart:async" show Future;
import "dart:io" show HttpRequest, HttpStatus, HttpResponse;

import "package:unittest/unittest.dart";
import "package:unittest/mock.dart";
import "package:stream/stream.dart";
import "package:zumolla_server/json.dart";
import "package:zumolla_server/json_crud_controller.dart";

class MockHttpConnect extends Mock implements HttpConnect {}
class MockHttpRequest extends Mock implements HttpRequest {}
class MockUri extends Mock implements Uri {}

class TestJsonEntity extends AbstractJsonEntity {
  TestJsonEntity();
  factory TestJsonEntity.fromJson( String json ) => 
      new AbstractJsonEntity.fromJson(json,new TestJsonEntity());
}

class TestableJsonCrudController extends JsonCrudController<TestJsonEntity> {
  var called = {};

  TestableJsonCrudController( String baseUrl, _getHttpMethod, 
      _renderMethodNotAllowed, _getHttpHeaderContentType, _getHttpBody, 
      _getJsonUriId ) : super.test("${baseUrl}.*",_getHttpMethod,
      _renderMethodNotAllowed, _getHttpHeaderContentType, _getHttpBody,
      _getJsonUriId );
  
  Future<TestJsonEntity> parse( String contentType, String body ) 
      => new Future.value( new TestJsonEntity.fromJson(body) );
  
  Future create( HttpConnect connect, TestJsonEntity input ) => new Future.value(called["POST"]=input);
  Future find( HttpConnect connect ) => new Future.value(called["GET"]=true);
  Future get( HttpConnect connect, String id ) => new Future.value(called["GET"]=id);
  Future update( HttpConnect connect, TestJsonEntity input ) => new Future.value(called["PUT"]=input);
  Future delete( HttpConnect connect, String id ) => new Future.value(called["DELETE"]=id);

}

void main() {

  group( "json_crud_controller", () {
    
    group( "base", () {
  
      group( "JsonCrudController", () {

        MockHttpConnect connect;
        
        setUp( () {
          connect = new MockHttpConnect();
        });
        
        Future testRoutingOfMethod( String method, String id, expectations ) {
          var controller = new TestableJsonCrudController(
              "baseUrl",
              (connect) => method,
              (connect) => new Future.value(),
              (connect) => "application/json",
              (connect) => new Future.value('{"gretting":"ola k ase"}'),
              (connect,baseUrl) => id
          );
          
          return controller.handle(connect).then( (_) {
            expectations( controller.called[method] );
          });
        }

        test( "handle() routes create() correctly", () 
            => testRoutingOfMethod( "POST", "", (input) {
                expect( input, isNotNull );
                expect( input, new isInstanceOf<TestJsonEntity>("TestJsonEntity") );
                expect( input.gretting, equals("ola k ase") );
            })
        );
        
        test( "handle() routes find() correctly", () 
            => testRoutingOfMethod( "GET", "", (called) {
                expect( called, isTrue );
            })
        );
        
        test( "handle() routes get() correctly", () 
            => testRoutingOfMethod( "GET", "666", (id) {
                expect( id, equals("666") );
            })
        );
        
        test( "handle() routes update() correctly", () 
            => testRoutingOfMethod( "PUT", "666", (input) {
                expect( input, isNotNull );
                expect( input, new isInstanceOf<TestJsonEntity>("TestJsonEntity") );
                expect( input.id, equals("666") );
                expect( input.gretting, equals("ola k ase") );
            })
        );
        
        test( "handle() routes delete() correctly", () 
            => testRoutingOfMethod( "DELETE", "666", (id) {
                expect( id, equals("666") );
            })
        );
        
      });
      
    });

    group( "helpers", () {
      
      MockHttpConnect connect;
      MockHttpRequest request;
      MockUri uri;
      
      setUp( () {
        connect = new MockHttpConnect();
        request = new MockHttpRequest();
        uri = new MockUri();
        connect.when(callsTo("get request")).alwaysReturn(request);
        request.when(callsTo("get uri")).alwaysReturn(uri);
      });

      test( "getJsonUriId() returns the last part of the request URI", () {
        uri.when(callsTo("get path")).alwaysReturn("/authors/666");
        expect( getJsonUriId(connect, "/authors"), "666" );        
      });
        
    });

  });
  
}
