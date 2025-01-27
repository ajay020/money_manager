import 'package:flutter/material.dart';
import 'package:money_manager/models/expense.dart';
import 'package:money_manager/screens/expense_detail_screen.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final int index;

  const ExpenseItem({super.key, required this.expense, required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.home),
      title: Text(
        expense.title,
        style: TextStyle(fontSize: 16),
      ),
      // subtitle: Text('\$${expense.amount.toStringAsFixed(2)}'),
      trailing: Text(
        '\$${expense.amount.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 16),
      ),
      onTap: () {
        // Navigate to expense detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExpenseDetailScreen(index: index),
          ),
        );
      },
    );
  }
}
