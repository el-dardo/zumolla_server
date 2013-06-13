part of zumolla_json;

/**
 * A base implementation of [JsonEntity] based on [JsonObject]
 */
abstract class AbstractJsonEntity extends JsonObject implements JsonEntity {

  AbstractJsonEntity();
  
  factory AbstractJsonEntity.fromJson( String json, AbstractJsonEntity instance ) => 
      new JsonObject.fromJsonString( json, instance )..isExtendable=true;
  
  dynamic noSuchMethod( Invocation mirror ) {
    int positionalArgs = 0;
    if (mirror.positionalArguments != null) positionalArgs = mirror.positionalArguments.length;

    var property = _symbolToString(mirror.memberName);

    if( mirror.isGetter && (positionalArgs == 0) && !this.containsKey(property) ) {
      this[property] = null;
    }

    return super.noSuchMethod(mirror);      
  }

  String _symbolToString(value) {
    if (value is Symbol) {
      return MirrorSystem.getName(value);
    }
    else {
      return value.toString();
    }
  }
  
}