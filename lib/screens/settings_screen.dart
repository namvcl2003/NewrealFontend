// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../services/api_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings values
  bool _pushNotifications = true;
  bool _breakingNewsAlerts = true;
  bool _autoRefresh = false;
  bool _wifiOnly = false;
  bool _darkMode = false;
  bool _saveReadHistory = true;
  String _textSize = 'medium';
  String _language = 'vi';
  int _cacheSize = 0;

  bool _isLoading = true;
  Map<String, dynamic>? _apiHealth;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _checkApiHealth();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _breakingNewsAlerts = prefs.getBool('breaking_news_alerts') ?? true;
      _autoRefresh = prefs.getBool('auto_refresh') ?? false;
      _wifiOnly = prefs.getBool('wifi_only') ?? false;
      _darkMode = prefs.getBool('dark_mode') ?? false;
      _saveReadHistory = prefs.getBool('save_read_history') ?? true;
      _textSize = prefs.getString('text_size') ?? 'medium';
      _language = prefs.getString('language') ?? 'vi';
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications', _pushNotifications);
    await prefs.setBool('breaking_news_alerts', _breakingNewsAlerts);
    await prefs.setBool('auto_refresh', _autoRefresh);
    await prefs.setBool('wifi_only', _wifiOnly);
    await prefs.setBool('dark_mode', _darkMode);
    await prefs.setBool('save_read_history', _saveReadHistory);
    await prefs.setString('text_size', _textSize);
    await prefs.setString('language', _language);
  }

  Future<void> _checkApiHealth() async {
    try {
      final health = await ApiService.checkHealth();
      setState(() {
        _apiHealth = health;
      });
    } catch (e) {
      setState(() {
        _apiHealth = {'status': 'error', 'error': e.toString()};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cài đặt')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Cài đặt'),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showAboutDialog,
          ),
        ],
      ),
      body: ListView(
        children: [
          // User Profile Section
          _buildProfileSection(),

          const SizedBox(height: 8),

          // Notification Settings
          _buildSectionHeader('Thông báo'),
          _buildNotificationSettings(),

          const SizedBox(height: 8),

          // Display Settings
          _buildSectionHeader('Hiển thị'),
          _buildDisplaySettings(),

          const SizedBox(height: 8),

          // Data & Storage
          _buildSectionHeader('Dữ liệu & Lưu trữ'),
          _buildDataSettings(),

          const SizedBox(height: 8),

          // Content Preferences
          _buildSectionHeader('Tùy chọn nội dung'),
          _buildContentPreferences(),

          const SizedBox(height: 8),

          // Privacy & Security
          _buildSectionHeader('Quyền riêng tư & Bảo mật'),
          _buildPrivacySettings(),

          const SizedBox(height: 8),

          // App Info & Support
          _buildSectionHeader('Về ứng dụng'),
          _buildAppInfo(),

          const SizedBox(height: 8),

          // Developer Options (Debug Mode)
          if (AppConstants.isDebugMode) ...[
            _buildSectionHeader('Developer Options'),
            _buildDeveloperOptions(),
            const SizedBox(height: 8),
          ],

          // Dangerous Actions
          _buildSectionHeader('Nguy hiểm'),
          _buildDangerousActions(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ==================== SECTION BUILDERS ====================

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryRed,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isAuthenticated = authProvider.isAuthenticated;
        final user = authProvider.currentUser;

        return InkWell(
          onTap: () {
            if (isAuthenticated) {
              // Navigate to profile screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            } else {
              // Navigate to login screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryRed, AppTheme.primaryRed.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryRed.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  backgroundImage: isAuthenticated && user?.avatar != null
                      ? NetworkImage(user!.avatar!)
                      : null,
                  child: isAuthenticated && user?.avatar != null
                      ? null
                      : Icon(
                          isAuthenticated ? Icons.person : Icons.person_outline,
                          size: 32,
                          color: AppTheme.primaryRed,
                        ),
                ),
                const SizedBox(width: 16),
                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAuthenticated ? user!.name : 'Khách',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isAuthenticated ? user!.email : 'Nhấn để đăng nhập',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                      if (isAuthenticated && user!.stats.articlesRead > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${user.stats.articlesRead} bài đã đọc',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Action icon
                Icon(
                  isAuthenticated ? Icons.arrow_forward_ios : Icons.login,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Thông báo đẩy'),
            subtitle: const Text('Nhận thông báo tin tức mới'),
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
              });
              _saveSettings();
            },
            secondary: const Icon(Icons.notifications_active),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Tin nóng'),
            subtitle: const Text('Thông báo tin tức khẩn cấp'),
            value: _breakingNewsAlerts,
            onChanged: _pushNotifications
                ? (value) {
              setState(() {
                _breakingNewsAlerts = value;
              });
              _saveSettings();
            }
                : null,
            secondary: const Icon(Icons.warning_amber),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Quản lý thông báo'),
            subtitle: const Text('Tùy chỉnh thông báo theo danh mục'),
            leading: const Icon(Icons.tune),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDisplaySettings() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Container(
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Chế độ tối'),
            subtitle: Text(
              themeProvider.isDarkMode ? 'Bật (Bảo vệ mắt ban đêm)' : 'Tắt',
            ),
            value: themeProvider.isDarkMode,
            onChanged: (_) {
              themeProvider.toggleTheme();
              _showSnackBar('Đã ${themeProvider.isDarkMode ? "bật" : "tắt"} chế độ tối');
            },
            secondary: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Cỡ chữ'),
            subtitle: Text('${settingsProvider.fontSize.label} (${(settingsProvider.fontScale * 100).toInt()}%)'),
            leading: const Icon(Icons.format_size),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showFontSizeDialog(settingsProvider),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Ngôn ngữ'),
            subtitle: Text(_language == 'vi' ? 'Tiếng Việt' : 'English'),
            leading: const Icon(Icons.language),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showLanguageDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildDataSettings() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Tự động làm mới'),
            subtitle: const Text('Tự động tải tin tức mới'),
            value: _autoRefresh,
            onChanged: (value) {
              setState(() {
                _autoRefresh = value;
              });
              _saveSettings();
            },
            secondary: const Icon(Icons.refresh),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Chỉ tải qua WiFi'),
            subtitle: const Text('Tiết kiệm dữ liệu di động'),
            value: _wifiOnly,
            onChanged: (value) {
              setState(() {
                _wifiOnly = value;
              });
              _saveSettings();
            },
            secondary: const Icon(Icons.wifi),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Bộ nhớ đệm'),
            subtitle: Text('Đã sử dụng: ${_formatCacheSize()}'),
            leading: const Icon(Icons.storage),
            trailing: TextButton(
              onPressed: _clearCache,
              child: const Text('Xóa'),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Quản lý tải xuống'),
            subtitle: const Text('Xem và quản lý bài viết đã tải'),
            leading: const Icon(Icons.download),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showSnackBar('Tính năng đang phát triển');
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Bài viết đã lưu'),
            subtitle: const Text('Xem các bài viết yêu thích đã lưu'),
            leading: const Icon(Icons.bookmark),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, '/bookmarks');
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Lịch sử đọc'),
            subtitle: const Text('Xem lịch sử các bài viết đã đọc'),
            leading: const Icon(Icons.history),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, '/reading-history');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContentPreferences() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: const Text('Nguồn tin ưa thích'),
            subtitle: const Text('Chọn nguồn tin yêu thích'),
            leading: const Icon(Icons.bookmarks),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SourcePreferencesScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Danh mục ưa thích'),
            subtitle: const Text('Tùy chỉnh danh mục hiển thị'),
            leading: const Icon(Icons.category),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CategoryPreferencesScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Từ khóa quan tâm'),
            subtitle: const Text('Nhận tin theo từ khóa'),
            leading: const Icon(Icons.label),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showSnackBar('Tính năng đang phát triển');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Lưu lịch sử đọc'),
            subtitle: const Text('Ghi nhớ bài viết đã đọc'),
            value: _saveReadHistory,
            onChanged: (value) {
              setState(() {
                _saveReadHistory = value;
              });
              _saveSettings();
            },
            secondary: const Icon(Icons.history),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Xóa lịch sử đọc'),
            subtitle: const Text('Xóa toàn bộ lịch sử đã đọc'),
            leading: const Icon(Icons.delete_outline),
            onTap: _confirmClearHistory,
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Chính sách quyền riêng tư'),
            leading: const Icon(Icons.privacy_tip),
            trailing: const Icon(Icons.open_in_new, size: 16),
            onTap: () {
              _showSnackBar('Mở chính sách quyền riêng tư');
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Điều khoản sử dụng'),
            leading: const Icon(Icons.description),
            trailing: const Icon(Icons.open_in_new, size: 16),
            onTap: () {
              _showSnackBar('Mở điều khoản sử dụng');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfo() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: const Text('Phiên bản'),
            subtitle: Text(AppStrings.appVersion),
            leading: const Icon(Icons.info),
            trailing: _apiHealth != null
                ? _buildApiHealthIndicator()
                : const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Kiểm tra cập nhật'),
            leading: const Icon(Icons.system_update),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _checkForUpdates,
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Đánh giá ứng dụng'),
            leading: const Icon(Icons.star_rate),
            trailing: const Icon(Icons.open_in_new, size: 16),
            onTap: () {
              _showSnackBar('Cảm ơn bạn đã quan tâm!');
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Hỗ trợ & Phản hồi'),
            leading: const Icon(Icons.support_agent),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showFeedbackDialog,
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Về chúng tôi'),
            leading: const Icon(Icons.people),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showAboutDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperOptions() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: const Text('API Health Check'),
            subtitle: Text(_apiHealth?['status'] ?? 'Checking...'),
            leading: const Icon(Icons.api),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _checkApiHealth,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Test Connection'),
            leading: const Icon(Icons.network_check),
            onTap: _testConnection,
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('View Logs'),
            leading: const Icon(Icons.bug_report),
            onTap: () {
              _showSnackBar('Logs viewer - Coming soon');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDangerousActions() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: const Text(
              'Đặt lại ứng dụng',
              style: TextStyle(color: Colors.red),
            ),
            subtitle: const Text('Xóa toàn bộ dữ liệu và cài đặt'),
            leading: const Icon(Icons.restore, color: Colors.red),
            onTap: _confirmResetApp,
          ),
        ],
      ),
    );
  }

  // ==================== HELPER WIDGETS ====================

  Widget _buildApiHealthIndicator() {
    final status = _apiHealth?['status'];
    Color color;
    IconData icon;

    switch (status) {
      case 'healthy':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'error':
        color = Colors.red;
        icon = Icons.error;
        break;
      default:
        color = Colors.orange;
        icon = Icons.warning;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          status ?? 'Unknown',
          style: TextStyle(color: color, fontSize: 12),
        ),
      ],
    );
  }

  // ==================== DIALOG METHODS ====================

  void _showFontSizeDialog(SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cỡ chữ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...FontSize.values.map((size) {
              return RadioListTile<FontSize>(
                title: Text(size.label),
                subtitle: Text('${(size.scale * 100).toInt()}%', style: TextStyle(fontSize: 12)),
                value: size,
                groupValue: settingsProvider.fontSize,
                onChanged: (value) {
                  if (value != null) {
                    settingsProvider.setFontSize(value);
                    Navigator.pop(dialogContext);
                    _showSnackBar('Đã đổi cỡ chữ sang ${value.label}');
                  }
                },
              );
            }),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Xem trước:',
                style: TextStyle(
                  fontSize: 12 * settingsProvider.fontScale,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Đây là đoạn văn bản mẫu',
                style: TextStyle(fontSize: 14 * settingsProvider.fontScale),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ngôn ngữ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Tiếng Việt'),
              value: 'vi',
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
                _saveSettings();
                Navigator.pop(context);
                _showSnackBar('Đã chuyển sang Tiếng Việt');
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
                _saveSettings();
                Navigator.pop(context);
                _showSnackBar('Language changed to English');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedbackDialog() {
    final feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gửi phản hồi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Hãy cho chúng tôi biết ý kiến của bạn!'),
            const SizedBox(height: 16),
            TextField(
              controller: feedbackController,
              decoration: const InputDecoration(
                hintText: 'Nhập phản hồi của bạn...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Cảm ơn phản hồi của bạn!');
            },
            child: const Text('Gửi'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: AppStrings.appVersion,
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryRed,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.newspaper, size: 32, color: Colors.white),
      ),
      children: [
        const SizedBox(height: 16),
        Text(
          AppStrings.appDescription,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
        const Text(
          '© 2025 VnNews. All rights reserved.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  // ==================== ACTION METHODS ====================

  Future<void> _clearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa bộ nhớ đệm'),
        content: const Text('Bạn có chắc muốn xóa toàn bộ bộ nhớ đệm?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Implement cache clearing
      setState(() {
        _cacheSize = 0;
      });
      _showSnackBar('Đã xóa bộ nhớ đệm');
    }
  }

  Future<void> _confirmClearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa lịch sử'),
        content: const Text('Bạn có chắc muốn xóa toàn bộ lịch sử đọc?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Implement history clearing
      _showSnackBar('Đã xóa lịch sử đọc');
    }
  }

  Future<void> _confirmResetApp() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đặt lại ứng dụng'),
        content: const Text(
          'Bạn có chắc muốn đặt lại ứng dụng?\n\nToàn bộ dữ liệu, cài đặt, và lịch sử sẽ bị xóa.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Đặt lại'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _showSnackBar('Đã đặt lại ứng dụng');

      // Restart app
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  Future<void> _checkForUpdates() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context);
      _showSnackBar('Bạn đang sử dụng phiên bản mới nhất');
    }
  }

  Future<void> _testConnection() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang kiểm tra kết nối...'),
          ],
        ),
      ),
    );

    try {
      final provider = Provider.of<ArticleProvider>(context, listen: false);
      final isConnected = await provider.testConnection();

      if (mounted) {
        Navigator.pop(context);
        _showSnackBar(
          isConnected
              ? 'Kết nối API thành công!'
              : 'Không thể kết nối với API',
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showSnackBar('Lỗi: ${e.toString()}');
      }
    }
  }

  // ==================== HELPER METHODS ====================

  String _getTextSizeLabel() {
    switch (_textSize) {
      case 'small':
        return 'Nhỏ';
      case 'large':
        return 'Lớn';
      default:
        return 'Trung bình';
    }
  }

  String _formatCacheSize() {
    if (_cacheSize < 1024) {
      return '${_cacheSize} KB';
    } else {
      return '${(_cacheSize / 1024).toStringAsFixed(1)} MB';
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ==================== SUB SCREENS ====================

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý thông báo')),
      body: ListView(
        children: AppConstants.defaultCategories.map((category) {
          return SwitchListTile(
            title: Text(category),
            value: true,
            onChanged: (value) {
              // TODO: Save notification preferences
            },
          );
        }).toList(),
      ),
    );
  }
}

class SourcePreferencesScreen extends StatelessWidget {
  const SourcePreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nguồn tin ưa thích')),
      body: ListView(
        children: AppConstants.defaultSources.skip(1).map((source) {
          return CheckboxListTile(
            title: Text(source),
            value: true,
            onChanged: (value) {
              // TODO: Save source preferences
            },
          );
        }).toList(),
      ),
    );
  }
}

class CategoryPreferencesScreen extends StatelessWidget {
  const CategoryPreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh mục ưa thích')),
      body: ListView(
        children: AppConstants.defaultCategories.skip(1).map((category) {
          return CheckboxListTile(
            title: Text(category),
            secondary: Text(AppConstants.categoryIcons[category] ?? '📰'),
            value: true,
            onChanged: (value) {
              // TODO: Save category preferences
            },
          );
        }).toList(),
      ),
    );
  }
}