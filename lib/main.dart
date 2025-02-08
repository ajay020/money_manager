import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/providers/category_provider.dart';
import 'package:money_manager/providers/transaction_provider.dart';
import 'package:money_manager/screens/add_expense_screen.dart';
import 'package:money_manager/screens/home_screen.dart';
import 'package:money_manager/screens/transactions_screen.dart';
import 'package:money_manager/services/category_service.dart';
import 'package:money_manager/services/transaction_service.dart';
import 'package:provider/provider.dart';

import 'screens/graph_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final categoryService = CategoryService();
  await categoryService.init();
  final transactionService = TransactionService();
  await transactionService.init();

  runApp(MoneyManagerApp(
    transactionService,
    categoryService,
  ));
}

class MoneyManagerApp extends StatelessWidget {
  final TransactionService _transactionService;
  final CategoryService _categoryService;

  const MoneyManagerApp(this._transactionService, this._categoryService,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => TransactionProvider(_transactionService)),
        ChangeNotifierProvider(
            create: (context) => CategoryProvider(_categoryService)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Monay Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BottomNavBar(
          _transactionService,
          _categoryService,
        ),
        routes: {"/add-transaction": (context) => AddExpenseScreen()},
      ),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  final TransactionService _transactionService;
  final CategoryService _categoryService;

  const BottomNavBar(this._transactionService, this._categoryService,
      {super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  // List of screens
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onNavigateToTransactions: _navigateToTransactions),
      TransactionsScreen(),
      ExpenseGraphScreen(
        transactionService: widget._transactionService,
        categoryService: widget._categoryService,
      ),
    ];
  }

   void _navigateToTransactions() {
    setState(() {
      _currentIndex = 1; // Transactions index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/add-transaction');
          }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.lightBlue,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Graph',
          ),
        ],
      ),
    );
  }
}
