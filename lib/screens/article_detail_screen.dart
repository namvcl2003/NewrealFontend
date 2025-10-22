// // lib/screens/article_detail_screen.dart
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../models/article.dart';
// import '../utils/app_theme.dart';
// import '../utils/constants.dart';
// import '../utils/date_utils.dart';
//
// class ArticleDetailScreen extends StatefulWidget {
//   final Article article;
//
//   const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);
//
//   @override
//   State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
// }
//
// class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
//   final ScrollController _scrollController = ScrollController();
//   bool _isScrolled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _setupScrollController();
//   }
//
//   void _setupScrollController() {
//     _scrollController.addListener(() {
//       final isScrolled = _scrollController.offset > 100;
//       if (_isScrolled != isScrolled) {
//         setState(() {
//           _isScrolled = isScrolled;
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomScrollView(
//         controller: _scrollController,
//         slivers: [
//           _buildAppBar(context),
//           _buildContent(context),
//         ],
//       ),
//     );
//   }
//
//   /// Build app bar with dynamic title
//   Widget _buildAppBar(BuildContext context) {
//     return SliverAppBar(
//       backgroundColor: Colors.white,
//       elevation: _isScrolled ? 2 : 0,
//       pinned: true,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back, color: Colors.black54),
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: AnimatedOpacity(
//         opacity: _isScrolled ? 1.0 : 0.0,
//         duration: AppConstants.shortAnimation,
//         child: Text(
//           widget.article.title,
//           style: const TextStyle(
//             color: Colors.black87,
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.share, color: Colors.black54),
//           onPressed: () => _shareArticle(context),
//         ),
//         IconButton(
//           icon: const Icon(Icons.bookmark_border, color: Colors.black54),
//           onPressed: () => _bookmarkArticle(context),
//         ),
//         PopupMenuButton<String>(
//           icon: const Icon(Icons.more_vert, color: Colors.black54),
//           onSelected: (value) => _handleMenuAction(context, value),
//           itemBuilder: (context) => [
//             const PopupMenuItem(value: 'open_original', child: Text('Mở bài gốc')),
//             const PopupMenuItem(value: 'copy_link', child: Text('Sao chép liên kết')),
//             const PopupMenuItem(value: 'report', child: Text('Báo lỗi')),
//           ],
//         ),
//       ],
//     );
//   }
//
//   /// Build main content
//   Widget _buildContent(BuildContext context) {
//     return SliverList(
//       delegate: SliverChildListDelegate([
//         // Article header section
//         _buildArticleHeader(),
//
//         // Article image
//         if (widget.article.hasValidImage) _buildArticleImage(),
//
//         // Article content
//         _buildArticleContent(),
//
//         // Tags section
//         if (widget.article.tags.isNotEmpty) _buildTagsSection(),
//
//         // Action buttons
//         _buildActionButtons(),
//
//         // Related articles placeholder
//         _buildRelatedSection(),
//
//         // Bottom padding
//         const SizedBox(height: AppConstants.extraLargePadding),
//       ]),
//     );
//   }
//
//   /// Build article header with metadata
//   Widget _buildArticleHeader() {
//     return Container(
//       padding: const EdgeInsets.all(AppConstants.defaultPadding),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Category and source badges
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: AppTheme.primaryRed,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   widget.article.category,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: AppTheme.getSourceColor(widget.article.source),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   widget.article.sourceDisplayName,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const Spacer(),
//               if (AppDateUtils.shouldShowHotBadge(widget.article.publishDate))
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Text(
//                     'HOT',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 9,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 12),
//
//           // Title
//           Text(
//             widget.article.title,
//             style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               height: 1.3,
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           // Metadata row
//           Wrap(
//             spacing: 16,
//             runSpacing: 8,
//             children: [
//               if (widget.article.author.isNotEmpty) ...[
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.person, size: 16, color: Colors.grey[600]),
//                     const SizedBox(width: 4),
//                     Flexible(
//                       child: Text(
//                         widget.article.author,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: AppTheme.primaryRed,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
//                   const SizedBox(width: 4),
//                   Text(
//                     AppDateUtils.getContextualDateFormat(
//                       widget.article.publishDate,
//                       context: 'detail',
//                     ),
//                     style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
//                   const SizedBox(width: 4),
//                   Text(
//                     '${widget.article.viewCount} ${AppStrings.viewCount}',
//                     style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
//                   const SizedBox(width: 4),
//                   Text(
//                     AppDateUtils.getReadingTimeEstimate(widget.article.content.length),
//                     style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           // Summary box (VnExpress style)
//           Container(
//             padding: const EdgeInsets.all(AppConstants.defaultPadding),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFFF8E1),
//               borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
//               border: Border.all(color: const Color(0xFFFFCC02), width: 1),
//             ),
//             child: Text(
//               widget.article.summary,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black87,
//                 height: 1.5,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Build article image
//   Widget _buildArticleImage() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
//         child: Image.network(
//           widget.article.imageUrl,
//           width: double.infinity,
//           height: 250,
//           fit: BoxFit.cover,
//           loadingBuilder: (context, child, loadingProgress) {
//             if (loadingProgress == null) return child;
//             return Container(
//               height: 250,
//               color: Colors.grey[300],
//               child: Center(
//                 child: CircularProgressIndicator(
//                   value: loadingProgress.expectedTotalBytes != null
//                       ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//                       : null,
//                 ),
//               ),
//             );
//           },
//           errorBuilder: (context, error, stackTrace) {
//             return Container(
//               height: 250,
//               color: Colors.grey[300],
//               child: const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
//                     SizedBox(height: 8),
//                     Text('Không thể tải hình ảnh', style: TextStyle(color: Colors.grey)),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   /// Build article content
//   Widget _buildArticleContent() {
//     return Container(
//       padding: const EdgeInsets.all(AppConstants.defaultPadding),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Nội dung bài báo',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: AppTheme.primaryRed,
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           // Content text with better formatting
//           SelectableText(
//             widget.article.content,
//             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//               height: 1.6,
//               fontSize: 16,
//             ),
//             textAlign: TextAlign.justify,
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Build tags section
//   Widget _buildTagsSection() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Từ khóa:',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[700],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Wrap(
//             spacing: 8,
//             runSpacing: 6,
//             children: widget.article.tags.map((tag) {
//               return GestureDetector(
//                 onTap: () => _searchByTag(tag),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(15),
//                     border: Border.all(color: Colors.grey[300]!),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.tag, size: 12, color: Colors.grey[600]),
//                       const SizedBox(width: 4),
//                       Text(
//                         tag,
//                         style: TextStyle(fontSize: 12, color: Colors.grey[700]),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 24),
//         ],
//       ),
//     );
//   }
//
//   /// Build action buttons
//   Widget _buildActionButtons() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
//       child: Column(
//         children: [
//           // Primary actions
//           Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: () => _launchUrl(widget.article.url),
//                   icon: const Icon(Icons.open_in_new, size: 18),
//                   label: const Text(AppStrings.readOriginal),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: () => _shareArticle(context),
//                   icon: const Icon(Icons.share, size: 18),
//                   label: const Text(AppStrings.share),
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 12),
//
//           // Secondary actions
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               TextButton.icon(
//                 onPressed: () => _bookmarkArticle(context),
//                 icon: const Icon(Icons.bookmark_border, size: 18),
//                 label: const Text('Lưu bài'),
//               ),
//               TextButton.icon(
//                 onPressed: () => _copyLink(),
//                 icon: const Icon(Icons.copy, size: 18),
//                 label: const Text('Sao chép link'),
//               ),
//               TextButton.icon(
//                 onPressed: () => _reportArticle(context),
//                 icon: const Icon(Icons.report_outlined, size: 18),
//                 label: const Text('Báo lỗi'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Build related articles section
//   Widget _buildRelatedSection() {
//     return Container(
//       margin: const EdgeInsets.only(top: AppConstants.largePadding),
//       padding: const EdgeInsets.all(AppConstants.defaultPadding),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         border: Border(
//           top: BorderSide(color: Colors.grey[300]!, width: 1),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Bài viết liên quan',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: AppTheme.primaryRed,
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           // Placeholder for related articles
//           Container(
//             height: 100,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
//               border: Border.all(color: Colors.grey[300]!),
//             ),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.article_outlined, size: 32, color: Colors.grey[400]),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Tính năng bài viết liên quan\nđang được phát triển',
//                     style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Action methods
//   void _launchUrl(String url) async {
//     try {
//       final Uri uri = Uri.parse(url);
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(
//           uri,
//           mode: LaunchMode.externalApplication,
//         );
//       } else {
//         _showErrorSnackBar('Không thể mở liên kết');
//       }
//     } catch (e) {
//       _showErrorSnackBar('Lỗi khi mở liên kết: $e');
//     }
//   }
//
//   void _shareArticle(BuildContext context) {
//     final shareText = '${widget.article.title}\n\n${widget.article.url}';
//
//     // For now, copy to clipboard (you can integrate actual sharing later)
//     Clipboard.setData(ClipboardData(text: shareText));
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Đã sao chép liên kết để chia sẻ'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
//
//   void _bookmarkArticle(BuildContext context) {
//     // TODO: Implement bookmark functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Tính năng lưu bài đang được phát triển'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
//
//   void _copyLink() {
//     Clipboard.setData(ClipboardData(text: widget.article.url));
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Đã sao chép liên kết'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
//
//   void _searchByTag(String tag) {
//     // TODO: Navigate to search screen with tag filter
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Tìm kiếm theo từ khóa: $tag'),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }
//
//   void _reportArticle(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Báo lỗi bài viết'),
//         content: const Text('Bạn có muốn báo cáo vấn đề với bài viết này?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Hủy'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _showSuccessSnackBar('Đã gửi báo cáo. Cảm ơn bạn!');
//             },
//             child: const Text('Báo cáo'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _handleMenuAction(BuildContext context, String action) {
//     switch (action) {
//       case 'open_original':
//         _launchUrl(widget.article.url);
//         break;
//       case 'copy_link':
//         _copyLink();
//         break;
//       case 'report':
//         _reportArticle(context);
//         break;
//     }
//   }
//
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red[600],
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
//
//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.green[600],
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
// }


// lib/screens/article_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../providers/article_provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../utils/date_utils.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  List<Article> _relatedArticles = [];
  bool _loadingRelated = true;

  @override
  void initState() {
    super.initState();
    _setupScrollController();
    _loadRelatedArticles();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      final isScrolled = _scrollController.offset > 100;
      if (_isScrolled != isScrolled) {
        setState(() {
          _isScrolled = isScrolled;
        });
      }
    });
  }

  void _loadRelatedArticles() {
    final provider = Provider.of<ArticleProvider>(context, listen: false);

    setState(() {
      _loadingRelated = true;
    });

    // Get related articles by tags (smarter matching)
    // If no tags, fallback to category matching
    _relatedArticles = provider.getRelatedArticlesByTags(
      widget.article,
      limit: 5,
    );

    setState(() {
      _loadingRelated = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(context),
          _buildContent(context),
        ],
      ),
    );
  }

  /// Build app bar with dynamic title
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: _isScrolled ? 2 : 0,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black54),
        onPressed: () => Navigator.pop(context),
      ),
      title: AnimatedOpacity(
        opacity: _isScrolled ? 1.0 : 0.0,
        duration: AppConstants.shortAnimation,
        child: Text(
          widget.article.title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.black54),
          onPressed: () => _shareArticle(context),
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: Colors.black54),
          onPressed: () => _bookmarkArticle(context),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.black54),
          onSelected: (value) => _handleMenuAction(context, value),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'open_original', child: Text('Mở bài gốc')),
            const PopupMenuItem(value: 'copy_link', child: Text('Sao chép liên kết')),
            const PopupMenuItem(value: 'report', child: Text('Báo lỗi')),
          ],
        ),
      ],
    );
  }

  /// Build main content
  Widget _buildContent(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        // Article header section
        _buildArticleHeader(),

        // Article image
        if (widget.article.hasValidImage) _buildArticleImage(),

        // Article content
        _buildArticleContent(),

        // Tags section
        if (widget.article.tags.isNotEmpty) _buildTagsSection(),

        // Action buttons
        _buildActionButtons(),

        // Related articles section - NEW!
        _buildRelatedSection(),

        // Bottom padding
        const SizedBox(height: AppConstants.extraLargePadding),
      ]),
    );
  }

  /// Build article header with metadata
  Widget _buildArticleHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category and source badges
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.article.category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.getSourceColor(widget.article.source),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.article.sourceDisplayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              if (AppDateUtils.shouldShowHotBadge(widget.article.publishDate))
                Container(
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
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            widget.article.title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),

          // Metadata row
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              if (widget.article.author.isNotEmpty) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        widget.article.author,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.primaryRed,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    AppDateUtils.getContextualDateFormat(
                      widget.article.publishDate,
                      context: 'detail',
                    ),
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.article.viewCount} ${AppStrings.viewCount}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    AppDateUtils.getReadingTimeEstimate(widget.article.content.length),
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Summary box (VnExpress style)
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              border: Border.all(color: const Color(0xFFFFCC02), width: 1),
            ),
            child: Text(
              widget.article.summary,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build article image
  Widget _buildArticleImage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        child: Image.network(
          widget.article.imageUrl,
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 250,
              color: Colors.grey[300],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 250,
              color: Colors.grey[300],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Không thể tải hình ảnh', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build article content
  Widget _buildArticleContent() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nội dung bài báo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryRed,
            ),
          ),
          const SizedBox(height: 12),

          // Content text with better formatting
          SelectableText(
            widget.article.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
              fontSize: 16,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  /// Build tags section
  Widget _buildTagsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Từ khóa:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: widget.article.tags.map((tag) {
              return GestureDetector(
                onTap: () => _searchByTag(tag),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.tag, size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        tag,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Column(
        children: [
          // Primary actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchUrl(widget.article.url),
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: const Text(AppStrings.readOriginal),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _shareArticle(context),
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text(AppStrings.share),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Secondary actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () => _bookmarkArticle(context),
                icon: const Icon(Icons.bookmark_border, size: 18),
                label: const Text('Lưu bài'),
              ),
              TextButton.icon(
                onPressed: () => _copyLink(),
                icon: const Icon(Icons.copy, size: 18),
                label: const Text('Sao chép link'),
              ),
              TextButton.icon(
                onPressed: () => _reportArticle(context),
                icon: const Icon(Icons.report_outlined, size: 18),
                label: const Text('Báo lỗi'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build related articles section - UPDATED WITH REAL DATA!
  Widget _buildRelatedSection() {
    return Container(
      margin: const EdgeInsets.only(top: AppConstants.largePadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.article_outlined, size: 20, color: AppTheme.primaryRed),
              const SizedBox(width: 8),
              Text(
                'Bài viết liên quan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryRed,
                ),
              ),
              const Spacer(),
              if (_loadingRelated)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Related articles list
          if (_loadingRelated)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_relatedArticles.isEmpty)
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.article_outlined, size: 32, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'Không có bài viết liên quan',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: _relatedArticles.map((article) {
                return _buildRelatedArticleItem(article);
              }).toList(),
            ),
        ],
      ),
    );
  }

  /// Build related article item
  Widget _buildRelatedArticleItem(Article article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to article detail
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(article: article),
            ),
          );
        },
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
                  height: 70,
                  width: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 70,
                      width: 90,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, size: 24, color: Colors.grey[500]),
                    );
                  },
                )
                    : Container(
                  height: 70,
                  width: 90,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 24, color: Colors.grey[500]),
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
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Metadata
                    Row(
                      children: [
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
                        const SizedBox(width: 8),
                        Icon(Icons.schedule, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            AppDateUtils.formatRelativeDate(article.publishDate),
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  // Action methods
  void _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showErrorSnackBar('Không thể mở liên kết');
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi khi mở liên kết: $e');
    }
  }

  void _shareArticle(BuildContext context) {
    final shareText = '${widget.article.title}\n\n${widget.article.url}';
    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép liên kết để chia sẻ'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _bookmarkArticle(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng lưu bài đang được phát triển'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: widget.article.url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép liên kết'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _searchByTag(String tag) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tìm kiếm theo từ khóa: $tag'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _reportArticle(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Báo lỗi bài viết'),
        content: const Text('Bạn có muốn báo cáo vấn đề với bài viết này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('Đã gửi báo cáo. Cảm ơn bạn!');
            },
            child: const Text('Báo cáo'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'open_original':
        _launchUrl(widget.article.url);
        break;
      case 'copy_link':
        _copyLink();
        break;
      case 'report':
        _reportArticle(context);
        break;
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 3),
      ),
    );
  }
}