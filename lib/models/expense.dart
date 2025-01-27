import 'package:hive/hive.dart';

part 'expense.g.dart'; // Required for code generation

@HiveType(typeId: 0) // Unique ID for this model
class Expense extends HiveObject {
  @HiveField(0) // Field ID
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });
}
