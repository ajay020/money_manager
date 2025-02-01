import 'package:hive_flutter/adapters.dart';

import '../models/expense.dart';

class ExpenseService {
  static const String _boxName = 'expenses';
  late Box<Expense> _expenseBox;

  Future<void> init() async {
    Hive.registerAdapter(ExpenseAdapter());
    _expenseBox = await Hive.openBox<Expense>(_boxName);
  }

  // Add a new expense
  Future<void> addExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  // Get all expenses (sorted by date)
  List<Expense> getAllExpenses({bool sortByDateDesc = true}) {
    final expenses = _expenseBox.values.toList();
    if (sortByDateDesc) {
      expenses.sort((a, b) => b.date.compareTo(a.date));
    }
    return expenses;
  }

  // Get expense by ID
  Expense? getExpenseById(String id) {
    return _expenseBox.get(id);
  }

  // Update an existing expense
  Future<void> updateExpense(String id, Expense updatedExpense) async {
    if (_expenseBox.containsKey(id)) {
      await _expenseBox.put(id, updatedExpense);
    }
  }

  // Delete an expense by ID
  Future<void> deleteExpense(String id) async {
    await _expenseBox.delete(id);
  }

  // Get expenses grouped by date
  Map<DateTime, List<Expense>> getExpensesGroupedByDate() {
    final expenses = getAllExpenses();
    final groupedExpenses = <DateTime, List<Expense>>{};

    for (var expense in expenses) {
      // Remove time component for grouping
      final dateOnly = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );

      if (!groupedExpenses.containsKey(dateOnly)) {
        groupedExpenses[dateOnly] = [];
      }
      groupedExpenses[dateOnly]!.add(expense);
    }

    return groupedExpenses;
  }

  // Get expenses filtered by category
  List<Expense> getExpensesByCategory(String category) {
    return _expenseBox.values
        .where((expense) => expense.categoryName == category)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get expenses within a date range
  List<Expense> getExpensesByDateRange(DateTime startDate, DateTime endDate) {
    return _expenseBox.values
        .where((expense) =>
            (expense.date.isAtSameMomentAs(startDate) ||
                expense.date.isAfter(startDate)) &&
            (expense.date.isAtSameMomentAs(endDate) ||
                expense.date.isBefore(endDate)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort latest to oldest
  }

  // Get total expenses
  double getTotalExpenses() {
    return _expenseBox.values.fold(0, (sum, expense) => sum + expense.amount);
  }

  // Get total expenses by category
  double getTotalExpensesByCategory(String category) {
    return _expenseBox.values
        .where((expense) => expense.categoryName == category)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  // Clear all expenses
  Future<void> clearAllExpenses() async {
    await _expenseBox.clear();
  }
}
