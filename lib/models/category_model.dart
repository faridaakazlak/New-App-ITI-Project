import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String displayName;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final int? articleCount;
  CategoryModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.icon,
    required this.color,
    this.isSelected = false,
    this.articleCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      displayName: json['displayName'] ?? '',
      icon: _getIconFromString(json['icon'] ?? 'article'),
      color: Color(json['color'] ?? 0xFF2196F3),
      isSelected: json['isSelected'] ?? false,
      articleCount: json['articleCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'icon': _getStringFromIcon(icon),
      'color': color.value,
      'isSelected': isSelected,
      'articleCount': articleCount,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? displayName,
    IconData? icon,
    Color? color,
    bool? isSelected,
    int? articleCount,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isSelected: isSelected ?? this.isSelected,
      articleCount: articleCount ?? this.articleCount,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, displayName: $displayName, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // Static method to get default categories
  static List<CategoryModel> getDefaultCategories() {
    return [
      CategoryModel(
        id: 'general',
        name: 'general',
        displayName: 'General',
        icon: Icons.article,
        color: const Color(0xFF2196F3),
        isSelected: true,
      ),
      CategoryModel(
        id: 'business',
        name: 'business',
        displayName: 'Business',
        icon: Icons.business,
        color: const Color(0xFF4CAF50),
      ),
      CategoryModel(
        id: 'entertainment',
        name: 'entertainment',
        displayName: 'Entertainment',
        icon: Icons.movie,
        color: const Color(0xFFE91E63),
      ),
      CategoryModel(
        id: 'health',
        name: 'health',
        displayName: 'Health',
        icon: Icons.local_hospital,
        color: const Color(0xFFFF5722),
      ),
      CategoryModel(
        id: 'science',
        name: 'science',
        displayName: 'Science',
        icon: Icons.science,
        color: const Color(0xFF9C27B0),
      ),
      CategoryModel(
        id: 'sports',
        name: 'sports',
        displayName: 'Sports',
        icon: Icons.sports_football,
        color: const Color(0xFFFF9800),
      ),
      CategoryModel(
        id: 'technology',
        name: 'technology',
        displayName: 'Technology',
        icon: Icons.computer,
        color: const Color(0xFF607D8B),
      ),
    ];
  }

  // Helper method to get icon from string
  static IconData _getIconFromString(String iconString) {
    switch (iconString.toLowerCase()) {
      case 'business':
        return Icons.business;
      case 'entertainment':
      case 'movie':
        return Icons.movie;
      case 'health':
      case 'hospital':
        return Icons.local_hospital;
      case 'science':
        return Icons.science;
      case 'sports':
      case 'football':
        return Icons.sports_football;
      case 'technology':
      case 'computer':
        return Icons.computer;
      case 'general':
      case 'article':
      default:
        return Icons.article;
    }
  }

  // Helper method to convert icon to string
  static String _getStringFromIcon(IconData icon) {
    if (icon == Icons.business) return 'business';
    if (icon == Icons.movie) return 'movie';
    if (icon == Icons.local_hospital) return 'hospital';
    if (icon == Icons.science) return 'science';
    if (icon == Icons.sports_football) return 'football';
    if (icon == Icons.computer) return 'computer';
    return 'article';
  }

  // Static method to select a category from list
  static List<CategoryModel> selectCategory(
    List<CategoryModel> categories,
    String categoryId,
  ) {
    return categories.map((category) {
      return category.copyWith(isSelected: category.id == categoryId);
    }).toList();
  }

  // Static method to get selected category
  static CategoryModel? getSelectedCategory(List<CategoryModel> categories) {
    try {
      return categories.firstWhere((category) => category.isSelected);
    } catch (e) {
      return null;
    }
  }

  // Helper method to get category color with opacity
  Color get colorWithOpacity => color.withOpacity(0.1);
}
