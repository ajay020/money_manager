import 'package:hive_flutter/adapters.dart';

import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../models/transaction_type.dart';

class TransactionService {
  static const String _boxName = 'transactions';
  late Box<Transaction> _transactionBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(TransactionTypeAdapter());
    _transactionBox = await Hive.openBox<Transaction>(_boxName);
  }

  // Add a new transaction
  Future<void> addTransaction(Transaction transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  // Delete an transaction by ID
  Future<void> deleteTransaction(String id) async {
    await _transactionBox.delete(id);
  }

  // Update an existing expense
  Future<void> updateTransaction(
      String id, Transaction updatedTransaction) async {
    if (_transactionBox.containsKey(id)) {
      await _transactionBox.put(id, updatedTransaction);
    }
  }

  Transaction? getTransactionById(String id) {
    final transaction = _transactionBox.get(id);
    return transaction;
  }

  // Get all transactions sorted by date
  List<Transaction> getAllTransactions({bool sortByDateDesc = true}) {
    final transactions = _transactionBox.values.toList();
    if (sortByDateDesc) {
      transactions.sort((a, b) => b.date.compareTo(a.date));
    }
    return transactions;
  }

  // Get transactions by type
  List<Transaction> getTransactionsByType(TransactionType type) {
    return _transactionBox.values
        .where((transaction) => transaction.type == type)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get balance (income - expenses)
  double getBalance() {
    final transactions = getAllTransactions(sortByDateDesc: false);
    return transactions.fold(0.0, (sum, transaction) {
      return sum +
          (transaction.type.isIncome
              ? transaction.amount
              : -transaction.amount);
    });
  }

  // Get total income
  double getTotalIncome({DateTime? startDate, DateTime? endDate}) {
    var transactions = _transactionBox.values.where((t) => t.type.isIncome);

    if (startDate != null && endDate != null) {
      transactions = transactions
          .where((t) => t.date.isAfter(startDate) && t.date.isBefore(endDate));
    }

    return transactions.fold(0.0, (sum, t) => sum + t.amount);
  }

  // Get total expenses
  double getTotalExpenses({DateTime? startDate, DateTime? endDate}) {
    var transactions = _transactionBox.values.where((t) => t.type.isExpense);

    if (startDate != null && endDate != null) {
      transactions = transactions
          .where((t) => t.date.isAfter(startDate) && t.date.isBefore(endDate));
    }

    return transactions.fold(0.0, (sum, t) => sum + t.amount);
  }

  // Get transactions by category
  List<Transaction> getTransactionsByCategory(Category category) {
    return _transactionBox.values
        .where((t) => t.category.id == category.id)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get total amount by category
  double getTotalByCategory(Category category, {TransactionType? type}) {
    var transactions =
        _transactionBox.values.where((t) => t.category.id == category.id);

    if (type != null) {
      transactions = transactions.where((t) => t.type == type);
    }

    return transactions.fold(0.0, (sum, t) => sum + t.amount);
  }

  // Get transactions for a specific month
  List<Transaction> getTransactionsByMonth(DateTime date) {
    final startOfMonth = DateTime(date.year, date.month, 1);
    final endOfMonth = DateTime(date.year, date.month + 1, 0);

    return _transactionBox.values
        .where(
            (t) => t.date.isAfter(startOfMonth) && t.date.isBefore(endOfMonth))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get category-wise totals for a specific time period
  Map<Category, double> getCategoryTotals({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
  }) {
    var transactions = _transactionBox.values;

    if (startDate != null && endDate != null) {
      transactions = transactions
          .where((t) => t.date.isAfter(startDate) && t.date.isBefore(endDate));
    }

    if (type != null) {
      transactions = transactions.where((t) => t.type == type);
    }

    final totals = <Category, double>{};
    for (var transaction in transactions) {
      totals[transaction.category] =
          (totals[transaction.category] ?? 0) + transaction.amount;
    }

    return totals;
  }

  // Get expenses within a date range
  List<Transaction> getTransactionByDateRange(
      DateTime startDate, DateTime endDate) {
    return _transactionBox.values
        .where((transaction) =>
            (transaction.date.isAtSameMomentAs(startDate) ||
                transaction.date.isAfter(startDate)) &&
            (transaction.date.isAtSameMomentAs(endDate) ||
                transaction.date.isBefore(endDate)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort latest to oldest
  }
}
