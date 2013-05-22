part of rest;

abstract class AuthorFields {
  String name;
  String surname;
  String email;
  String moreInfoLink;
}

class Author extends DefaultRestEntity implements AuthorFields {
  
  Author();

  factory Author.fromJson( String json ) => 
      new DefaultRestEntity.fromJson( json, new Author() );
  
}

