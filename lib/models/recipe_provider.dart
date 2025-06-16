import 'dart:async';

import 'package:app_resep_makanan/models/recipe_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> _favoriteRecipes = [];
  String? currentUser = FirebaseAuth.instance.currentUser?.displayName; 
  final _dbRef = FirebaseDatabase.instance.ref();

  static const String RECIPE_PATH = 'recipe';
  static const String FAV_RECIPE_PATH = 'users';

  late final StreamSubscription<DatabaseEvent> _recipeStream;
  late final StreamSubscription<DatabaseEvent> _favRecipeStream;

  List<Recipe> get recipes => _recipes;
  List<Recipe> get favoriteRecipes => _favoriteRecipes;

  RecipeProvider() {
    _listenToRecipes();
    _listenToFavRecipes();
  }

  void _listenToRecipes() {
    _recipeStream = _dbRef.child(RECIPE_PATH).onValue.listen((event) {
        final Map<String, dynamic> recipes = Map<String, dynamic>.from(event.snapshot.value as Map);
        _recipes = recipes.values.map((asJson) => Recipe.fromRTDB(Map<String, dynamic>.from(asJson))).toList();
      notifyListeners();
    });
  }

  void _listenToFavRecipes() {
    _favRecipeStream = _dbRef.child(FAV_RECIPE_PATH).child(currentUser!).child('favorite').onValue.listen((event) {
        final Map<String, dynamic> recipes = Map<String, dynamic>.from(event.snapshot.value as Map);
        _favoriteRecipes = recipes.values.map((asJson) => Recipe.fromRTDB(Map<String, dynamic>.from(asJson))).toList();
      notifyListeners();
    }); 
  }

  @override
  void dispose() {
    _recipeStream.cancel();
    _favRecipeStream.cancel();
    super.dispose();
  }
}
