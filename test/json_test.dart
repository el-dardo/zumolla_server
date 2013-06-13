library json_test;

import "dart:io";
//import "dart:async";

import "package:unittest/unittest.dart";
import "package:unittest/mock.dart";

import "package:stream/stream.dart";
import "package:zumolla_server/json.dart";

class MockHttpConnect extends Mock implements HttpConnect {}
class MockHttpResponse extends Mock implements HttpResponse {}
class MockHttpHeaders extends Mock implements HttpHeaders {}
class MockEncoding implements Encoding { // cannot use Mock because it has a name field
  final String name;
  MockEncoding(this.name);
}

class TestableJsonEntity extends AbstractJsonEntity {
  
  TestableJsonEntity();
  
  factory TestableJsonEntity.fromJson( String json ) 
    => new AbstractJsonEntity.fromJson( json, new TestableJsonEntity() );
  
}

void main() {

  group( "json", () {
  
    group( "base", () {
  
      TestableJsonEntity entity;
    
      setUp( () {
        entity = new TestableJsonEntity.fromJson("{}");
      });
    
      group( "AbstractJsonEntity", () {
    
        test( "fromJson() constructor returns an extendable object", () {
          expect( entity.isExtendable, isTrue );
        });
    
        test( "fromJson() constructor returns an object of the correct class", () {
          expect( entity, new isInstanceOf<TestableJsonEntity>("TestableJsonEntity") );
        });
    
        test( "unset properties return null", () {
          expect( entity.unsetProperty, isNull );
        });
    
      });
        
    });
  
    group( "renderers", () {
  
      MockHttpConnect connect;
      MockHttpResponse response;
      
      setUp( () {
        connect = new MockHttpConnect();
        response = new MockHttpResponse();
        connect.when(callsTo("get response")).alwaysReturn( response );
      });
  
      group( "renderJsonObject()", () {
        
        test( "returns HTTP not found if object is null", () {
          return renderJsonObject( connect, null ).then( (_) {
            response.calls("set statusCode",equals(HttpStatus.NOT_FOUND)).verify(happenedOnce);
          });
        });
    
        test( "sends given object as JSON stream", () {
          var encoding = new MockEncoding("UTF-8");
          var headers = new MockHttpHeaders();
  
          response.when(callsTo("get encoding")).alwaysReturn(encoding);
          response.when(callsTo("get headers")).alwaysReturn(headers);
          
          return renderJsonObject( connect, {"greeting":"ola k ase"} ).then( (_) {
            headers.calls("add",equals(HttpHeaders.CONTENT_TYPE),equals("application/json; charset=UTF-8")).verify(happenedOnce);
            response.calls("add",equals('{"greeting":"ola k ase"}'.codeUnits)).verify(happenedOnce);
          });
        });
    
      });
      
    });

  });
}
