import 'package:flutter/material.dart';
import 'package:money_manager/models/category.dart';

import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService;
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  CategoryProvider(this._categoryService) {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    _categories = _categoryService.getAllCategories();
    notifyListeners();
  }

  void addCategory(Category category) async {
    await _categoryService.addCategory(category);
    _loadCategories();
  }

  void updateCategory(String id, Category newCategory) async {
    await _categoryService.updateCategory(id, newCategory);
    _loadCategories();
  }

  void deleteCategory(String id) async {
    await _categoryService.deleteCategory(id);
    _loadCategories();
  }
}
