import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../widgets/transaction_item.dart';
import '../utils/date_formatter.dart';

class TransactionListView extends StatelessWidget {
  final Map<DateTime, List<Transaction>> groupedTransactions;

  const TransactionListView({super.key, required this.groupedTransactions});

  @override
  Widget build(BuildContext context) {
    return groupedTransactions.isEmpty
        ? const Center(
            child: Text(
              'No transactions available.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics:
                NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
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
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  // Display transactions for the Date
                  ...transactions.map(
                    (transaction) => TransactionItem(transaction: transaction),
                  ),
                ],
              );
            },
          );
  }
}
