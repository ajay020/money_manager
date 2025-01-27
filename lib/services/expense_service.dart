import 'package:hive/hive.dart';

import '../models/expense.dart';

class ExpenseService {
  static const String _boxName = 'expensesBox';

  /// Open the Hive box
  Future<void> initializeHive() async {
    await Hive.openBox<Expense>(_boxName);
  }

  /// Add an expense to the box
  Future<void> addExpense(Expense expense) async {
    final box = Hive.box<Expense>(_boxName);
    await box.add(expense);
  }

  /// Get all expenses from the box
  List<Expense> getExpenses() {
    final box = Hive.box<Expense>(_boxName);
    return box.values.toList();
  }

  /// Update an expense at a specific index
  Future<void> updateExpense(int index, Expense updatedExpense) async {
    final box = Hive.box<Expense>(_boxName);
    await box.putAt(index, updatedExpense);
  }

  /// Delete an expense at a specific index
  Future<void> deleteExpense(int index) async {
    final box = Hive.box<Expense>(_boxName);
    await box.deleteAt(index);
  }
}
