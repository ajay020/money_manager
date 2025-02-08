import 'package:flutter/material.dart';
import 'package:money_manager/models/category_model.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';
import 'add_category_dialog.dart';

Future<void> showCategoryBottomSheet({
  required BuildContext context,
  required Function(Category) onCategorySelected,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (bottomSheetContext) {
      return Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 500,
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    itemCount: categoryProvider.categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final category = categoryProvider.categories[index];
                      return GestureDetector(
                        onTap: () {
                          onCategorySelected(category);
                          Navigator.of(context).pop();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(category.icon, size: 40, color: Colors.blue),
                            const SizedBox(height: 8),
                            Text(category.name),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showAddCategoryDialog(context);
                  },
                  child: const Text("Add New Category"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
