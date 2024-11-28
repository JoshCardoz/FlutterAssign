// lib/pages/view_orders_page.dart
import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/food_item.dart';

class ViewOrdersPage extends StatefulWidget {
  const ViewOrdersPage({super.key});

  @override
  State<ViewOrdersPage> createState() => _ViewOrdersPageState();
}

class _ViewOrdersPageState extends State<ViewOrdersPage> {
  final _dataService = DataService();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _filteredOrders = _dataService.orders;
  }

  void _searchOrders(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        _filteredOrders = _dataService.orders;
      } else {
        _filteredOrders = _dataService.orders
            .where((order) => order['date'].toString().contains(searchTerm))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search/Filter by date
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by Date (YYYY-MM-DD)',
                prefixIcon: Icon(Icons.search),
                hintText: 'Example: 2024-11',
              ),
              onChanged: _searchOrders,
            ),
            
            const SizedBox(height: 20),
            
            // Orders List
            Expanded(
              child: _filteredOrders.isEmpty
                ? const Center(
                    child: Text('No orders found'),
                  )
                : ListView.builder(
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];
                      final orderDate = DateTime.parse(order['date']).toLocal();
                      final formattedDate = '${orderDate.year}-${orderDate.month.toString().padLeft(2, '0')}-${orderDate.day.toString().padLeft(2, '0')}';
                      final items = order['items'] as List<FoodItem>;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ExpansionTile(
                          title: Text('Order Date: $formattedDate'),
                          subtitle: Text(
                            'Target Cost: \$${order['target_cost'].toStringAsFixed(2)} | '
                            'Total: \$${order['total_cost'].toStringAsFixed(2)}'
                          ),
                          trailing: Icon(
                            order['total_cost'] <= order['target_cost'] 
                              ? Icons.check_circle 
                              : Icons.warning,
                            color: order['total_cost'] <= order['target_cost']
                              ? Colors.green
                              : Colors.orange,
                          ),
                          children: [
                            // Show food items in the order
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (context, itemIndex) {
                                final item = items[itemIndex];
                                return ListTile(
                                  title: Text(item.name),
                                  trailing: Text(
                                    '\$${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Summary section
                            Container(
                              padding: const EdgeInsets.all(16),
                              color: Colors.grey.shade100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Items: ${items.length}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Status: ${order['total_cost'] <= order['target_cost'] ? 'Within Budget' : 'Over Budget'}',
                                    style: TextStyle(
                                      color: order['total_cost'] <= order['target_cost']
                                        ? Colors.green
                                        : Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}