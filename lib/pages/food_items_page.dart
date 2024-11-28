// lib/pages/food_items_page.dart
import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/food_item.dart';

class FoodItemsPage extends StatefulWidget {
  const FoodItemsPage({super.key});

  @override
  State<FoodItemsPage> createState() => _FoodItemsPageState();
}

class _FoodItemsPageState extends State<FoodItemsPage> {
  final _dataService = DataService();
  String _newItemName = '';
  double _newItemPrice = 0.0;

  Future<void> _addFoodItem() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Food Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                _newItemName = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _newItemPrice = double.tryParse(value) ?? 0.0;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_newItemName.isNotEmpty && _newItemPrice > 0) {
                setState(() {
                  _dataService.addFoodItem(FoodItem(
                    name: _newItemName,
                    price: _newItemPrice,
                  ));
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter valid name and price'),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editFoodItem(int index, FoodItem item) {
    _newItemName = item.name;
    _newItemPrice = item.price;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Food Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              controller: TextEditingController(text: _newItemName),
              onChanged: (value) {
                _newItemName = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Price'),
              controller: TextEditingController(text: _newItemPrice.toString()),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _newItemPrice = double.tryParse(value) ?? _newItemPrice;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_newItemName.isNotEmpty && _newItemPrice > 0) {
                setState(() {
                  _dataService.updateFoodItem(
                    index,
                    FoodItem(
                      name: _newItemName,
                      price: _newItemPrice,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteFoodItem(int index, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Food Item'),
        content: Text('Are you sure you want to delete $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _dataService.deleteFoodItem(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _dataService.foodItems.length,
        itemBuilder: (context, index) {
          final item = _dataService.foodItems[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editFoodItem(index, item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteFoodItem(index, item.name),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFoodItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}