// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../models/article.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../utils/date_utils.dart';
import 'article_detail_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _setupScrollController();
  }

  void _setupScrollController() {
    // Tắt auto-load khi scroll - user phải nhấn nút "Xem thêm"
    // Uncomment dòng dưới để bật lại infinite scroll:

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels >=
    //       _scrollController.position.maxScrollExtent - AppConstants.loadMoreThreshold) {
    //     _loadMoreArticles();
    //   }
    // });
  }

  void _loadMoreArticles() {
    final provider = Provider.of<ArticleProvider>(context, listen: false);
    if (provider.hasMore && !provider.isLoading) {
      provider.loadMoreArticles();
    }
  }




  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea( // Thêm SafeArea bọc toàn bộ body
        child: Consumer<ArticleProvider>(
          builder: (context, provider, child) {
            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () => provider.refreshData(),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  _buildAppBar(context),
                  // _buildStatsSection(provider), // Đã comment
                  _buildFiltersSection(provider),
                  _buildContentSection(provider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build VnExpress style app bar
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 2,
      pinned: true,
      expandedHeight: 122,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Theme.of(context).appBarTheme.backgroundColor,
          child: Column(
            children: [
              // Top bar with logo and weather
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                alignment: Alignment.center, // Thêm alignment
                child: Row(
                  children: [
                    _buildVnExpressLogo(),
                    const SizedBox(width: 16),
                    Flexible( // Thay Text bằng Flexible để tránh overflow
                      child: Text(
                        AppStrings.appSubtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    _buildWeatherInfo(),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Search and actions
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                alignment: Alignment.center, // Thêm alignment
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _navigateToSearch(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                size: 20,
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                              ),
                              const SizedBox(width: 8),
                              Flexible( // Thêm Flexible
                                child: Text(
                                  AppStrings.searchPlaceholder,
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () => _navigateToPersonalizedFeed(context),
                      icon: const Icon(Icons.person_pin),
                      color: Theme.of(context).iconTheme.color,
                      tooltip: 'Dành cho bạn',
                    ),
                    IconButton(
                      onPressed: () => _showNotifications(context),
                      icon: const Icon(Icons.notifications_outlined),
                      color: Theme.of(context).iconTheme.color,
                    ),
                    IconButton(
                      onPressed: () => _showSettings(context),
                      icon: const Icon(Icons.settings_outlined),
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build VnExpress logo
  Widget _buildVnExpressLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryRed,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'VN',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Container(
            width: 2,
            height: 16,
            color: Theme.of(context).cardColor,
            margin: const EdgeInsets.symmetric(horizontal: 2),
          ),
          const Text(
            'NEWS',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Build weather info
  Widget _buildWeatherInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.location_on, size: 14, color: Theme.of(context).textTheme.bodySmall?.color),
        Text(
          'Hà Nội ',
          style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
          overflow: TextOverflow.ellipsis,
        ),
        const Icon(Icons.wb_sunny, size: 14, color: Colors.orange),
        Text(
          ' 28°',
          style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Build statistics section
  Widget _buildStatsSection(ArticleProvider provider) {
    if (provider.stats == null) return const SliverToBoxAdapter(child: SizedBox.shrink());

    final stats = provider.stats!;
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          children: [
            Expanded(child: _buildStatCard('Tổng bài viết', '${stats.totalArticles}', Icons.newspaper, Colors.blue)),
            const SizedBox(width: 8),
            Expanded(child: _buildStatCard('Tổng lượt xem', stats.formattedTotalViews, Icons.visibility, Colors.green)),
            const SizedBox(width: 8),
            Expanded(child: _buildStatCard('Chủ đề hot', stats.topCategory, Icons.trending_up, Colors.orange)),
            const SizedBox(width: 8),
            Expanded(child: _buildStatCard('Hôm nay', '${stats.todayArticles}', Icons.today, Colors.purple)),
          ],
        ),
      ),
    );
  }

  /// Build stat card
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Build filters section
  Widget _buildFiltersSection(ArticleProvider provider) {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).cardColor,
        child: Column(
          children: [
            // Category tabs
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
                itemCount: provider.categories.length,
                itemBuilder: (context, index) {
                  final category = provider.categories[index];
                  final isSelected = category == provider.selectedCategory;

                  return GestureDetector(
                    onTap: () => provider.setCategory(category),
                    child: Container(
                      margin: const EdgeInsets.only(right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? AppTheme.primaryRed : Theme.of(context).textTheme.bodyMedium?.color,
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 2,
                            width: category.length * 8.0,
                            color: isSelected ? AppTheme.primaryRed : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Source filter
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              child: Row(
                children: [
                  Text('Nguồn: ', style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color)),
                  ...(provider.sources.map((source) {
                    final isSelected = source == provider.selectedSource;
                    return GestureDetector(
                      onTap: () => provider.setSource(source),
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryRed : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryRed : Colors.grey[400]!,
                          ),
                        ),
                        child: Text(
                          source,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  })).toList(),
                  const Spacer(),
                  Text(
                    '${provider.filteredArticles.length} bài viết',
                    style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }

  /// Build content section
  Widget _buildContentSection(ArticleProvider provider) {
    if (provider.isLoading && provider.articles.isEmpty) {
      return const SliverFillRemaining(child: _LoadingWidget());
    }

    if (provider.hasError && provider.articles.isEmpty) {
      return SliverFillRemaining(
        child: _ErrorWidget(
          message: provider.errorMessage,
          onRetry: () => provider.initializeData(),
        ),
      );
    }

    if (provider.filteredArticles.isEmpty) {
      return const SliverFillRemaining(child: _EmptyStateWidget());
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          if (index == 0) {
            // Featured article
            return _buildFeaturedArticle(provider.filteredArticles[0]);
          } else if (index == 1) {
            // Latest news header with pagination info
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: AppConstants.smallPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppStrings.latestNews,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.primaryRed,
                        ),
                      ),
                      const Spacer(),
                      if (provider.isRefreshing)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Pagination info
                  Text(
                    'Hiển thị ${provider.filteredArticles.length} bài viết',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ],
              ),
            );
          } else {
            final articleIndex = index - 1;
            if (articleIndex < provider.filteredArticles.length) {
              return _buildRegularArticle(provider.filteredArticles[articleIndex]);
            } else if (provider.hasMore) {
              // Load More Button
              return Container(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Center(
                  child: provider.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          onPressed: () => _loadMoreArticles(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Xem thêm bài viết'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                ),
              );
            } else {
              // End of list
              return Container(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 48,
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Đã hiển thị tất cả bài viết',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
        childCount: provider.filteredArticles.length + (provider.hasMore ? 2 : 3),
      ),
    );
  }

  /// Build featured article card
  Widget _buildFeaturedArticle(Article article) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).dividerColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _navigateToArticleDetail(context, article),
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.defaultRadius)),
                  child: article.hasValidImage
                      ? Image.network(
                    article.imageUrl,
                    height: AppConstants.defaultImageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                  )
                      : _buildImagePlaceholder(),
                ),

                // Category badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      article.category,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),

                // Source badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.getSourceColor(article.source),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      article.sourceShortName,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),

                  // Summary
                  Text(
                    article.summary,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Metadata
                  _buildArticleMetadata(article),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build regular article card
  Widget _buildRegularArticle(Article article) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      child: InkWell(
        onTap: () => _navigateToArticleDetail(context, article),
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
                  errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(isSmall: true),
                )
                    : _buildImagePlaceholder(isSmall: true),
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

                    // Title
                    Text(
                      article.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Summary
                    Text(
                      article.summary,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
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
                          style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7)),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.visibility, size: 12, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7)),
                        const SizedBox(width: 2),
                        Text(
                          article.viewCount,
                          style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build article metadata
  Widget _buildArticleMetadata(Article article) {
    return Row(
      children: [
        Icon(Icons.schedule, size: 14, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7)),
        const SizedBox(width: 4),
        Text(
          AppDateUtils.formatRelativeDate(article.publishDate),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(width: 16),
        Icon(Icons.visibility, size: 14, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7)),
        const SizedBox(width: 4),
        Text(
          '${article.viewCount} ${AppStrings.viewCount}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Spacer(),
        if (article.author.isNotEmpty)
          Flexible(
            child: Text(
              article.author,
              style: TextStyle(fontSize: 11, color: AppTheme.primaryRed),
              overflow: TextOverflow.ellipsis, // Thêm dòng này
              maxLines: 1, // Giới hạn 1 dòng
            ),
          ),
      ],
    );
  }

  /// Build image placeholder
  Widget _buildImagePlaceholder({bool isSmall = false}) {
    final size = isSmall ? AppConstants.thumbnailImageHeight : AppConstants.defaultImageHeight;
    return Container(
      height: size,
      width: isSmall ? AppConstants.thumbnailImageWidth : double.infinity,
      color: Theme.of(context).dividerColor,
      child: Icon(Icons.image, size: isSmall ? 32 : 64, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7)),
    );
  }

  // Navigation methods
  void _navigateToSearch(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
  }

  void _navigateToPersonalizedFeed(BuildContext context) {
    Navigator.pushNamed(context, '/personalized-feed');
  }

  void _navigateToArticleDetail(BuildContext context, Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ArticleDetailScreen(article: article)),
    );
  }

  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng thông báo đang phát triển')),
    );
  }

  // void _showSettings(BuildContext context) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Tính năng cài đặt đang phát triển')),
  //   );
  // }
  void _showSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

}

// Loading Widget
class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.primaryRed),
          SizedBox(height: 16),
          Text('Đang tải tin tức...'),
        ],
      ),
    );
  }
}

// Error Widget
class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            const Text('Có lỗi xảy ra', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

// Empty State Widget
class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.newspaper, size: 64, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy bài viết',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodySmall?.color),
            ),
            const SizedBox(height: 8),
            Text(
              'Thử thay đổi bộ lọc hoặc làm mới dữ liệu',
              style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}