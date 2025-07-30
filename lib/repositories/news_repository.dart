import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article_model.dart';
import '../services/news_service.dart';

class NewsRepository {
  final NewsService _newsService;
  final SharedPreferences _prefs;

  NewsRepository(this._newsService, this._prefs);

  Future<List<Article>> getTopHeadlines() async {
    try {
      final articles = await _newsService.getTopHeadlines();
      _cacheArticles(articles);
      return articles;
    } catch (e) {
      final cached = _getCachedArticles();
      if (cached.isNotEmpty) return cached;
      throw e;
    }
  }

  void _cacheArticles(List<Article> articles) {
    final jsonList = articles.map((a) => a.toJson()).toList();
    _prefs.setString('cached_articles', json.encode(jsonList));
    _prefs.setInt('last_cache_time', DateTime.now().millisecondsSinceEpoch);
  }

  List<Article> _getCachedArticles() {
    final jsonString = _prefs.getString('cached_articles');
    if (jsonString == null) return [];
    final jsonList = json.decode(jsonString) as List;
    return jsonList.map((json) => Article.fromJson(json)).toList();
  }
}
