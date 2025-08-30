import 'package:flutter/material.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with search bar
          _buildHeader(),
          
          // Results section
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Golligog logo (smaller)
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'G',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF4285F4),
                    ),
                  ),
                  TextSpan(
                    text: 'o',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFEA4335),
                    ),
                  ),
                  TextSpan(
                    text: 'l',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFFBBC05),
                    ),
                  ),
                  TextSpan(
                    text: 'l',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF4285F4),
                    ),
                  ),
                  TextSpan(
                    text: 'i',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF34A853),
                    ),
                  ),
                  TextSpan(
                    text: 'g',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFEA4335),
                    ),
                  ),
                  TextSpan(
                    text: 'o',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFFBBC05),
                    ),
                  ),
                  TextSpan(
                    text: 'g',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF4285F4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 30),
          
          // Search bar
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear, color: Colors.grey),
                        ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.mic, color: Colors.grey),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultsPage(query: value.trim()),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          
          const SizedBox(width: 20),
          
          // Top nav options
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Images', style: TextStyle(color: Colors.black54)),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Videos', style: TextStyle(color: Colors.black54)),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('News', style: TextStyle(color: Colors.black54)),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search stats
          Text(
            'About 15,70,00,000 results (0.45 seconds) for "${widget.query}"',
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          
          const SizedBox(height: 20),
          
          // Mock search results
          ...List.generate(10, (index) => _buildSearchResult(index)),
        ],
      ),
    );
  }

  Widget _buildSearchResult(int index) {
    final mockTitles = [
      'What is ${widget.query}? - Complete Guide and Overview',
      '${widget.query} - Wikipedia',
      'Learn ${widget.query} - Best Practices and Tips',
      '${widget.query} Tutorial for Beginners',
      'Advanced ${widget.query} Techniques',
      'Top 10 ${widget.query} Resources',
      '${widget.query} Examples and Use Cases',
      'How to master ${widget.query}',
      '${widget.query} - Latest News and Updates',
      'Free ${widget.query} Tools and Resources',
    ];

    final mockUrls = [
      'https://example.com/${widget.query.toLowerCase()}-guide',
      'https://en.wikipedia.org/wiki/${widget.query}',
      'https://learn${widget.query.toLowerCase()}.com',
      'https://tutorial.${widget.query.toLowerCase()}.org',
      'https://advanced${widget.query.toLowerCase()}.net',
      'https://top10${widget.query.toLowerCase()}.com',
      'https://examples.${widget.query.toLowerCase()}.edu',
      'https://master${widget.query.toLowerCase()}.io',
      'https://news.${widget.query.toLowerCase()}.com',
      'https://free${widget.query.toLowerCase()}.tools',
    ];

    final mockDescriptions = [
      'A comprehensive guide to understanding ${widget.query}. Learn everything you need to know about ${widget.query} with detailed explanations and examples.',
      '${widget.query} is a comprehensive topic that covers various aspects. This article provides detailed information about ${widget.query} and its applications.',
      'Discover the best practices for ${widget.query}. Our expert tips will help you master ${widget.query} quickly and efficiently.',
      'Start your journey with ${widget.query} using our beginner-friendly tutorial. Step-by-step instructions included.',
      'Take your ${widget.query} skills to the next level with advanced techniques and professional strategies.',
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // URL and menu
          Row(
            children: [
              Expanded(
                child: Text(
                  mockUrls[index],
                  style: const TextStyle(color: Colors.green, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, size: 16, color: Colors.grey),
              ),
            ],
          ),
          
          const SizedBox(height: 2),
          
          // Title
          GestureDetector(
            onTap: () {
              // Handle result click
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Clicked: ${mockTitles[index]}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Text(
              mockTitles[index],
              style: const TextStyle(
                color: Color(0xFF1a0dab),
                fontSize: 20,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          
          const SizedBox(height: 5),
          
          // Description
          Text(
            mockDescriptions[index % mockDescriptions.length],
            style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
