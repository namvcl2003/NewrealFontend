import 'package:flutter/foundation.dart';
import '../models/article.dart';
import '../services/api_service.dart';

enum LoadingState { idle, loading, success, error, refreshing }

class ArticleProvider with ChangeNotifier {
  // Private fields
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  NewsStats? _stats;
  List<String> _categories = [];
  List<String> _sources = [];

  LoadingState _loadingState = LoadingState.idle;
  String _errorMessage = '';

  // Filters
  String _selectedCategory = 'Tất cả';
  String _selectedSource = 'Tất cả';
  String _searchQuery = '';
  String _dateFilter = 'all';

  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;

  // Getters
  List<Article> get articles => _articles;
  List<Article> get filteredArticles => _filteredArticles;
  NewsStats? get stats => _stats;
  List<String> get categories => _categories;
  List<String> get sources => _sources;

  LoadingState get loadingState => _loadingState;
  String get errorMessage => _errorMessage;
  bool get isLoading => _loadingState == LoadingState.loading;
  bool get isRefreshing => _loadingState == LoadingState.refreshing;
  bool get hasError => _loadingState == LoadingState.error;
  bool get hasMore => _hasMore;

  // Filter getters
  String get selectedCategory => _selectedCategory;
  String get selectedSource => _selectedSource;
  String get searchQuery => _searchQuery;
  String get dateFilter => _dateFilter;

  // Initialize data
  Future<void> initializeData() async {
    _setLoadingState(LoadingState.loading);

    try {
      // Load sample data first for demo
      _loadSampleData();

      // Then try to load from API
      try {
        await Future.wait([
          _loadCategories(),
          _loadSources(),
          _loadStats(),
          _loadArticles(refresh: true),
        ]);
      } catch (e) {
        // If API fails, continue with sample data
        print('API failed, using sample data: $e');
      }

      _setLoadingState(LoadingState.success);
    } catch (e) {
      _setError('Không thể tải dữ liệu: ${e.toString()}');
    }
  }

  // Load sample data for demo
  void _loadSampleData() {
    _articles = [
      Article(
        id: "1",
        url: "https://vnexpress.net/sample1",
        source: "vnexpress",
        title: "'Hạ tầng số ở xã, phường không hoạt động thì phải khoảnh lại'",
        summary: "Thủ tướng Phạm Minh Chính yêu cầu rà soát toàn bộ hạ tầng số ở cơ sở, công trình nào đầu tư mà không hoạt động phải 'khoảnh lại', tránh lãng phí.",
        content: "Chiều 24/9, tại phiên họp Ban Chỉ đạo của Thủ tướng về phát triển Chính phủ số, Thủ tướng Phạm Minh Chính nhấn mạnh cần rà soát toàn bộ hạ tầng số tại các cơ sở. Những công trình đầu tư mà không hoạt động hiệu quả cần được 'khoảnh lại' để tránh lãng phí ngân sách nhà nước.",
        author: "Ngọc Thành",
        publishDate: "2025-09-25 16:30",
        category: "Thời sự",
        tags: ["Chính phủ số", "Thủ tướng", "Hạ tầng"],
        imageUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&h=400&fit=crop",
        viewCount: "12,540",
        crawlTimestamp: "2025-09-25 16:45:00",
      ),
      Article(
        id: "2",
        url: "https://vnexpress.net/sample2",
        source: "vnexpress",
        title: "Cảnh tan hoang ở thành phố Trung Quốc sau bão Ragasa",
        summary: "Bão Ragasa tràn qua miền đông Trung Quốc, gây thiệt hại nặng nề về người và tài sản.",
        content: "Bão Ragasa đổ bộ vào tỉnh Giang Tô với sức gió mạnh cấp 12, gây ra những thiệt hại nghiêm trọng. Nhiều tòa nhà bị hư hại, cây xanh đổ rạp khắp nơi. Chính quyền địa phương đã sơ tán hàng ngàn người dân đến nơi an toàn.",
        author: "Hồng Hạnh",
        publishDate: "2025-09-25 15:20",
        category: "Thế giới",
        tags: ["Thiên tai", "Trung Quốc", "Bão"],
        imageUrl: "https://images.unsplash.com/photo-1547036967-23d11aacaee0?w=600&h=400&fit=crop",
        viewCount: "8,930",
        crawlTimestamp: "2025-09-25 15:30:00",
      ),
      Article(
        id: "3",
        url: "https://dantri.com.vn/sample3",
        source: "dantri",
        title: "Vì sao báo đón đập vào Biển Đông?",
        summary: "Chuyên gia khí tượng giải thích nguyên nhân khiến nhiều cơn bão liên tiếp hướng vào Biển Đông trong thời gian gần đây.",
        content: "Theo Trung tâm Dự báo Khí tượng Thủy văn Quốc gia, nguyên nhân chính là do sự thay đổi của dòng chảy khí quyển và nhiệt độ nước biển. Hiện tượng La Nina cũng đang tác động mạnh đến hình thái thời tiết khu vực.",
        author: "Minh Đức",
        publishDate: "2025-09-25 14:15",
        category: "Khoa học",
        tags: ["Khí tượng", "Biển Đông", "Thiên tai"],
        imageUrl: "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?w=600&h=400&fit=crop",
        viewCount: "15,670",
        crawlTimestamp: "2025-09-25 14:30:00",
      ),
      Article(
        id: "4",
        url: "https://vnexpress.net/sample4",
        source: "vnexpress",
        title: "Lãn lớn L - N",
        summary: "Có lẻ trong các nhâm lần về phát âm, l-n là khó sửa nhất và cũng là điều khiến nhiều người lo lắng nhất.",
        content: "Trong tiếng Việt, âm L và N thường bị nhầm lẫn bởi nhiều người, đặc biệt là trẻ em. Đây là một trong những khó khăn phổ biến trong việc học phát âm tiếng Việt chuẩn. Các chuyên gia ngôn ngữ học khuyên nên luyện tập thường xuyên để cải thiện.",
        author: "Thu Hằng",
        publishDate: "2025-09-25 13:45",
        category: "Giáo dục",
        tags: ["Tiếng Việt", "Phát âm", "Học tập"],
        imageUrl: "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=600&h=400&fit=crop",
        viewCount: "6,720",
        crawlTimestamp: "2025-09-25 14:00:00",
      ),
      Article(
        id: "5",
        url: "https://vnexpress.net/sample5",
        source: "vnexpress",
        title: "Thị trường chứng khoán biến động mạnh cuối phiên",
        summary: "VN-Index giảm 8,5 điểm trong phiên chiều sau thông tin Fed có thể điều chỉnh lãi suất.",
        content: "Thị trường chứng khoán Việt Nam kết thúc phiên 25/9 trong sắc đỏ với VN-Index mất 8,5 điểm. Nguyên nhân chính được cho là do lo ngại Fed sẽ điều chỉnh lãi suất trong cuộc họp tới. Nhiều cổ phiếu ngân hàng và bất động sản giảm mạnh.",
        author: "Minh Sơn",
        publishDate: "2025-09-25 15:30",
        category: "Kinh doanh",
        tags: ["Chứng khoán", "VN-Index", "Tài chính"],
        imageUrl: "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=600&h=400&fit=crop",
        viewCount: "9,840",
        crawlTimestamp: "2025-09-25 15:45:00",
      ),
    ];

    _stats = NewsStats(
      totalArticles: _articles.length,
      totalViews: 52710,
      topCategory: "Thời sự",
      todayArticles: 3,
    );

    _categories = [
      'Tất cả', 'Thời sự', 'Thế giới', 'Kinh doanh', 'Khoa học',
      'Giải trí', 'Thể thao', 'Pháp luật', 'Giáo dục', 'Sức khỏe',
      'Đời sống', 'Du lịch', 'Xe', 'Ý kiến'
    ];

    _sources = ['Tất cả', 'Dân Trí', 'VnExpress'];
    _filteredArticles = List.from(_articles);
  }

  // Load articles from API
  Future<void> _loadArticles({bool refresh = false}) async {
    try {
      if (refresh) {
        _currentPage = 1;
        _hasMore = true;
      }

      final response = await ApiService.fetchArticles(
        category: _selectedCategory != 'Tất cả' ? _selectedCategory : null,
        source: _selectedSource != 'Tất cả' ? _selectedSource : null,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        date: _dateFilter != 'all' ? _dateFilter : null,
        page: _currentPage,
        limit: 20,
      );

      if (refresh) {
        _articles = response.articles;
      } else {
        _articles.addAll(response.articles);
      }

      _filteredArticles = List.from(_articles);
      _totalPages = response.totalPages;
      _hasMore = _currentPage < _totalPages;

    } catch (e) {
      // If API fails, keep sample data
      print('Failed to load articles from API: $e');
    }
  }

  // Load more articles (pagination)
  Future<void> loadMoreArticles() async {
    if (!_hasMore || _loadingState == LoadingState.loading) return;

    try {
      _currentPage++;
      await _loadArticles();
      notifyListeners();
    } catch (e) {
      _currentPage--; // Revert page number on error
      _setError('Không thể tải thêm bài viết: ${e.toString()}');
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    _setLoadingState(LoadingState.refreshing);

    try {
      await Future.wait([
        _loadStats(),
        _loadArticles(refresh: true),
      ]);

      _setLoadingState(LoadingState.success);
    } catch (e) {
      // Keep existing data if refresh fails
      _setLoadingState(LoadingState.success);
    }
  }

  // Load categories
  Future<void> _loadCategories() async {
    try {
      _categories = await ApiService.fetchCategories();
    } catch (e) {
      // Keep default categories if API fails
    }
  }

  // Load sources
  Future<void> _loadSources() async {
    try {
      _sources = await ApiService.fetchSources();
    } catch (e) {
      // Keep default sources if API fails
    }
  }

  // Load stats
  Future<void> _loadStats() async {
    try {
      _stats = await ApiService.fetchStats();
    } catch (e) {
      // Keep existing stats if API fails
    }
  }

  // Apply filters
  Future<void> applyFilters() async {
    _setLoadingState(LoadingState.loading);

    try {
      await _loadArticles(refresh: true);
      _setLoadingState(LoadingState.success);
    } catch (e) {
      // Filter locally if API fails
      _filterLocally();
      _setLoadingState(LoadingState.success);
    }
  }

  // Local filtering fallback
  void _filterLocally() {
    _filteredArticles = _articles.where((article) {
      bool matchesCategory = _selectedCategory == 'Tất cả' ||
          _mapCategoryToVietnamese(article.category) == _selectedCategory;
      bool matchesSource = _selectedSource == 'Tất cả' ||
          _mapSourceToVietnamese(article.source) == _selectedSource;
      bool matchesSearch = _searchQuery.isEmpty ||
          article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.summary.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSource && matchesSearch;
    }).toList();
  }

  // Set category filter
  void setCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      applyFilters();
    }
  }

  // Set source filter
  void setSource(String source) {
    if (_selectedSource != source) {
      _selectedSource = source;
      applyFilters();
    }
  }

  // Set search query
  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      applyFilters();
    }
  }

  // Set date filter
  void setDateFilter(String dateFilter) {
    if (_dateFilter != dateFilter) {
      _dateFilter = dateFilter;
      applyFilters();
    }
  }

  // Search articles
  Future<List<Article>> searchArticles(String query) async {
    try {
      return await ApiService.searchArticles(query);
    } catch (e) {
      // Fallback to local search
      return _articles.where((article) =>
      article.title.toLowerCase().contains(query.toLowerCase()) ||
          article.summary.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
  }

  // Get article by ID
  Future<Article?> getArticleById(String id) async {
    try {
      return await ApiService.fetchArticle(id);
    } catch (e) {
      // Fallback to local search
      try {
        return _articles.firstWhere((article) => article.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  // Clear filters
  void clearFilters() {
    _selectedCategory = 'Tất cả';
    _selectedSource = 'Tất cả';
    _searchQuery = '';
    _dateFilter = 'all';
    applyFilters();
  }

  // Helper methods for mapping
  String _mapCategoryToVietnamese(String category) {
    Map<String, String> categoryMap = {
      'Xã hội': 'Thời sự',
      'Kinh tế': 'Kinh doanh',
      'Công nghệ': 'Khoa học',
      'Thể thao': 'Thể thao',
      'Giải trí': 'Giải trí',
      'Pháp luật': 'Pháp luật',
    };
    return categoryMap[category] ?? category;
  }

  String _mapSourceToVietnamese(String source) {
    return source == 'dantri' ? 'Dân Trí' :
    source == 'vnexpress' ? 'VnExpress' : source;
  }

  // Private helper methods
  void _setLoadingState(LoadingState state) {
    _loadingState = state;
    if (state != LoadingState.error) {
      _errorMessage = '';
    }
    notifyListeners();
  }

  void _setError(String message) {
    _loadingState = LoadingState.error;
    _errorMessage = message;
    notifyListeners();
  }

  // Test API connection
  Future<bool> testConnection() async {
    return await ApiService.testConnection();
  }

  @override
  void dispose() {
    super.dispose();
  }








  // Add these methods to your ArticleProvider class (lib/providers/article_provider.dart)

// Get related articles by category (exclude current article)
  List<Article> getRelatedArticles(Article currentArticle, {int limit = 5}) {
    // Filter articles with same category, excluding current article
    final relatedArticles = _articles.where((article) {
      // Exclude current article
      if (article.id == currentArticle.id) return false;

      // Match category
      final currentCategory = _mapCategoryToVietnamese(currentArticle.category);
      final articleCategory = _mapCategoryToVietnamese(article.category);

      return currentCategory == articleCategory;
    }).toList();

    // Sort by publish date (newest first)
    relatedArticles.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.publishDate.replaceAll(' ', 'T') + ':00');
        final dateB = DateTime.parse(b.publishDate.replaceAll(' ', 'T') + ':00');
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });

    // Return limited number of articles
    return relatedArticles.take(limit).toList();
  }


// Get related articles by tags (SMART MATCHING)
  List<Article> getRelatedArticlesByTags(Article currentArticle, {int limit = 5}) {
    if (currentArticle.tags.isEmpty) {
      return getRelatedArticles(currentArticle, limit: limit);
    }

    // Calculate relevance score for each article
    final scoredArticles = <Map<String, dynamic>>[];

    for (final article in _articles) {
      // Skip current article
      if (article.id == currentArticle.id) continue;

      int score = 0;

      // Score based on matching tags
      for (final tag in currentArticle.tags) {
        if (article.tags.contains(tag)) {
          score += 3; // High weight for matching tags
        }
      }

      // Score based on same category
      final currentCategory = _mapCategoryToVietnamese(currentArticle.category);
      final articleCategory = _mapCategoryToVietnamese(article.category);
      if (currentCategory == articleCategory) {
        score += 2;
      }

      // Score based on same source
      if (article.source == currentArticle.source) {
        score += 1;
      }

      if (score > 0) {
        scoredArticles.add({
          'article': article,
          'score': score,
        });
      }
    }

    // Sort by score descending
    scoredArticles.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));

    // Return top articles
    return scoredArticles
        .take(limit)
        .map((item) => item['article'] as Article)
        .toList();
  }
}