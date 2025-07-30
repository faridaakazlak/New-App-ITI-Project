import 'package:dio/dio.dart';
import '../models/article_model.dart';

class NewsService {
  final Dio _dio = Dio();
  final String _apiKey = '6b94641be6804413b155cebb3cdf7639';

  Future<List<Article>> getTopHeadlines({
    String country = 'us',
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {
          'country': country,
          'page': page,
          'pageSize': pageSize,
          'apiKey': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        return (response.data['articles'] as List)
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
      } else {
        throw Exception('Failed to load headlines: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    }
  }

  Future<List<Article>> getNewsByCategory(
    String category, {
    String country = 'us',
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {
          'country': country,
          'category': category,
          'page': page,
          'pageSize': pageSize,
          'apiKey': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        return (response.data['articles'] as List)
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
      } else {
        throw Exception('Failed to load category news: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error (category): ${e.message}');
    }
  }

  Future<List<Article>> searchArticles(
    String query, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/everything',
        queryParameters: {
          'q': query,
          'page': page,
          'pageSize': pageSize,
          'apiKey': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        return (response.data['articles'] as List)
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
      } else {
        throw Exception('Failed to search articles: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error (search): ${e.message}');
    }
  }
}
