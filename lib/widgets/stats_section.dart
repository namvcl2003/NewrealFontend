// lib/widgets/stats_section.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/article.dart';
import '../utils/constants.dart';

class StatsSection extends StatelessWidget {
  final NewsStats stats;

  const StatsSection({Key? key, required this.stats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Tổng bài viết',
                '${stats.totalArticles}',
                Icons.newspaper,
                Colors.blue,
              ),
            ),
            SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: _buildStatCard(
                context,
                'Tổng lượt xem',
                NumberFormat('#,###').format(stats.totalViews),
                Icons.visibility,
                Colors.green,
              ),
            ),
            SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: _buildStatCard(
                context,
                'Chủ đề hot',
                stats.topCategory,
                Icons.trending_up,
                Colors.orange,
              ),
            ),
            SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: _buildStatCard(
                context,
                'Hôm nay',
                '${stats.todayArticles}',
                Icons.today,
                Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
