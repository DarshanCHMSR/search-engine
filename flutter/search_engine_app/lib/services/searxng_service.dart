import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_models.dart';

class SearXNGService {
  // SearXNG instance URL - running locally as backend
  static const String _baseUrl = 'http://localhost:8080';
  static const String _searchEndpoint = '/search';
  
  final http.Client _client = http.Client();
  
  /// Search using SearXNG API directly
  Future<SearchResponse> search({
    required String query,
    String category = 'general',
    String format = 'json',
    String language = 'en',
    int page = 1,
    String? engines,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$_searchEndpoint');
      final queryParams = {
        'q': query,
        'category': category,
        'format': format,
        'lang': language,
        'pageno': page.toString(),
        if (engines != null) 'engines': engines,
      };
      
      final response = await _client.get(
        uri.replace(queryParameters: queryParams),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          'Accept-Language': 'en-US,en;q=0.9',
          'Accept-Encoding': 'gzip, deflate',
          'Connection': 'keep-alive',
          'X-Forwarded-For': '127.0.0.1',
          'X-Real-IP': '127.0.0.1',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return SearchResponse.fromJson(jsonData);
      } else {
        throw SearXNGException('Search failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SearXNGException) rethrow;
      throw SearXNGException('Network error: $e');
    }
  }

  /// Get available search engines
  Future<List<EngineInfo>> getEngines() async {
    try {
      final uri = Uri.parse('$_baseUrl/engines');
      final response = await _client.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Golligog-Flutter-App/1.0',
        },
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => EngineInfo.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// Search for images specifically
  Future<SearchResponse> searchImages({
    required String query,
    String language = 'en',
    int page = 1,
  }) async {
    return await search(
      query: query,
      category: 'images',
      language: language,
      page: page,
    );
  }
  
  /// Search for videos specifically
  Future<SearchResponse> searchVideos({
    required String query,
    String language = 'en',
    int page = 1,
  }) async {
    return await search(
      query: query,
      category: 'videos',
      language: language,
      page: page,
    );
  }
  
  /// Search for news specifically
  Future<SearchResponse> searchNews({
    required String query,
    String language = 'en',
    int page = 1,
  }) async {
    return await search(
      query: query,
      category: 'news',
      language: language,
      page: page,
    );
  }

  /// Check if SearXNG instance is available
  Future<bool> checkInstanceHealth() async {
    try {
      final uri = Uri.parse('$_baseUrl/healthz');
      final response = await _client.get(uri).timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Dispose of the HTTP client
  void dispose() {
    _client.close();
  }
}

/// Custom exception for SearXNG-related errors
class SearXNGException implements Exception {
  final String message;
  
  SearXNGException(this.message);
  
  @override
  String toString() => 'SearXNGException: $message';
}
