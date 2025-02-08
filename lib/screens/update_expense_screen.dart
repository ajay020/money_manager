import 'package:flutter/material.dart';
import 'package:money_manager/models/transaction_type.dart';
import 'package:money_manager/providers/transaction_provider.dart';
import 'package:money_manager/utils/bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../widgets/category_selectory.dart';

class UpdateExpenseScreen extends StatefulWidget {
  final Transaction transaction;

  const UpdateExpenseScreen({
    super.key,
    required this.transaction,
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
    _titleController = TextEditingController(text: widget.transaction.title);
    _amountController =
        TextEditingController(text: widget.transaction.amount.toString());
    _selectedDate = widget.transaction.date;
    _selectedCategory = Category(
      name: widget.transaction.category.name,
      iconCode: widget.transaction.category.iconCode,
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

  void _updateTransaction(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final updatedTransaction = Transaction(
        id: widget.transaction.id,
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        date: _selectedDate,
        type: TransactionType.expense,
        category: Category(
          name: _selectedCategory.name,
          iconCode: _selectedCategory.iconCode,
        ),
      );

      // Call the provider's update method
      Provider.of<TransactionProvider>(context, listen: false)
          .updateTransaction(widget.transaction.id, updatedTransaction);

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
                onPressed: () => _updateTransaction(context),
                child: const Text('Update Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
