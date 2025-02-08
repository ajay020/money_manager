import 'package:flutter/material.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/providers/transaction_provider.dart';
import 'package:money_manager/screens/update_expense_screen.dart';
import 'package:provider/provider.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final String id;
  const ExpenseDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    print("Received ID: $id");
    
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final Transaction? transaction = transactionProvider.getTransactionById(id);

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
              'Title: ${transaction?.title}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Amount: \$${transaction?.amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Category: ${transaction?.category.name}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${transaction?.date.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 18),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Show the confirmation dialog
                    if (transaction != null) {
                      _showDeleteConfirmationDialog(
                        context,
                        transaction,
                        transactionProvider,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                  ),
                  child: const Text('Delete'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (transaction != null) {
                      // Navigate to the Update Screen
                      _navigateToUpdateScreen(context, transaction);
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
    Transaction transaction,
    TransactionProvider transactionProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text(
          'Are you sure you want to delete this expense? This action cannot be undone.',
        ),
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
              transactionProvider.deleteTransaction(transaction.id);
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

  void _navigateToUpdateScreen(BuildContext context, Transaction transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateExpenseScreen(
          transaction: transaction,
        ),
      ),
    );
  }
}
