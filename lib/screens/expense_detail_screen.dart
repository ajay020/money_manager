import 'package:flutter/material.dart';
import 'package:money_manager/screens/update_expense_screen.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final String id;

  const ExpenseDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final Expense? expense = expenseProvider.getExpenseById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${expense?.title}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Amount: \$${expense?.amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Category: ${expense?.categoryName}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${expense?.date.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 18),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Show the confirmation dialog
                    if (expense != null) {
                      _showDeleteConfirmationDialog(
                          context, expense, expenseProvider);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                  ),
                  child: const Text('Delete'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (expense != null) {
                      // Navigate to the Update Screen
                      _navigateToUpdateScreen(context, expense);
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    Expense expense,
    ExpenseProvider expenseProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text(
            'Are you sure you want to delete this expense? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Delete the expense
              expenseProvider.deleteExpense(expense.id);
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Go back to the home screen
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _navigateToUpdateScreen(BuildContext context, Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateExpenseScreen(expense: expense),
      ),
    );
  }
}
