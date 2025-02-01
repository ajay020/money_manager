import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/providers/category_provider.dart';
import 'package:money_manager/providers/expense_provider.dart';
import 'package:money_manager/screens/add_expense_screen.dart';
import 'package:money_manager/screens/home_screen.dart';
import 'package:money_manager/services/category_service.dart';
import 'package:provider/provider.dart';

import 'screens/graph_screen.dart';
import 'services/expense_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final expenseService = ExpenseService();
  await expenseService.init();
  final categoryService = CategoryService();
  await categoryService.init();

  runApp(MoneyManagerApp(
    expenseService,
    categoryService,
  ));
}

class MoneyManagerApp extends StatelessWidget {
  final ExpenseService _expenseService;
  final CategoryService _categoryService;

  const MoneyManagerApp(this._expenseService, this._categoryService,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ExpenseProvider(_expenseService)),
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
          _expenseService,
          _categoryService,
        ),
      ),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  final ExpenseService _expenseService;
  final CategoryService _categoryService;

  const BottomNavBar(this._expenseService, this._categoryService, {super.key});

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
      HomeScreen(), // Screen to display expenses
      AddExpenseScreen(), // Screen to add an expense
      ExpenseGraphScreen(
        expenseService: widget._expenseService,
        categoryService: widget._categoryService,
      ), // Screen to display expenses in graphical form
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.lightBlue,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected index
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Expense',
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
