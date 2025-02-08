import 'package:hive/hive.dart';

part 'transaction_type.g.dart';

@HiveType(typeId: 0)
enum TransactionType {
  @HiveField(0)
  expense,

  @HiveField(1)
  income;

  bool get isExpense => this == TransactionType.expense;
  bool get isIncome => this == TransactionType.income;
}
