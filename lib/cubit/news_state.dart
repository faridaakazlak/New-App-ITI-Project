import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/news_service.dart';
import '../models/article_model.dart';

/// STATES

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoadingMore extends NewsState {}

class NewsLoaded extends NewsState {
  final List<Article> articles;
  final bool hasMore;

  NewsLoaded(this.articles, {this.hasMore = true});
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);
}

/// CUBIT

class NewsCubit extends Cubit<NewsState> {
  final NewsService _newsService;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  NewsCubit(this._newsService) : super(NewsInitial());

  Future<void> getTopHeadlines() async {
    if (!_hasMore || _isLoading) return;
    _isLoading = true;

    try {
      emit(_page == 1 ? NewsLoading() : NewsLoadingMore());

      final articles = await _newsService.getTopHeadlines(
        page: _page,
        pageSize: 20,
      );

      _hasMore = articles.length >= 20;

      emit(
        NewsLoaded(
          _page == 1
              ? articles
              : [
                  ...(state is NewsLoaded
                      ? (state as NewsLoaded).articles
                      : []),
                  ...articles,
                ],
          hasMore: _hasMore,
        ),
      );

      _page++;
    } catch (e) {
      emit(NewsError(e.toString()));
      if (_page == 1) emit(NewsInitial());
    } finally {
      _isLoading = false;
    }
  }

  Future<void> refreshNews() async {
    _page = 1;
    _hasMore = true;
    await getTopHeadlines();
  }

  Future<void> loadMore() async {
    if (_hasMore && !_isLoading) {
      await getTopHeadlines();
    }
  }
}
