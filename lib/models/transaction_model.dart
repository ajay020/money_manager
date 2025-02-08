import 'package:hive/hive.dart';
import 'package:money_manager/models/category_model.dart';
import 'package:uuid/uuid.dart';
import 'transaction_type.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  final Category category;

  @HiveField(4)
  final String id;

  @HiveField(5)
  final TransactionType type;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    String? id,
  }) : id = id ?? const Uuid().v4();

  // Helper method to create a copy with modified fields
  Transaction copyWith({
    String? title,
    double? amount,
    DateTime? date,
    Category? category,
    TransactionType? type,
  }) {
    return Transaction(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      type: type ?? this.type,
    );
  }
}
