import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lib/models/search_models.dart';

void main() async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:8080/search?q=google&category=general&format=json&language=en&pageno=1'),
      headers: {
        'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Accept': 'application/json, text/plain, */*',
      },
    );
    
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('Full response structure:');
      print('Query: ${jsonData['query']}');
      print('Number of results: ${jsonData['number_of_results']}');
      print('Results length: ${(jsonData['results'] as List).length}');
      
      if ((jsonData['results'] as List).isNotEmpty) {
        print('\nFirst result structure:');
        final firstResult = jsonData['results'][0];
        print('Keys: ${(firstResult as Map).keys.toList()}');
        
        for (String key in (firstResult as Map<String, dynamic>).keys) {
          final value = firstResult[key];
          print('$key: ${value.runtimeType} = $value');
        }
        
        print('\n--- Attempting to parse SearchResult ---');
        try {
          final searchResult = SearchResult.fromJson(firstResult as Map<String, dynamic>);
          print('SUCCESS: SearchResult parsed successfully');
          print('Title: ${searchResult.title}');
          print('URL: ${searchResult.url}');
        } catch (e) {
          print('ERROR parsing SearchResult: $e');
          print('Error type: ${e.runtimeType}');
          
          // Try to identify which field is causing the issue
          print('\n--- Testing individual fields ---');
          final testResult = firstResult as Map<String, dynamic>;
          
          try {
            print('Testing title: ${testResult['title'] as String}');
          } catch (e) {
            print('ERROR with title: $e');
          }
          
          try {
            print('Testing url: ${testResult['url'] as String}');
          } catch (e) {
            print('ERROR with url: $e');
          }
          
          try {
            print('Testing content: ${testResult['content'] as String}');
          } catch (e) {
            print('ERROR with content: $e');
          }
          
          try {
            print('Testing engines: ${testResult['engines']}');
            final engines = (testResult['engines'] as List<dynamic>?)?.map((e) => e as String).toList();
            print('Engines converted: $engines');
          } catch (e) {
            print('ERROR with engines: $e');
          }
        }
        
        print('\n--- Attempting to parse full SearchResponse ---');
        try {
          final searchResponse = SearchResponse.fromJson(jsonData);
          print('SUCCESS: SearchResponse parsed successfully');
          print('Query: ${searchResponse.query}');
          print('Results count: ${searchResponse.results.length}');
        } catch (e) {
          print('ERROR parsing SearchResponse: $e');
          print('Error type: ${e.runtimeType}');
        }
      }
    }
  } catch (e) {
    print('Error: $e');
  }
}
