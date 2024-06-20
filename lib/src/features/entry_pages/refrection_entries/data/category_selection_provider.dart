import 'package:flutter/material.dart';
import 'model/category_model.dart';

class CategorySelectionProvider extends ChangeNotifier {
  final List<CategoryModel> _categories = [
    CategoryModel(
      title: "Other",
      items: [
        CategoryItemModel(icon: Icons.fitness_center, label: "exercise"),
        CategoryItemModel(icon: Icons.sports_soccer, label: "sport"),
        CategoryItemModel(icon: Icons.bedtime, label: "sleep early"),
        CategoryItemModel(icon: Icons.restaurant, label: "eat healthy"),
        CategoryItemModel(icon: Icons.beach_access, label: "relax"),
        CategoryItemModel(icon: Icons.movie, label: "movies"),
        CategoryItemModel(icon: Icons.book, label: "reading"),
        CategoryItemModel(icon: Icons.videogame_asset, label: "gaming"),
        CategoryItemModel(icon: Icons.cleaning_services, label: "cleaning"),
        CategoryItemModel(icon: Icons.shopping_cart, label: "shopping"),
      ],
    ),
    CategoryModel(
      title: "Social",
      items: [
        CategoryItemModel(icon: Icons.celebration, label: "party"),
        CategoryItemModel(icon: Icons.family_restroom, label: "family"),
        CategoryItemModel(icon: Icons.group, label: "friends"),
        CategoryItemModel(icon: Icons.favorite, label: "date"),
      ],
    ),
    CategoryModel(
      title: "Romance",
      items: [],
    ),
    CategoryModel(
      title: "Places",
      items: [
        CategoryItemModel(icon: Icons.home, label: "home"),
        CategoryItemModel(icon: Icons.work, label: "work"),
        CategoryItemModel(icon: Icons.school, label: "school"),
        CategoryItemModel(icon: Icons.group, label: "visit"),
        CategoryItemModel(icon: Icons.directions_car, label: "travel"),
        CategoryItemModel(icon: Icons.fitness_center, label: "gym"),
        CategoryItemModel(icon: Icons.local_movies, label: "cinema"),
        CategoryItemModel(icon: Icons.nature, label: "nature"),
        CategoryItemModel(icon: Icons.beach_access, label: "vacation"),
      ],
    ),
    CategoryModel(
      title: "Emotions",
      items: [],
    ),
    CategoryModel(
      title: "Bad Habits",
      items: [],
    ),
  ];

  List<CategoryModel> get categories => _categories;

  void toggleExpansion(int index) {
    _categories[index].isExpanded = !_categories[index].isExpanded;
    notifyListeners();
  }

  void toggleSelection(String label) {
    for (var category in _categories) {
      for (var item in category.items) {
        if (item.label == label) {
          item.isSelected = !item.isSelected;
          notifyListeners();
          return;
        }
      }
    }
  }

  List<String> getSelectedItems() {
    List<String> selectedItems = [];
    for (var category in _categories) {
      for (var item in category.items) {
        if (item.isSelected) {
          selectedItems.add(item.label);
        }
      }
    }
    return selectedItems;
  }

  void clearSelections() {
    for (var category in _categories) {
      for (var item in category.items) {
        item.isSelected = false;
      }
    }
    notifyListeners();
  }

    List<int> getSelectedIcons() {
    List<int> selectedIcons = [];
    for (var category in _categories) {
      for (var item in category.items) {
        if (item.isSelected) {
          selectedIcons.add(item.icon.codePoint);
        }
      }
    }
    return selectedIcons;
    }
}
