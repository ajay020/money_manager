import 'package:flutter/material.dart';
import 'package:money_manager/models/category_model.dart';
import 'package:money_manager/models/transaction_model.dart';
import 'package:money_manager/models/transaction_type.dart';
import 'package:money_manager/providers/transaction_provider.dart';
import 'package:money_manager/utils/bottom_sheet.dart';
import 'package:money_manager/utils/common_utils.dart';
import 'package:money_manager/widgets/category_selectory.dart';
import 'package:provider/provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Category? _selectedCategory;

  void _showSnackBarMessage(String message) {
    showSnackbar(context, message);
  }

  void _submitData() {
    if (_titleController.text.isEmpty) {
      _showSnackBarMessage('Please enter a title');
      return;
    }

    if (_amountController.text.isEmpty) {
      _showSnackBarMessage('Please enter an amount');
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showSnackBarMessage('Please enter a valid amount');
      return;
    }

    if (_selectedCategory == null) {
      _showSnackBarMessage('Please select a category');
      return;
    }

    final newTransaction = Transaction(
      title: _titleController.text,
      amount: amount,
      date: _selectedDate,
      type: TransactionType.expense,
      category: Category(
        name: _selectedCategory!.name,
        iconCode: _selectedCategory!.iconCode,
      ),
    );

    // Provider.of<ExpenseProvider>(context, listen: false).addExpense(newExpense);
    Provider.of<TransactionProvider>(context, listen: false)
        .addTransaction(newTransaction);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction Added Successfully!')),
    );

    // Reset all fields
    _resetFields();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _openCategoryBottomSheet() {
    showCategoryBottomSheet(
      context: context,
      onCategorySelected: (selectedCategory) {
        setState(() {
          _selectedCategory = selectedCategory;
        });
      },
    );
  }

  void _resetFields() {
    setState(() {
      _titleController.clear();
      _amountController.clear();
      _selectedDate = DateTime.now();
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CategorySelectory(
                selectedCategory: _selectedCategory,
                onCategoryTap: _openCategoryBottomSheet,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Picked Date: ${_selectedDate.toLocal().toIso8601String().split('T')[0]}',
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
