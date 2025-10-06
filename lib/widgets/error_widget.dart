import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final String? secondaryActionText;
  final VoidCallback? onSecondaryActionPressed;
  final Color? iconColor;
  final bool showDetails;
  final String? details;

  const AppErrorWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.error_outline,
    this.actionText,
    this.onActionPressed,
    this.secondaryActionText,
    this.onSecondaryActionPressed,
    this.iconColor,
    this.showDetails = false,
    this.details,
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
            // Error Icon
            Icon(
              icon,
              size: 80.0,
              color: iconColor ?? theme.colorScheme.error,
            ),

            const SizedBox(height: 24),

            // Error Title
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Error Message
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            // Error Details (expandable)
            if (showDetails && details != null) ...[
              const SizedBox(height: 16),
              Theme(
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'Chi tiết lỗi',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: theme.colorScheme.error.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          details!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Action Buttons
            if (actionText != null && onActionPressed != null) ...[
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onActionPressed,
                  icon: const Icon(Icons.refresh),
                  label: Text(actionText!),
                ),
              ),
            ],

            if (secondaryActionText != null && onSecondaryActionPressed != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onSecondaryActionPressed,
                  icon: const Icon(Icons.arrow_back),
                  label: Text(secondaryActionText!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Predefined error widgets for common scenarios
class ErrorWidgets {
  static Widget networkError({
    VoidCallback? onRetry,
    VoidCallback? onGoBack,
  }) {
    return AppErrorWidget(
      icon: Icons.wifi_off_outlined,
      title: 'Lỗi kết nối mạng',
      message: 'Vui lòng kiểm tra kết nối internet và thử lại.',
      actionText: onRetry != null ? 'Thử lại' : null,
      onActionPressed: onRetry,
      secondaryActionText: onGoBack != null ? 'Quay lại' : null,
      onSecondaryActionPressed: onGoBack,
    );
  }

  static Widget serverError({
    VoidCallback? onRetry,
    VoidCallback? onGoBack,
    String? details,
  }) {
    return AppErrorWidget(
      icon: Icons.dns_outlined,
      title: 'Lỗi máy chủ',
      message: 'Đã xảy ra lỗi từ phía máy chủ. Vui lòng thử lại sau.',
      actionText: onRetry != null ? 'Thử lại' : null,
      onActionPressed: onRetry,
      secondaryActionText: onGoBack != null ? 'Quay lại' : null,
      onSecondaryActionPressed: onGoBack,
      showDetails: details != null,
      details: details,
    );
  }

  static Widget notFound({
    VoidCallback? onGoHome,
    VoidCallback? onGoBack,
    String title = 'Không tìm thấy',
    String message = 'Nội dung bạn đang tìm kiếm không tồn tại.',
  }) {
    return AppErrorWidget(
      icon: Icons.search_off_outlined,
      title: title,
      message: message,
      actionText: onGoHome != null ? 'Về trang chủ' : null,
      onActionPressed: onGoHome,
      secondaryActionText: onGoBack != null ? 'Quay lại' : null,
      onSecondaryActionPressed: onGoBack,
    );
  }

  static Widget unauthorized({
    VoidCallback? onLogin,
    VoidCallback? onGoBack,
  }) {
    return AppErrorWidget(
      icon: Icons.lock_outline,
      title: 'Không có quyền truy cập',
      message: 'Bạn cần đăng nhập để truy cập nội dung này.',
      actionText: onLogin != null ? 'Đăng nhập' : null,
      onActionPressed: onLogin,
      secondaryActionText: onGoBack != null ? 'Quay lại' : null,
      onSecondaryActionPressed: onGoBack,
    );
  }

  static Widget forbidden({
    VoidCallback? onGoHome,
    VoidCallback? onGoBack,
  }) {
    return AppErrorWidget(
      icon: Icons.block_outlined,
      title: 'Truy cập bị từ chối',
      message: 'Bạn không có quyền truy cập vào tài nguyên này.',
      actionText: onGoHome != null ? 'Về trang chủ' : null,
      onActionPressed: onGoHome,
      secondaryActionText: onGoBack != null ? 'Quay lại' : null,
      onSecondaryActionPressed: onGoBack,
    );
  }

  static Widget timeout({
    VoidCallback? onRetry,
    VoidCallback? onGoBack,
  }) {
    return AppErrorWidget(
      icon: Icons.access_time_outlined,
      title: 'Hết thời gian chờ',
      message: 'Yêu cầu của bạn đã hết thời gian chờ. Vui lòng thử lại.',
      actionText: onRetry != null ? 'Thử lại' : null,
      onActionPressed: onRetry,
      secondaryActionText: onGoBack != null ? 'Quay lại' : null,
      onSecondaryActionPressed: onGoBack,
    );
  }

  static Widget maintenanceMode({
    VoidCallback? onRetry,
  }) {
    return AppErrorWidget(
      icon: Icons.build_outlined,
      title: 'Đang bảo trì',
      message: 'Hệ thống đang trong quá trình bảo trì. Vui lòng quay lại sau.',
      actionText: onRetry != null ? 'Kiểm tra lại' : null,
      onActionPressed: onRetry,
      iconColor: Colors.orange,
    );
  }

  static Widget genericError({
    required String message,
    VoidCallback? onRetry,
    VoidCallback? onGoBack,
    String? details,
  }) {
    return AppErrorWidget(
      title: 'Đã xảy ra lỗi',
      message: message,
      actionText: onRetry != null ? 'Thử lại' : null,
      onActionPressed: onRetry,
      secondaryActionText: onGoBack != null ? 'Quay lại' : null,
      onSecondaryActionPressed: onGoBack,
      showDetails: details != null,
      details: details,
    );
  }
}

// Error boundary widget for handling unexpected errors
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stackTrace)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (FlutterErrorDetails details) {
      setState(() {
        _error = details.exception;
        _stackTrace = details.stack;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(_error!, _stackTrace) ??
          ErrorWidgets.genericError(
            message: 'Đã xảy ra lỗi không mong muốn.',
            details: _error.toString(),
            onRetry: () {
              setState(() {
                _error = null;
                _stackTrace = null;
              });
            },
          );
    }

    return widget.child;
  }
}