// lib/models/food_item.dart
class FoodItem {
  final int? id;
  final String name;
  final double price;

  FoodItem({
    this.id,
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      price: map['price'],
    );
  }
}
