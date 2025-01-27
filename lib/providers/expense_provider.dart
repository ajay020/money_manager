import 'package:flutter/material.dart';
import 'package:money_manager/services/expense_service.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseService _expenseService = ExpenseService();
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  /// Load saved expenses from local storage
  Future<void> loadExpenses() async {
    _expenses = _expenseService.getExpenses();
    notifyListeners(); // Notify UI to rebuild
  }

  /// Add a new expense
  Future<void> addExpense(Expense expense) async {
    await _expenseService.addExpense(expense);
    _expenses.add(expense);
    _sortExpenses(); // Sort after adding
    notifyListeners();
  }

  /// Update an expense
  Future<void> updateExpense(int index, Expense updatedExpense) async {
    await _expenseService.updateExpense(index, updatedExpense);
    _expenses[index] = updatedExpense;
    _sortExpenses(); // Sort after updating
    notifyListeners();
  }

  /// Delete an expense
  Future<void> deleteExpense(int index) async {
    await _expenseService.deleteExpense(index);
    _expenses.removeAt(index);
    _sortExpenses(); // Sort after deleting
    notifyListeners();
  }

  void _sortExpenses() {
    _expenses.sort((a, b) => b.date.compareTo(a.date)); // Latest to oldest
  }
}
