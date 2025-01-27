import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/providers/expense_provider.dart';
import 'package:money_manager/screens/add_expense_screen.dart';
import 'package:money_manager/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'models/expense.dart';
import 'services/expense_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter()); // Register the adapter

  final expenseService = ExpenseService();
  await expenseService.initializeHive(); // Initialize Hive box

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Monay Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/add-expense': (context) => AddExpenseScreen(),
        },
      ),
    );
  }
}
