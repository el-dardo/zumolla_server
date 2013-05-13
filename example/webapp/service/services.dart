library services;

import "dart:async";
import "../../../lib/service.dart";
import "../rest/entities.dart";

export "../rest/entities.dart";

class MonthService extends Service<Month,DateTime> {

  Future<Month> get( DateTime id ) {
    var firstDayOfMonth = new DateTime( id.year, id.month, 1 );
    var month = new Month(_getDaysOfMonth(firstDayOfMonth),firstDayOfMonth.weekday);
    return new Future.value(month);
  }
  
  int _getDaysOfMonth( DateTime month ) {
    var nextMonth = new DateTime( month.year, month.month+1, 1 );
    var lastDayOfMonth = nextMonth.subtract( new Duration(days: 1) );
    return lastDayOfMonth.day;
  }
  
}
