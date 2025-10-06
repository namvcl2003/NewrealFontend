// lib/utils/constants.dart

/// App-wide constants for configuration and strings
class AppConstants {
  // ========== API CONFIGURATION ==========

  /// Base URL for API - should match api_service.dart
  static const String apiBaseUrl = 'http://localhost:3000/api';

  /// API timeout duration
  static const Duration apiTimeout = Duration(seconds: 30);

  /// API retry attempts
  static const int maxRetryAttempts = 3;

  /// API retry delay
  static const Duration retryDelay = Duration(seconds: 2);

  // ========== PAGINATION SETTINGS ==========

  /// Default number of articles per page
  static const int defaultPageSize = 20;

  /// Maximum number of articles per page
  static const int maxPageSize = 100;

  /// Minimum number of articles per page
  static const int minPageSize = 5;

  /// Load more threshold (pixels from bottom)
  static const double loadMoreThreshold = 200.0;

  // ========== IMAGE SETTINGS ==========

  /// Default height for featured article images
  static const double defaultImageHeight = 200.0;

  /// Height for thumbnail images in article cards
  static const double thumbnailImageHeight = 80.0;

  /// Width for thumbnail images in article cards
  static const double thumbnailImageWidth = 100.0;

  /// Image cache duration
  static const Duration imageCacheDuration = Duration(days: 7);

  /// Default placeholder image URL
  static const String placeholderImageUrl = 'https://via.placeholder.com/400x300/E0E0E0/757575?text=No+Image';

  // ========== UI DIMENSIONS ==========

  /// Default padding for containers
  static const double defaultPadding = 16.0;

  /// Small padding
  static const double smallPadding = 8.0;

  /// Large padding
  static const double largePadding = 24.0;

  /// Extra large padding
  static const double extraLargePadding = 32.0;

  /// Default border radius
  static const double defaultRadius = 8.0;

  /// Small border radius
  static const double smallRadius = 4.0;

  /// Large border radius
  static const double largeRadius = 12.0;

  /// Card elevation
  static const double cardElevation = 2.0;

  /// App bar elevation
  static const double appBarElevation = 2.0;

  // ========== ANIMATION DURATIONS ==========

  /// Short animation duration
  static const Duration shortAnimation = Duration(milliseconds: 200);

  /// Medium animation duration
  static const Duration mediumAnimation = Duration(milliseconds: 300);

  /// Long animation duration
  static const Duration longAnimation = Duration(milliseconds: 500);

  /// Page transition duration
  static const Duration pageTransition = Duration(milliseconds: 250);

  // ========== CATEGORIES - VNEXPRESS STYLE ==========

  /// Default categories list
  static const List<String> defaultCategories = [
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

  /// Category icons mapping
  static const Map<String, String> categoryIcons = {
    'Tất cả': '🏠',
    'Thời sự': '📰',
    'Thế giới': '🌍',
    'Kinh doanh': '💼',
    'Khoa học công nghệ': '🔬',
    'Giải trí': '🎭',
    'Thể thao': '⚽',
    'Pháp luật': '⚖️',
    'Giáo dục': '📚',
    'Sức khỏe': '🏥',
    'Đời sống': '🏡',
    'Du lịch': '✈️',
    'Xe': '🚗',
    'Ý kiến': '💭'
  };

  // ========== SOURCES ==========

  /// Default news sources
  static const List<String> defaultSources = [
    'Tất cả',
    'Dân Trí',
    'VnExpress'
  ];

  /// Source colors for badges
  static const Map<String, int> sourceColors = {
    'dantri': 0xFF1976D2,      // Blue
    'vnexpress': 0xFFB52D3D,   // VnExpress Red
  };

  /// Source short names for badges
  static const Map<String, String> sourceShortNames = {
    'dantri': 'DT',
    'vnexpress': 'VE',
  };

  // ========== DATE FILTERS ==========

  /// Date filter options
  static const Map<String, String> dateFilters = {
    'all': 'Tất cả thời gian',
    'today': 'Hôm nay',
    'week': 'Tuần này',
    'month': 'Tháng này',
    'year': 'Năm nay',
  };

  /// Date filter icons
  static const Map<String, String> dateFilterIcons = {
    'all': '📅',
    'today': '📋',
    'week': '📊',
    'month': '📈',
    'year': '📉',
  };

  // ========== CACHE SETTINGS ==========

  /// Cache expiration time for articles
  static const Duration articleCacheExpiration = Duration(minutes: 30);

  /// Cache expiration time for stats
  static const Duration statsCacheExpiration = Duration(minutes: 15);

  /// Cache expiration time for categories/sources
  static const Duration metadataCacheExpiration = Duration(hours: 24);

  /// Maximum cache size (number of items)
  static const int maxCacheSize = 1000;

  // ========== SEARCH SETTINGS ==========

  /// Minimum search query length
  static const int minSearchQueryLength = 2;

  /// Maximum search query length
  static const int maxSearchQueryLength = 100;

  /// Search debounce duration
  static const Duration searchDebounce = Duration(milliseconds: 500);

  /// Maximum search results
  static const int maxSearchResults = 50;

  // ========== BREAKING NEWS ==========

  /// Time window for breaking news (in hours)
  static const int breakingNewsHours = 2;

  /// Minimum view count for trending news
  static const int trendingViewThreshold = 10000;

  // ========== SHARING ==========

  /// App share text template
  static const String shareTextTemplate = 'Đọc tin tức từ {title} - {url}';

  /// Share hashtags
  static const List<String> shareHashtags = [
    '#TinTức',
    '#VnExpress',
    '#DânTrí',
    '#NewsApp'
  ];

  // ========== NOTIFICATION SETTINGS ==========

  /// Breaking news notification channel
  static const String breakingNewsChannelId = 'breaking_news';

  /// General news notification channel
  static const String generalNewsChannelId = 'general_news';

  /// Notification icon
  static const String notificationIcon = '@mipmap/ic_launcher';

  // ========== ANALYTICS ==========

  /// Events tracking
  static const Map<String, String> analyticsEvents = {
    'articleRead': 'article_read',
    'articleShare': 'article_share',
    'categoryFilter': 'category_filter',
    'sourceFilter': 'source_filter',
    'search': 'search_query',
    'refresh': 'refresh_data',
  };

  // ========== FEATURE FLAGS ==========

  /// Enable offline mode
  static const bool enableOfflineMode = true;

  /// Enable push notifications
  static const bool enablePushNotifications = true;

  /// Enable article bookmarking
  static const bool enableBookmarks = true;

  /// Enable dark mode
  static const bool enableDarkMode = true;

  /// Enable analytics
  static const bool enableAnalytics = false;

  /// Enable crash reporting
  static const bool enableCrashReporting = false;

  // ========== DEVELOPMENT ==========

  /// Debug mode flag
  static const bool isDebugMode = bool.fromEnvironment('DEBUG', defaultValue: false);

  /// Show debug info
  static const bool showDebugInfo = bool.fromEnvironment('DEBUG_INFO', defaultValue: false);

  /// Enable API logging
  static const bool enableApiLogging = bool.fromEnvironment('DEBUG_API', defaultValue: false);

  /// Mock data for testing
  static const bool useMockData = bool.fromEnvironment('MOCK_DATA', defaultValue: false);

  // ========== LIMITS ==========

  /// Maximum title length for display
  static const int maxTitleLength = 200;

  /// Maximum summary length for display
  static const int maxSummaryLength = 500;

  /// Maximum content length for display
  static const int maxContentLength = 10000;

  /// Maximum tags per article
  static const int maxTagsPerArticle = 10;

  /// Maximum recent searches to store
  static const int maxRecentSearches = 20;

  // ========== VALIDATION ==========

  /// URL validation regex
  static const String urlRegex = r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';

  /// Vietnamese text validation regex
  static const String vietnameseTextRegex = r'^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵýỷỹ\s\d\.,;:!?\-()]+$';

  // ========== PERFORMANCE ==========

  /// List scroll physics
  static const String listScrollPhysics = 'platform'; // 'platform', 'bouncing', 'clamping'

  /// Image loading fade duration
  static const Duration imageFadeDuration = Duration(milliseconds: 300);

  /// Refresh indicator displacement
  static const double refreshIndicatorDisplacement = 40.0;

  /// Maximum concurrent image loads
  static const int maxConcurrentImageLoads = 10;
}

/// App-wide string constants for localization
class AppStrings {
  // ========== APP INFO ==========

  static const String appName = 'Hệ thống Tòa soạn Điện tử';
  static const String appSubtitle = 'VnNews by Nam';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Ứng dụng tổng hợp tin tức từ các nguồn uy tín';

  // ========== NAVIGATION ==========

  static const String dashboard = 'Trang chủ';
  static const String search = 'Tìm kiếm';
  static const String categories = 'Danh mục';
  static const String bookmarks = 'Đã lưu';
  static const String settings = 'Cài đặt';
  static const String about = 'Về ứng dụng';

  // ========== ACTIONS ==========

  static const String refresh = 'Làm mới';
  static const String retry = 'Thử lại';
  static const String cancel = 'Hủy';
  static const String ok = 'Đồng ý';
  static const String yes = 'Có';
  static const String no = 'Không';
  static const String close = 'Đóng';
  static const String back = 'Quay lại';
  static const String next = 'Tiếp theo';
  static const String previous = 'Trước đó';
  static const String save = 'Lưu';
  static const String delete = 'Xóa';
  static const String edit = 'Chỉnh sửa';
  static const String share = 'Chia sẻ';
  static const String copy = 'Sao chép';
  static const String bookmark = 'Lưu bài';
  static const String unbookmark = 'Bỏ lưu';
  static const String readOriginal = 'Đọc bài gốc';
  static const String viewSummary = 'Xem tóm tắt';
  static const String loadMore = 'Tải thêm';

  // ========== LABELS ==========

  static const String category = 'Danh mục';
  static const String source = 'Nguồn';
  static const String author = 'Tác giả';
  static const String publishDate = 'Thời gian';
  static const String viewCount = 'lượt xem';
  static const String tags = 'Từ khóa';
  static const String summary = 'Tóm tắt';
  static const String content = 'Nội dung';
  static const String image = 'Hình ảnh';
  static const String url = 'Liên kết';

  // ========== PLACEHOLDERS ==========

  static const String searchPlaceholder = 'Tìm kiếm bài viết...';
  static const String noResults = 'Không tìm thấy kết quả';
  static const String noData = 'Không có dữ liệu';
  static const String noImage = 'Không có hình ảnh';
  static const String loading = 'Đang tải...';
  static const String loadingMore = 'Đang tải thêm...';
  static const String refreshing = 'Đang làm mới...';

  // ========== ERROR MESSAGES ==========

  static const String networkError = 'Không có kết nối internet';
  static const String serverError = 'Lỗi máy chủ';
  static const String timeoutError = 'Kết nối quá thời gian chờ';
  static const String dataError = 'Dữ liệu không hợp lệ';
  static const String unknownError = 'Lỗi không xác định';
  static const String connectionError = 'Lỗi kết nối. Vui lòng kiểm tra mạng và thử lại.';
  static const String loadError = 'Không thể tải dữ liệu';
  static const String searchError = 'Lỗi tìm kiếm';
  static const String refreshError = 'Không thể làm mới dữ liệu';
  static const String saveError = 'Không thể lưu';
  static const String shareError = 'Không thể chia sẻ';
  static const String permissionError = 'Không có quyền truy cập';

  // ========== SUCCESS MESSAGES ==========

  static const String refreshSuccess = 'Dữ liệu đã được cập nhật';
  static const String loadSuccess = 'Tải dữ liệu thành công';
  static const String saveSuccess = 'Đã lưu thành công';
  static const String shareSuccess = 'Đã chia sẻ thành công';
  static const String bookmarkAdded = 'Đã thêm vào danh sách lưu';
  static const String bookmarkRemoved = 'Đã xóa khỏi danh sách lưu';

  // ========== TIME FORMATS ==========

  static const String justNow = 'Vừa xong';
  static const String minutesAgo = 'phút trước';
  static const String hoursAgo = 'giờ trước';
  static const String daysAgo = 'ngày trước';
  static const String weeksAgo = 'tuần trước';
  static const String monthsAgo = 'tháng trước';
  static const String yearsAgo = 'năm trước';
  static const String today = 'Hôm nay';
  static const String yesterday = 'Hôm qua';
  static const String tomorrow = 'Ngày mai';

  // ========== STATISTICS ==========

  static const String totalArticles = 'Tổng bài viết';
  static const String totalViews = 'Tổng lượt xem';
  static const String topCategory = 'Chủ đề hot';
  static const String todayArticles = 'Bài viết hôm nay';
  static const String featuredNews = 'Tin nổi bật';
  static const String latestNews = 'Tin mới nhất';
  static const String breakingNews = 'Tin nóng';
  static const String trendingNews = 'Tin thịnh hành';

  // ========== FILTERS ==========

  static const String allCategories = 'Tất cả danh mục';
  static const String allSources = 'Tất cả nguồn';
  static const String allTime = 'Tất cả thời gian';
  static const String filterBy = 'Lọc theo';
  static const String sortBy = 'Sắp xếp theo';
  static const String newest = 'Mới nhất';
  static const String oldest = 'Cũ nhất';
  static const String mostViewed = 'Nhiều lượt xem';
  static const String leastViewed = 'Ít lượt xem';

  // ========== NOTIFICATIONS ==========

  static const String notificationTitle = 'Tin tức mới';
  static const String breakingNewsTitle = 'Tin nóng';
  static const String notificationPermission = 'Cho phép thông báo để nhận tin tức mới nhất';
  static const String notificationSettings = 'Cài đặt thông báo';

  // ========== OFFLINE ==========

  static const String offlineMode = 'Chế độ ngoại tuyến';
  static const String offlineMessage = 'Bạn đang ở chế độ ngoại tuyến';
  static const String connectToInternet = 'Kết nối internet để cập nhật tin tức mới';
  static const String cachedContent = 'Nội dung được lưu trữ';

  // ========== DEVELOPMENT ==========

  static const String debugMode = 'Chế độ debug';
  static const String testData = 'Dữ liệu test';
  static const String mockMode = 'Chế độ giả lập';
  static const String apiStatus = 'Trạng thái API';
  static const String connected = 'Đã kết nối';
  static const String disconnected = 'Mất kết nối';

  // ========== ACCESSIBILITY ==========

  static const String articleImage = 'Hình ảnh bài viết';
  static const String sourceBadge = 'Nguồn tin';
  static const String categoryBadge = 'Danh mục';
  static const String shareButton = 'Nút chia sẻ';
  static const String bookmarkButton = 'Nút lưu bài';
  static const String backButton = 'Nút quay lại';
  static const String searchButton = 'Nút tìm kiếm';
  static const String refreshButton = 'Nút làm mới';
  static const String menuButton = 'Nút menu';
}