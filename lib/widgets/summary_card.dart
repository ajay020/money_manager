import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;

  const SummaryCard({
    super.key,
    required this.totalExpense,
    required this.totalIncome,
  });

  @override
  Widget build(BuildContext context) {
    double balance = totalIncome - totalExpense;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Income
            _buildSummaryItem("Total Income", totalIncome, Colors.green),
            const SizedBox(height: 10),

            // Total Expense
            _buildSummaryItem("Total Expense", totalExpense, Colors.red),
            const SizedBox(height: 10),

            // Balance
            _buildSummaryItem(
                "Balance", balance, balance >= 0 ? Colors.blue : Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
