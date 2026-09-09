class IngredientModel {
  final String name;
  final double quantity;
  final String unit;
  final double cost;

  IngredientModel({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.cost,
  });

  factory IngredientModel.fromMap(Map<String, dynamic> map) {
    return IngredientModel(
      name: map['name'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? '',
      cost: (map['cost'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'cost': cost,
    };
  }

  /// Calculate quantity based on servings
  double getQuantity(int servings) {
    return quantity * servings;
  }

  /// Calculate cost based on servings
  double getCost(int servings) {
    return cost * servings;
  }
}