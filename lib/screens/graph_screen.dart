import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/services/transaction_service.dart';

import '../services/category_service.dart';

class ExpenseGraphScreen extends StatefulWidget {
  final TransactionService transactionService;
  final CategoryService categoryService;

  const ExpenseGraphScreen({
    super.key,
    required this.transactionService,
    required this.categoryService,
  });

  @override
  State<ExpenseGraphScreen> createState() => _ExpenseGraphScreenState();
}

class _ExpenseGraphScreenState extends State<ExpenseGraphScreen> {
  String _selectedTimeFrame = 'month'; // 'month' or 'year'
  late DateTime _selectedDate;
  List<PieChartSectionData> _sections = [];
  double _totalExpenses = 0;
  Map<String, double> _categoryTotals = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _updateChartData();
  }

  void _updateChartData() {
    DateTime startDate;
    DateTime endDate;

    if (_selectedTimeFrame == 'month') {
      startDate = DateTime(_selectedDate.year, _selectedDate.month, 1);
      endDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    } else {
      startDate = DateTime(_selectedDate.year, 1, 1);
      endDate = DateTime(_selectedDate.year, 12, 31);
    }

    final transactions =
        widget.transactionService.getTransactionByDateRange(startDate, endDate);
    _categoryTotals = {};
    _totalExpenses = 0;

    // Calculate totals for each category
    for (var transaction in transactions) {
      _categoryTotals[transaction.category.name] =
          (_categoryTotals[transaction.category.name] ?? 0) +
              transaction.amount;
      _totalExpenses += transaction.amount;
    }

    // Generate pie chart sections
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
    ];

    _sections = [];
    int colorIndex = 0;

    _categoryTotals.forEach((category, amount) {
      if (amount > 0) {
        _sections.add(
          PieChartSectionData(
            value: amount,
            title: '${(amount / _totalExpenses * 100).toStringAsFixed(1)}%',
            radius: 100,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            color: colors[colorIndex % colors.length],
          ),
        );
        colorIndex++;
      }
    });

    setState(() {});
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16.0,
      runSpacing: 8.0,
      children: _categoryTotals.entries.map((entry) {
        final category = widget.categoryService.getCategoryByName(entry.key);
        if (category == null) return const SizedBox.shrink();

        return Container(
          constraints: const BoxConstraints(minWidth: 150),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, size: 20),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '${category.name}: ${NumberFormat.currency(symbol: '\$').format(entry.value)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Analysis'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Time frame selector
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'month',
                    label: Text('Month'),
                  ),
                  ButtonSegment(
                    value: 'year',
                    label: Text('Year'),
                  ),
                ],
                selected: {_selectedTimeFrame},
                onSelectionChanged: (Set<String> selection) {
                  setState(() {
                    _selectedTimeFrame = selection.first;
                    _updateChartData();
                  });
                },
              ),
              const SizedBox(height: 16),

              // Date selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      setState(() {
                        if (_selectedTimeFrame == 'month') {
                          _selectedDate = DateTime(
                            _selectedDate.year,
                            _selectedDate.month - 1,
                          );
                        } else {
                          _selectedDate = DateTime(
                            _selectedDate.year - 1,
                          );
                        }
                        _updateChartData();
                      });
                    },
                  ),
                  Text(
                    _selectedTimeFrame == 'month'
                        ? DateFormat('MMMM yyyy').format(_selectedDate)
                        : _selectedDate.year.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        if (_selectedTimeFrame == 'month') {
                          _selectedDate = DateTime(
                            _selectedDate.year,
                            _selectedDate.month + 1,
                          );
                        } else {
                          _selectedDate = DateTime(
                            _selectedDate.year + 1,
                          );
                        }
                        _updateChartData();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Total expenses
              Text(
                'Total: ${NumberFormat.currency(symbol: '\$').format(_totalExpenses)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),

              // Pie chart
              _totalExpenses > 0
                  ? SizedBox(
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sections: _sections,
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    )
                  : const Center(
                      child: Text('No expenses in this period'),
                    ),
              const SizedBox(height: 24),

              // Legend
              _buildLegend(),
            ],
          ),
        ),
      ),
    );
  }
}
