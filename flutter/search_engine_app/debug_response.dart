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
      print('Full response top-level fields:');
      
      for (String key in (jsonData as Map<String, dynamic>).keys) {
        final value = jsonData[key];
        print('$key: ${value.runtimeType} = $value');
        
        if (value is List && value.isNotEmpty) {
          print('  First item type: ${value[0].runtimeType}');
          if (value[0] is Map) {
            print('  First item keys: ${(value[0] as Map).keys.toList()}');
          }
        } else if (value is Map) {
          print('  Map keys: ${value.keys.toList()}');
        }
      }
    }
  } catch (e) {
    print('Error: $e');
  }
}
