import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('Testing Flutter HTTP client...');
  
  // Test 1: Simple HTTP request to a public API
  try {
    print('\n1. Testing public API (httpbin.org)...');
    final response1 = await http.get(
      Uri.parse('https://httpbin.org/json'),
      headers: {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 5));
    
    print('   Status: ${response1.statusCode}');
    print('   Success: Public API works');
  } catch (e) {
    print('   Error: $e');
  }
  
  // Test 2: Test localhost connectivity
  try {
    print('\n2. Testing localhost connectivity...');
    final response2 = await http.get(
      Uri.parse('http://localhost:8080/'),
      headers: {'Accept': 'text/html'},
    ).timeout(const Duration(seconds: 10));
    
    print('   Status: ${response2.statusCode}');
    print('   Success: Can reach SearXNG web interface');
  } catch (e) {
    print('   Error: $e');
  }
  
  // Test 3: Test SearXNG API endpoint with same query as Python script
  try {
    print('\n3. Testing SearXNG API...');
    final response3 = await http.get(
      Uri.parse('http://localhost:8080/search?q=test+search&format=json&language=en'),
      headers: {
        'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Accept': 'application/json, text/plain, */*',
        'Accept-Language': 'en-US,en;q=0.9',
        'Accept-Encoding': 'gzip, deflate',
        'Connection': 'keep-alive',
        'X-Forwarded-For': '127.0.0.1',
        'X-Real-IP': '127.0.0.1',
      },
    ).timeout(const Duration(seconds: 15));
    
    final data3 = jsonDecode(response3.body);
    final resultsCount = (data3['results'] as List?)?.length ?? 0;
    print('   Status: ${response3.statusCode}');
    print('   Body length: ${response3.body.length}');
    print('   Results: $resultsCount');
    
    // Print first 500 chars of response to debug
    print('   Response preview: ${response3.body.substring(0, response3.body.length > 500 ? 500 : response3.body.length)}');
    
    if (resultsCount > 0) {
      print('   First result: ${data3['results'][0]}');
    } else {
      print('   Warning: No results found!');
      // Print some key fields from response
      if (data3 is Map) {
        print('   Response keys: ${data3.keys.toList()}');
        if (data3.containsKey('number_of_results')) {
          print('   Number of results field: ${data3['number_of_results']}');
        }
      }
    }
    
    print('   Success: SearXNG API works!');
  } catch (e) {
    print('   Error: $e');
  }
}
