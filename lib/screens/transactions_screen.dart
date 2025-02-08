import 'package:flutter/material.dart';
import 'package:money_manager/widgets/transaction_listview.dart';

import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  late List<DateTime> months;
  int currentIndex = 5; // Default to current month (middle of list)

  @override
  void initState() {
    super.initState();

    // Generate 5 previous months, current month, and 5 next months
    final now = DateTime.now();
    months = List.generate(
      11,
      (index) => DateTime(now.year, now.month - 5 + index, 1),
    );

    _tabController = TabController(
        length: months.length, vsync: this, initialIndex: currentIndex);
    _pageController = PageController(initialPage: currentIndex);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() => currentIndex = _tabController.index);
        _pageController.jumpToPage(currentIndex);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Column(
        children: [
          // Tab Bar for Months
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.amber,
            tabs: months
                .map((month) => Tab(text: DateFormat('MMM yyyy').format(month)))
                .toList(),
          ),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: months.length,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
                _tabController.animateTo(index);
              },
              itemBuilder: (context, index) {
                // get transactions by month
                final monthTransactions =
                    transactionProvider.getTransactionsByMonth(months[index]);

                // Group transactions by date
                final groupedTransactions = transactionProvider
                    .getTransactionsGroupedByDate(monthTransactions);

                return TransactionListView(
                    groupedTransactions: groupedTransactions);
              },
            ),
          ),
        ],
      ),
    );
  }
}
