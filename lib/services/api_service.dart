// lib/services/api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/article.dart';
import 'auth_service.dart';

/// Main API service for news editorial app
class ApiService {
  // ========== CONFIGURATION ==========

  /// Base URL for API - THAY ĐỔI URL NÀY THEO BACKEND CỦA BẠN
  // static const String baseUrl = 'http://localhost:3000/api';
  static const String baseUrl = 'http://localhost:3000/api';
  // Các URL khác có thể sử dụng:
  // Android Emulator: 'http://10.0.2.2:3000/api'
  // iOS Simulator: 'http://localhost:3000/api'
  // Local Network: 'http://192.168.1.100:3000/api'
  // Production: 'https://your-domain.com/api'

  /// Timeout duration for all requests
  static const Duration timeoutDuration = Duration(seconds: 30);

  /// Default headers for all requests
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'NewsEditorial/1.0',
  };

  /// Get headers with authentication token if available
  static Future<Map<String, String>> _getHeadersWithAuth() async {
    final headers = Map<String, String>.from(_headers);

    // Get auth token from AuthService
    final authService = AuthService();
    if (authService.token != null) {
      headers['Authorization'] = 'Bearer ${authService.token}';
    }

    return headers;
  }

  // ========== ERROR HANDLING ==========

  /// Handle HTTP errors and return user-friendly messages
  static String _handleHttpError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return 'Yêu cầu không hợp lệ (400)';
      case 401:
        return 'Không có quyền truy cập (401)';
      case 403:
        return 'Truy cập bị từ chối (403)';
      case 404:
        return 'Không tìm thấy dữ liệu (404)';
      case 429:
        return 'Quá nhiều yêu cầu, vui lòng thử lại sau (429)';
      case 500:
        return 'Lỗi máy chủ nội bộ (500)';
      case 502:
        return 'Bad Gateway (502)';
      case 503:
        return 'Dịch vụ tạm thời không khả dụng (503)';
      case 504:
        return 'Gateway Timeout (504)';
      default:
        return 'Lỗi không xác định (${response.statusCode})';
    }
  }

  /// Handle different types of exceptions
  static ApiError _handleException(dynamic error) {
    if (error is SocketException) {
      return ApiError.networkError();
    } else if (error is FormatException) {
      return const ApiError(
        message: 'Dữ liệu trả về không hợp lệ',
        errorCode: 'FORMAT_ERROR',
      );
    } else if (error is http.ClientException) {
      return ApiError.timeoutError();
    } else {
      return ApiError(
        message: 'Lỗi không xác định: ${error.toString()}',
        errorCode: 'UNKNOWN_ERROR',
      );
    }
  }

  // ========== ARTICLES API ==========

  /// Fetch articles with filters and pagination
  ///
  /// Parameters:
  /// - [category]: Filter by category (null = all categories)
  /// - [source]: Filter by source (null = all sources)
  /// - [search]: Search term in title/summary
  /// - [date]: Date filter ('today', 'week', 'month', null = all)
  /// - [page]: Page number (starts from 1)
  /// - [limit]: Number of articles per page
  static Future<ArticleResponse> fetchArticles({
    String? category,
    String? source,
    String? search,
    String? date,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Build query parameters
      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      // Add filters if provided
      if (category != null && category.isNotEmpty && category != 'Tất cả') {
        queryParams['category'] = _mapCategoryToEnglish(category);
      }

      if (source != null && source.isNotEmpty && source != 'Tất cả') {
        queryParams['source'] = _mapSourceToEnglish(source);
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      if (date != null && date.isNotEmpty && date != 'all') {
        queryParams['date'] = date;
      }

      // Build URI with query parameters
      final uri = Uri.parse('$baseUrl/articles').replace(queryParameters: queryParams);

      // Make HTTP request
      final response = await http
          .get(uri, headers: _headers)
          .timeout(timeoutDuration);

      // Check response status
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return ArticleResponse.fromJson(data);
      } else {
        throw ApiError(
          message: _handleHttpError(response),
          statusCode: response.statusCode,
        );
      }
    } catch (error) {
      throw _handleException(error);
    }
  }

  /// Fetch single article by ID
  static Future<Article> fetchArticle(String id) async {
    try {
      if (id.isEmpty) {
        throw const ApiError(
          message: 'ID bài viết không hợp lệ',
          errorCode: 'INVALID_ID',
        );
      }

      final response = await http
          .get(Uri.parse('$baseUrl/articles/$id'), headers: _headers)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Article.fromJson(data);
      } else {
        throw ApiError(
          message: _handleHttpError(response),
          statusCode: response.statusCode,
        );
      }
    } catch (error) {
      throw _handleException(error);
    }
  }

  /// Search articles by query
  // static Future<List<Article>> searchArticles(String query) async {
  //   try {
  //     if (query.trim().isEmpty) {
  //       return [];
  //     }
  //
  //     final uri = Uri.parse('$baseUrl/articles').replace(queryParameters: {
  //       'search': query.trim(),
  //       'limit': '50', // Higher limit for search results
  //     });
  //
  //     final response = await http
  //         .get(uri, headers: _headers)
  //         .timeout(timeoutDuration);
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body) as Map<String, dynamic>;
  //       final articleResponse = ArticleResponse.fromJson(data);
  //       return articleResponse.articles;
  //     } else {
  //       throw ApiError(
  //         message: _handleHttpError(response),
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } catch (error) {
  //     throw _handleException(error);
  //   }
  // }

  /// Search articles by query
  static Future<List<Article>> searchArticles(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      // Sửa lại path - backend dùng /articles/search/:query
      final uri = Uri.parse('$baseUrl/articles/search/${Uri.encodeComponent(query)}');

      final response = await http
          .get(uri, headers: _headers)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final articles = data['articles'] as List;
        return articles.map((json) => Article.fromJson(json)).toList();
      } else {
        throw ApiError(
          message: _handleHttpError(response),
          statusCode: response.statusCode,
        );
      }
    } catch (error) {
      throw _handleException(error);
    }
  }

  // ========== METADATA API ==========

  /// Fetch available categories from API
  static Future<List<String>> fetchCategories() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/categories'), headers: _headers)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List;
        final categories = data.map((item) => item.toString()).toList();

        // Ensure "Tất cả" is first
        if (!categories.contains('Tất cả')) {
          categories.insert(0, 'Tất cả');
        }

        return categories;
      } else {
        return _getDefaultCategories();
      }
    } catch (error) {
      // Return default categories if API fails
      return _getDefaultCategories();
    }
  }

  /// Fetch available sources from API
  static Future<List<String>> fetchSources() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/sources'), headers: _headers)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List;
        final sources = data
            .map((source) => _mapSourceToVietnamese(source.toString()))
            .toList();

        // Ensure "Tất cả" is first
        if (!sources.contains('Tất cả')) {
          sources.insert(0, 'Tất cả');
        }

        return sources;
      } else {
        return _getDefaultSources();
      }
    } catch (error) {
      return _getDefaultSources();
    }
  }

  /// Fetch dashboard statistics
  static Future<NewsStats> fetchStats() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/stats'), headers: _headers)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return NewsStats.fromJson(data);
      } else {
        throw ApiError(
          message: _handleHttpError(response),
          statusCode: response.statusCode,
        );
      }
    } catch (error) {
      throw _handleException(error);
    }
  }

  // ========== WRITE OPERATIONS (Optional) ==========

  /// Create new article (for admin/crawler use)
  static Future<Article> createArticle(Article article) async {
    try {
      final response = await http
          .post(
        Uri.parse('$baseUrl/articles'),
        headers: _headers,
        body: json.encode(article.toJson()),
      )
          .timeout(timeoutDuration);

      if (response.statusCode == 201) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Article.fromJson(data);
      } else if (response.statusCode == 409) {
        throw const ApiError(
          message: 'Bài viết đã tồn tại',
          statusCode: 409,
          errorCode: 'DUPLICATE_ARTICLE',
        );
      } else {
        throw ApiError(
          message: _handleHttpError(response),
          statusCode: response.statusCode,
        );
      }
    } catch (error) {
      throw _handleException(error);
    }
  }

  /// Update existing article
  static Future<Article> updateArticle(String id, Article article) async {
    try {
      final response = await http
          .put(
        Uri.parse('$baseUrl/articles/$id'),
        headers: _headers,
        body: json.encode(article.toJson()),
      )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Article.fromJson(data);
      } else {
        throw ApiError(
          message: _handleHttpError(response),
          statusCode: response.statusCode,
        );
      }
    } catch (error) {
      throw _handleException(error);
    }
  }

  /// Delete article
  static Future<void> deleteArticle(String id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/articles/$id'), headers: _headers)
          .timeout(timeoutDuration);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiError(
          message: _handleHttpError(response),
          statusCode: response.statusCode,
        );
      }
    } catch (error) {
      throw _handleException(error);
    }
  }

  // ========== UTILITY METHODS ==========

  /// Test API connection
  static Future<bool> testConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/stats'), headers: _headers)
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  /// Check API health with detailed info
  static Future<Map<String, dynamic>> checkHealth() async {
    try {
      final stopwatch = Stopwatch()..start();

      final response = await http
          .get(Uri.parse('$baseUrl/health'), headers: _headers)
          .timeout(const Duration(seconds: 10));

      stopwatch.stop();

      return {
        'status': response.statusCode == 200 ? 'healthy' : 'unhealthy',
        'statusCode': response.statusCode,
        'responseTime': stopwatch.elapsedMilliseconds,
        'timestamp': DateTime.now().toIso8601String(),
        'baseUrl': baseUrl,
      };
    } catch (error) {
      return {
        'status': 'error',
        'error': error.toString(),
        'timestamp': DateTime.now().toIso8601String(),
        'baseUrl': baseUrl,
      };
    }
  }

  // ========== MAPPING HELPERS ==========

  /// Map Vietnamese category names to English (for API)
  static String _mapCategoryToEnglish(String vietnameseCategory) {
    const Map<String, String> categoryMap = {
      'Thời sự': 'Xã hội',
      'Thế giới': 'Thế giới',
      'Kinh doanh': 'Kinh tế',
      'Khoa học': 'Công nghệ',
      'Khoa học công nghệ': 'Công nghệ',
      'Giải trí': 'Giải trí',
      'Thể thao': 'Thể thao',
      'Pháp luật': 'Pháp luật',
      'Giáo dục': 'Giáo dục',
      'Sức khỏe': 'Sức khỏe',
      'Đời sống': 'Đời sống',
      'Du lịch': 'Du lịch',
      'Xe': 'Xe',
      'Ý kiến': 'Ý kiến',
    };

    return categoryMap[vietnameseCategory] ?? vietnameseCategory;
  }

  /// Map Vietnamese source names to English (for API)
  static String _mapSourceToEnglish(String vietnameseSource) {
    const Map<String, String> sourceMap = {
      'Dân Trí': 'dantri',
      'VnExpress': 'vnexpress',
    };

    return sourceMap[vietnameseSource] ?? vietnameseSource.toLowerCase();
  }

  /// Map English source names to Vietnamese (for display)
  static String _mapSourceToVietnamese(String englishSource) {
    const Map<String, String> sourceMap = {
      'dantri': 'Dân Trí',
      'vnexpress': 'VnExpress',
    };

    return sourceMap[englishSource.toLowerCase()] ?? englishSource;
  }

  // ========== DEFAULT DATA ==========

  /// Get default categories if API fails
  static List<String> _getDefaultCategories() {
    return [
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
    ];
  }

  /// Get default sources if API fails
  static List<String> _getDefaultSources() {
    return ['Tất cả', 'Dân Trí', 'VnExpress'];
  }

  // ========== BATCH OPERATIONS ==========

  /// Fetch multiple articles by IDs
  static Future<List<Article>> fetchArticlesByIds(List<String> ids) async {
    try {
      if (ids.isEmpty) return [];

      final response = await http
          .post(
        Uri.parse('$baseUrl/articles/batch'),
        headers: _headers,
        body: json.encode({'ids': ids}),
      )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List;
        return data.map((json) => Article.fromJson(json)).toList();
      } else {
        throw ApiError(
          message: _handleHttpError(response),
          statusCode: response.statusCode,
        );
      }
    } catch (error) {
      throw _handleException(error);
    }
  }

  // ========== CACHE HELPERS ==========

  /// Get cache key for API requests
  static String getCacheKey(String endpoint, Map<String, String>? params) {
    final paramString = params?.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&') ?? '';

    return '${endpoint}_$paramString'.hashCode.toString();
  }

  // ========== DEBUG HELPERS ==========

  /// Log API request for debugging
  static void _logRequest(String method, String url, {Map<String, String>? params}) {
    if (const bool.fromEnvironment('DEBUG_API', defaultValue: false)) {
      print('🌐 API $method: $url');
      if (params != null && params.isNotEmpty) {
        print('📋 Params: $params');
      }
    }
  }

  /// Log API response for debugging
  static void _logResponse(int statusCode, String url, {dynamic data}) {
    if (const bool.fromEnvironment('DEBUG_API', defaultValue: false)) {
      print('📥 Response [$statusCode]: $url');
      if (data != null) {
        print('📊 Data: ${data.toString().substring(0, 100)}...');
      }
    }
  }
}