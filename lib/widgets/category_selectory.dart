import 'package:flutter/material.dart';
import 'package:money_manager/models/category.dart';

class CategorySelectory extends StatelessWidget {
  final Category? selectedCategory;
  final VoidCallback onCategoryTap;

  const CategorySelectory({
    super.key,
    required this.selectedCategory,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCategoryTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(selectedCategory?.icon, size: 24, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              selectedCategory?.name ?? "Select a category",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
