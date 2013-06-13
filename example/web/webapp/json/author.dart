part of rest;

abstract class AuthorFields implements HasIdField {
  String name;
  String surname;
  String email;
  String moreInfoLink;
}

class Author extends AbstractJsonEntity implements AuthorFields {
  
  Author();

  factory Author.fromJson( String json ) => 
      new AbstractJsonEntity.fromJson( json, new Author() );
  
  String get fullName => "$name $surname";
  
}

