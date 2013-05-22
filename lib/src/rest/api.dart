part of zumolla_rest;

/** 
 * Interface to be implemented by all REST entities 
 */
abstract class RestEntity {
  /** The unique id of the entity */
  String id;
}

/**
 * A base implementation of [RestEntity] based on [JsonObject]
 */
abstract class DefaultRestEntity extends JsonObject implements RestEntity {

  DefaultRestEntity();
  
  factory DefaultRestEntity.fromJson( String json, DefaultRestEntity instance ) => 
      new JsonObject.fromJsonString( json, instance )..isExtendable=true;

}