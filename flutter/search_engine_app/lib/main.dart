import 'package:flutter/material.dart';
import 'search_results_page.dart';
import 'auth_wrapper.dart';
import 'search_history_page.dart';
import 'profile_page.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const GolligogApp());
}

class GolligogApp extends StatelessWidget {
  const GolligogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Golligog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: const Color(0xFF7B1FA2), // Deep purple
        scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B1FA2),
          brightness: Brightness.dark,
          background: const Color(0xFF121212),
          surface: const Color(0xFF1E1E1E),
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
        cardColor: const Color(0xFF1E1E1E),
        dividerColor: const Color(0xFF424242),
        fontFamily: 'Roboto',
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white70),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white70),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isHovered = false;
  bool _isLoggedIn = false;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    final userData = await AuthService.getUserData();
    
    setState(() {
      _isLoggedIn = isLoggedIn;
      _userData = userData;
    });
  }

  Future<void> _logout() async {
    try {
      await AuthService.logoutUser();
      setState(() {
        _isLoggedIn = false;
        _userData = null;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation bar
            _buildTopNavBar(),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      
                      // Golligog Logo
                      _buildLogo(),
                      
                      const SizedBox(height: 30),
                      
                      // Search bar
                      _buildSearchBar(),
                      
                      const SizedBox(height: 30),
                      
                      // Search buttons
                      _buildSearchButtons(),
                      
                      const SizedBox(height: 30),
                      
                      // Language options
                      _buildLanguageOptions(),
                      
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Gmail',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          const SizedBox(width: 15),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchResultsPage(query: 'images'),
                ),
              );
            },
            child: const Text(
              'Images',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          const SizedBox(width: 15),
          
          // Show different content based on login status
          if (_isLoggedIn) ...[
            // User menu
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'logout') {
                  _logout();
                } else if (value == 'history') {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchHistoryPage(),
                    ),
                  );
                  if (result != null && result is String) {
                    _searchController.text = result;
                    _performSearch(result);
                  }
                } else if (value == 'profile') {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                  // Refresh user data after profile changes
                  _checkAuthStatus();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userData?['name'] ?? 'User',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _userData?['email'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Color(0xFF7B1FA2)),
                      SizedBox(width: 8),
                      Text('Profile'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'history',
                  child: Row(
                    children: [
                      Icon(Icons.history, size: 16, color: Color(0xFF7B1FA2)),
                      SizedBox(width: 8),
                      Text('Search History'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Sign out'),
                    ],
                  ),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B1FA2).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF7B1FA2).withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: const Color(0xFF7B1FA2),
                      child: Text(
                        (_userData?['name'] ?? _userData?['email'] ?? 'U')[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_drop_down, size: 16),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Sign in button for non-logged in users
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthWrapper(),
                  ),
                );
                // Refresh auth status after returning from auth
                if (result == true) {
                  _checkAuthStatus();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B1FA2), // Purple color
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 1,
              ),
              child: const Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          
          const SizedBox(width: 15),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.apps, color: Colors.black54),
          ),
          const SizedBox(width: 15),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade600,
            child: const Text(
              'G',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'G',
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w400,
                color: Color(0xFF7B1FA2),
                fontFamily: 'Arial',
              ),
            ),
            TextSpan(
              text: 'o',
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9C27B0),
                fontFamily: 'Arial',
              ),
            ),
            TextSpan(
              text: 'l',
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w400,
                color: Color(0xFFAB47BC),
                fontFamily: 'Arial',
              ),
            ),
            TextSpan(
              text: 'l',
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w400,
                color: Color(0xFF7B1FA2),
                fontFamily: 'Arial',
              ),
            ),
            TextSpan(
              text: 'i',
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w400,
                color: Color(0xFF8E24AA),
                fontFamily: 'Arial',
              ),
            ),
            TextSpan(
              text: 'g',
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9C27B0),
                fontFamily: 'Arial',
              ),
            ),
            TextSpan(
              text: 'o',
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w400,
                color: Color(0xFFAB47BC),
                fontFamily: 'Arial',
              ),
            ),
            TextSpan(
              text: 'g',
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w400,
                color: Color(0xFF7B1FA2),
                fontFamily: 'Arial',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: MediaQuery.of(context).size.width > 600 ? 584 : MediaQuery.of(context).size.width * 0.9,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border.all(color: _isHovered ? const Color(0xFF7B1FA2) : const Color(0xFF424242), width: 1),
        borderRadius: BorderRadius.circular(24),
        boxShadow: _isHovered
            ? [
                BoxShadow(
                  color: const Color(0xFF7B1FA2).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintText: 'Search Golligog or type a URL',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Icon(Icons.search, color: Colors.grey, size: 20),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                    tooltip: 'Clear',
                  ),
                IconButton(
                  onPressed: () {
                    _performSearch(_searchController.text);
                  },
                  icon: const Icon(Icons.search, color: Color(0xFF7B1FA2), size: 20),
                  tooltip: 'Search',
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mic, color: Colors.grey, size: 20),
                  tooltip: 'Voice search',
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt, color: Colors.grey, size: 20),
                  tooltip: 'Search by image',
                ),
              ],
            ),
          ),
          onSubmitted: (value) {
            _performSearch(value);
          },
          onChanged: (value) {
            setState(() {}); // To show/hide clear button
          },
        ),
      ),
    );
  }

  Widget _buildSearchButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton('Golligog Search'),
          const SizedBox(width: 15),
          _buildButton("I'm Feeling Lucky"),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF424242), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            if (text == 'Golligog Search') {
              _performSearch(_searchController.text);
            } else {
              // I'm Feeling Lucky functionality
              _performLuckySearch();
            }
          },
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Golligog offered in: हिन्दी বাংলা తెలుగు मराठी தமிழ் ગુજરાતી ಕನ್ನಡ മലയാളം ਪੰਜਾਬੀ',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF7B1FA2),
          fontSize: 13,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }



  Future<void> _performSearch(String query) async {
    if (query.trim().isNotEmpty) {
      final trimmedQuery = query.trim();
      
      // Save search to history if user is logged in
      if (_isLoggedIn) {
        try {
          await AuthService.saveSearchHistory(trimmedQuery);
        } catch (e) {
          // Don't block search if history save fails
          print('Failed to save search history: $e');
        }
      }
      
      // Navigate to search results page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(query: trimmedQuery),
        ),
      );
    } else {
      // Show error if search is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a search term'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _performLuckySearch() {
    // I'm Feeling Lucky functionality - search with random term or first suggestion
    String query = _searchController.text.trim();
    if (query.isEmpty) {
      // If no search term, use a random popular search
      final luckySearches = ['Flutter', 'Programming', 'Technology', 'AI', 'Science'];
      query = (luckySearches..shuffle()).first;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(query: query),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
