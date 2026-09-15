import 'package:flutter/foundation.dart';
import '../models/mock_recipe.dart';
import '../models/recipe_model.dart';

/// Meal plan structure: date string → meal type → recipe (nullable)
typedef DayPlan = Map<String, RecipeModel?>;

class AppState extends ChangeNotifier {
  // ─── Recipes ───────────────────────────────────────────────
  List<RecipeModel> _recipes = [];
  bool _isLoading = false;

  List<RecipeModel> get recipes => _recipes;
  bool get isLoading => _isLoading;

  /// Initialise with mock data immediately, then swap to Firestore when available.
  AppState() {
    _loadMockData();
  }

  void _loadMockData() {
    _recipes = MockRecipe.getSampleRecipes().map((m) {
      return RecipeModel(
        id: m.id,
        name: m.name,
        category: m.category,
        imageUrl: m.imageUrl,
        calories: m.calories,
        cookingTimeMinutes: m.cookingTimeMinutes,
        rating: 4.5,
        ingredients: _defaultIngredients(m.name),
        isFavorite: _favoriteIds.contains(m.id),
      );
    }).toList();
  }

  void setFirestoreRecipes(List<RecipeModel> firestoreRecipes) {
    // Preserve local isFavorite flags
    _recipes = firestoreRecipes.map((r) {
      return r.copyWith(isFavorite: _favoriteIds.contains(r.id));
    }).toList();
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // ─── Favorites ─────────────────────────────────────────────
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  List<RecipeModel> get favoriteRecipes =>
      _recipes.where((r) => _favoriteIds.contains(r.id)).toList();

  void toggleFavorite(String recipeId) {
    if (_favoriteIds.contains(recipeId)) {
      _favoriteIds.remove(recipeId);
    } else {
      _favoriteIds.add(recipeId);
    }
    // Sync isFavorite on recipe objects
    for (int i = 0; i < _recipes.length; i++) {
      if (_recipes[i].id == recipeId) {
        _recipes[i] = _recipes[i].copyWith(
          isFavorite: _favoriteIds.contains(recipeId),
        );
        break;
      }
    }
    notifyListeners();
  }

  bool isFavorite(String recipeId) => _favoriteIds.contains(recipeId);

  // ─── Meal Plan ─────────────────────────────────────────────
  /// Map from date string (yyyy-MM-dd) to meal-type map.
  final Map<String, DayPlan> _mealPlan = {};

  static const List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner'];

  DayPlan getDayPlan(String dateKey) {
    _mealPlan.putIfAbsent(dateKey, () => {
          'Breakfast': null,
          'Lunch': null,
          'Dinner': null,
        });
    return _mealPlan[dateKey]!;
  }

  void addToMealPlan(String dateKey, String mealType, RecipeModel recipe) {
    getDayPlan(dateKey)[mealType] = recipe;
    notifyListeners();
  }

  void removeFromMealPlan(String dateKey, String mealType) {
    getDayPlan(dateKey)[mealType] = null;
    notifyListeners();
  }

  // ─── Helpers ───────────────────────────────────────────────
  static List<RecipeModel> filterRecipes({
    required List<RecipeModel> recipes,
    required String query,
    required String category,
  }) {
    return recipes.where((r) {
      final matchesCategory =
          category == 'All' || r.category.toLowerCase() == category.toLowerCase();
      final matchesQuery =
          query.isEmpty || r.name.toLowerCase().contains(query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  static List<Ingredient> _defaultIngredients(String recipeName) {
    // Provide realistic defaults based on recipe name
    return [
      const Ingredient(name: 'Main ingredient', quantity: 200, unit: 'g'),
      const Ingredient(name: 'Olive oil', quantity: 2, unit: 'tbsp'),
      const Ingredient(name: 'Salt', quantity: 1, unit: 'tsp'),
      const Ingredient(name: 'Black pepper', quantity: 0.5, unit: 'tsp'),
      const Ingredient(name: 'Garlic', quantity: 3, unit: 'cloves'),
    ];
  }
}
