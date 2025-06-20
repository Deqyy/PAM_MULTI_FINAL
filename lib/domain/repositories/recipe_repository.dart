import 'dart:async';

import 'package:app_resep_makanan/domain/entities/recipe_model.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class RecipeRepository {
  List<Recipe>? _recipes;
  List<Recipe>? _favoriteRecipes;
  String? currentUserDisplayName;
  final _dbRef = FirebaseDatabase.instance.ref();

  static const String RECIPE_PATH = 'recipe';
  static const String FAV_RECIPE_PATH = 'users';

  List<Recipe> get recipes;
  List<Recipe> get favoriteRecipes;

  Stream<List<Recipe>> getRecipesStream();

  Stream<List<Recipe>> getFavoriteRecipesStream();

  // Future<void> addFavoriteRecipe({
  //   required String? currentUser,
  //   required String namaMakanan,
  //   required String deskripsiMasakan,
  //   required String waktuMasak,
  //   required String kalori,
  //   required List<String> bahan,
  //   required List<String> instruksi,
  //   required String urlGambar
  // });

  Recipe getRecipeFromRTDB(Map<String,dynamic> data);
}