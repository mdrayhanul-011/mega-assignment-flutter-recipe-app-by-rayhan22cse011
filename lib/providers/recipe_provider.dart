import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../models/recipe_model.dart';
import '../services/firebase_service.dart';

class RecipeProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<RecipeModel> _recipes = [];
  List<CategoryModel> _categories = [];

  bool _isLoading = true;
  String? _errorMessage;

  String _selectedCategory = "All";
  String _searchQuery = "";

  List<RecipeModel> get recipes => _filteredRecipes;
  List<CategoryModel> get categories => _categories;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get selectedCategory => _selectedCategory;

  RecipeProvider() {
    loadCategories();
    loadRecipes();
  }

  void loadCategories() {
    _firebaseService.getCategories().listen((data) {
      _categories = data;
      notifyListeners();
    });
  }

  void loadRecipes() {
    _firebaseService.getRecipes().listen(
      (data) {
        _recipes = data;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void searchRecipe(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  List<RecipeModel> get _filteredRecipes {
    return _recipes.where((recipe) {
      final matchesCategory =
          _selectedCategory == "All" ||
          recipe.category == _selectedCategory;

      final matchesSearch =
          recipe.name.toLowerCase().contains(_searchQuery);

      return matchesCategory && matchesSearch;
    }).toList();
  }
}