import 'dart:convert';
import 'package:http/http.dart' as http;

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
      print('Testing manual parsing...');
      
      // Test SearchResponse level fields
      print('Testing SearchResponse fields:');
      try {
        final query = jsonData['query'] as String;
        print('✓ query: $query');
      } catch (e) {
        print('✗ query error: $e');
      }
      
      try {
        final numberResults = jsonData['number_of_results'] as int;
        print('✓ number_of_results: $numberResults');
      } catch (e) {
        print('✗ number_of_results error: $e');
      }
      
      try {
        final results = jsonData['results'] as List;
        print('✓ results list: ${results.length} items');
      } catch (e) {
        print('✗ results error: $e');
      }
      
      try {
        final corrections = jsonData['corrections'] as List?;
        print('✓ corrections: $corrections');
      } catch (e) {
        print('✗ corrections error: $e');
      }
      
      try {
        final infoboxes = jsonData['infoboxes'] as List?;
        print('✓ infoboxes: ${infoboxes?.length} items');
      } catch (e) {
        print('✗ infoboxes error: $e');
      }
      
      try {
        final suggestions = jsonData['suggestions'] as List?;
        print('✓ suggestions: ${suggestions?.length} items');
      } catch (e) {
        print('✗ suggestions error: $e');
      }
      
      try {
        final answers = jsonData['answers'] as List?;
        print('✓ answers: ${answers?.length} items');
      } catch (e) {
        print('✗ answers error: $e');
      }
      
      try {
        final unresponsive = jsonData['unresponsive_engines'] as List?;
        print('✓ unresponsive_engines: $unresponsive');
      } catch (e) {
        print('✗ unresponsive_engines error: $e');
      }
      
      // Test first SearchResult
      if ((jsonData['results'] as List).isNotEmpty) {
        print('\nTesting first SearchResult fields:');
        final firstResult = jsonData['results'][0] as Map<String, dynamic>;
        
        final testFields = [
          'title', 'url', 'content', 'engine', 'template', 'thumbnail', 
          'img_src', 'publishedDate', 'author', 'priority', 'category'
        ];
        
        for (String field in testFields) {
          try {
            final value = firstResult[field] as String?;
            print('✓ $field: $value');
          } catch (e) {
            print('✗ $field error: $e (actual type: ${firstResult[field].runtimeType}, value: ${firstResult[field]})');
          }
        }
        
        // Test specific list fields
        try {
          final engines = firstResult['engines'] as List?;
          final enginesStrings = engines?.map((e) => e as String).toList();
          print('✓ engines: $enginesStrings');
        } catch (e) {
          print('✗ engines error: $e (actual: ${firstResult['engines']})');
        }
        
        try {
          final positions = firstResult['positions'] as List?;
          print('✓ positions: $positions');
        } catch (e) {
          print('✗ positions error: $e');
        }
        
        try {
          final parsedUrl = firstResult['parsed_url'] as List?;
          print('✓ parsed_url: $parsedUrl');
        } catch (e) {
          print('✗ parsed_url error: $e');
        }
        
        try {
          final score = firstResult['score'] as double?;
          print('✓ score: $score');
        } catch (e) {
          print('✗ score error: $e');
        }
      }
    }
  } catch (e) {
    print('Error: $e');
  }
}
