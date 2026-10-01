import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' as foundation;
import '../models/recipe_model.dart';
import '../services/firestore_service.dart';

/// Meal plan structure: date string → meal type → recipe (nullable)
typedef DayPlan = Map<String, RecipeModel?>;

class AppState extends foundation.ChangeNotifier {
  final FirestoreService _firestoreService;

  // ─── Recipes ───────────────────────────────────────────────
  List<RecipeModel> _recipes = [];
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription<List<RecipeModel>>? _recipesSubscription;

  List<RecipeModel> get recipes => _recipes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  AppState({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService() {
    initRecipesStream();
  }

  /// Connects to real-time Firestore stream and updates state dynamically.
  void initRecipesStream() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (Firebase.apps.isEmpty) {
      _isLoading = false;
      _errorMessage = 'Firebase is not initialized';
      notifyListeners();
      return;
    }

    _recipesSubscription?.cancel();
    try {
      _recipesSubscription = _firestoreService.getRecipesStream().listen(
        (firestoreRecipes) {
          _recipes = firestoreRecipes.map((r) {
            return r.copyWith(isFavorite: _favoriteIds.contains(r.id));
          }).toList();
          _isLoading = false;
          _errorMessage = null;
          notifyListeners();
        },
        onError: (error) {
          _isLoading = false;
          _errorMessage = 'Failed to connect to Firestore: $error';
          foundation.debugPrint('[AppState] Firestore stream error: $error');
          notifyListeners();
        },
      );
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Could not initialize Firestore: $e';
      foundation.debugPrint('[AppState] Stream init error: $e');
      notifyListeners();
    }
  }

  void retryLoading() {
    initRecipesStream();
  }

  void setFirestoreRecipes(List<RecipeModel> firestoreRecipes) {
    _recipes = firestoreRecipes.map((r) {
      return r.copyWith(isFavorite: _favoriteIds.contains(r.id));
    }).toList();
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // ─── Dynamic Categories ────────────────────────────────────
  /// Derives categories dynamically from loaded recipes. Always puts 'All' first.
  List<String> get categories {
    final Set<String> uniqueCategories = {};
    for (final recipe in _recipes) {
      final trimmed = recipe.category.trim();
      if (trimmed.isNotEmpty) {
        uniqueCategories.add(trimmed);
      }
    }
    final sorted = uniqueCategories.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return ['All', ...sorted];
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
      final matchesCategory = category == 'All' ||
          r.category.trim().toLowerCase() == category.trim().toLowerCase();
      final matchesQuery =
          query.isEmpty || r.name.toLowerCase().contains(query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  void dispose() {
    _recipesSubscription?.cancel();
    super.dispose();
  }
}
