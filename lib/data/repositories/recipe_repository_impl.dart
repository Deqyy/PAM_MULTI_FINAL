import 'dart:async';

import 'package:app_resep_makanan/domain/repositories/recipe_repository.dart';
import 'package:app_resep_makanan/domain/entities/recipe_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  static const String RECIPE_PATH = 'recipe';
  static const String FAV_RECIPE_PATH = 'users';

  List<Recipe> _recipes = [];
  List<Recipe> _favoriteRecipes = [];

  final _dbRef = FirebaseDatabase.instance.ref();

  @override
  String? currentUser = FirebaseAuth.instance.currentUser?.displayName;

  @override
  List<Recipe> get recipes => _recipes;

  @override
  List<Recipe> get favoriteRecipes => _favoriteRecipes;

  @override
  Stream<List<Recipe>> getRecipesStream() {
    return _dbRef.child(RECIPE_PATH).onValue.map((event) {
      if (event.snapshot.value == null) {
        return []; // Handle case where there's no data
      }
      final Map<String, dynamic> recipesData =
      Map<String, dynamic>.from(event.snapshot.value as Map);
      return recipesData.values
          .map((asJson) =>
          getRecipeFromRTDB(Map<String, dynamic>.from(asJson)))
          .toList();
    });
  }

  @override
  Stream<List<Recipe>> getFavoriteRecipesStream() {
    return _dbRef.child(FAV_RECIPE_PATH).child(currentUser!).child('favorite').onValue.map((event) {
      if (event.snapshot.value == null) {
        return []; // Handle case where there are no favorite recipes
      }
      // The event.snapshot.value might be null or not a Map if no favorites exist.
      // Safely cast it. If it's not a map, assume empty favorites.
      final dynamic snapshotValue = event.snapshot.value;
      if (snapshotValue is! Map) {
        return [];
      }
      final Map<String, dynamic> recipesData = Map<String, dynamic>.from(snapshotValue);

      return recipesData.values
          .map((asJson) =>
          getRecipeFromRTDB(Map<String, dynamic>.from(asJson)))
          .toList();
    });
  }

  @override
  Recipe getRecipeFromRTDB(Map<String, dynamic> data) {
    return Recipe(
      namaMakanan : data['namaMakanan'],
      deskripsiMasakan : data['deskripsiMasakan'],
      waktuMasak : data['waktuMasak'],
      kalori : data['kalori'],
      bahan : data['bahan'].trim().split(","),
      instruksi : data['instruksi'].trim().split("."),
      urlGambar : data['urlGambarOnline'],
    );
  }

  // @override
  // Future<void> addFavoriteRecipe({
  //   required String? currentUser,
  //   required String namaMakanan,
  //   required String deskripsiMasakan,
  //   required String waktuMasak,
  //   required String kalori,
  //   required List<String> bahan,
  //   required List<String> instruksi,
  //   required String urlGambar
  // }) async {
  //   String user = currentUser.toString();
  //   final db = FirebaseDatabase.instance.ref().child('users').child(user);
  //
  //   await db.child('favorite').child(namaMakanan.trim()).set({
  //     'namaMakanan': namaMakanan,
  //     'deskripsiMasakan': deskripsiMasakan,
  //     'waktuMasak': waktuMasak,
  //     'kalori': kalori,
  //     'bahan': bahan.toString().replaceAll(RegExp(r'[\[\]]'), ''),
  //     'instruksi': instruksi.toString().replaceAll(RegExp(r'[\[\]]'), '').replaceAll(',', '.'),
  //     'urlGambarOnline': urlGambar
  //   });
  // }
}