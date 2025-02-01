import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'expense.g.dart'; // Required for code generation

@HiveType(typeId: 0) // Unique ID for this model
class Expense extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String categoryName;

  @HiveField(4)
  final int categoryIconCode;

  @HiveField(5)
  final String id;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.categoryName,
    required this.categoryIconCode,
    String? id,
  }) : id = id ?? const Uuid().v4();

  // Helper method to create a copy of the expense with modified fields
  Expense copyWith(
      {String? title,
      double? amount,
      DateTime? date,
      String? categoryName,
      int? categoryIconCode}) {
    return Expense(
        id: id, // Keep the same ID
        title: title ?? this.title,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        categoryName: categoryName ?? this.categoryName,
        categoryIconCode: categoryIconCode ?? this.categoryIconCode);
  }

  IconData get categoryIcon =>
      IconData(categoryIconCode, fontFamily: 'MaterialIcons');
}
