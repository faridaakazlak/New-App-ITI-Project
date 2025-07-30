import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../widgets/article_card.dart';

class CategoryNewsScreen extends StatelessWidget {
  final String category;
  final List<Article> articles;

  const CategoryNewsScreen({
    super.key,
    required this.category,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$category News')),
      body: articles.isEmpty
          ? const Center(child: Text('No articles found.'))
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return ArticleCard(article: articles[index]);
              },
            ),
    );
  }
}
