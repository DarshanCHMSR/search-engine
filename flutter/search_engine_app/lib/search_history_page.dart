import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class SearchHistoryPage extends StatefulWidget {
  const SearchHistoryPage({super.key});

  @override
  State<SearchHistoryPage> createState() => _SearchHistoryPageState();
}

class _SearchHistoryPageState extends State<SearchHistoryPage> {
  List<Map<String, dynamic>> _searchHistory = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await AuthService.getSearchHistory();
      if (result['success']) {
        setState(() {
          _searchHistory = List<Map<String, dynamic>>.from(
            result['data']['searchHistory'] ?? []
          );
        });
      } else {
        setState(() {
          _error = result['message'];
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load search history: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteHistoryItem(String historyId) async {
    try {
      final result = await AuthService.deleteSearchHistoryItem(historyId);
      if (result['success']) {
        // Remove item from local list
        setState(() {
          _searchHistory.removeWhere((item) => item['id'] == historyId);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Search history item deleted'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _clearAllHistory() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text('Are you sure you want to clear all search history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final result = await AuthService.clearSearchHistory();
        if (result['success']) {
          setState(() {
            _searchHistory.clear();
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('All search history cleared'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing history: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return '${difference.inMinutes} minutes ago';
        }
        return '${difference.inHours} hours ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (_searchHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearAllHistory,
              tooltip: 'Clear all history',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSearchHistory,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading search history',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSearchHistory,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_searchHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No search history yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your search queries will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSearchHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _searchHistory.length,
        itemBuilder: (context, index) {
          final item = _searchHistory[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(
                Icons.search,
                color: Colors.blue,
              ),
              title: Text(
                item['query'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                _formatDate(item['createdAt'] ?? ''),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteHistoryItem(item['id']),
                tooltip: 'Delete this search',
              ),
              onTap: () {
                // Navigate back to search page with this query
                Navigator.pop(context, item['query']);
              },
            ),
          );
        },
      ),
    );
  }
}
