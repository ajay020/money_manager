import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../providers/category_provider.dart';

void showAddCategoryDialog(BuildContext context) {
  final categoryController = TextEditingController();
  IconData selectedIcon = Icons.category;

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxHeight: 500),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add New Category",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(
                      labelText: "Category Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: [
                        Icons.fastfood,
                        Icons.flight,
                        Icons.shopping_cart,
                        Icons.lightbulb,
                        Icons.movie,
                        Icons.local_hospital,
                        Icons.sports_soccer,
                        Icons.pets,
                        Icons.directions_car,
                        Icons.home,
                        Icons.school,
                        Icons.work,
                        Icons.fitness_center,
                        Icons.music_note,
                        Icons.book,
                        Icons.computer,
                        Icons.phone_android,
                        Icons.videogame_asset,
                        Icons.spa,
                        Icons.beach_access,
                      ].map((icon) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedIcon = icon;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedIcon == icon
                                  ? Colors.blue.withAlpha(1)
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              icon,
                              size: 32,
                              color: selectedIcon == icon
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (categoryController.text.isNotEmpty) {
                            final newCategory = Category(
                              name: categoryController.text,
                              iconCode: selectedIcon.codePoint,
                            );

                            Provider.of<CategoryProvider>(context,
                                    listen: false)
                                .addCategory(newCategory);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Category added successfully!"),
                              ),
                            );
                            Navigator.of(dialogContext).pop();
                          }
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
