import 'package:flutter/material.dart';
import 'package:money_manager/models/category_model.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/expense.dart';

class CategoryService {
  static const String _boxName = 'categories';
  late Box<Category> _categoryBox;

  // Initialize Hive and open the box
  Future<void> init() async {
    Hive.registerAdapter(CategoryAdapter());
    _categoryBox = await Hive.openBox<Category>(_boxName);

    // Add default categories if box is empty
    if (_categoryBox.isEmpty) {
      await addDefaultCategories();
    }
  }

  // Add a new category
  Future<void> addCategory(Category category) async {
    await _categoryBox.put(category.id, category);
  }

  // Get all categories
  List<Category> getAllCategories() {
    return _categoryBox.values.toList();
  }

  // Get category by ID
  Category? getCategoryById(String id) {
    return _categoryBox.get(id);
  }

  // Get category by name
  Category? getCategoryByName(String name) {
    return _categoryBox.values.firstWhere(
      (category) => category.name.toLowerCase() == name.toLowerCase(),
      orElse: () => throw Exception('Category not found'),
    );
  }

  // Update an existing category
  Future<void> updateCategory(String id, Category newCategory) async {
    final existingCategory = _categoryBox.get(id);
    if (existingCategory != null) {
      final updatedCategory = Category(
        name: newCategory.name,
        iconCode: newCategory.iconCode,
        id: id,
      );
      await _categoryBox.put(id, updatedCategory);
    }
  }

  // Delete a category
  Future<void> deleteCategory(String id) async {
    await _categoryBox.delete(id);
  }

  // Check if a category exists by name (case insensitive)
  bool categoryExistsByName(String name) {
    return _categoryBox.values.any(
      (category) => category.name.toLowerCase() == name.toLowerCase(),
    );
  }

  // Add default categories
  Future<void> addDefaultCategories() async {
    final defaultCategories = [
      Category(
        name: 'Food',
        iconCode: Icons.restaurant.codePoint,
      ),
      Category(
        name: 'Transportation',
        iconCode: Icons.directions_car.codePoint,
      ),
      Category(
        name: 'Shopping',
        iconCode: Icons.shopping_bag.codePoint,
      ),
      Category(
        name: 'Bills',
        iconCode: Icons.receipt_long.codePoint,
      ),
      Category(
        name: 'Entertainment',
        iconCode: Icons.movie.codePoint,
      ),
      Category(
        name: 'Health',
        iconCode: Icons.medical_services.codePoint,
      ),
    ];

    for (var category in defaultCategories) {
      await addCategory(category);
    }
  }

  // Clear all categories
  Future<void> clearAllCategories() async {
    await _categoryBox.clear();
  }

  // Get category count
  int getCategoryCount() {
    return _categoryBox.length;
  }

  // Check if a category is in use by any expense
  Future<bool> isCategoryInUse(String categoryId, Box<Expense> expenseBox) {
    return Future.value(expenseBox.values.any(
      (expense) => expense.categoryName == getCategoryById(categoryId)?.name,
    ));
  }
}
