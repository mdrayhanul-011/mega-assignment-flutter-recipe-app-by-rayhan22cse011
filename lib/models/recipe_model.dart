import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  final String name;
  final double quantity;
  final String unit;

  const Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toDouble() ?? 1.0,
      unit: map['unit'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'quantity': quantity,
        'unit': unit,
      };

  Ingredient copyWith({double? quantity}) {
    return Ingredient(
      name: name,
      quantity: quantity ?? this.quantity,
      unit: unit,
    );
  }
}

class RecipeModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final int calories;
  final int cookingTimeMinutes;
  final double rating;
  final List<Ingredient> ingredients;
  bool isFavorite;

  RecipeModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.calories,
    required this.cookingTimeMinutes,
    this.rating = 4.5,
    this.ingredients = const [],
    this.isFavorite = false,
  });

  /// Creates a RecipeModel from a Firestore document snapshot.
  factory RecipeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final ingredientsRaw = data['ingredients'] as List<dynamic>? ?? [];
    return RecipeModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      category: data['category'] as String? ?? '',
      imageUrl: data['image'] as String? ?? data['imageUrl'] as String? ?? '',
      calories: (data['calories'] as num?)?.toInt() ?? 0,
      cookingTimeMinutes: (data['cookingTime'] as num?)?.toInt() ??
          (data['cookingTimeMinutes'] as num?)?.toInt() ??
          0,
      rating: (data['rating'] as num?)?.toDouble() ?? 4.5,
      ingredients: ingredientsRaw
          .map((e) => Ingredient.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Creates a RecipeModel from the existing MockRecipe format.
  factory RecipeModel.fromMock(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      imageUrl: map['imageUrl'] as String,
      calories: map['calories'] as int,
      cookingTimeMinutes: map['cookingTimeMinutes'] as int,
      rating: 4.5,
      ingredients: _defaultIngredients(),
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }

  RecipeModel copyWith({bool? isFavorite}) {
    return RecipeModel(
      id: id,
      name: name,
      category: category,
      imageUrl: imageUrl,
      calories: calories,
      cookingTimeMinutes: cookingTimeMinutes,
      rating: rating,
      ingredients: ingredients,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  static List<Ingredient> _defaultIngredients() {
    return [
      const Ingredient(name: 'Main ingredient', quantity: 200, unit: 'g'),
      const Ingredient(name: 'Salt', quantity: 1, unit: 'tsp'),
      const Ingredient(name: 'Olive oil', quantity: 2, unit: 'tbsp'),
      const Ingredient(name: 'Black pepper', quantity: 0.5, unit: 'tsp'),
    ];
  }
}
