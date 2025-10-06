// lib/utils/date_utils.dart

import 'package:intl/intl.dart';
import 'constants.dart';

/// Utility class for date/time formatting and manipulation
class AppDateUtils {
  // ========== DATE FORMATTERS ==========

  /// Vietnamese date formatter (dd/MM/yyyy)
  static final DateFormat _vietnameseDateFormatter = DateFormat('dd/MM/yyyy');

  /// Vietnamese datetime formatter (dd/MM/yyyy HH:mm)
  static final DateFormat _vietnameseDateTimeFormatter = DateFormat('dd/MM/yyyy HH:mm');

  /// Vietnamese time formatter (HH:mm)
  static final DateFormat _vietnameseTimeFormatter = DateFormat('HH:mm');

  /// ISO date formatter for API (yyyy-MM-dd)
  static final DateFormat _isoDateFormatter = DateFormat('yyyy-MM-dd');

  /// ISO datetime formatter for API (yyyy-MM-dd HH:mm:ss)
  static final DateFormat _isoDateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  // ========== BASIC DATE FORMATTING ==========

  /// Format date string to Vietnamese format (dd/MM/yyyy HH:mm)
  ///
  /// Input: "2025-09-25 16:30" or "2025-09-25T16:30:00"
  /// Output: "25/09/2025 16:30"
  static String formatDate(String dateString) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      return _vietnameseDateTimeFormatter.format(date);
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  /// Format date to Vietnamese date only (dd/MM/yyyy)
  ///
  /// Input: "2025-09-25 16:30"
  /// Output: "25/09/2025"
  static String formatDateOnly(String dateString) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      return _vietnameseDateFormatter.format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Format date to time only (HH:mm)
  ///
  /// Input: "2025-09-25 16:30"
  /// Output: "16:30"
  static String formatTimeOnly(String dateString) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      return _vietnameseTimeFormatter.format(date);
    } catch (e) {
      return '';
    }
  }

  // ========== RELATIVE DATE FORMATTING (VNEXPRESS STYLE) ==========

  /// Format date with relative time (like VnExpress: "2 giờ trước", "1 ngày trước")
  ///
  /// Input: "2025-09-25 16:30"
  /// Output: "2 giờ trước" or "25/09/2025" if too old
  static String formatRelativeDate(String dateString) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(date);

      // Just now (< 1 minute)
      if (difference.inMinutes < 1) {
        return AppStrings.justNow;
      }

      // Minutes ago (1-59 minutes)
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} ${AppStrings.minutesAgo}';
      }

      // Hours ago (1-23 hours)
      if (difference.inHours < 24) {
        return '${difference.inHours} ${AppStrings.hoursAgo}';
      }

      // Days ago (1-6 days)
      if (difference.inDays < 7) {
        if (difference.inDays == 1) {
          return AppStrings.yesterday;
        }
        return '${difference.inDays} ${AppStrings.daysAgo}';
      }

      // Weeks ago (1-4 weeks)
      if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks ${AppStrings.weeksAgo}';
      }

      // For older dates, show full date
      return _vietnameseDateFormatter.format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Format date with smart relative display
  /// Shows time for today, "yesterday" for yesterday, date for older
  static String formatSmartDate(String dateString) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      final DateTime now = DateTime.now();

      // Check if same day
      if (_isSameDay(date, now)) {
        return _vietnameseTimeFormatter.format(date);
      }

      // Check if yesterday
      final DateTime yesterday = now.subtract(const Duration(days: 1));
      if (_isSameDay(date, yesterday)) {
        return '${AppStrings.yesterday} ${_vietnameseTimeFormatter.format(date)}';
      }

      // Check if this week
      if (_isThisWeek(date, now)) {
        final dayName = _getDayName(date.weekday);
        return '$dayName ${_vietnameseTimeFormatter.format(date)}';
      }

      // For older dates
      return _vietnameseDateFormatter.format(date);
    } catch (e) {
      return dateString;
    }
  }

  // ========== DATE COMPARISON HELPERS ==========

  /// Check if date string represents today
  static bool isToday(String dateString) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      final DateTime now = DateTime.now();
      return _isSameDay(date, now);
    } catch (e) {
      return false;
    }
  }

  /// Check if date string represents yesterday
  static bool isYesterday(String dateString) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      final DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
      return _isSameDay(date, yesterday);
    } catch (e) {
      return false;
    }
  }

  /// Check if date string is within this week
  static bool isThisWeek(String dateString) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      final DateTime now = DateTime.now();
      return _isThisWeek(date, now);
    } catch (e) {
      return false;
    }
  }

  /// Check if date string is within this month
  static bool isThisMonth(String dateString) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      final DateTime now = DateTime.now();
      return date.year == now.year && date.month == now.month;
    } catch (e) {
      return false;
    }
  }

  /// Check if date string is within this year
  static bool isThisYear(String dateString) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      final DateTime now = DateTime.now();
      return date.year == now.year;
    } catch (e) {
      return false;
    }
  }

  /// Check if article is breaking news (within X hours)
  static bool isBreakingNews(String dateString, {int hoursThreshold = 2}) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(date);
      return difference.inHours < hoursThreshold;
    } catch (e) {
      return false;
    }
  }

  // ========== API DATE FORMATTING ==========

  /// Format DateTime for API requests (yyyy-MM-dd)
  static String formatForApi(DateTime date) {
    return _isoDateFormatter.format(date);
  }

  /// Format DateTime for API requests with time (yyyy-MM-dd HH:mm:ss)
  static String formatDateTimeForApi(DateTime date) {
    return _isoDateTimeFormatter.format(date);
  }

  /// Get current date in API format
  static String getCurrentDateForApi() {
    return formatForApi(DateTime.now());
  }

  /// Get current datetime in API format
  static String getCurrentDateTimeForApi() {
    return formatDateTimeForApi(DateTime.now());
  }

  // ========== DATE RANGE HELPERS ==========

  /// Get date range for filter options
  /// Returns map with 'start' and 'end' keys in API format
  static Map<String, String> getDateRange(String filter) {
    final DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate = now;

    switch (filter.toLowerCase()) {
      case 'today':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'yesterday':
        final yesterday = now.subtract(const Duration(days: 1));
        startDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
        endDate = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
        break;
      case 'week':
        startDate = _getStartOfWeek(now);
        break;
      case 'last_week':
        final lastWeek = now.subtract(const Duration(days: 7));
        startDate = _getStartOfWeek(lastWeek);
        endDate = _getEndOfWeek(lastWeek);
        break;
      case 'month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'last_month':
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        startDate = lastMonth;
        endDate = DateTime(now.year, now.month, 0, 23, 59, 59);
        break;
      case 'year':
        startDate = DateTime(now.year, 1, 1);
        break;
      case 'last_year':
        startDate = DateTime(now.year - 1, 1, 1);
        endDate = DateTime(now.year - 1, 12, 31, 23, 59, 59);
        break;
      default:
        return {};
    }

    return {
      'start': formatForApi(startDate),
      'end': formatForApi(endDate),
    };
  }

  /// Get date range with time for API
  static Map<String, String> getDateTimeRange(String filter) {
    final dateRange = getDateRange(filter);
    if (dateRange.isEmpty) return {};

    final DateTime startDate = DateTime.parse(dateRange['start']!);
    final DateTime endDate = DateTime.parse(dateRange['end']!);

    return {
      'start': formatDateTimeForApi(startDate),
      'end': formatDateTimeForApi(endDate),
    };
  }

  // ========== VIETNAMESE DATE HELPERS ==========

  /// Get Vietnamese day name
  static String _getDayName(int weekday) {
    const Map<int, String> dayNames = {
      1: 'Thứ Hai',
      2: 'Thứ Ba',
      3: 'Thứ Tư',
      4: 'Thứ Năm',
      5: 'Thứ Sáu',
      6: 'Thứ Bảy',
      7: 'Chủ Nhật',
    };
    return dayNames[weekday] ?? '';
  }

  /// Get Vietnamese month name
  static String getVietnameseMonthName(int month) {
    const Map<int, String> monthNames = {
      1: 'Tháng Một',
      2: 'Tháng Hai',
      3: 'Tháng Ba',
      4: 'Tháng Tư',
      5: 'Tháng Năm',
      6: 'Tháng Sáu',
      7: 'Tháng Bảy',
      8: 'Tháng Tám',
      9: 'Tháng Chín',
      10: 'Tháng Mười',
      11: 'Tháng Mười Một',
      12: 'Tháng Mười Hai',
    };
    return monthNames[month] ?? '';
  }

  /// Format full Vietnamese date
  /// Output: "Thứ Hai, 25 Tháng Chín 2025"
  static String formatFullVietnameseDate(String dateString) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      final String dayName = _getDayName(date.weekday);
      final String monthName = getVietnameseMonthName(date.month);
      return '$dayName, ${date.day} $monthName ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  // ========== TIME ZONE HELPERS ==========

  /// Convert UTC time to local time
  static String convertUtcToLocal(String utcDateString) {
    try {
      final DateTime utcDate = DateTime.parse(utcDateString).toUtc();
      final DateTime localDate = utcDate.toLocal();
      return formatDate(localDate.toString());
    } catch (e) {
      return utcDateString;
    }
  }

  /// Convert local time to UTC for API
  static String convertLocalToUtc(DateTime localDate) {
    final DateTime utcDate = localDate.toUtc();
    return formatDateTimeForApi(utcDate);
  }

  /// Get current timezone offset
  static String getTimezoneOffset() {
    final DateTime now = DateTime.now();
    final Duration offset = now.timeZoneOffset;
    final int hours = offset.inHours;
    final int minutes = offset.inMinutes % 60;
    final String sign = offset.isNegative ? '-' : '+';
    return '$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.abs().toString().padLeft(2, '0')}';
  }

  // ========== AGE CALCULATION ==========

  /// Calculate age of article in hours
  static int getArticleAgeInHours(String dateString) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      final DateTime now = DateTime.now();
      return now.difference(date).inHours;
    } catch (e) {
      return 0;
    }
  }

  /// Calculate age of article in days
  static int getArticleAgeInDays(String dateString) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      final DateTime now = DateTime.now();
      return now.difference(date).inDays;
    } catch (e) {
      return 0;
    }
  }

  // ========== SORTING HELPERS ==========

  /// Compare two date strings for sorting (newest first)
  static int compareDatesNewestFirst(String dateA, String dateB) {
    try {
      final DateTime a = _parseFlexibleDate(dateA);
      final DateTime b = _parseFlexibleDate(dateB);
      return b.compareTo(a); // Reverse order for newest first
    } catch (e) {
      return 0;
    }
  }

  /// Compare two date strings for sorting (oldest first)
  static int compareDatesOldestFirst(String dateA, String dateB) {
    try {
      final DateTime a = _parseFlexibleDate(dateA);
      final DateTime b = _parseFlexibleDate(dateB);
      return a.compareTo(b);
    } catch (e) {
      return 0;
    }
  }

  // ========== VALIDATION ==========

  /// Check if date string is valid
  static bool isValidDate(String dateString) {
    try {
      _parseFlexibleDate(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if date is in the future
  static bool isInFuture(String dateString) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      final DateTime now = DateTime.now();
      return date.isAfter(now);
    } catch (e) {
      return false;
    }
  }

  /// Check if date is in the past
  static bool isInPast(String dateString) {
    try {
      final DateTime date = _parseFlexibleDate(dateString);
      final DateTime now = DateTime.now();
      return date.isBefore(now);
    } catch (e) {
      return false;
    }
  }

  // ========== PRIVATE HELPER METHODS ==========

  /// Parse flexible date string (handles multiple formats)
  static DateTime _parseFlexibleDate(String dateString) {
    String normalizedDate = dateString.trim();

    // Handle space separator (common in MongoDB)
    if (normalizedDate.contains(' ') && !normalizedDate.contains('T')) {
      normalizedDate = normalizedDate.replaceFirst(' ', 'T');
    }

    // Add seconds if missing
    if (RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$').hasMatch(normalizedDate)) {
      normalizedDate += ':00';
    }

    // Try parsing with DateTime.parse first
    try {
      return DateTime.parse(normalizedDate);
    } catch (e) {
      // Try manual parsing for custom formats
      final List<DateFormat> formatters = [
        DateFormat('yyyy-MM-dd HH:mm:ss'),
        DateFormat('yyyy-MM-dd HH:mm'),
        DateFormat('yyyy-MM-dd'),
        DateFormat('dd/MM/yyyy HH:mm:ss'),
        DateFormat('dd/MM/yyyy HH:mm'),
        DateFormat('dd/MM/yyyy'),
      ];

      for (final formatter in formatters) {
        try {
          return formatter.parse(dateString);
        } catch (e) {
          continue;
        }
      }
      throw FormatException('Unable to parse date: $dateString');
    }
  }

  /// Check if two dates are on the same day
  static bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Check if date is within this week
  static bool _isThisWeek(DateTime date, DateTime now) {
    final DateTime startOfWeek = _getStartOfWeek(now);
    final DateTime endOfWeek = _getEndOfWeek(now);
    return date.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(seconds: 1)));
  }

  /// Get start of week (Monday)
  static DateTime _getStartOfWeek(DateTime date) {
    final int weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  /// Get end of week (Sunday)
  static DateTime _getEndOfWeek(DateTime date) {
    final int weekday = date.weekday;
    return date.add(Duration(days: 7 - weekday));
  }

  // ========== BUSINESS LOGIC HELPERS ==========

  /// Check if article should show "HOT" badge
  static bool shouldShowHotBadge(String dateString) {
    return isBreakingNews(dateString, hoursThreshold: AppConstants.breakingNewsHours);
  }

  /// Get reading time estimate based on content length
  static String getReadingTimeEstimate(int contentLength) {
    // Average reading speed: 200 words per minute
    // Average word length: 5 characters
    final int estimatedWords = (contentLength / 5).round();
    final int minutes = (estimatedWords / 200).round();

    if (minutes < 1) {
      return '< 1 phút đọc';
    } else if (minutes == 1) {
      return '1 phút đọc';
    } else {
      return '$minutes phút đọc';
    }
  }

  /// Generate cache key based on date range
  static String generateCacheKey(String filter) {
    final dateRange = getDateRange(filter);
    if (dateRange.isEmpty) return 'all_time';

    return '${dateRange['start']}_${dateRange['end']}';
  }

  /// Get appropriate date format for context
  static String getContextualDateFormat(String dateString, {String context = 'list'}) {
    switch (context) {
      case 'detail':
        return formatFullVietnameseDate(dateString);
      case 'card':
        return formatSmartDate(dateString);
      case 'relative':
        return formatRelativeDate(dateString);
      case 'list':
      default:
        return formatRelativeDate(dateString);
    }
  }
}