import 'package:flutter/foundation.dart';

@immutable
class Article {
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String? content;
  final String? category;
  final String? sourceName; // ✅ الجديد

  const Article({
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
    this.category,
    this.sourceName, // ✅ الجديد
  });

  Article copyWith({
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    DateTime? publishedAt,
    String? content,
    String? category,
    String? sourceName, // ✅ الجديد
  }) {
    return Article(
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
      category: category ?? this.category,
      sourceName: sourceName ?? this.sourceName, // ✅ الجديد
    );
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      author: json['author'] as String?,
      title: (json['title'] as String?) ?? '',
      description: json['description'] as String?,
      url: (json['url'] as String?) ?? '',
      urlToImage: json['urlToImage'] as String?,
      publishedAt: DateTime.parse(
        json['publishedAt'] as String? ?? DateTime.now().toString(),
      ),
      content: json['content'] as String?,
      category: json['category'] as String?,
      sourceName: json['source']?['name'], // ✅ الجديد
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toIso8601String(),
      'content': content,
      if (category != null) 'category': category,
      if (sourceName != null) 'source': {'name': sourceName}, // ✅ الجديد
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Article &&
        other.author == author &&
        other.title == title &&
        other.description == description &&
        other.url == url &&
        other.urlToImage == urlToImage &&
        other.publishedAt == publishedAt &&
        other.content == content &&
        other.category == category &&
        other.sourceName == sourceName; // ✅ الجديد
  }

  @override
  int get hashCode {
    return Object.hash(
      author,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      content,
      category,
      sourceName, // ✅ الجديد
    );
  }
}
