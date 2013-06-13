part of rest;

abstract class ArticleFields implements HasIdField {
  String title;
  String intro;
  String content;
  Author author; 
}

class Article extends AbstractJsonEntity implements ArticleFields {

  Article();

  factory Article.fromArticle( Article other ) => 
      new AbstractJsonEntity.fromJson( stringify(other), new Article() );
  
  factory Article.fromJson( String json ) => 
      new AbstractJsonEntity.fromJson( json, new Article() );
  
}

