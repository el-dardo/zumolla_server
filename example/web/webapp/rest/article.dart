part of rest;

abstract class ArticleFields {
  String id;
  String title;
  String intro;
  String content;
  Author author; 
}

class Article extends RestEntity implements ArticleFields {

  Article();

  factory Article.fromJson( String json ) => 
      new RestEntity.fromJson( json, new Article() );
  
}

