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
      final results = jsonData['results'] as List;
      
      print('Analyzing all ${results.length} results...');
      Set<String> allKeys = {};
      
      for (int i = 0; i < results.length; i++) {
        final result = results[i] as Map<String, dynamic>;
        allKeys.addAll(result.keys);
        
        // Check for any fields that are Lists when we expect Strings
        for (String key in result.keys) {
          final value = result[key];
          if (value is List && !['engines', 'positions', 'parsed_url'].contains(key)) {
            print('WARNING: Result $i has field "$key" as List: $value');
          }
          if (value is Map && !['parsed_url'].contains(key)) {
            print('WARNING: Result $i has field "$key" as Map: $value');
          }
        }
      }
      
      print('\nAll unique keys found across results:');
      print(allKeys.toList()..sort());
      
      // Check our expected keys
      final expectedKeys = [
        'title', 'url', 'content', 'engine', 'template', 'engines', 'score',
        'thumbnail', 'img_src', 'publishedDate', 'author', 'priority', 
        'category', 'parsed_url', 'positions'
      ];
      
      final missingKeys = allKeys.difference(expectedKeys.toSet());
      if (missingKeys.isNotEmpty) {
        print('\nKeys found in results but not in our model:');
        print(missingKeys.toList()..sort());
      }
    }
  } catch (e) {
    print('Error: $e');
  }
}
