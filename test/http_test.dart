library http_test;

import "dart:io";
import "dart:async";

import "package:unittest/unittest.dart";
import "package:unittest/mock.dart";

import "package:stream/stream.dart";
import "package:zumolla_server/http.dart";

class MockHttpConnect extends Mock implements HttpConnect {}
class MockHttpRequest extends Mock implements HttpRequest {}
class MockUri extends Mock implements Uri {}
class MockHeaders extends Mock implements HttpHeaders {}
class MockStreamSubscription extends Mock implements StreamSubscription {}
class MockHttpResponse extends Mock implements HttpResponse {}

void main() {

  group( "http", () {

    group( "helpers", () {
    
      MockHttpConnect connect;
      MockHttpRequest request;
      MockUri uri;
      MockHeaders headers;
      
      setUp( () {
        connect = new MockHttpConnect();
        request = new MockHttpRequest();
        uri = new MockUri();
        headers = new MockHeaders();
        connect.when(callsTo("get request")).alwaysReturn(request);
        request.when(callsTo("get uri")).alwaysReturn(uri);
        request.when(callsTo("get headers")).alwaysReturn(headers);
      });
    
      group( "getHttpMethod()", () {
    
        test( "returns correct method when __http-method query parameter is given", () {
          request.when(callsTo("get method")).alwaysReturn("GET");
          uri.when(callsTo("get queryParameters")).alwaysReturn({"__http-method":"POST"});
          expect( getHttpMethod(connect), "POST" );
        });
    
        test( "returns correct method when __http-method query parameter is NOT given", () {
          request.when(callsTo("get method")).alwaysReturn("GET");
          uri.when(callsTo("get queryParameters")).alwaysReturn({});
          expect( getHttpMethod(connect), "GET" );
        });
    
      });
    
      group( "getHttpHeaderContentType()", () {
    
        test( "returns correct header when __http-header-content-type query parameter is given", () {
          uri.when(callsTo("get queryParameters")).alwaysReturn({"__http-header-content-type":"application/json"});
          expect( getHttpHeaderContentType(connect), "application/json" );
        });
    
        test( "returns correct method when __http-header-content-type query parameter is NOT given", () {
          headers.when(callsTo("[]",HttpHeaders.CONTENT_TYPE)).alwaysReturn(["text/xml"]);
          uri.when(callsTo("get queryParameters")).alwaysReturn({});
          expect( getHttpHeaderContentType(connect), "text/xml" );
        });
    
      });
      
      group( "getHttpBody()", () {
    
        test( "returns correct body when __http-body query parameter is given", () {
          //request.when(callsTo("get method")).alwaysReturn("GET");
          uri.when(callsTo("get queryParameters")).alwaysReturn({"__http-body":"THE BODY"});
          return getHttpBody(connect).then( (body) {
            expect( body, "THE BODY" );
          });
        });
    
        test( "returns correct body when __http-body query parameter is NOT given", () {
          final subscription = new MockStreamSubscription();
          
          request.when(callsTo("listen")).alwaysCall( (void onData(List<int> event)) {
            onData("THE BODY".codeUnits);
            return subscription;
          });
          subscription.when(callsTo("asFuture")).alwaysReturn( new Future.value() );
  
          uri.when(callsTo("get queryParameters")).alwaysReturn({});
          return getHttpBody(connect).then( (body) {
            expect( body, "THE BODY" );
          });
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
  
      test( "renderMethodNotAllowed() send correct HTTP response code", () {
        renderMethodNotAllowed(connect);
        response.calls("set statusCode",equals(HttpStatus.METHOD_NOT_ALLOWED)).verify(happenedOnce);
      });
      
      test( "renderNotFound() send correct HTTP response code", () {
        renderNotFound(connect);
        response.calls("set statusCode",equals(HttpStatus.NOT_FOUND)).verify(happenedOnce);
      });
      
    });
    
  });  
}
