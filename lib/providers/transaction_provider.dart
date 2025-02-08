import 'package:flutter/material.dart';
import 'package:money_manager/models/transaction_model.dart';

import '../models/category_model.dart';
import '../models/transaction_type.dart';
import '../screens/records_screen.dart';
import '../services/transaction_service.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionService _transactionService;
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  TransactionProvider(this._transactionService);

  Future<void> init() async {
    await _transactionService.init();
    _loadTransaction();
    notifyListeners();
  }

  void _loadTransaction() {
    _transactions = _transactionService.getAllTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _transactionService.addTransaction(transaction);
    _transactions = _transactionService.getAllTransactions();
    notifyListeners();
  }

  List<Transaction> getTransactionsByType(TransactionType type) {
    return _transactionService.getTransactionsByType(type);
  }

  double getBalance() {
    return _transactionService.getBalance();
  }

  double getTotalIncome({DateTime? startDate, DateTime? endDate}) {
    return _transactionService.getTotalIncome(
      startDate: startDate,
      endDate: endDate,
    );
  }

  double getTotalExpenses({DateTime? startDate, DateTime? endDate}) {
    return _transactionService.getTotalExpenses(
        startDate: startDate, endDate: endDate);
  }

  List<Transaction> getTransactionsByCategory(Category category) {
    return _transactionService.getTransactionsByCategory(category);
  }

  Map<DateTime, List<Transaction>> getTransactionsGroupedByDate(
    List<Transaction> transactions,
  ) {
    final groupedTransactions = <DateTime, List<Transaction>>{};

    for (var transaction in transactions) {
      final dateOnly = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );

      if (!groupedTransactions.containsKey(dateOnly)) {
        groupedTransactions[dateOnly] = [];
      }
      groupedTransactions[dateOnly]!.add(transaction);
    }

    return groupedTransactions;
  }

  // Filter Transactions
  List<Transaction> getFilteredTransactions(FilterType filterType) {
    _loadTransaction();
    if (filterType == FilterType.income) {
      return _transactions.where((tx) => tx.type.isIncome).toList();
    } else if (filterType == FilterType.expense) {
      return _transactions.where((tx) => !tx.type.isIncome).toList();
    }
    return _transactions; // Default: Show all
  }

  List<Transaction> getTransactionsByMonth(DateTime date) {
    return _transactionService.getTransactionsByMonth(date);
  }

  Transaction? getTransactionById(String id) {
    return _transactionService.getTransactionById(id);
  }

  void deleteTransaction(String id) {
    _transactionService.deleteTransaction(id);
    notifyListeners();
  }

  void updateTransaction(String id, Transaction newTransaction) {
    _transactionService.updateTransaction(id, newTransaction);
    notifyListeners();
  }

  Map<Category, double> getCategoryTotals({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
  }) {
    return _transactionService.getCategoryTotals(
      startDate: startDate,
      endDate: endDate,
      type: type,
    );
  }
}
