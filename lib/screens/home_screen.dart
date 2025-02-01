import 'package:flutter/material.dart';
import 'package:money_manager/utils/date_formatter.dart';

import 'package:provider/provider.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    // Group expenses by date
    final groupedExpenses =
        Provider.of<ExpenseProvider>(context).getExpensesGroupedByDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Manager'),
      ),
      body: groupedExpenses.isEmpty
          ? const Center(
              child: Text(
                'No expenses added yet. Tap the + button to add one!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: groupedExpenses.length,
              itemBuilder: (ctx, index) {
                final date = groupedExpenses.keys.elementAt(index);
                final expenses = groupedExpenses[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display Date Header
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        formatDate(date.toString()),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),

                    Divider(),

                    // Display Expenses for the Date
                    ...expenses.map((expense) {
                      return ExpenseItem(expense: expense);
                    }),
                  ],
                );
              },
            ),
    );
  }

  // Map<String, List<Expense>> groupExpensesByDate(List<Expense> expenses) {
  //   Map<String, List<Expense>> groupedExpenses = {};

  //   for (var expense in expenses) {
  //     String dateKey = DateFormat('MMM d, EEEE').format(expense.date);
  //     if (!groupedExpenses.containsKey(dateKey)) {
  //       groupedExpenses[dateKey] = [];
  //     }
  //     groupedExpenses[dateKey]!.add(expense);
  //   }

  //   return groupedExpenses;
  // }
}
