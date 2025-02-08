import 'package:flutter/material.dart';
import 'package:money_manager/providers/transaction_provider.dart';
import 'package:money_manager/utils/date_formatter.dart';
import 'package:money_manager/widgets/summary_card.dart';

import 'package:provider/provider.dart';
import '../widgets/transaction_item.dart';

enum FilterType { all, income, expense }

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<RecordsScreen> {
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
    final groupedTransactions =
        transactionProvider.getTransactionsGroupedByDate(transactions);

    final totalIncome = transactionProvider.getTotalIncome();
    final totalExpense = transactionProvider.getTotalExpenses();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Manager'),
        backgroundColor: Colors.amber,
      ),
      body: Column(
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
                    value: FilterType.expense, label: Text("Expense")),
                ButtonSegment(value: FilterType.income, label: Text("Income")),
              ],
              selected: <FilterType>{selectedFilter},
              onSelectionChanged: (newSelection) {
                setState(() {
                  selectedFilter = newSelection.first;
                });
              },
            ),
          ),
          // transaction list
          Expanded(
            child: groupedTransactions.isEmpty
                ? const Center(
                    child: Text(
                      'No expenses added yet. Tap the + button to add one!',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: groupedTransactions.length,
                    itemBuilder: (ctx, index) {
                      final date = groupedTransactions.keys.elementAt(index);
                      final transactions = groupedTransactions[date]!;

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

                          // Display transactions for the Date
                          ...transactions.map(
                            (transaction) {
                              return TransactionItem(transaction: transaction);
                            },
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
