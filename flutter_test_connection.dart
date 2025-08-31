import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('Testing Flutter HTTP connection to SearXNG...');
  
  try {
    final uri = Uri.parse('http://localhost:8080/search');
    final queryParams = {
      'q': 'test',
      'format': 'json',
    };
    
    final response = await http.get(
      uri.replace(queryParameters: queryParams),
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'X-Forwarded-For': '127.0.0.1',
        'X-Real-IP': '127.0.0.1',
      },
    ).timeout(const Duration(seconds: 15));
    
    print('Status Code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print('Success! Found ${jsonData['number_of_results']} results');
      print('First result: ${jsonData['results']?[0]?['title'] ?? 'N/A'}');
    } else {
      print('Error: HTTP ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('Network error: $e');
    print('Error type: ${e.runtimeType}');
  }
}
