// lib/models/article.dart

/// Main Article model representing a news article
class Article {
  final String id;
  final String url;
  final String source;
  final String title;
  final String summary;
  final String content;
  final String author;
  final String publishDate;
  final String category;
  final List<String> tags;
  final String imageUrl;
  final String viewCount;
  final String crawlTimestamp;

  const Article({
    required this.id,
    required this.url,
    required this.source,
    required this.title,
    required this.summary,
    required this.content,
    required this.author,
    required this.publishDate,
    required this.category,
    required this.tags,
    required this.imageUrl,
    required this.viewCount,
    required this.crawlTimestamp,
  });

  /// Create Article from JSON (from MongoDB/API response)
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['_id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      publishDate: json['publish_date']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      tags: json['tags'] != null
          ? List<String>.from(json['tags'].map((x) => x.toString()))
          : <String>[],
      imageUrl: json['image_url']?.toString() ?? '',
      viewCount: json['view_count']?.toString() ?? '0',
      crawlTimestamp: json['crawl_timestamp']?.toString() ?? '',
    );
  }

  /// Convert Article to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'url': url,
      'source': source,
      'title': title,
      'summary': summary,
      'content': content,
      'author': author,
      'publish_date': publishDate,
      'category': category,
      'tags': tags,
      'image_url': imageUrl,
      'view_count': viewCount,
      'crawl_timestamp': crawlTimestamp,
    };
  }

  /// Create a copy of Article with updated fields
  Article copyWith({
    String? id,
    String? url,
    String? source,
    String? title,
    String? summary,
    String? content,
    String? author,
    String? publishDate,
    String? category,
    List<String>? tags,
    String? imageUrl,
    String? viewCount,
    String? crawlTimestamp,
  }) {
    return Article(
      id: id ?? this.id,
      url: url ?? this.url,
      source: source ?? this.source,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      author: author ?? this.author,
      publishDate: publishDate ?? this.publishDate,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      viewCount: viewCount ?? this.viewCount,
      crawlTimestamp: crawlTimestamp ?? this.crawlTimestamp,
    );
  }

  /// Check if this is a breaking news article (published in last 2 hours)
  bool get isBreakingNews {
    try {
      final publishDateTime = DateTime.parse(publishDate.replaceAll(' ', 'T') + ':00');
      final now = DateTime.now();
      final difference = now.difference(publishDateTime);
      return difference.inHours < 2;
    } catch (e) {
      return false;
    }
  }

  /// Get readable view count
  String get readableViewCount {
    try {
      final count = int.parse(viewCount.replaceAll(',', ''));
      if (count >= 1000000) {
        return '${(count / 1000000).toStringAsFixed(1)}M';
      } else if (count >= 1000) {
        return '${(count / 1000).toStringAsFixed(1)}K';
      }
      return viewCount;
    } catch (e) {
      return viewCount;
    }
  }

  /// Check if article has valid image
  bool get hasValidImage {
    return imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
  }

  /// Get source display name
  String get sourceDisplayName {
    switch (source.toLowerCase()) {
      case 'vnexpress':
        return 'VnExpress';
      case 'dantri':
        return 'Dân Trí';
      default:
        return source;
    }
  }

  /// Get source short name for badges
  String get sourceShortName {
    switch (source.toLowerCase()) {
      case 'vnexpress':
        return 'VE';
      case 'dantri':
        return 'DT';
      default:
        return source.length > 2 ? source.substring(0, 2).toUpperCase() : source;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Article &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Article{id: $id, title: $title, source: $source, category: $category}';
  }
}

/// Response model for paginated articles API
class ArticleResponse {
  final List<Article> articles;
  final int totalPages;
  final int currentPage;
  final int total;
  final bool hasMore;

  const ArticleResponse({
    required this.articles,
    required this.totalPages,
    required this.currentPage,
    required this.total,
    required this.hasMore,
  });

  factory ArticleResponse.fromJson(Map<String, dynamic> json) {
    final articlesList = json['articles'] as List? ?? [];
    final totalPages = json['totalPages'] as int? ?? 1;
    final currentPage = json['currentPage'] as int? ?? 1;

    return ArticleResponse(
      articles: articlesList
          .map((articleJson) => Article.fromJson(articleJson as Map<String, dynamic>))
          .toList(),
      totalPages: totalPages,
      currentPage: currentPage,
      total: json['total'] as int? ?? 0,
      hasMore: currentPage < totalPages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'articles': articles.map((article) => article.toJson()).toList(),
      'totalPages': totalPages,
      'currentPage': currentPage,
      'total': total,
    };
  }

  @override
  String toString() {
    return 'ArticleResponse{articles: ${articles.length}, currentPage: $currentPage, totalPages: $totalPages}';
  }
}

/// Dashboard statistics model
class NewsStats {
  final int totalArticles;
  final int totalViews;
  final String topCategory;
  final int todayArticles;
  final Map<String, int>? categoryBreakdown;
  final Map<String, int>? sourceBreakdown;

  const NewsStats({
    required this.totalArticles,
    required this.totalViews,
    required this.topCategory,
    required this.todayArticles,
    this.categoryBreakdown,
    this.sourceBreakdown,
  });

  factory NewsStats.fromJson(Map<String, dynamic> json) {
    return NewsStats(
      totalArticles: json['totalArticles'] as int? ?? 0,
      totalViews: json['totalViews'] as int? ?? 0,
      topCategory: json['topCategory'] as String? ?? '',
      todayArticles: json['todayArticles'] as int? ?? 0,
      categoryBreakdown: json['categoryBreakdown'] != null
          ? Map<String, int>.from(json['categoryBreakdown'])
          : null,
      sourceBreakdown: json['sourceBreakdown'] != null
          ? Map<String, int>.from(json['sourceBreakdown'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalArticles': totalArticles,
      'totalViews': totalViews,
      'topCategory': topCategory,
      'todayArticles': todayArticles,
      if (categoryBreakdown != null) 'categoryBreakdown': categoryBreakdown,
      if (sourceBreakdown != null) 'sourceBreakdown': sourceBreakdown,
    };
  }

  /// Get formatted total views string
  String get formattedTotalViews {
    if (totalViews >= 1000000) {
      return '${(totalViews / 1000000).toStringAsFixed(1)}M';
    } else if (totalViews >= 1000) {
      return '${(totalViews / 1000).toStringAsFixed(1)}K';
    }
    return totalViews.toString();
  }

  /// Check if today has high activity (more than average)
  bool get isHighActivityDay {
    if (totalArticles == 0) return false;
    final averagePerDay = totalArticles / 30; // Assuming 30 days of data
    return todayArticles > averagePerDay;
  }

  @override
  String toString() {
    return 'NewsStats{totalArticles: $totalArticles, totalViews: $totalViews, topCategory: $topCategory, todayArticles: $todayArticles}';
  }
}

/// Search query model for API requests
class SearchQuery {
  final String query;
  final String? category;
  final String? source;
  final String? dateFilter;
  final int page;
  final int limit;

  const SearchQuery({
    required this.query,
    this.category,
    this.source,
    this.dateFilter,
    this.page = 1,
    this.limit = 20,
  });

  Map<String, String> toQueryParameters() {
    final Map<String, String> params = {
      'search': query,
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (category != null && category!.isNotEmpty && category != 'Tất cả') {
      params['category'] = category!;
    }

    if (source != null && source!.isNotEmpty && source != 'Tất cả') {
      params['source'] = source!;
    }

    if (dateFilter != null && dateFilter!.isNotEmpty && dateFilter != 'all') {
      params['date'] = dateFilter!;
    }

    return params;
  }

  @override
  String toString() {
    return 'SearchQuery{query: $query, category: $category, source: $source, dateFilter: $dateFilter, page: $page, limit: $limit}';
  }
}

/// Filter options model
class FilterOptions {
  final List<String> categories;
  final List<String> sources;
  final Map<String, String> dateFilters;

  const FilterOptions({
    required this.categories,
    required this.sources,
    required this.dateFilters,
  });

  factory FilterOptions.fromJson(Map<String, dynamic> json) {
    return FilterOptions(
      categories: List<String>.from(json['categories'] ?? []),
      sources: List<String>.from(json['sources'] ?? []),
      dateFilters: Map<String, String>.from(json['dateFilters'] ?? {}),
    );
  }

  /// Get default filter options
  factory FilterOptions.defaultOptions() {
    return const FilterOptions(
      categories: [
        'Tất cả',
        'Thời sự',
        'Thế giới',
        'Kinh doanh',
        'Khoa học công nghệ',
        'Giải trí',
        'Thể thao',
        'Pháp luật',
        'Giáo dục',
        'Sức khỏe',
        'Đời sống',
        'Du lịch',
        'Xe',
        'Ý kiến'
      ],
      sources: [
        'Tất cả',
        'Dân Trí',
        'VnExpress'
      ],
      dateFilters: {
        'all': 'Tất cả thời gian',
        'today': 'Hôm nay',
        'week': 'Tuần này',
        'month': 'Tháng này',
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories,
      'sources': sources,
      'dateFilters': dateFilters,
    };
  }
}

/// API error model
class ApiError {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final Map<String, dynamic>? details;

  const ApiError({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.details,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['message'] as String? ?? 'Unknown error',
      statusCode: json['statusCode'] as int?,
      errorCode: json['errorCode'] as String?,
      details: json['details'] as Map<String, dynamic>?,
    );
  }

  /// Create network error
  factory ApiError.networkError() {
    return const ApiError(
      message: 'Không có kết nối internet',
      statusCode: 0,
      errorCode: 'NETWORK_ERROR',
    );
  }

  /// Create timeout error
  factory ApiError.timeoutError() {
    return const ApiError(
      message: 'Kết nối quá thời gian chờ',
      statusCode: 408,
      errorCode: 'TIMEOUT_ERROR',
    );
  }

  /// Create server error
  factory ApiError.serverError([String? customMessage]) {
    return ApiError(
      message: customMessage ?? 'Lỗi máy chủ nội bộ',
      statusCode: 500,
      errorCode: 'SERVER_ERROR',
    );
  }

  @override
  String toString() {
    return 'ApiError{message: $message, statusCode: $statusCode, errorCode: $errorCode}';
  }
}