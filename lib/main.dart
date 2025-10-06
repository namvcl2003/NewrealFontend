// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:intl/intl.dart';
// // import 'package:url_launcher/url_launcher.dart';
// //
// // // Model classes
// // class Article {
// //   final String id;
// //   final String url;
// //   final String source;
// //   final String title;
// //   final String summary;
// //   final String content;
// //   final String author;
// //   final String publishDate;
// //   final String category;
// //   final List<String> tags;
// //   final String imageUrl;
// //   final String viewCount;
// //   final String crawlTimestamp;
// //
// //   Article({
// //     required this.id,
// //     required this.url,
// //     required this.source,
// //     required this.title,
// //     required this.summary,
// //     required this.content,
// //     required this.author,
// //     required this.publishDate,
// //     required this.category,
// //     required this.tags,
// //     required this.imageUrl,
// //     required this.viewCount,
// //     required this.crawlTimestamp,
// //   });
// //
// //   factory Article.fromJson(Map<String, dynamic> json) {
// //     return Article(
// //       id: json['_id'] ?? '',
// //       url: json['url'] ?? '',
// //       source: json['source'] ?? '',
// //       title: json['title'] ?? '',
// //       summary: json['summary'] ?? '',
// //       content: json['content'] ?? '',
// //       author: json['author'] ?? '',
// //       publishDate: json['publish_date'] ?? '',
// //       category: json['category'] ?? '',
// //       tags: List<String>.from(json['tags'] ?? []),
// //       imageUrl: json['image_url'] ?? '',
// //       viewCount: json['view_count'] ?? '0',
// //       crawlTimestamp: json['crawl_timestamp'] ?? '',
// //     );
// //   }
// // }
// //
// // class NewsStats {
// //   final int totalArticles;
// //   final int totalViews;
// //   final String topCategory;
// //   final int todayArticles;
// //
// //   NewsStats({
// //     required this.totalArticles,
// //     required this.totalViews,
// //     required this.topCategory,
// //     required this.todayArticles,
// //   });
// // }
// //
// // // Main App
// // class NewsEditorialApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Hệ thống Tòa soạn Điện tử',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //         visualDensity: VisualDensity.adaptivePlatformDensity,
// //         appBarTheme: AppBarTheme(
// //           backgroundColor: Colors.white,
// //           foregroundColor: Colors.black,
// //           elevation: 1,
// //         ),
// //       ),
// //       home: NewsEditorialDashboard(),
// //     );
// //   }
// // }
// //
// // // Dashboard Screen
// // class NewsEditorialDashboard extends StatefulWidget {
// //   @override
// //   _NewsEditorialDashboardState createState() => _NewsEditorialDashboardState();
// // }
// //
// // class _NewsEditorialDashboardState extends State<NewsEditorialDashboard> {
// //   List<Article> _articles = [];
// //   List<Article> _filteredArticles = [];
// //   bool _loading = true;
// //
// //   String _searchTerm = '';
// //   String _selectedCategory = 'Tất cả';
// //   String _selectedSource = 'Tất cả';
// //   String _dateFilter = 'today';
// //
// //   List<String> _categories = ['Tất cả'];
// //   List<String> _sources = ['Tất cả'];
// //
// //   final TextEditingController _searchController = TextEditingController();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadSampleData();
// //   }
// //
// //   // Load sample data (replace with API call)
// //   void _loadSampleData() {
// //     Future.delayed(Duration(seconds: 2), () {
// //       setState(() {
// //         _articles = [
// //           Article(
// //             id: "fdcc06ad49fc7679d4dd01acea4c00ec",
// //             url: "https://dantri.com.vn/xa-hoi/nuoc-tran-bo-de-hang-nghin-ho-dan-bi-ngap-sau-trong-lu-20250827172655877.htm",
// //             source: "dantri",
// //             title: "Nước tràn bờ đê, hàng nghìn hộ dân bị ngập sâu trong lũ",
// //             summary: "(Dân trí) - Lũ từ trên thượng nguồn đổ về khiến nước sông Bưởi qua xã Kim Tân, tỉnh Thanh Hóa vượt mức báo động 3. Trưa nay, nước lũ tràn qua đê bao sông Bưởi, gây ngập lụt hơn 1.500 hộ dân trên địa bàn.",
// //             content: "Tảng đá lớn từ trên núi lăn xuống đường sắt Bắc - Nam...",
// //             author: "Thực hiện: Thanh Tùng - Quách Tuấn",
// //             publishDate: "2025-08-27 17:49",
// //             category: "Xã hội",
// //             tags: ["Môi trường", "Giao thông", "Nóng trên mạng"],
// //             imageUrl: "https://cdnphoto.dantri.com.vn/4LP9bqQswpJsBWv7P611NPLHUuw=/2025/08/29/lgpng-1756450605989.png",
// //             viewCount: "1,247",
// //             crawlTimestamp: "2025-09-04 09:42:38",
// //           ),
// //           Article(
// //             id: "sample2",
// //             url: "https://vnexpress.net/sample",
// //             source: "vnexpress",
// //             title: "Thị trường bất động sản cuối năm có nhiều biến động",
// //             summary: "Các chuyên gia dự báo thị trường bất động sản trong quý 4/2025 sẽ có những thay đổi đáng kể, đặc biệt ở phân khúc nhà ở.",
// //             content: "Nội dung bài viết...",
// //             author: "Minh Anh",
// //             publishDate: "2025-09-25 14:30",
// //             category: "Kinh tế",
// //             tags: ["Bất động sản", "Thị trường", "Tài chính"],
// //             imageUrl: "https://images.unsplash.com/photo-1560520653-9e0e4c89eb11?w=400&h=300&fit=crop",
// //             viewCount: "3,456",
// //             crawlTimestamp: "2025-09-25 15:00:00",
// //           ),
// //           Article(
// //             id: "sample3",
// //             url: "https://dantri.com.vn/sample3",
// //             source: "dantri",
// //             title: "Công nghệ AI mới giúp dự báo thời tiết chính xác hơn",
// //             summary: "Hệ thống AI mới được phát triển có thể dự báo thời tiết với độ chính xác lên đến 95%, giúp cảnh báo thiên tai hiệu quả hơn.",
// //             content: "Nội dung chi tiết về công nghệ...",
// //             author: "Minh Quân",
// //             publishDate: "2025-09-25 10:15",
// //             category: "Công nghệ",
// //             tags: ["AI", "Khoa học", "Thời tiết"],
// //             imageUrl: "https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=400&h=300&fit=crop",
// //             viewCount: "2,189",
// //             crawlTimestamp: "2025-09-25 10:45:00",
// //           ),
// //         ];
// //         _updateFilters();
// //         _filteredArticles = _articles;
// //         _loading = false;
// //       });
// //     });
// //   }
// //
// //   void _updateFilters() {
// //     Set<String> categories = {'Tất cả'};
// //     Set<String> sources = {'Tất cả'};
// //
// //     for (Article article in _articles) {
// //       if (article.category.isNotEmpty) categories.add(article.category);
// //       if (article.source.isNotEmpty) sources.add(article.source);
// //     }
// //
// //     _categories = categories.toList()..sort();
// //     _sources = sources.toList()..sort();
// //   }
// //
// //   void _filterArticles() {
// //     setState(() {
// //       _filteredArticles = _articles.where((article) {
// //         bool matchesSearch = article.title.toLowerCase().contains(_searchTerm.toLowerCase()) ||
// //             article.summary.toLowerCase().contains(_searchTerm.toLowerCase());
// //         bool matchesCategory = _selectedCategory == 'Tất cả' || article.category == _selectedCategory;
// //         bool matchesSource = _selectedSource == 'Tất cả' || article.source == _selectedSource;
// //
// //         return matchesSearch && matchesCategory && matchesSource;
// //       }).toList();
// //     });
// //   }
// //
// //   NewsStats _calculateStats() {
// //     int totalViews = _articles.fold(0, (sum, article) {
// //       int views = int.tryParse(article.viewCount.replaceAll(',', '')) ?? 0;
// //       return sum + views;
// //     });
// //
// //     Map<String, int> categoryCount = {};
// //     for (Article article in _articles) {
// //       categoryCount[article.category] = (categoryCount[article.category] ?? 0) + 1;
// //     }
// //
// //     String topCategory = categoryCount.entries.isEmpty ? '' :
// //     categoryCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
// //
// //     DateTime today = DateTime.now();
// //     int todayArticles = _articles.where((article) {
// //       try {
// //         DateTime articleDate = DateTime.parse(article.publishDate.replaceAll(' ', 'T') + ':00');
// //         return articleDate.year == today.year &&
// //             articleDate.month == today.month &&
// //             articleDate.day == today.day;
// //       } catch (e) {
// //         return false;
// //       }
// //     }).length;
// //
// //     return NewsStats(
// //       totalArticles: _articles.length,
// //       totalViews: totalViews,
// //       topCategory: topCategory,
// //       todayArticles: todayArticles,
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     NewsStats stats = _calculateStats();
// //
// //     if (_loading) {
// //       return Scaffold(
// //         body: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               CircularProgressIndicator(),
// //               SizedBox(height: 16),
// //               Text('Đang tải dữ liệu...', style: TextStyle(color: Colors.grey[600])),
// //             ],
// //           ),
// //         ),
// //       );
// //     }
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Row(
// //           children: [
// //             Icon(Icons.newspaper, color: Colors.blue[600]),
// //             SizedBox(width: 8),
// //             Text('Hệ thống Tòa soạn Điện tử'),
// //           ],
// //         ),
// //         actions: [
// //           Padding(
// //             padding: EdgeInsets.all(16),
// //             child: Text(
// //               'Cập nhật: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
// //               style: TextStyle(fontSize: 12, color: Colors.grey[600]),
// //             ),
// //           ),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           // Stats Dashboard
// //           Container(
// //             padding: EdgeInsets.all(16),
// //             child: Row(
// //               children: [
// //                 Expanded(child: _buildStatCard('Tổng bài viết', '${stats.totalArticles}', Icons.newspaper, Colors.blue)),
// //                 SizedBox(width: 8),
// //                 Expanded(child: _buildStatCard('Tổng lượt xem', '${NumberFormat('#,###').format(stats.totalViews)}', Icons.visibility, Colors.green)),
// //                 SizedBox(width: 8),
// //                 Expanded(child: _buildStatCard('Chủ đề hot', stats.topCategory, Icons.trending_up, Colors.orange)),
// //                 SizedBox(width: 8),
// //                 Expanded(child: _buildStatCard('Hôm nay', '${stats.todayArticles}', Icons.today, Colors.purple)),
// //               ],
// //             ),
// //           ),
// //
// //           // Filters
// //           Container(
// //             padding: EdgeInsets.symmetric(horizontal: 16),
// //             child: Card(
// //               child: Padding(
// //                 padding: EdgeInsets.all(16),
// //                 child: Column(
// //                   children: [
// //                     // Search
// //                     TextField(
// //                       controller: _searchController,
// //                       decoration: InputDecoration(
// //                         hintText: 'Tìm kiếm bài viết...',
// //                         prefixIcon: Icon(Icons.search),
// //                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //                         contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                       ),
// //                       onChanged: (value) {
// //                         _searchTerm = value;
// //                         _filterArticles();
// //                       },
// //                     ),
// //                     SizedBox(height: 12),
// //                     // Dropdowns
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: DropdownButtonFormField<String>(
// //                             value: _selectedCategory,
// //                             decoration: InputDecoration(
// //                               labelText: 'Danh mục',
// //                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //                             ),
// //                             items: _categories.map((category) {
// //                               return DropdownMenuItem(value: category, child: Text(category));
// //                             }).toList(),
// //                             onChanged: (value) {
// //                               setState(() {
// //                                 _selectedCategory = value!;
// //                                 _filterArticles();
// //                               });
// //                             },
// //                           ),
// //                         ),
// //                         SizedBox(width: 8),
// //                         Expanded(
// //                           child: DropdownButtonFormField<String>(
// //                             value: _selectedSource,
// //                             decoration: InputDecoration(
// //                               labelText: 'Nguồn',
// //                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //                             ),
// //                             items: _sources.map((source) {
// //                               String displayName = source == 'Tất cả' ? 'Tất cả nguồn' :
// //                               source == 'dantri' ? 'Dân Trí' : 'VnExpress';
// //                               return DropdownMenuItem(value: source, child: Text(displayName));
// //                             }).toList(),
// //                             onChanged: (value) {
// //                               setState(() {
// //                                 _selectedSource = value!;
// //                                 _filterArticles();
// //                               });
// //                             },
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     SizedBox(height: 8),
// //                     Row(
// //                       children: [
// //                         Icon(Icons.filter_list, size: 16, color: Colors.grey[600]),
// //                         SizedBox(width: 4),
// //                         Text('Hiển thị ${_filteredArticles.length} / ${_articles.length} bài viết',
// //                             style: TextStyle(fontSize: 12, color: Colors.grey[600])),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //
// //           // Articles List
// //           Expanded(
// //             child: _filteredArticles.isEmpty
// //                 ? Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.newspaper, size: 64, color: Colors.grey[400]),
// //                   SizedBox(height: 16),
// //                   Text('Không tìm thấy bài viết', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
// //                   Text('Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm', style: TextStyle(color: Colors.grey[500])),
// //                 ],
// //               ),
// //             )
// //                 : ListView.builder(
// //               padding: EdgeInsets.all(16),
// //               itemCount: _filteredArticles.length,
// //               itemBuilder: (context, index) {
// //                 return _buildArticleCard(_filteredArticles[index]);
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStatCard(String title, String value, IconData icon, Color color) {
// //     return Card(
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             Icon(icon, color: color, size: 24),
// //             SizedBox(height: 8),
// //             Text(title, style: TextStyle(fontSize: 10, color: Colors.grey[600]), textAlign: TextAlign.center),
// //             SizedBox(height: 4),
// //             Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildArticleCard(Article article) {
// //     return Card(
// //       margin: EdgeInsets.only(bottom: 16),
// //       child: InkWell(
// //         onTap: () => _showArticleDetail(article),
// //         borderRadius: BorderRadius.circular(8),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Image and badges
// //             if (article.imageUrl.isNotEmpty)
// //               Stack(
// //                 children: [
// //                   ClipRRect(
// //                     borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
// //                     child: Image.network(
// //                       article.imageUrl,
// //                       height: 200,
// //                       width: double.infinity,
// //                       fit: BoxFit.cover,
// //                       errorBuilder: (context, error, stackTrace) {
// //                         return Container(
// //                           height: 200,
// //                           color: Colors.grey[300],
// //                           child: Icon(Icons.image, size: 64, color: Colors.grey[500]),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                   Positioned(
// //                     top: 8,
// //                     left: 8,
// //                     child: Container(
// //                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                       decoration: BoxDecoration(
// //                         color: article.source == 'dantri' ? Colors.blue : Colors.red,
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       child: Text(
// //                         article.source == 'dantri' ? 'DT' : 'VE',
// //                         style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
// //                       ),
// //                     ),
// //                   ),
// //                   Positioned(
// //                     top: 8,
// //                     right: 8,
// //                     child: Container(
// //                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                       decoration: BoxDecoration(
// //                         color: Colors.black87,
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       child: Text(
// //                         article.category,
// //                         style: TextStyle(color: Colors.white, fontSize: 12),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //
// //             Padding(
// //               padding: EdgeInsets.all(16),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   // Title
// //                   Text(
// //                     article.title,
// //                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                     maxLines: 2,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                   SizedBox(height: 8),
// //
// //                   // Summary
// //                   Text(
// //                     article.summary,
// //                     style: TextStyle(color: Colors.grey[600], fontSize: 14),
// //                     maxLines: 3,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                   SizedBox(height: 12),
// //
// //                   // Tags
// //                   if (article.tags.isNotEmpty)
// //                     Wrap(
// //                       spacing: 4,
// //                       runSpacing: 4,
// //                       children: article.tags.take(3).map((tag) {
// //                         return Container(
// //                           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                           decoration: BoxDecoration(
// //                             color: Colors.blue[50],
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: Text(tag, style: TextStyle(fontSize: 12, color: Colors.blue[800])),
// //                         );
// //                       }).toList(),
// //                     ),
// //                   SizedBox(height: 12),
// //
// //                   // Metadata
// //                   Row(
// //                     children: [
// //                       Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
// //                       SizedBox(width: 4),
// //                       Text(
// //                         _formatDate(article.publishDate),
// //                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
// //                       ),
// //                       Spacer(),
// //                       if (article.viewCount.isNotEmpty) ...[
// //                         Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
// //                         SizedBox(width: 4),
// //                         Text(
// //                           '${article.viewCount} lượt xem',
// //                           style: TextStyle(fontSize: 12, color: Colors.grey[600]),
// //                         ),
// //                       ],
// //                     ],
// //                   ),
// //
// //                   if (article.author.isNotEmpty) ...[
// //                     SizedBox(height: 8),
// //                     Row(
// //                       children: [
// //                         Icon(Icons.person, size: 16, color: Colors.grey[600]),
// //                         SizedBox(width: 4),
// //                         Expanded(
// //                           child: Text(
// //                             article.author,
// //                             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //
// //                   SizedBox(height: 16),
// //                   Divider(),
// //
// //                   // Actions
// //                   Row(
// //                     children: [
// //                       TextButton.icon(
// //                         onPressed: () => _showArticleDetail(article),
// //                         icon: Icon(Icons.summarize, size: 16),
// //                         label: Text('Xem tóm tắt'),
// //                       ),
// //                       Spacer(),
// //                       TextButton.icon(
// //                         onPressed: () => _launchUrl(article.url),
// //                         icon: Icon(Icons.open_in_new, size: 16),
// //                         label: Text('Bài gốc'),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   String _formatDate(String dateString) {
// //     try {
// //       DateTime date = DateTime.parse(dateString.replaceAll(' ', 'T') + ':00');
// //       return DateFormat('dd/MM/yyyy HH:mm').format(date);
// //     } catch (e) {
// //       return dateString;
// //     }
// //   }
// //
// //   void _showArticleDetail(Article article) {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       builder: (context) => ArticleDetailSheet(article: article),
// //     );
// //   }
// //
// //   void _launchUrl(String url) async {
// //     if (await canLaunch(url)) {
// //       await launch(url);
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Không thể mở liên kết')),
// //       );
// //     }
// //   }
// // }
// //
// // // Article Detail Sheet
// // class ArticleDetailSheet extends StatelessWidget {
// //   final Article article;
// //
// //   ArticleDetailSheet({required this.article});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return DraggableScrollableSheet(
// //       initialChildSize: 0.7,
// //       minChildSize: 0.5,
// //       maxChildSize: 0.95,
// //       builder: (context, scrollController) {
// //         return Container(
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //           ),
// //           child: Column(
// //             children: [
// //               Container(
// //                 width: 40,
// //                 height: 4,
// //                 margin: EdgeInsets.symmetric(vertical: 8),
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey[300],
// //                   borderRadius: BorderRadius.circular(2),
// //                 ),
// //               ),
// //               Expanded(
// //                 child: SingleChildScrollView(
// //                   controller: scrollController,
// //                   padding: EdgeInsets.all(16),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       // Image
// //                       if (article.imageUrl.isNotEmpty)
// //                         ClipRRect(
// //                           borderRadius: BorderRadius.circular(8),
// //                           child: Image.network(
// //                             article.imageUrl,
// //                             width: double.infinity,
// //                             height: 200,
// //                             fit: BoxFit.cover,
// //                             errorBuilder: (context, error, stackTrace) {
// //                               return Container(
// //                                 height: 200,
// //                                 color: Colors.grey[300],
// //                                 child: Icon(Icons.image, size: 64, color: Colors.grey[500]),
// //                               );
// //                             },
// //                           ),
// //                         ),
// //                       SizedBox(height: 16),
// //
// //                       // Title
// //                       Text(
// //                         article.title,
// //                         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //                       ),
// //                       SizedBox(height: 16),
// //
// //                       // Summary
// //                       Container(
// //                         padding: EdgeInsets.all(16),
// //                         decoration: BoxDecoration(
// //                           color: Colors.blue[50],
// //                           borderRadius: BorderRadius.circular(8),
// //                         ),
// //                         child: Text(
// //                           article.summary,
// //                           style: TextStyle(fontSize: 16, color: Colors.blue[800]),
// //                         ),
// //                       ),
// //                       SizedBox(height: 16),
// //
// //                       // Content
// //                       Text(
// //                         'Nội dung tóm tắt:',
// //                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                       ),
// //                       SizedBox(height: 8),
// //                       Text(
// //                         article.content,
// //                         style: TextStyle(fontSize: 16, height: 1.5),
// //                       ),
// //                       SizedBox(height: 24),
// //
// //                       // Actions
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: ElevatedButton.icon(
// //                               onPressed: () async {
// //                                 if (await canLaunch(article.url)) {
// //                                   await launch(article.url);
// //                                 }
// //                               },
// //                               icon: Icon(Icons.open_in_new),
// //                               label: Text('Đọc bài gốc'),
// //                             ),
// //                           ),
// //                           SizedBox(width: 16),
// //                           Expanded(
// //                             child: OutlinedButton.icon(
// //                               onPressed: () => Navigator.pop(context),
// //                               icon: Icon(Icons.close),
// //                               label: Text('Đóng'),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
// //
// // // Main function
// // void main() {
// //   runApp(NewsEditorialApp());
// // }
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// // Model classes
// class Article {
//   final String id;
//   final String url;
//   final String source;
//   final String title;
//   final String summary;
//   final String content;
//   final String author;
//   final String publishDate;
//   final String category;
//   final List<String> tags;
//   final String imageUrl;
//   final String viewCount;
//   final String crawlTimestamp;
//
//   Article({
//     required this.id,
//     required this.url,
//     required this.source,
//     required this.title,
//     required this.summary,
//     required this.content,
//     required this.author,
//     required this.publishDate,
//     required this.category,
//     required this.tags,
//     required this.imageUrl,
//     required this.viewCount,
//     required this.crawlTimestamp,
//   });
//
//   factory Article.fromJson(Map<String, dynamic> json) {
//     return Article(
//       id: json['_id'] ?? '',
//       url: json['url'] ?? '',
//       source: json['source'] ?? '',
//       title: json['title'] ?? '',
//       summary: json['summary'] ?? '',
//       content: json['content'] ?? '',
//       author: json['author'] ?? '',
//       publishDate: json['publish_date'] ?? '',
//       category: json['category'] ?? '',
//       tags: List<String>.from(json['tags'] ?? []),
//       imageUrl: json['image_url'] ?? '',
//       viewCount: json['view_count'] ?? '0',
//       crawlTimestamp: json['crawl_timestamp'] ?? '',
//     );
//   }
// }
//
// // Main App
// class NewsEditorialApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Hệ thống Tòa soạn - VnExpress Style',
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//         primaryColor: Color(0xFFB52D3D), // VnExpress red color
//         scaffoldBackgroundColor: Color(0xFFF5F5F5),
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           elevation: 2,
//           titleTextStyle: TextStyle(
//             color: Color(0xFFB52D3D),
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         textTheme: TextTheme(
//           headlineSmall: TextStyle(
//             color: Colors.black87,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             height: 1.3,
//           ),
//           bodyMedium: TextStyle(
//             color: Colors.black54,
//             fontSize: 14,
//             height: 1.4,
//           ),
//           bodySmall: TextStyle(
//             color: Colors.grey[600],
//             fontSize: 12,
//           ),
//         ),
//       ),
//       home: VnExpressStyleDashboard(),
//     );
//   }
// }
//
// // VnExpress Style Dashboard
// class VnExpressStyleDashboard extends StatefulWidget {
//   @override
//   _VnExpressStyleDashboardState createState() => _VnExpressStyleDashboardState();
// }
//
// class _VnExpressStyleDashboardState extends State<VnExpressStyleDashboard> {
//   List<Article> _articles = [];
//   List<Article> _filteredArticles = [];
//   bool _loading = true;
//   String _selectedCategory = 'Tất cả';
//   String _selectedSource = 'Tất cả';
//
//   // VnExpress style categories
//   final List<String> _categories = [
//     'Tất cả', 'Thời sự', 'Thế giới', 'Kinh doanh', 'Khoa học',
//     'Giải trí', 'Thể thao', 'Pháp luật', 'Giáo dục', 'Sức khỏe',
//     'Đời sống', 'Du lịch', 'Xe', 'Ý kiến'
//   ];
//
//   final List<String> _sources = ['Tất cả', 'Dân Trí', 'VnExpress'];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSampleData();
//   }
//
//   void _loadSampleData() {
//     Future.delayed(Duration(seconds: 1), () {
//       setState(() {
//         _articles = [
//           Article(
//             id: "1",
//             url: "https://vnexpress.net/sample1",
//             source: "vnexpress",
//             title: "'Hạ tầng số ở xã, phường không hoạt động thì phải khoảnh lại'",
//             summary: "Thủ tướng Phạm Minh Chính yêu cầu rà soát toàn bộ hạ tầng số ở cơ sở, công trình nào đầu tư mà không hoạt động phải 'khoảnh lại', tránh lãng phí.",
//             content: "Chiều 24/9, tại phiên họp Ban Chỉ đạo của Thủ tướng về phát triển Chính phủ số...",
//             author: "Ngọc Thành",
//             publishDate: "2025-09-25 16:30",
//             category: "Thời sự",
//             tags: ["Chính phủ số", "Thủ tướng", "Hạ tầng"],
//             imageUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&h=400&fit=crop",
//             viewCount: "12,540",
//             crawlTimestamp: "2025-09-25 16:45:00",
//           ),
//           Article(
//             id: "2",
//             url: "https://vnexpress.net/sample2",
//             source: "vnexpress",
//             title: "Cảnh tan hoang ở thành phố Trung Quốc sau bão Ragasa",
//             summary: "Bão Ragasa tràn qua miền đông Trung Quốc, gây thiệt hại nặng nề về người và tài sản.",
//             content: "Bão Ragasa đổ bộ vào tỉnh Giang Tô với sức gió mạnh cấp 12...",
//             author: "Hồng Hạnh",
//             publishDate: "2025-09-25 15:20",
//             category: "Thế giới",
//             tags: ["Thiên tai", "Trung Quốc", "Bão"],
//             imageUrl: "https://images.unsplash.com/photo-1547036967-23d11aacaee0?w=600&h=400&fit=crop",
//             viewCount: "8,930",
//             crawlTimestamp: "2025-09-25 15:30:00",
//           ),
//           Article(
//             id: "3",
//             url: "https://dantri.com.vn/sample3",
//             source: "dantri",
//             title: "Vì sao báo đón đập vào Biển Đông?",
//             summary: "Chuyên gia khí tượng giải thích nguyên nhân khiến nhiều cơn bão liên tiếp hướng vào Biển Đông trong thời gian gần đây.",
//             content: "Theo Trung tâm Dự báo Khí tượng Thủy văn Quốc gia...",
//             author: "Minh Đức",
//             publishDate: "2025-09-25 14:15",
//             category: "Khoa học",
//             tags: ["Khí tượng", "Biển Đông", "Thiên tai"],
//             imageUrl: "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?w=600&h=400&fit=crop",
//             viewCount: "15,670",
//             crawlTimestamp: "2025-09-25 14:30:00",
//           ),
//           Article(
//             id: "4",
//             url: "https://vnexpress.net/sample4",
//             source: "vnexpress",
//             title: "Lãn lớn L - N",
//             summary: "Có lẻ trong các nhâm lần về phát âm, l-n là khó sửa nhất và cũng...",
//             content: "Trong tiếng Việt, âm L và N thường bị nhầm lẫn bởi nhiều người...",
//             author: "Thu Hằng",
//             publishDate: "2025-09-25 13:45",
//             category: "Giáo dục",
//             tags: ["Tiếng Việt", "Phát âm", "Học tập"],
//             imageUrl: "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=600&h=400&fit=crop",
//             viewCount: "6,720",
//             crawlTimestamp: "2025-09-25 14:00:00",
//           ),
//           Article(
//             id: "5",
//             url: "https://vnexpress.net/sample5",
//             source: "vnexpress",
//             title: "Thị trường chứng khoán biến động mạnh cuối phiên",
//             summary: "VN-Index giảm 8,5 điểm trong phiên chiều sau thông tin Fed có thể điều chỉnh lãi suất.",
//             content: "Thị trường chứng khoán Việt Nam kết thúc phiên 25/9 trong sắc đỏ...",
//             author: "Minh Sơn",
//             publishDate: "2025-09-25 15:30",
//             category: "Kinh doanh",
//             tags: ["Chứng khoán", "VN-Index", "Tài chính"],
//             imageUrl: "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=600&h=400&fit=crop",
//             viewCount: "9,840",
//             crawlTimestamp: "2025-09-25 15:45:00",
//           ),
//           Article(
//             id: "6",
//             url: "https://vnexpress.net/sample6",
//             source: "vnexpress",
//             title: "Liverpool thắng đậm West Ham 5-1",
//             summary: "Đội bóng của HLV Jurgen Klopp tiếp tục thể hiện phong độ ấn tượng với chiến thắng thuyết phục.",
//             content: "Tại sân Anfield, Liverpool đã có màn trình diễn ấn tượng...",
//             author: "Thanh Vũ",
//             publishDate: "2025-09-25 12:30",
//             category: "Thể thao",
//             tags: ["Bóng đá", "Premier League", "Liverpool"],
//             imageUrl: "https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=600&h=400&fit=crop",
//             viewCount: "18,520",
//             crawlTimestamp: "2025-09-25 13:00:00",
//           ),
//         ];
//
//         _filteredArticles = _articles;
//         _loading = false;
//       });
//     });
//   }
//
//   void _filterArticles() {
//     setState(() {
//       _filteredArticles = _articles.where((article) {
//         bool matchesCategory = _selectedCategory == 'Tất cả' ||
//             _mapCategoryToVietnamese(article.category) == _selectedCategory;
//         bool matchesSource = _selectedSource == 'Tất cả' ||
//             _mapSourceToVietnamese(article.source) == _selectedSource;
//
//         return matchesCategory && matchesSource;
//       }).toList();
//     });
//   }
//
//   String _mapCategoryToVietnamese(String category) {
//     Map<String, String> categoryMap = {
//       'Xã hội': 'Thời sự',
//       'Kinh tế': 'Kinh doanh',
//       'Công nghệ': 'Khoa học',
//       'Thể thao': 'Thể thao',
//       'Giải trí': 'Giải trí',
//       'Pháp luật': 'Pháp luật',
//     };
//     return categoryMap[category] ?? category;
//   }
//
//   String _mapSourceToVietnamese(String source) {
//     return source == 'dantri' ? 'Dân Trí' : source == 'vnexpress' ? 'VnExpress' : source;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return Scaffold(
//         backgroundColor: Color(0xFFF5F5F5),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(color: Color(0xFFB52D3D)),
//               SizedBox(height: 16),
//               Text('Đang tải tin tức...', style: TextStyle(color: Colors.grey[600])),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: Color(0xFFF5F5F5),
//       body: CustomScrollView(
//         slivers: [
//           // VnExpress Style Header
//           SliverAppBar(
//             backgroundColor: Colors.white,
//             elevation: 2,
//             pinned: true,
//             expandedHeight: 140,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//                 color: Colors.white,
//                 child: Column(
//                   children: [
//                     // Top bar with logo and info
//                     Container(
//                       height: 60,
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: Row(
//                         children: [
//                           // Logo
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Color(0xFFB52D3D),
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: Row(
//                               children: [
//                                 Text('VN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//                                 Container(
//                                   width: 2,
//                                   height: 16,
//                                   color: Colors.white,
//                                   margin: EdgeInsets.symmetric(horizontal: 2),
//                                 ),
//                                 Text('EXPRESS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//                               ],
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           Text('Tòa soạn điện tử', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//                           Spacer(),
//                           // Weather info (mimicking VnExpress)
//                           Row(
//                             children: [
//                               Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
//                               Text('Hà Nội ', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//                               Icon(Icons.wb_sunny, size: 14, color: Colors.orange),
//                               Text(' 28°', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Divider(height: 1, color: Colors.grey[300]),
//                     // Navigation categories
//                     Container(
//                       height: 80,
//                       child: Column(
//                         children: [
//                           // Category tabs
//                           Container(
//                             height: 40,
//                             child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               padding: EdgeInsets.symmetric(horizontal: 16),
//                               itemCount: _categories.length,
//                               itemBuilder: (context, index) {
//                                 final category = _categories[index];
//                                 final isSelected = category == _selectedCategory;
//
//                                 return GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       _selectedCategory = category;
//                                       _filterArticles();
//                                     });
//                                   },
//                                   child: Container(
//                                     margin: EdgeInsets.only(right: 24),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           category,
//                                           style: TextStyle(
//                                             color: isSelected ? Color(0xFFB52D3D) : Colors.black54,
//                                             fontSize: 14,
//                                             fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                                           ),
//                                         ),
//                                         SizedBox(height: 4),
//                                         Container(
//                                           height: 2,
//                                           width: category.length * 8.0,
//                                           color: isSelected ? Color(0xFFB52D3D) : Colors.transparent,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           // Source filter
//                           Container(
//                             height: 40,
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             child: Row(
//                               children: [
//                                 Text('Nguồn: ', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//                                 ...(_sources.map((source) {
//                                   final isSelected = source == _selectedSource;
//                                   return GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         _selectedSource = source;
//                                         _filterArticles();
//                                       });
//                                     },
//                                     child: Container(
//                                       margin: EdgeInsets.only(right: 16),
//                                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                       decoration: BoxDecoration(
//                                         color: isSelected ? Color(0xFFB52D3D) : Colors.transparent,
//                                         borderRadius: BorderRadius.circular(12),
//                                         border: Border.all(
//                                           color: isSelected ? Color(0xFFB52D3D) : Colors.grey[400]!,
//                                         ),
//                                       ),
//                                       child: Text(
//                                         source,
//                                         style: TextStyle(
//                                           color: isSelected ? Colors.white : Colors.grey[600],
//                                           fontSize: 11,
//                                           fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 })).toList(),
//                                 Spacer(),
//                                 Text('${_filteredArticles.length} bài viết',
//                                     style: TextStyle(fontSize: 11, color: Colors.grey[500])),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // Articles list
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//                   (context, index) {
//                 if (index == 0) {
//                   // Featured article (first article, large layout)
//                   return _buildFeaturedArticle(_filteredArticles[0]);
//                 } else if (index == 1) {
//                   return Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     child: Text(
//                       'Tin mới nhất',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFFB52D3D),
//                       ),
//                     ),
//                   );
//                 } else {
//                   // Regular articles
//                   return _buildRegularArticle(_filteredArticles[index - 1]);
//                 }
//               },
//               childCount: _filteredArticles.length + 1,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFeaturedArticle(Article article) {
//     return Container(
//       margin: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: InkWell(
//         onTap: () => _showArticleDetail(article),
//         borderRadius: BorderRadius.circular(8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
//                   child: Image.network(
//                     article.imageUrl,
//                     height: 200,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         height: 200,
//                         color: Colors.grey[300],
//                         child: Icon(Icons.image, size: 64, color: Colors.grey[500]),
//                       );
//                     },
//                   ),
//                 ),
//                 // Category badge
//                 Positioned(
//                   top: 12,
//                   left: 12,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Color(0xFFB52D3D),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Text(
//                       _mapCategoryToVietnamese(article.category),
//                       style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                 ),
//                 // Source badge
//                 Positioned(
//                   top: 12,
//                   right: 12,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                     decoration: BoxDecoration(
//                       color: article.source == 'vnexpress' ? Color(0xFFB52D3D) : Color(0xFF1976D2),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       article.source == 'vnexpress' ? 'VE' : 'DT',
//                       style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             Padding(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title
//                   Text(
//                     article.title,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                       height: 1.3,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//
//                   // Summary
//                   Text(
//                     article.summary,
//                     style: TextStyle(
//                       color: Colors.black54,
//                       fontSize: 14,
//                       height: 1.4,
//                     ),
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 12),
//
//                   // Metadata
//                   Row(
//                     children: [
//                       Icon(Icons.schedule, size: 14, color: Colors.grey[500]),
//                       SizedBox(width: 4),
//                       Text(
//                         _formatDate(article.publishDate),
//                         style: TextStyle(fontSize: 11, color: Colors.grey[500]),
//                       ),
//                       SizedBox(width: 16),
//                       Icon(Icons.visibility, size: 14, color: Colors.grey[500]),
//                       SizedBox(width: 4),
//                       Text(
//                         '${article.viewCount} lượt xem',
//                         style: TextStyle(fontSize: 11, color: Colors.grey[500]),
//                       ),
//                       Spacer(),
//                       if (article.author.isNotEmpty)
//                         Text(
//                           article.author,
//                           style: TextStyle(fontSize: 11, color: Color(0xFFB52D3D)),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRegularArticle(Article article) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: InkWell(
//         onTap: () => _showArticleDetail(article),
//         borderRadius: BorderRadius.circular(8),
//         child: Padding(
//           padding: EdgeInsets.all(12),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(6),
//                 child: Image.network(
//                   article.imageUrl,
//                   height: 80,
//                   width: 100,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       height: 80,
//                       width: 100,
//                       color: Colors.grey[300],
//                       child: Icon(Icons.image, size: 32, color: Colors.grey[500]),
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(width: 12),
//
//               // Content
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Category and source
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: Color(0xFFB52D3D).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(3),
//                           ),
//                           child: Text(
//                             _mapCategoryToVietnamese(article.category),
//                             style: TextStyle(
//                               color: Color(0xFFB52D3D),
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 6),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: article.source == 'vnexpress' ? Color(0xFFB52D3D) : Color(0xFF1976D2),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             article.source == 'vnexpress' ? 'VE' : 'DT',
//                             style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 6),
//
//                     // Title
//                     Text(
//                       article.title,
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                         height: 1.2,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 6),
//
//                     // Summary
//                     Text(
//                       article.summary,
//                       style: TextStyle(
//                         color: Colors.black54,
//                         fontSize: 12,
//                         height: 1.3,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 8),
//
//                     // Metadata
//                     Row(
//                       children: [
//                         Text(
//                           _formatDate(article.publishDate),
//                           style: TextStyle(fontSize: 10, color: Colors.grey[500]),
//                         ),
//                         SizedBox(width: 12),
//                         Icon(Icons.visibility, size: 12, color: Colors.grey[500]),
//                         SizedBox(width: 2),
//                         Text(
//                           article.viewCount,
//                           style: TextStyle(fontSize: 10, color: Colors.grey[500]),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _formatDate(String dateString) {
//     try {
//       DateTime date = DateTime.parse(dateString.replaceAll(' ', 'T') + ':00');
//       DateTime now = DateTime.now();
//       Duration difference = now.difference(date);
//
//       if (difference.inMinutes < 60) {
//         return '${difference.inMinutes} phút trước';
//       } else if (difference.inHours < 24) {
//         return '${difference.inHours} giờ trước';
//       } else {
//         return DateFormat('dd/MM/yyyy HH:mm').format(date);
//       }
//     } catch (e) {
//       return dateString;
//     }
//   }
//
//   void _showArticleDetail(Article article) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ArticleDetailScreen(article: article),
//       ),
//     );
//   }
// }
//
// // VnExpress Style Article Detail Screen
// class ArticleDetailScreen extends StatelessWidget {
//   final Article article;
//
//   ArticleDetailScreen({required this.article});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             backgroundColor: Colors.white,
//             elevation: 1,
//             pinned: true,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: Colors.black54),
//               onPressed: () => Navigator.pop(context),
//             ),
//             title: Text(
//               'Chi tiết bài viết',
//               style: TextStyle(color: Colors.black87, fontSize: 18),
//             ),
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.share, color: Colors.black54),
//                 onPressed: () {
//                   // Share functionality
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.open_in_new, color: Colors.black54),
//                 onPressed: () => _launchUrl(article.url),
//               ),
//             ],
//           ),
//
//           SliverList(
//             delegate: SliverChildListDelegate([
//               // Article header
//               Container(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Category and source badges
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Color(0xFFB52D3D),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Text(
//                             _mapCategoryToVietnamese(article.category),
//                             style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: article.source == 'vnexpress' ? Color(0xFFB52D3D) : Color(0xFF1976D2),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(
//                             article.source == 'vnexpress' ? 'VnExpress' : 'Dân Trí',
//                             style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 12),
//
//                     // Title
//                     Text(
//                       article.title,
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                         height: 1.3,
//                       ),
//                     ),
//                     SizedBox(height: 16),
//
//                     // Metadata
//                     Row(
//                       children: [
//                         if (article.author.isNotEmpty) ...[
//                           Icon(Icons.person, size: 16, color: Colors.grey[600]),
//                           SizedBox(width: 4),
//                           Text(
//                             article.author,
//                             style: TextStyle(fontSize: 13, color: Color(0xFFB52D3D), fontWeight: FontWeight.w500),
//                           ),
//                           SizedBox(width: 16),
//                         ],
//                         Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
//                         SizedBox(width: 4),
//                         Text(
//                           _formatDate(article.publishDate),
//                           style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                         ),
//                         SizedBox(width: 16),
//                         Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
//                         SizedBox(width: 4),
//                         Text(
//                           '${article.viewCount} lượt xem',
//                           style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//
//                     // Summary box (VnExpress style)
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Color(0xFFFFF8E1),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Color(0xFFFFCC02), width: 1),
//                       ),
//                       child: Text(
//                         article.summary,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.black87,
//                           height: 1.5,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Article image
//               if (article.imageUrl.isNotEmpty)
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 16),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.network(
//                       article.imageUrl,
//                       width: double.infinity,
//                       height: 250,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           height: 250,
//                           color: Colors.grey[300],
//                           child: Center(
//                             child: Icon(Icons.image, size: 64, color: Colors.grey[500]),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//
//               // Article content
//               Container(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Nội dung tóm tắt',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFFB52D3D),
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     Text(
//                       article.content,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black87,
//                         height: 1.6,
//                       ),
//                     ),
//                     SizedBox(height: 24),
//
//                     // Tags
//                     if (article.tags.isNotEmpty) ...[
//                       Text(
//                         'Từ khóa:',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 6,
//                         children: article.tags.map((tag) {
//                           return Container(
//                             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[100],
//                               borderRadius: BorderRadius.circular(15),
//                               border: Border.all(color: Colors.grey[300]!),
//                             ),
//                             child: Text(
//                               tag,
//                               style: TextStyle(fontSize: 12, color: Colors.grey[700]),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                       SizedBox(height: 24),
//                     ],
//
//                     // Action buttons
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             onPressed: () => _launchUrl(article.url),
//                             icon: Icon(Icons.open_in_new, size: 18),
//                             label: Text('Đọc bài gốc'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Color(0xFFB52D3D),
//                               foregroundColor: Colors.white,
//                               padding: EdgeInsets.symmetric(vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 12),
//                         Expanded(
//                           child: OutlinedButton.icon(
//                             onPressed: () {
//                               // Share functionality
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text('Tính năng chia sẻ đang được phát triển')),
//                               );
//                             },
//                             icon: Icon(Icons.share, size: 18),
//                             label: Text('Chia sẻ'),
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: Color(0xFFB52D3D),
//                               side: BorderSide(color: Color(0xFFB52D3D)),
//                               padding: EdgeInsets.symmetric(vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _mapCategoryToVietnamese(String category) {
//     Map<String, String> categoryMap = {
//       'Xã hội': 'Thời sự',
//       'Kinh tế': 'Kinh doanh',
//       'Công nghệ': 'Khoa học',
//       'Thể thao': 'Thể thao',
//       'Giải trí': 'Giải trí',
//       'Pháp luật': 'Pháp luật',
//     };
//     return categoryMap[category] ?? category;
//   }
//
//   String _formatDate(String dateString) {
//     try {
//       DateTime date = DateTime.parse(dateString.replaceAll(' ', 'T') + ':00');
//       return DateFormat('dd/MM/yyyy HH:mm').format(date);
//     } catch (e) {
//       return dateString;
//     }
//   }
//
//   void _launchUrl(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       print('Could not launch $url');
//     }
//   }
// }
//
// // Main function
// void main() {
//   runApp(NewsEditorialApp());
// }

// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Providers
import 'providers/article_provider.dart';

// Screens
import 'screens/dashboard_screen.dart';

// Utils
import 'utils/app_theme.dart';
import 'utils/constants.dart';
import 'services/api_service.dart';
/// Entry point of the News Editorial App
void main() async {
  // Ensure Flutter framework is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Test API connection
  try {
    final health = await ApiService.checkHealth();
    print('API Health: $health');
  } catch (e) {
    print('API Connection Error: $e');
  }
  // Configure system UI
  await _configureSystemUI();

  // Run the app
  runApp(NewsEditorialApp());
}

/// Configure system UI settings
Future<void> _configureSystemUI() async {
  // Set preferred orientations (portrait only for better UX)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // Status bar settings
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,

      // Navigation bar settings
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
}

/// Root widget of the News Editorial Application
class NewsEditorialApp extends StatelessWidget {
  const NewsEditorialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Article Provider for state management
        ChangeNotifierProvider(
          create: (_) => ArticleProvider(),
          lazy: false, // Load immediately for better UX
        ),

        // Add more providers here as needed
        // ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<ArticleProvider>(
        builder: (context, articleProvider, child) {
          return MaterialApp(
            // ========== APP CONFIGURATION ==========
            title: AppStrings.appName,
            debugShowCheckedModeBanner: AppConstants.isDebugMode,

            // ========== THEME CONFIGURATION ==========
            theme: AppTheme.lightTheme,
            // darkTheme: AppTheme.darkTheme, // Enable when dark mode is ready
            // themeMode: ThemeMode.system, // Follow system theme

            // ========== LOCALIZATION ==========
            // Add localization delegates when needed
            // localizationsDelegates: const [
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate,
            // ],
            // supportedLocales: const [
            //   Locale('vi', 'VN'), // Vietnamese
            //   Locale('en', 'US'), // English
            // ],
            // locale: const Locale('vi', 'VN'),

            // ========== NAVIGATION ==========
            home: const AppInitializer(),

            // ========== ROUTE CONFIGURATION ==========
            onGenerateRoute: _onGenerateRoute,
            onUnknownRoute: _onUnknownRoute,

            // ========== PERFORMANCE ==========
            builder: (context, child) {
              return MediaQuery(
                // Disable font scaling for consistent UI
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0,
                ),
                child: child!,
              );
            },

            // ========== ERROR HANDLING ==========
            // Custom error widget for better UX
            // errorBuilder: (context, error, stackTrace) {
            //   return ErrorScreen(error: error);
            // },
          );
        },
      ),
    );
  }

  /// Handle route generation for navigation
  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
          settings: settings,
        );

      case '/article-detail':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null && args.containsKey('article')) {
          return MaterialPageRoute(
            builder: (_) => ArticleDetailScreen(article: args['article']),
            settings: settings,
          );
        }
        return _createErrorRoute('Invalid article data');

      case '/search':
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
          settings: settings,
        );

      default:
        return null;
    }
  }

  /// Handle unknown routes
  Route<dynamic> _onUnknownRoute(RouteSettings settings) {
    return _createErrorRoute('Route not found: ${settings.name}');
  }

  /// Create error route for invalid navigation
  Route<dynamic> _createErrorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Lỗi')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(_).pushReplacementNamed('/dashboard'),
                child: const Text('Về trang chủ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// App initializer widget that handles startup logic
class AppInitializer extends StatefulWidget {
  const AppInitializer({Key? key}) : super(key: key);

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitializing = true;
  String _initializationStatus = 'Đang khởi tạo ứng dụng...';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Initialize app data and services
  Future<void> _initializeApp() async {
    try {
      setState(() {
        _initializationStatus = 'Đang tải dữ liệu...';
      });

      // Get article provider
      final articleProvider = Provider.of<ArticleProvider>(context, listen: false);

      // Initialize data
      await articleProvider.initializeData();

      setState(() {
        _initializationStatus = 'Hoàn thành!';
      });

      // Small delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isInitializing = false;
      });

    } catch (error) {
      setState(() {
        _initializationStatus = 'Khởi tạo thất bại: ${error.toString()}';
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return _buildLoadingScreen();
    }

    // Show dashboard after initialization
    return const DashboardScreen();
  }

  /// Build loading screen during app initialization
  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed,
                borderRadius: BorderRadius.circular(AppConstants.largeRadius),
              ),
              child: const Icon(
                Icons.newspaper,
                size: 64,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: AppConstants.largePadding),

            // App Title
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.primaryRed,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.smallPadding),

            // App Subtitle
            Text(
              AppStrings.appSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.extraLargePadding),

            // Loading Indicator
            const CircularProgressIndicator(
              color: AppTheme.primaryRed,
              strokeWidth: 3,
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Status Text
            Text(
              _initializationStatus,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

            // Debug Info (only in debug mode)
            if (AppConstants.isDebugMode) ...[
              const SizedBox(height: AppConstants.largePadding),
              Container(
                padding: const EdgeInsets.all(AppConstants.smallPadding),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                ),
                child: Column(
                  children: [
                    Text(
                      'DEBUG MODE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Version: ${AppStrings.appVersion}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Custom error widget for global error handling
class AppErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const AppErrorWidget({
    Key? key,
    required this.errorDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              Text(
                'Oops! Có lỗi xảy ra',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.smallPadding),

              if (AppConstants.isDebugMode)
                Container(
                  padding: const EdgeInsets.all(AppConstants.smallPadding),
                  margin: const EdgeInsets.symmetric(vertical: AppConstants.defaultPadding),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Text(
                    errorDetails.exception.toString(),
                    style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                    textAlign: TextAlign.center,
                  ),
                ),

              ElevatedButton.icon(
                onPressed: () {
                  // Restart app or navigate to safe screen
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/dashboard',
                        (route) => false,
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Khởi động lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Import missing screens (these need to be created)
class ArticleDetailScreen extends StatelessWidget {
  final dynamic article;

  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết bài viết')),
      body: const Center(child: Text('Article Detail Screen')),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm')),
      body: const Center(child: Text('Search Screen')),
    );
  }
}