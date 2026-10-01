import 'dart:convert';
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
      name: _parseString(_findValue(map, ['name', 'ingredient', 'item', 'Name'])),
      quantity: _parseDouble(_findValue(map, ['quantity', 'qty', 'amount', 'count', 'Quantity']), 1.0),
      unit: _parseString(_findValue(map, ['unit', 'measure', 'measurement', 'Unit'])),
    );
  }

  factory Ingredient.fromAny(dynamic item) {
    if (item is Map) {
      final stringMap = item.map((key, value) => MapEntry(key.toString(), value));
      return Ingredient.fromMap(stringMap);
    } else if (item is String && item.trim().isNotEmpty) {
      final parts = item.split('-');
      if (parts.length >= 2) {
        final name = parts[0].trim();
        final rest = parts.sublist(1).join('-').trim();
        final restParts = rest.split(RegExp(r'\s+'));
        final qty = _parseDouble(restParts.isNotEmpty ? restParts[0] : 1, 1.0);
        final unit = restParts.length > 1 ? restParts.sublist(1).join(' ') : '';
        return Ingredient(name: name, quantity: qty, unit: unit);
      }
      return Ingredient(
        name: item.trim(),
        quantity: 1.0,
        unit: '',
      );
    }
    return const Ingredient(name: '', quantity: 0, unit: '');
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'quantity': quantity,
        'unit': unit,
      };

  Ingredient copyWith({String? name, double? quantity, String? unit}) {
    return Ingredient(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  static dynamic _findValue(Map<String, dynamic> data, List<String> candidateKeys) {
    for (final key in candidateKeys) {
      if (data.containsKey(key) && data[key] != null) {
        return data[key];
      }
    }
    final normalized = <String, dynamic>{};
    for (final entry in data.entries) {
      normalized[entry.key.trim().toLowerCase()] = entry.value;
    }
    for (final key in candidateKeys) {
      final lowerKey = key.trim().toLowerCase();
      if (normalized.containsKey(lowerKey) && normalized[lowerKey] != null) {
        return normalized[lowerKey];
      }
    }
    return null;
  }

  static String _parseString(dynamic value, [String defaultValue = '']) {
    if (value is String) return value;
    if (value != null) return value.toString();
    return defaultValue;
  }

  static double _parseDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    if (value is String) {
      final match = RegExp(r'^-?\d+(\.\d+)?').stringMatch(value.trim());
      if (match != null) {
        return double.tryParse(match) ?? defaultValue;
      }
      return double.tryParse(value) ?? defaultValue;
    }
    try {
      final dynamic n = (value as dynamic).toDouble();
      if (n is num) return n.toDouble();
    } catch (_) {}
    try {
      return double.tryParse(value.toString().trim()) ?? defaultValue;
    } catch (_) {}
    return defaultValue;
  }
}

class RecipeModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final int calories;
  final int cookingTime;
  final double rating;
  final int cost;
  final List<Ingredient> ingredients;
  bool isFavorite;

  /// Compatibility getter for screens referencing cookingTimeMinutes
  int get cookingTimeMinutes => cookingTime;

  RecipeModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.calories,
    int? cookingTime,
    int? cookingTimeMinutes,
    this.rating = 4.5,
    this.cost = 0,
    this.ingredients = const [],
    this.isFavorite = false,
  }) : cookingTime = cookingTime ?? cookingTimeMinutes ?? 0;

  factory RecipeModel.fromFirestore(DocumentSnapshot doc) {
    final rawData = doc.data();
    final data = rawData is Map<String, dynamic>
        ? rawData
        : (rawData is Map
            ? rawData.map((k, v) => MapEntry(k.toString(), v))
            : <String, dynamic>{});

    dynamic rawIngredients =
        _findValue(data, ['ingredients', 'ingredientList', 'Ingredients']) ??
            data['ingredients'];
    if (rawIngredients is String && rawIngredients.trim().startsWith('[')) {
      try {
        rawIngredients = jsonDecode(rawIngredients);
      } catch (_) {}
    }
    final List<dynamic> ingredientsList;
    if (rawIngredients is List) {
      ingredientsList = rawIngredients;
    } else if (rawIngredients is Map) {
      ingredientsList = rawIngredients.values.toList();
    } else {
      ingredientsList = [];
    }

    final List<Ingredient> parsedIngredients = [];
    for (final item in ingredientsList) {
      try {
        final ing = Ingredient.fromAny(item);
        if (ing.name.isNotEmpty) {
          parsedIngredients.add(ing);
        }
      } catch (_) {
        // Ignore individual malformed ingredient rather than crashing document
      }
    }

    final rawCalories = _findValue(data, [
      'calories',
      'calorie',
      'cal',
      'Calories',
      'Calorie',
      'kcal',
      'energy',
    ]) ?? (data['nutrition'] is Map ? _findValue(Map<String, dynamic>.from(data['nutrition'] as Map), ['calories', 'calorie', 'cal', 'Calories']) : null);

    final rawCookingTime = _findValue(data, [
      'cookingTime',
      'cookingTimeMinutes',
      'cooking_time',
      'cookTime',
      'cook_time',
      'time',
      'duration',
      'CookingTime',
    ]);

    final rawImageUrl = _findValue(data, [
      'imageUrl',
      'image',
      'image_url',
      'photoUrl',
      'photo',
      'img',
      'ImageUrl',
      'Image',
    ]);

    final rawName = _findValue(data, [
      'name',
      'title',
      'recipeName',
      'recipe_name',
      'Name',
      'Title',
    ]);

    final rawCategory = _findValue(data, [
      'category',
      'categoryName',
      'type',
      'Category',
    ]);

    final rawRating = _findValue(data, [
      'rating',
      'rate',
      'stars',
      'Rating',
    ]);

    final rawCost = _findValue(data, [
      'cost',
      'Cost',
      'price',
      'Price',
      'totalCost',
      'total_cost',
    ]);

    return RecipeModel(
      id: doc.id,
      name: _parseString(rawName),
      category: _parseString(rawCategory, 'General'),
      imageUrl: _parseString(rawImageUrl),
      calories: _parseInt(rawCalories),
      cookingTime: _parseInt(rawCookingTime),
      rating: _parseDouble(rawRating, 4.5),
      cost: _parseInt(rawCost),
      ingredients: parsedIngredients,
      isFavorite: false,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'category': category,
        'imageUrl': imageUrl,
        'calories': calories,
        'cookingTime': cookingTime,
        'rating': rating,
        'cost': cost,
        'ingredients': ingredients.map((e) => e.toMap()).toList(),
      };

  RecipeModel copyWith({
    String? id,
    String? name,
    String? category,
    String? imageUrl,
    int? calories,
    int? cookingTime,
    double? rating,
    int? cost,
    List<Ingredient>? ingredients,
    bool? isFavorite,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      calories: calories ?? this.calories,
      cookingTime: cookingTime ?? this.cookingTime,
      rating: rating ?? this.rating,
      cost: cost ?? this.cost,
      ingredients: ingredients ?? this.ingredients,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  static dynamic _findValue(Map<String, dynamic> data, List<String> candidateKeys) {
    for (final key in candidateKeys) {
      if (data.containsKey(key) && data[key] != null) {
        return data[key];
      }
    }
    final normalized = <String, dynamic>{};
    for (final entry in data.entries) {
      normalized[entry.key.trim().toLowerCase()] = entry.value;
    }
    for (final key in candidateKeys) {
      final lowerKey = key.trim().toLowerCase();
      if (normalized.containsKey(lowerKey) && normalized[lowerKey] != null) {
        return normalized[lowerKey];
      }
    }
    return null;
  }

  static String _parseString(dynamic value, [String defaultValue = '']) {
    if (value is String) return value;
    if (value != null) return value.toString();
    return defaultValue;
  }

  static int _parseInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is num) return value.toInt();
    if (value is String) {
      final digits = RegExp(r'^-?\d+').stringMatch(value.trim());
      if (digits != null) {
        return int.tryParse(digits) ?? defaultValue;
      }
      return int.tryParse(value) ??
          (double.tryParse(value)?.toInt() ?? defaultValue);
    }
    // Handle Int64 (from fixnum or web), BigInt, or any custom numeric object with toInt()
    try {
      final dynamic n = (value as dynamic).toInt();
      if (n is num) return n.toInt();
    } catch (_) {}
    // Fallback to string representation parsing
    try {
      final str = value.toString().trim();
      final digits = RegExp(r'^-?\d+').stringMatch(str);
      if (digits != null) {
        return int.tryParse(digits) ?? defaultValue;
      }
    } catch (_) {}
    return defaultValue;
  }

  static double _parseDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    if (value is String) {
      final match = RegExp(r'^-?\d+(\.\d+)?').stringMatch(value.trim());
      if (match != null) {
        return double.tryParse(match) ?? defaultValue;
      }
      return double.tryParse(value) ?? defaultValue;
    }
    try {
      final dynamic n = (value as dynamic).toDouble();
      if (n is num) return n.toDouble();
    } catch (_) {}
    try {
      return double.tryParse(value.toString().trim()) ?? defaultValue;
    } catch (_) {}
    return defaultValue;
  }
}
