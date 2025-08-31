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
      }
    }
  } catch (e) {
    print('Error: $e');
  }
}
