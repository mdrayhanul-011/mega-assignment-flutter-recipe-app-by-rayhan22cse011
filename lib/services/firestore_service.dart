import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as foundation;
import '../models/recipe_model.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  /// Returns a real-time stream of recipes from Firestore.
  /// Individual invalid documents are logged and skipped without crashing the stream.
  Stream<List<RecipeModel>> getRecipesStream() {
    return _db.collection('recipes').snapshots().map((snapshot) {
      final List<RecipeModel> recipes = [];
      for (final doc in snapshot.docs) {
        try {
          recipes.add(RecipeModel.fromFirestore(doc));
        } catch (e, stack) {
          foundation.debugPrint(
            '[FirestoreService] Skipping invalid document ${doc.id}: $e\n$stack',
          );
        }
      }
      return recipes;
    });
  }
}
