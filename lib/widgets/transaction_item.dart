import 'package:flutter/material.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/screens/expense_detail_screen.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        transaction.category.icon,
        color: Colors.blue,
      ),
      title: Text(
        transaction.title,
        style: TextStyle(fontSize: 16),
      ),
      subtitle: Text(transaction.category.name),
      trailing: Text(
        '\$${transaction.amount.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 16),
      ),
      onTap: () {
        // Navigate to expense detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExpenseDetailScreen(id: transaction.id),
          ),
        );
      },
    );
  }
}
