import 'ingredient_model.dart';

class RecipeModel {
  final String id;
  final String name;
  final String category;
  final String image;
  final int calories;
  final int cookingTime;
  final double rating;
  final int reviewCount;
  final List<IngredientModel> ingredients;

  RecipeModel({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.calories,
    required this.cookingTime,
    required this.rating,
    required this.reviewCount,
    required this.ingredients,
  });

  factory RecipeModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return RecipeModel(
      id: documentId,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      image: map['image'] ?? '',
      calories: map['calories'] ?? 0,
      cookingTime: map['cookingTime'] ?? 0,
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      ingredients: (map['ingredients'] as List<dynamic>? ?? [])
          .map(
            (item) => IngredientModel.fromMap(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'image': image,
      'calories': calories,
      'cookingTime': cookingTime,
      'rating': rating,
      'reviewCount': reviewCount,
      'ingredients': ingredients
          .map((ingredient) => ingredient.toMap())
          .toList(),
    };
  }
}