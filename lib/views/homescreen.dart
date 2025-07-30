import 'package:flutter/material.dart';
import 'package:news_app/services/local_auth_service.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/widgets/article_card.dart';
import 'change_password_screen.dart';

class HomeScreen extends StatefulWidget {
  final LocalAuthService authService;

  const HomeScreen({super.key, required this.authService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<String?> _userEmailFuture;
  final NewsService _newsService = NewsService();
  List<Article> _articles = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _userEmailFuture = _getUserEmail();
    _loadInitialArticles();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<String?> _getUserEmail() async {
    final user = await widget.authService.getCurrentUser();
    return user?.email;
  }

  Future<void> _loadInitialArticles() async {
    setState(() => _isLoading = true);
    try {
      final articles = await _newsService.getTopHeadlines(
        country: 'us',
        page: _page,
      );
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load articles: ${e.toString()}')),
      );
    }
  }

  Future<void> _loadMoreArticles() async {
    if (!_hasMore || _isLoading) return;

    setState(() => _isLoading = true);
    try {
      final newArticles = await _newsService.getTopHeadlines(
        country: 'us',
        page: _page + 1,
      );

      setState(() {
        _articles.addAll(newArticles);
        _page++;
        _hasMore = newArticles.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load more articles')));
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_scrollController.position.outOfRange) {
      _loadMoreArticles();
    }
  }

  Future<void> _refreshArticles() async {
    setState(() {
      _page = 1;
      _hasMore = true;
    });
    await _loadInitialArticles();
  }

  void _logout() async {
    await widget.authService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _goToChangePassword(String userEmail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangePasswordScreen(
          userEmail: userEmail,
          authService: widget.authService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: FutureBuilder<String?>(
        future: _userEmailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Error loading user data'));
          }

          final userEmail = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshArticles,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Welcome, ${userEmail.split('@')[0]}!',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _goToChangePassword(userEmail),
                          child: const Text('Change Password'),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const Text(
                          'Latest Headlines',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return ArticleCard(article: _articles[index]);
                  }, childCount: _articles.length),
                ),
                if (_isLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (!_hasMore && _articles.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text('No more articles to load')),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
