import 'package:flutter/material.dart';

class CategoryItemModel {
  final IconData icon;
  final String label;
  bool isSelected;

  CategoryItemModel({required this.icon, required this.label, this.isSelected = false});
}

class CategoryModel {
  final String title;
  final List<CategoryItemModel> items;
  bool isExpanded;

  CategoryModel({required this.title, required this.items, this.isExpanded = false});
}
