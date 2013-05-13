part of zumolla_rest;

abstract class RestEntity extends JsonObject {
  
  RestEntity();
  
  factory RestEntity.fromJson( String json, RestEntity instance ) => 
      new JsonObject.fromJsonString( json, instance );
  
}