// lib/widgets/filter_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

class FilterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<ArticleProvider>(
        builder: (context, provider, child) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                // Category tabs
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
                    itemCount: provider.categories.length,
                    itemBuilder: (context, index) {
                      final category = provider.categories[index];
                      final isSelected = category == provider.selectedCategory;

                      return GestureDetector(
                        onTap: () => provider.setCategory(category),
                        child: Container(
                          margin: EdgeInsets.only(right: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? AppTheme.primaryRed : Colors.black54,
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 4),
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
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
                  child: Row(
                    children: [
                      Text('Nguồn: ', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ...(provider.sources.map((source) {
                        final isSelected = source == provider.selectedSource;
                        return GestureDetector(
                          onTap: () => provider.setSource(source),
                          child: Container(
                            margin: EdgeInsets.only(right: 16),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      Spacer(),
                      Text(
                        '${provider.filteredArticles.length} bài viết',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey[300]),
              ],
            ),
          );
        },
      ),
    );
  }
}
