import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:5000/api/auth';
  static const String _searchUrl = 'http://localhost:5000/api/search';
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  // Save token to persistent storage
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
  
  // Get token from persistent storage
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  
  // Save user data to persistent storage
  static Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userData));
  }
  
  // Get user data from persistent storage
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userKey);
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }
  
  // Clear stored authentication data
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
  
  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
  
  // Get authorization headers
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  
  // Login user
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        // Save token and user data to persistent storage
        if (data['token'] != null) {
          await _saveToken(data['token']);
        }
        if (data['user'] != null) {
          await _saveUserData(data['user']);
        }
        
        return {
          'success': true,
          'data': data,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Register user
  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': '$firstName $lastName',
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Save token and user data to persistent storage
        if (data['token'] != null) {
          await _saveToken(data['token']);
        }
        if (data['user'] != null) {
          await _saveUserData(data['user']);
        }
        
        return {
          'success': true,
          'data': data,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Get current user
  static Future<Map<String, dynamic>> getCurrentUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get user data',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Logout user
  static Future<Map<String, dynamic>> logoutUser() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: headers,
      );

      final data = jsonDecode(response.body);
      
      // Clear local storage regardless of API response
      await logout();
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        return {
          'success': true, // Still success as we cleared local data
          'message': 'Logged out locally',
        };
      }
    } catch (e) {
      // Clear local storage even if API call fails
      await logout();
      return {
        'success': true,
        'message': 'Logged out locally',
      };
    }
  }

  // Save search query to history
  static Future<Map<String, dynamic>> saveSearchHistory(String query) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$_searchUrl/history'),
        headers: headers,
        body: jsonEncode({
          'query': query,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': data,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to save search history',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Get user's search history
  static Future<Map<String, dynamic>> getSearchHistory({int limit = 20, int offset = 0}) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$_searchUrl/history?limit=$limit&offset=$offset'),
        headers: headers,
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data,
          'message': 'Search history retrieved successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get search history',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Delete specific search from history
  static Future<Map<String, dynamic>> deleteSearchHistoryItem(String historyId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$_searchUrl/history/$historyId'),
        headers: headers,
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to delete search history item',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Clear all search history
  static Future<Map<String, dynamic>> clearSearchHistory() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$_searchUrl/history'),
        headers: headers,
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to clear search history',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.put(
        Uri.parse('$_baseUrl/profile'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'email': email,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        // Update stored user data
        await _saveUserData(data['user']);
        
        return {
          'success': true,
          'message': data['message'] ?? 'Profile updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Change password
  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.put(
        Uri.parse('$_baseUrl/change-password'),
        headers: headers,
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Password changed successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to change password',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }
}
