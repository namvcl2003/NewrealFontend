// lib/widgets/article_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/article.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../utils/date_utils.dart';

/// Regular article card widget for displaying articles in list
class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final bool isBookmarked;

  const ArticleCard({
    Key? key,
    required this.article,
    required this.onTap,
    this.onBookmark,
    this.onShare,
    this.isBookmarked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article thumbnail
              _buildThumbnail(),
              const SizedBox(width: 12),

              // Article content
              Expanded(
                child: _buildContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build article thumbnail
  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Stack(
        children: [
          // Main image
          article.hasValidImage
              ? CachedNetworkImage(
            imageUrl: article.imageUrl,
            height: AppConstants.thumbnailImageHeight,
            width: AppConstants.thumbnailImageWidth,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildImagePlaceholder(showLoading: true),
            errorWidget: (context, url, error) => _buildImagePlaceholder(),
          )
              : _buildImagePlaceholder(),

          // Breaking news badge
          if (AppDateUtils.shouldShowHotBadge(article.publishDate))
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'HOT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build image placeholder
  Widget _buildImagePlaceholder({bool showLoading = false}) {
    return Container(
      height: AppConstants.thumbnailImageHeight,
      width: AppConstants.thumbnailImageWidth,
      color: Colors.grey[300],
      child: showLoading
          ? const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppTheme.primaryRed,
        ),
      )
          : Icon(
        Icons.image,
        size: 32,
        color: Colors.grey[500],
      ),
    );
  }

  /// Build article content
  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category and source badges
        _buildBadges(),
        const SizedBox(height: 6),

        // Article title
        _buildTitle(context),
        const SizedBox(height: 6),

        // Article summary
        _buildSummary(context),
        const SizedBox(height: 8),

        // Article metadata
        _buildMetadata(context),
      ],
    );
  }

  /// Build category and source badges
  Widget _buildBadges() {
    return Row(
      children: [
        // Category badge
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

        // Source badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.getSourceColor(article.source),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            article.sourceShortName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Reading time
        const Spacer(),
        if (article.content.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time, size: 10, color: Colors.grey[600]),
                const SizedBox(width: 2),
                Text(
                  AppDateUtils.getReadingTimeEstimate(article.content.length),
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Build article title
  Widget _buildTitle(BuildContext context) {
    return Text(
      article.title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        height: 1.2,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Build article summary
  Widget _buildSummary(BuildContext context) {
    return Text(
      article.summary,
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 12,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Build article metadata
  Widget _buildMetadata(BuildContext context) {
    return Row(
      children: [
        // Publish time
        Icon(Icons.schedule, size: 12, color: Colors.grey[500]),
        const SizedBox(width: 2),
        Text(
          AppDateUtils.formatRelativeDate(article.publishDate),
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
        ),
        const SizedBox(width: 12),

        // View count
        Icon(Icons.visibility, size: 12, color: Colors.grey[500]),
        const SizedBox(width: 2),
        Text(
          article.readableViewCount,
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
        ),

        // Author (if available and space permits)
        if (article.author.isNotEmpty) ...[
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              article.author,
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.primaryRed,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ] else
          const Spacer(),

        // Action buttons
        _buildActionButtons(),
      ],
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bookmark button
        if (onBookmark != null)
          GestureDetector(
            onTap: onBookmark,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                size: 16,
                color: isBookmarked ? AppTheme.primaryRed : Colors.grey[500],
              ),
            ),
          ),

        // Share button
        if (onShare != null)
          GestureDetector(
            onTap: onShare,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.share,
                size: 16,
                color: Colors.grey[500],
              ),
            ),
          ),
      ],
    );
  }
}

/// Featured article card widget for highlighting main articles
class FeaturedArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final bool isBookmarked;

  const FeaturedArticleCard({
    Key? key,
    required this.article,
    required this.onTap,
    this.onBookmark,
    this.onShare,
    this.isBookmarked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured image
            _buildFeaturedImage(),

            // Article content
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: _buildFeaturedContent(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Build featured image
  Widget _buildFeaturedImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppConstants.defaultRadius),
          ),
          child: article.hasValidImage
              ? CachedNetworkImage(
            imageUrl: article.imageUrl,
            height: AppConstants.defaultImageHeight,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildImagePlaceholder(showLoading: true),
            errorWidget: (context, url, error) => _buildImagePlaceholder(),
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Breaking news badge
        if (AppDateUtils.shouldShowHotBadge(article.publishDate))
          Positioned(
            top: 12,
            left: 50,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'HOT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Action buttons overlay
        Positioned(
          bottom: 12,
          right: 12,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onBookmark != null)
                _buildOverlayButton(
                  icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  onTap: onBookmark!,
                  isActive: isBookmarked,
                ),
              if (onShare != null) ...[
                const SizedBox(width: 8),
                _buildOverlayButton(
                  icon: Icons.share,
                  onTap: onShare!,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Build overlay button
  Widget _buildOverlayButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? AppTheme.primaryRed : Colors.white,
        ),
      ),
    );
  }

  /// Build image placeholder for featured
  Widget _buildImagePlaceholder({bool showLoading = false}) {
    return Container(
      height: AppConstants.defaultImageHeight,
      width: double.infinity,
      color: Colors.grey[300],
      child: showLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryRed,
        ),
      )
          : Icon(
        Icons.image,
        size: 64,
        color: Colors.grey[500],
      ),
    );
  }

  /// Build featured content
  Widget _buildFeaturedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          article.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),

        // Summary
        Text(
          article.summary,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            height: 1.4,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),

        // Tags (if available)
        if (article.tags.isNotEmpty) ...[
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: article.tags.take(3).map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[700],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],

        // Metadata
        _buildFeaturedMetadata(context),
      ],
    );
  }

  /// Build featured metadata
  Widget _buildFeaturedMetadata(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.schedule, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          AppDateUtils.formatRelativeDate(article.publishDate),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(width: 16),
        Icon(Icons.visibility, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          '${article.readableViewCount} ${AppStrings.viewCount}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (article.content.isNotEmpty) ...[
          const SizedBox(width: 16),
          Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
          const SizedBox(width: 4),
          Text(
            AppDateUtils.getReadingTimeEstimate(article.content.length),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const Spacer(),
        if (article.author.isNotEmpty)
          Text(
            article.author,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.primaryRed,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}

/// Compact article card for search results or secondary lists
class CompactArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  final String? highlightText;

  const CompactArticleCard({
    Key? key,
    required this.article,
    required this.onTap,
    this.highlightText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            // Small thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: article.hasValidImage
                  ? CachedNetworkImage(
                imageUrl: article.imageUrl,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 60,
                  width: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 24, color: Colors.grey),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 60,
                  width: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 24, color: Colors.grey),
                ),
              )
                  : Container(
                height: 60,
                width: 60,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 24, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Metadata
                  Row(
                    children: [
                      Text(
                        article.sourceDisplayName,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.getSourceColor(article.source),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppDateUtils.formatRelativeDate(article.publishDate),
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}