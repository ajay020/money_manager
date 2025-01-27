import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Load expenses when the app starts
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpenseProvider>(context).expenses;

    // Group expenses by date
    final groupedExpenses = groupExpensesByDate(expenses);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add-expense');
            },
          ),
        ],
      ),
      body: expenses.isEmpty
          ? const Center(
              child: Text(
                'No expenses added yet. Tap the + button to add one!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: groupedExpenses.keys.length,
              itemBuilder: (ctx, index) {
                final dateKey = groupedExpenses.keys.toList()[index];
                final dateExpenses = groupedExpenses[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display Date Header
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        dateKey,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Divider(),

                    // Display Expenses for the Date
                    ...dateExpenses.map((expense) {
                      return ExpenseItem(
                          expense: expense, index: expenses.indexOf(expense));
                    }),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-expense');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Map<String, List<Expense>> groupExpensesByDate(List<Expense> expenses) {
    Map<String, List<Expense>> groupedExpenses = {};

    for (var expense in expenses) {
      String dateKey = DateFormat('MMM d, EEEE').format(expense.date);
      if (!groupedExpenses.containsKey(dateKey)) {
        groupedExpenses[dateKey] = [];
      }
      groupedExpenses[dateKey]!.add(expense);
    }

    return groupedExpenses;
  }
}
