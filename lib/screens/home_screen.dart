import 'package:flutter/material.dart';
import 'package:money_manager/providers/transaction_provider.dart';
import 'package:money_manager/widgets/summary_card.dart';

import 'package:provider/provider.dart';
import '../widgets/transaction_listview.dart';

enum FilterType { all, income, expense }

class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToTransactions;
  const HomeScreen({super.key, required this.onNavigateToTransactions});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FilterType selectedFilter = FilterType.all;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    final transactions =
        transactionProvider.getFilteredTransactions(selectedFilter);

    // Group transactions by date
    final groupedTransactions = Map.fromEntries(transactionProvider
        .getTransactionsGroupedByDate(transactions)
        .entries
        .take(3));

    final totalIncome = transactionProvider.getTotalIncome();
    final totalExpense = transactionProvider.getTotalExpenses();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Manager'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SummaryCard(totalExpense: totalExpense, totalIncome: totalIncome),
            // Segmented button control for Filtering
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SegmentedButton<FilterType>(
                segments: const [
                  ButtonSegment(value: FilterType.all, label: Text("All")),
                  ButtonSegment(
                    value: FilterType.expense,
                    label: Text("Expense"),
                  ),
                  ButtonSegment(
                      value: FilterType.income, label: Text("Income")),
                ],
                selected: <FilterType>{selectedFilter},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    selectedFilter = newSelection.first;
                  });
                },
              ),
            ),
            SizedBox(height: 10), // Spacing

            Column(
              children: [
                TransactionListView(groupedTransactions: groupedTransactions),
                if (groupedTransactions.isNotEmpty)
                  Center(
                    child: TextButton(
                      onPressed: widget.onNavigateToTransactions,
                      child: Text("Show all transactions"),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
