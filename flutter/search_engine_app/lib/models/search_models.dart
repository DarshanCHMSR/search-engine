import 'package:json_annotation/json_annotation.dart';

part 'search_models.g.dart';

@JsonSerializable()
class SearchResult {
  final String title;
  final String url;
  final String content;
  final String? engine;
  final String? template;
  final List<String>? engines;
  final double? score;
  final String? thumbnail;
  final String? img_src;
  final String? publishedDate;
  final String? author;
  final String? priority;
  final String? category;
  final List<dynamic>? parsed_url;
  final List<dynamic>? positions;
  
  SearchResult({
    required this.title,
    required this.url,
    required this.content,
    this.engine,
    this.template,
    this.engines,
    this.score,
    this.thumbnail,
    this.img_src,
    this.publishedDate,
    this.author,
    this.priority,
    this.category,
    this.parsed_url,
    this.positions,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}

@JsonSerializable()
class SearchResponse {
  final String query;
  final int number_of_results;
  final List<SearchResult> results;
  final List<String>? corrections;
  final List<dynamic>? infoboxes;  // Changed from List<String> to List<dynamic>
  final List<String>? suggestions;
  final List<String>? answers;
  final List<String>? unresponsive_engines;  // Changed from String to List<String>
  
  SearchResponse({
    required this.query,
    required this.number_of_results,
    required this.results,
    this.corrections,
    this.infoboxes,
    this.suggestions,
    this.answers,
    this.unresponsive_engines,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) => _$SearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}

@JsonSerializable()
class EngineInfo {
  final String name;
  final String? displayname;
  final String? description;
  final List<String>? categories;
  
  EngineInfo({
    required this.name,
    this.displayname,
    this.description,
    this.categories,
  });

  factory EngineInfo.fromJson(Map<String, dynamic> json) => _$EngineInfoFromJson(json);
  Map<String, dynamic> toJson() => _$EngineInfoToJson(this);
}
