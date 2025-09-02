import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/searxng_service.dart';
import 'models/search_models.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final TextEditingController _searchController = TextEditingController();
  final SearXNGService _searchService = SearXNGService();
  
  SearchResponse? _searchResponse;
  bool _isLoading = true;
  String? _error;
  String _currentCategory = 'general';

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    _performSearch(widget.query);
  }

  Future<void> _performSearch(String query, {String category = 'general'}) async {
    if (query.trim().isEmpty) return;
    
    print('DEBUG: Starting search for query: "$query", category: "$category"');
    
    setState(() {
      _isLoading = true;
      _error = null;
      _currentCategory = category;
    });

    try {
      print('DEBUG: Calling SearXNG API...');
      final response = await _searchService.search(
        query: query.trim(),
        category: category,
      );
      
      print('DEBUG: Search successful! Found ${response.results.length} results');
      setState(() {
        _searchResponse = response;
        _isLoading = false;
      });
    } catch (e) {
      print('DEBUG: Search failed with error: $e');
      print('DEBUG: Error type: ${e.runtimeType}');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
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
      child: Column(
        children: [
          Row(
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
                        _performSearch(value.trim());
                      }
                    },
                  ),
                ),
              ),
              
              const SizedBox(width: 20),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Category navigation
          Row(
            children: [
              _buildCategoryButton('All', 'general'),
              _buildCategoryButton('Images', 'images'),
              _buildCategoryButton('Videos', 'videos'),
              _buildCategoryButton('News', 'news'),
              _buildCategoryButton('Maps', 'map'),
              _buildCategoryButton('Books', 'files'),
              _buildCategoryButton('Scholar', 'science'),
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
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                'Search failed',
                style: TextStyle(fontSize: 18, color: Colors.red.shade700),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _performSearch(_searchController.text, category: _currentCategory),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_searchResponse == null || _searchResponse!.results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'No results found',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Text(
                'Try different keywords or search terms',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    // Display results based on category
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search stats
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'About ${_searchResponse!.number_of_results} results for "${_searchResponse!.query}"',
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ),
            
            // Suggestions
            if (_searchResponse!.suggestions != null && _searchResponse!.suggestions!.isNotEmpty)
              _buildSuggestions(),
            
            // Results based on category
            if (_currentCategory == 'images')
              _buildImageResults()
            else if (_currentCategory == 'videos')
              _buildVideoResults()
            else if (_currentCategory == 'news')
              _buildNewsResults()
            else if (_currentCategory == 'files' || _currentCategory == 'science')
              _buildDocumentResults()
            else
              _buildGeneralResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String label, String category) {
    final isSelected = _currentCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: TextButton(
        onPressed: () => _performSearch(_searchController.text, category: category),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Did you mean:',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: _searchResponse!.suggestions!.map((suggestion) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = suggestion;
                  _performSearch(suggestion);
                },
                child: Text(
                  suggestion,
                  style: const TextStyle(
                    color: Color(0xFF1a0dab),
                    decoration: TextDecoration.underline,
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildRealSearchResult(SearchResult result, int index) {
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
                  result.url,
                  style: const TextStyle(color: Colors.green, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (result.engine != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      result.engine!,
                      style: const TextStyle(fontSize: 10, color: Colors.black54),
                    ),
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
              // Here you could open the URL in a browser
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening: ${result.title}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Text(
              result.title,
              style: const TextStyle(
                color: Color(0xFF1a0dab),
                fontSize: 20,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          
          const SizedBox(height: 5),
          
          // Content/Description
          if (result.content.isNotEmpty)
            Text(
              result.content,
              style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          
          // Additional info (published date, author)
          if (result.publishedDate != null || result.author != null)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  if (result.publishedDate != null)
                    Text(
                      result.publishedDate!,
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  if (result.publishedDate != null && result.author != null)
                    const Text(' • ', style: TextStyle(color: Colors.black54, fontSize: 12)),
                  if (result.author != null)
                    Text(
                      'by ${result.author}',
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                ],
              ),
            ),
          
          // Thumbnail for images/videos
          if (result.thumbnail != null && result.thumbnail!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Image.network(
                result.thumbnail!,
                width: 120,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 90,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGeneralResults() {
    return Column(
      children: _searchResponse!.results.asMap().entries.map((entry) {
        return _buildRealSearchResult(entry.value, entry.key);
      }).toList(),
    );
  }

  Widget _buildImageResults() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: _searchResponse!.results.length,
      itemBuilder: (context, index) {
        final result = _searchResponse!.results[index];
        return _buildImageCard(result);
      },
    );
  }

  Widget _buildVideoResults() {
    return Column(
      children: _searchResponse!.results.asMap().entries.map((entry) {
        return _buildVideoCard(entry.value, entry.key);
      }).toList(),
    );
  }

  Widget _buildNewsResults() {
    return Column(
      children: _searchResponse!.results.asMap().entries.map((entry) {
        return _buildNewsCard(entry.value, entry.key);
      }).toList(),
    );
  }

  Widget _buildDocumentResults() {
    return Column(
      children: _searchResponse!.results.asMap().entries.map((entry) {
        return _buildDocumentCard(entry.value, entry.key);
      }).toList(),
    );
  }

  Widget _buildImageCard(SearchResult result) {
    return GestureDetector(
      onTap: () {
        // Open image in full view or navigate to source
        _launchURL(result.url);
      },
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  color: Colors.grey.shade200,
                ),
                child: (result.thumbnail != null && result.thumbnail!.isNotEmpty)
                    ? Image.network(
                        result.thumbnail!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          );
                        },
                      )
                    : (result.img_src != null && result.img_src!.isNotEmpty)
                        ? Image.network(
                            result.img_src!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image, color: Colors.grey),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Uri.parse(result.url).host,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(SearchResult result, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video thumbnail
          Container(
            width: 160,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: (result.thumbnail != null && result.thumbnail!.isNotEmpty)
                      ? Image.network(
                          result.thumbnail!,
                          width: 160,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.videocam, color: Colors.grey),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.videocam, color: Colors.grey),
                        ),
                ),
                // Play button overlay
                const Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Video details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _launchURL(result.url),
                  child: Text(
                    result.title,
                    style: const TextStyle(
                      color: Color(0xFF1a0dab),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  Uri.parse(result.url).host,
                  style: const TextStyle(color: Colors.green, fontSize: 14),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  result.content,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                if (result.publishedDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      result.publishedDate!,
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(SearchResult result, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // News thumbnail (if available)
          if (result.thumbnail != null && result.thumbnail!.isNotEmpty)
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  result.thumbnail!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.article, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
          
          // News content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _launchURL(result.url),
                  child: Text(
                    result.title,
                    style: const TextStyle(
                      color: Color(0xFF1a0dab),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Row(
                  children: [
                    Text(
                      Uri.parse(result.url).host,
                      style: const TextStyle(color: Colors.green, fontSize: 14),
                    ),
                    if (result.publishedDate != null) ...[
                      const Text(' • ', style: TextStyle(color: Colors.black54, fontSize: 14)),
                      Text(
                        result.publishedDate!,
                        style: const TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  result.content,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                if (result.author != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'by ${result.author}',
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(SearchResult result, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document icon
          Container(
            width: 48,
            height: 48,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.red.shade50,
            ),
            child: Icon(
              _getDocumentIcon(result.url),
              color: Colors.red.shade400,
              size: 24,
            ),
          ),
          
          // Document content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _launchURL(result.url),
                  child: Text(
                    result.title,
                    style: const TextStyle(
                      color: Color(0xFF1a0dab),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Row(
                  children: [
                    Text(
                      Uri.parse(result.url).host,
                      style: const TextStyle(color: Colors.green, fontSize: 14),
                    ),
                    const Text(' • ', style: TextStyle(color: Colors.black54, fontSize: 14)),
                    Text(
                      _getFileType(result.url),
                      style: const TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    if (result.publishedDate != null) ...[
                      const Text(' • ', style: TextStyle(color: Colors.black54, fontSize: 14)),
                      Text(
                        result.publishedDate!,
                        style: const TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  result.content,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                if (result.author != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'by ${result.author}',
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDocumentIcon(String url) {
    final extension = url.toLowerCase();
    if (extension.contains('.pdf')) return Icons.picture_as_pdf;
    if (extension.contains('.doc') || extension.contains('.docx')) return Icons.description;
    if (extension.contains('.xls') || extension.contains('.xlsx')) return Icons.table_chart;
    if (extension.contains('.ppt') || extension.contains('.pptx')) return Icons.slideshow;
    return Icons.article;
  }

  String _getFileType(String url) {
    final extension = url.toLowerCase();
    if (extension.contains('.pdf')) return 'PDF';
    if (extension.contains('.doc') || extension.contains('.docx')) return 'Word';
    if (extension.contains('.xls') || extension.contains('.xlsx')) return 'Excel';
    if (extension.contains('.ppt') || extension.contains('.pptx')) return 'PowerPoint';
    return 'Document';
  }

  void _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchService.dispose();
    super.dispose();
  }
}
