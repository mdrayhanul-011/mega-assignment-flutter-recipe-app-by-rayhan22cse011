import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as foundation;
import '../models/recipe_model.dart';
import '../state/app_state.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Loads recipes from Firestore and updates AppState
  /// Silently falls back to mock data on error or empty collection.
  Future<void> loadRecipes(AppState appState) async {
    try {
      appState.setLoading(true);
      final snapshot = await _db.collection('recipes').get();
      if (snapshot.docs.isEmpty) {
        // No data in Firestore — keep mock data
        return;
      }
      final recipes =
          snapshot.docs.map((doc) => RecipeModel.fromFirestore(doc)).toList();
      appState.setFirestoreRecipes(recipes);
    } catch (e) {
      // Firestore unavailable — keep mock data as fallback
      foundation.debugPrint('[FirestoreService] Firestore load skipped (using mock data): $e');
    } finally {
      appState.setLoading(false);
    }
  }
}
