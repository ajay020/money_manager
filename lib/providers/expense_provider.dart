import 'package:flutter/material.dart';
import 'package:money_manager/services/expense_service.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseService _expenseService;
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  ExpenseProvider(this._expenseService) {
    _initializeExpenses();
  }

  Future<void> _initializeExpenses() async {
    // await _expenseService.init();
    loadExpenses();
  }

  /// Load saved expenses from local storage
  Future<void> loadExpenses() async {
    _expenses = _expenseService.getAllExpenses();
    notifyListeners(); // Notify UI to rebuild
  }

  /// Add a new expense
  Future<void> addExpense(Expense expense) async {
    await _expenseService.addExpense(expense);
    loadExpenses();
    _sortExpenses(); // Sort after adding
    notifyListeners();
  }

  /// Update an expense
  Future<void> updateExpense(String id, Expense updatedExpense) async {
    await _expenseService.updateExpense(id, updatedExpense);
    loadExpenses();
    _sortExpenses(); // Sort after updating
    notifyListeners();
  }

  Map<DateTime, List<Expense>> getExpensesGroupedByDate() {
    return _expenseService.getExpensesGroupedByDate();
  }

  /// Delete an expense
  Future<void> deleteExpense(String id) async {
    await _expenseService.deleteExpense(id);
    loadExpenses();
    _sortExpenses(); // Sort after deleting
    notifyListeners();
  }

  Expense? getExpenseById(String id) {
    return _expenseService.getExpenseById(id);
  }

  void _sortExpenses() {
    _expenses.sort((a, b) => b.date.compareTo(a.date)); // Latest to oldest
  }
}
