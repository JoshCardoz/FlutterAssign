// lib/models/order_plan.dart
import 'package:food_ordering_app/models/food_item.dart';

class OrderPlan {
  final int? id;
  final String date;
  final double targetCost;
  final List<FoodItem> items;

  OrderPlan({
    this.id,
    required this.date,
    required this.targetCost,
    required this.items,
  });

  double get totalCost => items.fold(0, (sum, item) => sum + item.price);
}