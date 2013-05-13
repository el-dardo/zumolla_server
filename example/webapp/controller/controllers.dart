library controllers;

import "dart:io" show HttpRequest;
import "dart:async";
import "dart:uri";
import "../../../lib/controller.dart";
import "../service/services.dart";
import "../view/views.dart";

// invocation: /month/<year>/<month>
// example:    /month/2009/4
class MonthController extends DefaultController<Month,DateTime> {
  
  const uris = const ["/month/.*"];
  final MonthService _monthService;
  
  MonthController(this._monthService);
  
  DateTime getId( Uri uri ) {
    var parts = uri.path.toString().split("/");
    var year = int.parse(parts[2]);
    var month = int.parse(parts[3]);
    return new DateTime(year,month,1);
  }

  Month parseJsonRequest( String json ) => new Month.fromJson(json);
  
  Future<Month> processGet( DateTime id ) => _monthService.get( id );

  Future renderHtmlEntityResponse(Request request, Month data) {
    request.response.renderStreamView( (connect) =>
        month_view(connect,
            id: getId(request.uri),
            data: data
        )
    );
  }

}
