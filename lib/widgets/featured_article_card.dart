// lib/widgets/featured_article_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/article.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../utils/date_utils.dart';

class FeaturedArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const FeaturedArticleCard({
    Key? key,
    required this.article,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.defaultRadius)),
                  child: CachedNetworkImage(
                    imageUrl: article.imageUrl,
                    height: AppConstants.defaultImageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: AppConstants.defaultImageHeight,
                      color: Colors.grey[300],
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: AppConstants.defaultImageHeight,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, size: 64, color: Colors.grey[500]),
                    ),
                  ),
                ),

                // Category badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _mapCategoryToVietnamese(article.category),
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),

                // Source badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.getSourceColor(article.source),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      article.source == 'vnexpress' ? 'VE' : 'DT',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8),

                  // Summary
                  Text(
                    article.summary,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),

                  // Metadata
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 14, color: Colors.grey[500]),
                      SizedBox(width: 4),
                      Text(
                        AppDateUtils.formatRelativeDate(article.publishDate),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.visibility, size: 14, color: Colors.grey[500]),
                      SizedBox(width: 4),
                      Text(
                        '${article.viewCount} ${AppStrings.viewCount}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Spacer(),
                      if (article.author.isNotEmpty)
                        Text(
                          article.author,
                          style: TextStyle(fontSize: 11, color: AppTheme.primaryRed),
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
}