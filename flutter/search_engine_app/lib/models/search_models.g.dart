// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) => SearchResult(
  title: json['title'] as String,
  url: json['url'] as String,
  content: json['content'] as String,
  engine: json['engine'] as String?,
  template: json['template'] as String?,
  engines: (json['engines'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  score: (json['score'] as num?)?.toDouble(),
  thumbnail: json['thumbnail'] as String?,
  img_src: json['img_src'] as String?,
  publishedDate: json['publishedDate'] as String?,
  author: json['author'] as String?,
);

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'content': instance.content,
      'engine': instance.engine,
      'template': instance.template,
      'engines': instance.engines,
      'score': instance.score,
      'thumbnail': instance.thumbnail,
      'img_src': instance.img_src,
      'publishedDate': instance.publishedDate,
      'author': instance.author,
    };

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) =>
    SearchResponse(
      query: json['query'] as String,
      number_of_results: (json['number_of_results'] as num).toInt(),
      results: (json['results'] as List<dynamic>)
          .map((e) => SearchResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      corrections: (json['corrections'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      infoboxes: (json['infoboxes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      suggestions: (json['suggestions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      answers: (json['answers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      unresponsive_engines: json['unresponsive_engines'] as String?,
    );

Map<String, dynamic> _$SearchResponseToJson(SearchResponse instance) =>
    <String, dynamic>{
      'query': instance.query,
      'number_of_results': instance.number_of_results,
      'results': instance.results,
      'corrections': instance.corrections,
      'infoboxes': instance.infoboxes,
      'suggestions': instance.suggestions,
      'answers': instance.answers,
      'unresponsive_engines': instance.unresponsive_engines,
    };

EngineInfo _$EngineInfoFromJson(Map<String, dynamic> json) => EngineInfo(
  name: json['name'] as String,
  displayname: json['displayname'] as String?,
  description: json['description'] as String?,
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$EngineInfoToJson(EngineInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'displayname': instance.displayname,
      'description': instance.description,
      'categories': instance.categories,
    };
