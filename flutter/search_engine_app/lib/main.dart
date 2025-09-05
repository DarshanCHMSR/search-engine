import 'package:flutter/material.dart';
import 'search_results_page.dart';
import 'auth_wrapper.dart';

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
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation bar
            _buildTopNavBar(),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 200,
                  ),
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
            
            // Footer
            _buildFooter(),
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
              style: TextStyle(color: Colors.black87, fontSize: 13),
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
              style: TextStyle(color: Colors.black87, fontSize: 13),
            ),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthWrapper(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4285F4),
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
                color: Color(0xFF4285F4),
                fontFamily: 'Arial',
              ),
            ),
            TextSpan(
              text: 'o',
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w400,
                color: Color(0xFFEA4335),
                fontFamily: 'Arial',
              ),
            ),
            TextSpan(
              text: 'l',
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w400,
                color: Color(0xFFFBBC05),
                fontFamily: 'Arial',
              ),
            ),
            TextSpan(
              text: 'l',
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4285F4),
                fontFamily: 'Arial',
              ),
            ),
            TextSpan(
              text: 'i',
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w400,
                color: Color(0xFF34A853),
                fontFamily: 'Arial',
              ),
            ),
            TextSpan(
              text: 'g',
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w400,
                color: Color(0xFFEA4335),
                fontFamily: 'Arial',
              ),
            ),
            TextSpan(
              text: 'o',
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w400,
                color: Color(0xFFFBBC05),
                fontFamily: 'Arial',
              ),
            ),
            TextSpan(
              text: 'g',
              style: TextStyle(
                fontSize: 90,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4285F4),
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
        color: Colors.white,
        border: Border.all(color: _isHovered ? Colors.grey.shade400 : Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(24),
        boxShadow: _isHovered
            ? [
                BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.grey.shade200,
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
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
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
                  icon: const Icon(Icons.search, color: Colors.blue, size: 20),
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
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300, width: 1),
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
                color: Color(0xFF3c4043),
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
          color: Color(0xFF1a0dab),
          fontSize: 13,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: const Text(
              'India',
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildFooterLink('About'),
                    _buildFooterLink('Advertising'),
                    _buildFooterLink('Business'),
                    _buildFooterLink('How Search works'),
                  ],
                ),
                Row(
                  children: [
                    _buildFooterLink('Privacy'),
                    _buildFooterLink('Terms'),
                    _buildFooterLink('Settings'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextButton(
        onPressed: () {},
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      // Navigate to search results page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(query: query.trim()),
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
