// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Import your app files
import 'package:news_editorial_app/main.dart';
import 'package:news_editorial_app/providers/article_provider.dart';
import 'package:news_editorial_app/models/article.dart';
import 'package:news_editorial_app/screens/dashboard_screen.dart';
import 'package:news_editorial_app/screens/search_screen.dart';
import 'package:news_editorial_app/screens/article_detail_screen.dart';
import 'package:news_editorial_app/utils/constants.dart';
import 'package:news_editorial_app/utils/app_theme.dart';
import 'package:news_editorial_app/utils/date_utils.dart';

void main() {
  group('News Editorial App Tests', () {

    // ========== APP INITIALIZATION TESTS ==========

    group('App Initialization', () {
      testWidgets('Should create NewsEditorialApp widget', (WidgetTester tester) async {
        // Build our app and trigger a frame
        await tester.pumpWidget(const NewsEditorialApp());

        // Verify that our app starts with loading screen
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text(AppStrings.appName), findsOneWidget);
      });

      testWidgets('Should show app logo and title during initialization', (WidgetTester tester) async {
        await tester.pumpWidget(const NewsEditorialApp());

        // Check for app branding elements
        expect(find.text(AppStrings.appName), findsOneWidget);
        expect(find.text(AppStrings.appSubtitle), findsOneWidget);
        expect(find.byIcon(Icons.newspaper), findsOneWidget);
      });

      testWidgets('Should initialize with proper theme', (WidgetTester tester) async {
        await tester.pumpWidget(const NewsEditorialApp());

        final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
        expect(materialApp.theme?.primaryColor, equals(AppTheme.primaryRed));
      });
    });

    // ========== DASHBOARD SCREEN TESTS ==========

    group('Dashboard Screen', () {
      late ArticleProvider mockProvider;

      setUp(() {
        mockProvider = ArticleProvider();
      });

      Widget createDashboardWidget() {
        return MaterialApp(
          home: ChangeNotifierProvider<ArticleProvider>.value(
            value: mockProvider,
            child: const DashboardScreen(),
          ),
        );
      }

      testWidgets('Should display VnExpress logo', (WidgetTester tester) async {
        await tester.pumpWidget(createDashboardWidget());
        await tester.pump(); // Allow loading to complete

        // Look for VN|EXPRESS logo elements
        expect(find.text('VN'), findsOneWidget);
        expect(find.text('EXPRESS'), findsOneWidget);
      });

      testWidgets('Should display search bar', (WidgetTester tester) async {
        await tester.pumpWidget(createDashboardWidget());
        await tester.pump();

        expect(find.text(AppStrings.searchPlaceholder), findsOneWidget);
        expect(find.byIcon(Icons.search), findsWidgets);
      });

      testWidgets('Should show weather info', (WidgetTester tester) async {
        await tester.pumpWidget(createDashboardWidget());
        await tester.pump();

        expect(find.text('Hà Nội '), findsOneWidget);
        expect(find.text(' 28°'), findsOneWidget);
        expect(find.byIcon(Icons.location_on), findsOneWidget);
        expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
      });

      testWidgets('Should navigate to search screen when search bar tapped', (WidgetTester tester) async {
        await tester.pumpWidget(createDashboardWidget());
        await tester.pump();

        // Find and tap search bar
        final searchBar = find.text(AppStrings.searchPlaceholder);
        expect(searchBar, findsOneWidget);

        await tester.tap(searchBar);
        await tester.pumpAndSettle();

        // Should navigate to SearchScreen
        expect(find.byType(SearchScreen), findsOneWidget);
      });

      testWidgets('Should display stats when available', (WidgetTester tester) async {
        // Mock provider with stats
        mockProvider.initializeData();

        await tester.pumpWidget(createDashboardWidget());
        await tester.pump(const Duration(seconds: 3)); // Wait for data loading

        // Check for stats section
        expect(find.text('Tổng bài viết'), findsOneWidget);
        expect(find.text('Tổng lượt xem'), findsOneWidget);
        expect(find.text('Chủ đề hot'), findsOneWidget);
        expect(find.text('Hôm nay'), findsOneWidget);
      });
    });

    // ========== SEARCH SCREEN TESTS ==========

    group('Search Screen', () {
      Widget createSearchWidget() {
        return MaterialApp(
          home: ChangeNotifierProvider<ArticleProvider>(
            create: (_) => ArticleProvider(),
            child: const SearchScreen(),
          ),
        );
      }

      testWidgets('Should display search input with focus', (WidgetTester tester) async {
        await tester.pumpWidget(createSearchWidget());

        // Check search input exists
        expect(find.byType(TextField), findsOneWidget);
        expect(find.text(AppStrings.searchPlaceholder), findsOneWidget);

        // Should auto-focus on search input
        final TextField textField = tester.widget(find.byType(TextField));
        expect(textField.focusNode?.hasFocus, isTrue);
      });

      testWidgets('Should show recent searches section', (WidgetTester tester) async {
        await tester.pumpWidget(createSearchWidget());

        expect(find.text('Tìm kiếm gần đây'), findsOneWidget);
        expect(find.byIcon(Icons.history), findsWidgets);
      });

      testWidgets('Should show suggested keywords', (WidgetTester tester) async {
        await tester.pumpWidget(createSearchWidget());

        expect(find.text('Từ khóa gợi ý'), findsOneWidget);
        expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
      });

      testWidgets('Should show trending topics', (WidgetTester tester) async {
        await tester.pumpWidget(createSearchWidget());

        expect(find.text('Chủ đề thịnh hành'), findsOneWidget);
        expect(find.byIcon(Icons.trending_up), findsOneWidget);
      });

      testWidgets('Should clear search when clear button tapped', (WidgetTester tester) async {
        await tester.pumpWidget(createSearchWidget());

        // Enter some text
        await tester.enterText(find.byType(TextField), 'test search');
        await tester.pump();

        // Should show clear button
        expect(find.byIcon(Icons.clear), findsOneWidget);

        // Tap clear button
        await tester.tap(find.byIcon(Icons.clear));
        await tester.pump();

        // Text should be cleared
        expect(find.text('test search'), findsNothing);
      });
    });

    // ========== ARTICLE DETAIL SCREEN TESTS ==========

    group('Article Detail Screen', () {
      late Article mockArticle;

      setUp(() {
        mockArticle = Article(
          id: '1',
          url: 'https://example.com/test-article',
          source: 'vnexpress',
          title: 'Test Article Title',
          summary: 'This is a test article summary for testing purposes.',
          content: 'This is the test article content that should be displayed in detail view.',
          author: 'Test Author',
          publishDate: '2025-09-25 16:30',
          category: 'Thời sự',
          tags: ['test', 'flutter', 'news'],
          imageUrl: 'https://example.com/test-image.jpg',
          viewCount: '1,234',
          crawlTimestamp: '2025-09-25 17:00:00',
        );
      });

      Widget createArticleDetailWidget() {
        return MaterialApp(
          home: ArticleDetailScreen(article: mockArticle),
        );
      }

      testWidgets('Should display article title', (WidgetTester tester) async {
        await tester.pumpWidget(createArticleDetailWidget());

        expect(find.text(mockArticle.title), findsWidgets);
      });

      testWidgets('Should display category and source badges', (WidgetTester tester) async {
        await tester.pumpWidget(createArticleDetailWidget());

        expect(find.text(mockArticle.category), findsOneWidget);
        expect(find.text('VnExpress'), findsOneWidget);
      });

      testWidgets('Should display article metadata', (WidgetTester tester) async {
        await tester.pumpWidget(createArticleDetailWidget());

        expect(find.text(mockArticle.author), findsOneWidget);
        expect(find.text('${mockArticle.viewCount} ${AppStrings.viewCount}'), findsOneWidget);
      });

      testWidgets('Should display summary in yellow box', (WidgetTester tester) async {
        await tester.pumpWidget(createArticleDetailWidget());

        expect(find.text(mockArticle.summary), findsOneWidget);

        // Check for summary box styling
        final Container summaryBox = tester.widget(
          find.ancestor(
            of: find.text(mockArticle.summary),
            matching: find.byType(Container),
          ).first,
        );
        expect(summaryBox.decoration, isA<BoxDecoration>());
      });

      testWidgets('Should display article content', (WidgetTester tester) async {
        await tester.pumpWidget(createArticleDetailWidget());

        expect(find.text('Nội dung tóm tắt'), findsOneWidget);
        expect(find.text(mockArticle.content), findsOneWidget);
      });

      testWidgets('Should display tags', (WidgetTester tester) async {
        await tester.pumpWidget(createArticleDetailWidget());

        expect(find.text('Từ khóa:'), findsOneWidget);

        for (String tag in mockArticle.tags) {
          expect(find.text(tag), findsOneWidget);
        }
      });

      testWidgets('Should display action buttons', (WidgetTester tester) async {
        await tester.pumpWidget(createArticleDetailWidget());

        expect(find.text(AppStrings.readOriginal), findsOneWidget);
        expect(find.text(AppStrings.share), findsOneWidget);
      });

      testWidgets('Should show app bar actions', (WidgetTester tester) async {
        await tester.pumpWidget(createArticleDetailWidget());

        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(find.byIcon(Icons.share), findsOneWidget);
        expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
        expect(find.byIcon(Icons.more_vert), findsOneWidget);
      });
    });

    // ========== UTILITY CLASSES TESTS ==========

    group('Utility Classes', () {
      group('AppDateUtils', () {
        test('Should format date correctly', () {
          final formatted = AppDateUtils.formatDate('2025-09-25 16:30');
          expect(formatted, equals('25/09/2025 16:30'));
        });

        test('Should format relative date correctly', () {
          final now = DateTime.now();
          final oneHourAgo = now.subtract(const Duration(hours: 1));
          final dateString = '${oneHourAgo.year}-${oneHourAgo.month.toString().padLeft(2, '0')}-${oneHourAgo.day.toString().padLeft(2, '0')} ${oneHourAgo.hour.toString().padLeft(2, '0')}:${oneHourAgo.minute.toString().padLeft(2, '0')}';

          final relative = AppDateUtils.formatRelativeDate(dateString);
          expect(relative, contains('giờ trước'));
        });

        test('Should identify today correctly', () {
          final today = DateTime.now();
          final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')} 12:00';

          expect(AppDateUtils.isToday(todayString), isTrue);
        });

        test('Should identify breaking news correctly', () {
          final now = DateTime.now();
          final oneHourAgo = now.subtract(const Duration(hours: 1));
          final dateString = '${oneHourAgo.year}-${oneHourAgo.month.toString().padLeft(2, '0')}-${oneHourAgo.day.toString().padLeft(2, '0')} ${oneHourAgo.hour.toString().padLeft(2, '0')}:${oneHourAgo.minute.toString().padLeft(2, '0')}';

          expect(AppDateUtils.isBreakingNews(dateString), isTrue);
        });

        test('Should generate reading time estimate', () {
          const shortContent = 'This is a short article content.';
          const longContent = 'This is a much longer article content. ' * 100;

          expect(AppDateUtils.getReadingTimeEstimate(shortContent.length), contains('< 1 phút đọc'));
          expect(AppDateUtils.getReadingTimeEstimate(longContent.length), contains('phút đọc'));
        });
      });

      group('Article Model', () {
        test('Should create article from JSON', () {
          final json = {
            '_id': '123',
            'title': 'Test Title',
            'source': 'vnexpress',
            'category': 'Thời sự',
            'publish_date': '2025-09-25 16:30',
            'tags': ['tag1', 'tag2'],
            'view_count': '1,234',
          };

          final article = Article.fromJson(json);

          expect(article.id, equals('123'));
          expect(article.title, equals('Test Title'));
          expect(article.source, equals('vnexpress'));
          expect(article.sourceDisplayName, equals('VnExpress'));
          expect(article.sourceShortName, equals('VE'));
          expect(article.tags.length, equals(2));
        });

        test('Should identify valid image URL', () {
          final articleWithImage = Article(
            id: '1',
            imageUrl: 'https://example.com/image.jpg',
            url: '', source: '', title: '', summary: '', content: '',
            author: '', publishDate: '', category: '', tags: [],
            viewCount: '', crawlTimestamp: '',
          );

          final articleWithoutImage = Article(
            id: '2',
            imageUrl: '',
            url: '', source: '', title: '', summary: '', content: '',
            author: '', publishDate: '', category: '', tags: [],
            viewCount: '', crawlTimestamp: '',
          );

          expect(articleWithImage.hasValidImage, isTrue);
          expect(articleWithoutImage.hasValidImage, isFalse);
        });

        test('Should check for breaking news', () {
          final now = DateTime.now();
          final oneHourAgo = now.subtract(const Duration(hours: 1));
          final threeDaysAgo = now.subtract(const Duration(days: 3));

          final recentArticle = Article(
            id: '1',
            publishDate: '${oneHourAgo.year}-${oneHourAgo.month.toString().padLeft(2, '0')}-${oneHourAgo.day.toString().padLeft(2, '0')} ${oneHourAgo.hour.toString().padLeft(2, '0')}:${oneHourAgo.minute.toString().padLeft(2, '0')}',
            url: '', source: '', title: '', summary: '', content: '',
            author: '', category: '', tags: [], imageUrl: '',
            viewCount: '', crawlTimestamp: '',
          );

          final oldArticle = Article(
            id: '2',
            publishDate: '${threeDaysAgo.year}-${threeDaysAgo.month.toString().padLeft(2, '0')}-${threeDaysAgo.day.toString().padLeft(2, '0')} 12:00',
            url: '', source: '', title: '', summary: '', content: '',
            author: '', category: '', tags: [], imageUrl: '',
            viewCount: '', crawlTimestamp: '',
          );

          expect(recentArticle.isBreakingNews, isTrue);
          expect(oldArticle.isBreakingNews, isFalse);
        });
      });

      group('Constants', () {
        test('Should have proper app constants', () {
          expect(AppConstants.defaultPadding, equals(16.0));
          expect(AppConstants.apiTimeout.inSeconds, equals(30));
          expect(AppConstants.breakingNewsHours, equals(2));
          expect(AppConstants.defaultCategories, isNotEmpty);
          expect(AppConstants.defaultSources, contains('Tất cả'));
        });

        test('Should have proper app strings', () {
          expect(AppStrings.appName, isNotEmpty);
          expect(AppStrings.searchPlaceholder, equals('Tìm kiếm bài viết...'));
          expect(AppStrings.loading, equals('Đang tải...'));
        });
      });
    });

    // ========== INTEGRATION TESTS ==========

    group('Integration Tests', () {
      testWidgets('Should complete full user flow', (WidgetTester tester) async {
        // Start app
        await tester.pumpWidget(const NewsEditorialApp());
        await tester.pump(const Duration(seconds: 3)); // Wait for initialization

        // Should be on dashboard
        expect(find.byType(DashboardScreen), findsOneWidget);

        // Tap search
        await tester.tap(find.text(AppStrings.searchPlaceholder));
        await tester.pumpAndSettle();

        // Should be on search screen
        expect(find.byType(SearchScreen), findsOneWidget);

        // Go back to dashboard
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        // Should be back on dashboard
        expect(find.byType(DashboardScreen), findsOneWidget);
      });

      testWidgets('Should handle error states gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(const NewsEditorialApp());

        // Even if there are errors, app should not crash
        expect(tester.takeException(), isNull);
      });
    });

    // ========== PERFORMANCE TESTS ==========

    group('Performance Tests', () {
      testWidgets('Should not rebuild unnecessarily', (WidgetTester tester) async {
        int buildCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                buildCount++;
                return const Scaffold(
                  body: Center(child: Text('Performance Test')),
                );
              },
            ),
          ),
        );

        expect(buildCount, equals(1));

        // Trigger rebuild
        await tester.pump();

        // Should not rebuild if no changes
        expect(buildCount, equals(1));
      });
    });

    // ========== ACCESSIBILITY TESTS ==========

    group('Accessibility Tests', () {
      testWidgets('Should have semantic labels', (WidgetTester tester) async {
        await tester.pumpWidget(const NewsEditorialApp());
        await tester.pump();

        // Check for semantic elements
        expect(find.byType(Semantics), findsWidgets);
      });
    });
  });
}