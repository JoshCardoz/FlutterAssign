// lib/services/data_service.dart
import '../models/food_item.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  
  DataService._internal() {
    // Pre-populate with 20 food items
    foodItems.addAll([
      FoodItem(name: 'Pizza', price: 12.99),
      FoodItem(name: 'Hamburger', price: 8.99),
      FoodItem(name: 'Caesar Salad', price: 7.99),
      FoodItem(name: 'Spaghetti Carbonara', price: 11.99),
      FoodItem(name: 'Chicken Wings', price: 9.99),
      FoodItem(name: 'Fish and Chips', price: 13.99),
      FoodItem(name: 'Steak Sandwich', price: 14.99),
      FoodItem(name: 'Veggie Wrap', price: 7.49),
      FoodItem(name: 'Grilled Chicken', price: 12.49),
      FoodItem(name: 'Sushi Roll', price: 15.99),
      FoodItem(name: 'Beef Tacos', price: 8.99),
      FoodItem(name: 'Greek Salad', price: 8.49),
      FoodItem(name: 'Pad Thai', price: 11.99),
      FoodItem(name: 'Chicken Curry', price: 13.49),
      FoodItem(name: 'Club Sandwich', price: 9.99),
      FoodItem(name: 'Beef Burrito', price: 10.99),
      FoodItem(name: 'Mushroom Soup', price: 5.99),
      FoodItem(name: 'Salmon Fillet', price: 16.99),
      FoodItem(name: 'Chicken Quesadilla', price: 9.49),
      FoodItem(name: 'Vegetable Stir Fry', price: 10.49),
    ]);
  }

  final List<FoodItem> foodItems = [];
  final List<Map<String, dynamic>> orders = [];

  void addFoodItem(FoodItem item) {
    foodItems.add(item);
  }

  void updateFoodItem(int index, FoodItem item) {
    foodItems[index] = item;
  }

  void deleteFoodItem(int index) {
    foodItems.removeAt(index);
  }

  void addOrder(Map<String, dynamic> order) {
    orders.add(order);
  }
}