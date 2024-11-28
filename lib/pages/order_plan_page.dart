// lib/pages/order_plan_page.dart
import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/food_item.dart';

class OrderPlanPage extends StatefulWidget {
  const OrderPlanPage({super.key});

  @override
  State<OrderPlanPage> createState() => _OrderPlanPageState();
}

class _OrderPlanPageState extends State<OrderPlanPage> {
  final _dataService = DataService();
  final TextEditingController _targetCostController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final List<FoodItem> _selectedFoodItems = [];
  double _totalCost = 0.0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showFoodItemsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Food Items'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _dataService.foodItems.length,
            itemBuilder: (context, index) {
              final item = _dataService.foodItems[index];
              final bool isSelected = _selectedFoodItems.contains(item);
              
              return ListTile(
                title: Text(item.name),
                subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                trailing: isSelected 
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
                onTap: () {
                  if (!isSelected) {
                    setState(() {
                      _selectedFoodItems.add(item);
                      _calculateTotal();
                    });
                    Navigator.pop(context);
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _calculateTotal() {
    setState(() {
      _totalCost = _selectedFoodItems.fold(
        0, (sum, item) => sum + item.price
      );
    });
  }

  void _saveOrder() {
    if (_selectedFoodItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one food item'),
        ),
      );
      return;
    }

    double targetCost = double.tryParse(_targetCostController.text) ?? 0.0;
    if (targetCost <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid target cost'),
        ),
      );
      return;
    }

    // Save the order to in-memory storage
    _dataService.addOrder({
      'date': _selectedDate.toIso8601String(),
      'target_cost': targetCost,
      'total_cost': _totalCost,
      'items': _selectedFoodItems.toList(),
    });

    // Clear the form
    setState(() {
      _selectedFoodItems.clear();
      _targetCostController.clear();
      _selectedDate = DateTime.now();
      _totalCost = 0.0;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Selection
            ListTile(
              title: Text(
                'Date: ${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}'
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            
            // Target Cost Input
            TextField(
              controller: _targetCostController,
              decoration: const InputDecoration(
                labelText: 'Target Cost Per Day',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 20),
            
            // Selected Foods List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Selected Foods:', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                ),
                TextButton.icon(
                  onPressed: _showFoodItemsDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Food'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedFoodItems.length,
                itemBuilder: (context, index) {
                  final item = _selectedFoodItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          _selectedFoodItems.removeAt(index);
                          _calculateTotal();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            
            // Summary Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Cost: \$${_totalCost.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (_targetCostController.text.isNotEmpty)
                    Text(
                      'Target Cost: \$${_targetCostController.text}',
                      style: TextStyle(
                        color: _totalCost > double.parse(_targetCostController.text)
                          ? Colors.red
                          : Colors.green,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveOrder,
        label: const Text('Save Order'),
        icon: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    _targetCostController.dispose();
    super.dispose();
  }
}