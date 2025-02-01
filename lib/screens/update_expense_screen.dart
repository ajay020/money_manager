import 'package:flutter/material.dart';
import 'package:money_manager/utils/bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../widgets/category_selectory.dart';

class UpdateExpenseScreen extends StatefulWidget {
  final Expense expense;

  const UpdateExpenseScreen({
    super.key,
    required this.expense,
  });

  @override
  State<UpdateExpenseScreen> createState() => _UpdateExpenseScreenState();
}

class _UpdateExpenseScreenState extends State<UpdateExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;
  late Category _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _amountController =
        TextEditingController(text: widget.expense.amount.toString());
    _selectedDate = widget.expense.date;
    _selectedCategory = Category(
      name: widget.expense.categoryName,
      iconCode: widget.expense.categoryIconCode,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _updateExpense(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final updatedExpense = Expense(
          title: _titleController.text.trim(),
          amount: double.parse(_amountController.text.trim()),
          date: _selectedDate,
          categoryName: _selectedCategory.name,
          categoryIconCode: _selectedCategory.iconCode);

      // Call the provider's update method
      Provider.of<ExpenseProvider>(context, listen: false)
          .updateExpense(widget.expense.id, updatedExpense);

      Navigator.pop(context); // Go back to the detail or home screen
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an amount.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CategorySelectory(
                selectedCategory: _selectedCategory,
                onCategoryTap: _openCategoryBottomSheet,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                  ),
                  TextButton(
                    onPressed: () => _pickDate(context),
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _updateExpense(context),
                child: const Text('Update Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
