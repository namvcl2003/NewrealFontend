import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Color? iconColor;
  final double iconSize;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.actionText,
    this.onActionPressed,
    this.iconColor,
    this.iconSize = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? theme.colorScheme.outline,
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              subtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            // Action button (if provided)
            if (actionText != null && onActionPressed != null) ...[
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onActionPressed,
                icon: const Icon(Icons.add),
                label: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Predefined empty state widgets for common scenarios
class EmptyStateWidgets {
  static Widget noData({
    String title = 'Không có dữ liệu',
    String subtitle = 'Hiện tại chưa có dữ liệu nào được tìm thấy.',
    VoidCallback? onRefresh,
  }) {
    return EmptyStateWidget(
      icon: Icons.inbox_outlined,
      title: title,
      subtitle: subtitle,
      actionText: onRefresh != null ? 'Làm mới' : null,
      onActionPressed: onRefresh,
    );
  }

  static Widget noSearchResults({
    String searchTerm = '',
    VoidCallback? onClearSearch,
  }) {
    return EmptyStateWidget(
      icon: Icons.search_off_outlined,
      title: 'Không tìm thấy kết quả',
      subtitle: searchTerm.isNotEmpty
          ? 'Không tìm thấy kết quả cho "$searchTerm". Hãy thử từ khóa khác.'
          : 'Không tìm thấy kết quả nào. Hãy thử từ khóa khác.',
      actionText: onClearSearch != null ? 'Xóa tìm kiếm' : null,
      onActionPressed: onClearSearch,
    );
  }

  static Widget noFavorites({
    VoidCallback? onExplore,
  }) {
    return EmptyStateWidget(
      icon: Icons.favorite_outline,
      title: 'Chưa có mục yêu thích',
      subtitle: 'Các mục bạn yêu thích sẽ xuất hiện ở đây.',
      actionText: onExplore != null ? 'Khám phá' : null,
      onActionPressed: onExplore,
    );
  }

  static Widget noNotifications() {
    return const EmptyStateWidget(
      icon: Icons.notifications_none_outlined,
      title: 'Không có thông báo',
      subtitle: 'Bạn đã xem hết tất cả thông báo.',
    );
  }

  static Widget noHistory({
    VoidCallback? onStartBrowsing,
  }) {
    return EmptyStateWidget(
      icon: Icons.history,
      title: 'Chưa có lịch sử',
      subtitle: 'Hoạt động của bạn sẽ xuất hiện ở đây.',
      actionText: onStartBrowsing != null ? 'Bắt đầu' : null,
      onActionPressed: onStartBrowsing,
    );
  }

  static Widget comingSoon({
    String title = 'Sắp ra mắt',
    String subtitle = 'Tính năng này đang được phát triển.',
  }) {
    return EmptyStateWidget(
      icon: Icons.construction_outlined,
      title: title,
      subtitle: subtitle,
      iconColor: Colors.orange,
    );
  }
}