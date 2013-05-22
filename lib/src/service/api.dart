part of zumolla_service;

/**
 * An interface to be implemented by objects which provide business methods to 
 * an [AbstractRestController]. [Service] objects usually handle conversions 
 * from [RestEntity]s to model objects (f.e.: to ORM model objects).
 */
abstract class Service<T extends RestEntity> {
  
  /**
   * Parse [body] contents interpreted as MIME type specified by [contentType]
   * and return a [RestEntity] derived object.
   */
  Future<T> parse( String contentType, String body );
  
  /**
   * Create a new empty instance given the params of a request. It's up to the
   * implementation to interpret the params.
   */
  Future<T> newInstance( Map<String,String> params );
  
  /**
   * Create a new model object given its [RestEntity] counterpart.
   */
  Future<String> create( T obj );

  /**
   * Find instances matching the search [criteria]. It's up to the 
   * implementation to give semantics to the keys and values of the [criteria]
   * map.
   * 
   * The [fetch] argument specifies the path of the fields to fetch in 1-n or 
   * n-m relationships. For not fetched paths only the id of the related object 
   * is retrieved.
   */
  Future<List<T>> find( Map<String,String> criteria, {Set<String> fetch} );
  
  /**
   * Update the model object associated to [obj]
   */
  Future update( T obj );
  
  /**
   * Delete the model object with the given [id].
   */
  Future delete( String id );
  
}