import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';
import '../models/recipe_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Real-time Category Stream
  Stream<List<CategoryModel>> getCategories() {
    return _firestore
        .collection('categories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CategoryModel.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  /// Real-time Recipe Stream
  Stream<List<RecipeModel>> getRecipes() {
    return _firestore
        .collection('recipes')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RecipeModel.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }
}