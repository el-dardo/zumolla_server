library json_entities;

import "dart:json" show stringify;
import "package:zumolla_server/json.dart";

part "article.dart";
part "author.dart";

abstract class HasIdField {
  String id;
}