// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../models/article.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../utils/date_utils.dart';
import 'article_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isSearching = false;
  List<Article> _searchResults = [];
  List<String> _recentSearches = [];
  List<String> _suggestedKeywords = [];

  @override
  void initState() {
    super.initState();
    _initializeSearchData();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _initializeSearchData() {
    // Initialize with some sample data
    _recentSearches = [
      'Covid-19',
      'Kinh tế Việt Nam',
      'Bóng đá',
      'Thời tiết',
      'Công nghệ',
    ];

    _suggestedKeywords = [
      'Tin nóng hôm nay',
      'Chính trị',
      'Thể thao',
      'Giải trí',
      'Sức khỏe',
      'Giáo dục',
      'Du lịch',
      'Ô tô',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(),
            Expanded(
              child: _buildSearchContent(),
            ),
          ],
        ),
      ),
    );
  }

  /// Build search header with input and filters
  Widget _buildSearchHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          // Search input row
          Row(
            children: [
              // Back button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.black54),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),

              // Search input
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: AppStrings.searchPlaceholder,
                      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        onPressed: _clearSearch,
                        icon: Icon(Icons.clear, color: Colors.grey[600], size: 18),
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    style: const TextStyle(fontSize: 14),
                    onChanged: _onSearchChanged,
                    onSubmitted: _performSearch,
                    textInputAction: TextInputAction.search,
                  ),
                ),
              ),

              // Voice search button (placeholder)
              const SizedBox(width: 8),
              IconButton(
                onPressed: _startVoiceSearch,
                icon: const Icon(Icons.mic, color: Colors.black54),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          // Search filters (when searching)
          if (_isSearching || _searchResults.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildSearchFilters(),
          ],
        ],
      ),
    );
  }

  /// Build search filters
  Widget _buildSearchFilters() {
    return Consumer<ArticleProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('Tất cả', true),
              const SizedBox(width: 8),
              ...provider.categories.skip(1).map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildFilterChip(category, false),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  /// Build filter chip
  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : Colors.grey[700],
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        // TODO: Implement filter selection
      },
      backgroundColor: Colors.grey[200],
      selectedColor: AppTheme.primaryRed,
      checkmarkColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  /// Build search content based on state
  Widget _buildSearchContent() {
    if (_isSearching) {
      return _buildLoadingState();
    }

    if (_searchResults.isNotEmpty) {
      return _buildSearchResults();
    }

    if (_searchController.text.isNotEmpty && _searchResults.isEmpty) {
      return _buildNoResultsState();
    }

    return _buildInitialState();
  }

  /// Build initial state with suggestions
  Widget _buildInitialState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          if (_recentSearches.isNotEmpty) ...[
            _buildSectionHeader('Tìm kiếm gần đây', Icons.history),
            const SizedBox(height: 12),
            _buildRecentSearches(),
            const SizedBox(height: 24),
          ],

          // Suggested keywords
          _buildSectionHeader('Từ khóa gợi ý', Icons.lightbulb_outline),
          const SizedBox(height: 12),
          _buildSuggestedKeywords(),
          const SizedBox(height: 24),

          // Trending topics
          _buildSectionHeader('Chủ đề thịnh hành', Icons.trending_up),
          const SizedBox(height: 12),
          _buildTrendingTopics(),
        ],
      ),
    );
  }

  /// Build section header
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryRed),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryRed,
          ),
        ),
      ],
    );
  }

  /// Build recent searches
  Widget _buildRecentSearches() {
    return Column(
      children: _recentSearches.map((search) {
        return ListTile(
          leading: Icon(Icons.history, color: Colors.grey[600], size: 20),
          title: Text(search),
          trailing: IconButton(
            icon: Icon(Icons.north_west, color: Colors.grey[500], size: 18),
            onPressed: () => _fillSearchQuery(search),
          ),
          onTap: () => _performSearch(search),
          contentPadding: EdgeInsets.zero,
          dense: true,
        );
      }).toList(),
    );
  }

  /// Build suggested keywords
  Widget _buildSuggestedKeywords() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _suggestedKeywords.map((keyword) {
        return GestureDetector(
          onTap: () => _performSearch(keyword),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  keyword,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Build trending topics
  Widget _buildTrendingTopics() {
    final trendingTopics = [
      {'title': 'Thời tiết hôm nay', 'count': '1.2K'},
      {'title': 'Kết quả bóng đá', 'count': '856'},
      {'title': 'Tỷ giá USD', 'count': '634'},
      {'title': 'Covid-19 Việt Nam', 'count': '523'},
      {'title': 'Lịch thi đấu V-League', 'count': '445'},
    ];

    return Column(
      children: trendingTopics.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final topic = entry.value;

        return ListTile(
          leading: CircleAvatar(
            radius: 12,
            backgroundColor: AppTheme.primaryRed,
            child: Text(
              '$index',
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(topic['title']!),
          trailing: Text(
            '${topic['count']} tìm kiếm',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          onTap: () => _performSearch(topic['title']!),
          contentPadding: EdgeInsets.zero,
          dense: true,
        );
      }).toList(),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppTheme.primaryRed),
          const SizedBox(height: 16),
          Text(
            'Đang tìm kiếm...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// Build search results
  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results header
        Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          color: Colors.white,
          child: Text(
            'Tìm thấy ${_searchResults.length} kết quả cho "${_searchController.text}"',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              return _buildSearchResultItem(_searchResults[index]);
            },
          ),
        ),
      ],
    );
  }

  /// Build search result item
  Widget _buildSearchResultItem(Article article) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      child: InkWell(
        onTap: () => _navigateToArticleDetail(article),
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: article.hasValidImage
                    ? Image.network(
                  article.imageUrl,
                  height: AppConstants.thumbnailImageHeight,
                  width: AppConstants.thumbnailImageWidth,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                )
                    : _buildImagePlaceholder(),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category and source badges
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            article.category,
                            style: TextStyle(
                              color: AppTheme.primaryRed,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.getSourceColor(article.source),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            article.sourceShortName,
                            style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Title with search highlighting
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Summary
                    Text(
                      article.summary,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Metadata
                    Row(
                      children: [
                        Text(
                          AppDateUtils.formatRelativeDate(article.publishDate),
                          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.visibility, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 2),
                        Text(
                          article.viewCount,
                          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // More options button
              IconButton(
                onPressed: () => _showArticleOptions(article),
                icon: Icon(Icons.more_vert, color: Colors.grey[500], size: 18),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build image placeholder
  Widget _buildImagePlaceholder() {
    return Container(
      height: AppConstants.thumbnailImageHeight,
      width: AppConstants.thumbnailImageWidth,
      color: Colors.grey[300],
      child: Icon(Icons.image, size: 32, color: Colors.grey[500]),
    );
  }

  /// Build no results state
  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              AppStrings.noResults,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Không tìm thấy kết quả cho "${_searchController.text}"',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Suggestions for no results
            Text(
              'Gợi ý:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• Kiểm tra chính tả từ khóa', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                Text('• Thử sử dụng từ khóa khác', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                Text('• Sử dụng từ khóa tổng quát hơn', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
            const SizedBox(height: 24),

            // Quick search suggestions
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Thời sự', 'Thể thao', 'Kinh tế', 'Giải trí'].map((keyword) {
                return ActionChip(
                  label: Text(keyword),
                  onPressed: () => _performSearch(keyword),
                  backgroundColor: Colors.grey[100],
                  labelStyle: TextStyle(color: Colors.grey[700], fontSize: 12),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Action methods
  void _onSearchChanged(String query) {
    setState(() {
      // Update UI immediately
    });

    // TODO: Implement search suggestions/autocomplete
    if (query.length >= AppConstants.minSearchQueryLength) {
      _debounceSearch(query);
    }
  }

  void _debounceSearch(String query) {
    // TODO: Implement debounced search for suggestions
  }

  void _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    // Update search controller if different
    if (_searchController.text != query) {
      _searchController.text = query;
    }

    // Add to recent searches
    _addToRecentSearches(query);

    setState(() {
      _isSearching = true;
      _searchResults.clear();
    });

    try {
      final provider = Provider.of<ArticleProvider>(context, listen: false);
      final results = await provider.searchArticles(query);

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });

      _showErrorSnackBar('Lỗi tìm kiếm: ${e.toString()}');
    }
  }

  void _addToRecentSearches(String query) {
    setState(() {
      _recentSearches.remove(query); // Remove if exists
      _recentSearches.insert(0, query); // Add to beginning

      // Keep only last 10 searches
      if (_recentSearches.length > AppConstants.maxRecentSearches) {
        _recentSearches = _recentSearches.take(AppConstants.maxRecentSearches).toList();
      }
    });

    // TODO: Persist to SharedPreferences
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchResults.clear();
      _isSearching = false;
    });
    _searchFocusNode.requestFocus();
  }

  void _fillSearchQuery(String query) {
    _searchController.text = query;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
  }

  void _startVoiceSearch() {
    // TODO: Implement voice search
    _showInfoSnackBar('Tính năng tìm kiếm bằng giọng nói đang được phát triển');
  }

  void _navigateToArticleDetail(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(article: article),
      ),
    );
  }

  void _showArticleOptions(Article article) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Options
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Chia sẻ'),
              onTap: () {
                Navigator.pop(context);
                _shareArticle(article);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_border),
              title: const Text('Lưu bài'),
              onTap: () {
                Navigator.pop(context);
                _bookmarkArticle(article);
              },
            ),
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: const Text('Mở bài gốc'),
              onTap: () {
                Navigator.pop(context);
                _openOriginalArticle(article);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Sao chép liên kết'),
              onTap: () {
                Navigator.pop(context);
                _copyArticleLink(article);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareArticle(Article article) {
    // TODO: Implement article sharing
    _showInfoSnackBar('Tính năng chia sẻ đang được phát triển');
  }

  void _bookmarkArticle(Article article) {
    // TODO: Implement bookmark functionality
    _showInfoSnackBar('Tính năng lưu bài đang được phát triển');
  }

  void _openOriginalArticle(Article article) {
    // TODO: Implement open original article
    _showInfoSnackBar('Mở bài gốc: ${article.url}');
  }

  void _copyArticleLink(Article article) {
    // TODO: Implement copy link
    _showSuccessSnackBar('Đã sao chép liên kết');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}