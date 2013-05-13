library rest;

import "../../../lib/rest.dart";

abstract class MonthFields {
  int numberOfDays;
  int firstDayOfWeek; // 1..7 is Monday..Sunday
}

class Month extends RestEntity implements MonthFields {
  
  Month([int numberOfDays,int firstDayOfWeek]) {
    this.numberOfDays = numberOfDays;
    this.firstDayOfWeek = firstDayOfWeek;
  } 

  factory Month.fromJson( String json ) => 
      new RestEntity.fromJson( json, new Month() );
  
}

