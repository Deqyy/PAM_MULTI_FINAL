import 'dart:async';

import 'package:app_resep_makanan/domain/repositories/recipe_repository.dart';
import 'package:app_resep_makanan/domain/entities/recipe_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  static const String RECIPE_PATH = 'recipe';
  static const String FAV_RECIPE_PATH = 'users';

  List<Recipe> _recipes = [];
  List<Recipe> _favoriteRecipes = [];

  final _dbRef = FirebaseDatabase.instance.ref();

  @override
  List<Recipe> get recipes => _recipes;

  @override
  List<Recipe> get favoriteRecipes => _favoriteRecipes;


  String? currentUserDisplayName;
  late StreamSubscription<User?> _authStateChangesSubscription;

  RecipeRepositoryImpl() {
    _listenToAuthStateChanges();
  }

  void _listenToAuthStateChanges() {
    _authStateChangesSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {

      currentUserDisplayName = user?.displayName;
      print('Auth State Changed: Current User Display Name: $currentUserDisplayName');
    });
  }


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
          _getRecipeFromRTDB(Map<String, dynamic>.from(asJson)))
          .toList();
    });
  }

  @override
  Stream<List<Recipe>> getFavoriteRecipesStream() {
    return _dbRef.child(FAV_RECIPE_PATH).child( currentUserDisplayName!).child('favorite').onValue.map((event) {
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
          _getRecipeFromRTDB(Map<String, dynamic>.from(asJson)))
          .toList();
    });
  }

  @override
  Future<void> addFavoriteRecipe({
    required String? currentUser,
    required String namaMakanan,
    required String deskripsiMasakan,
    required String waktuMasak,
    required String kalori,
    required List<String> bahan,
    required List<String> instruksi,
    required String urlGambar
  }) async {
    String user = currentUser.toString();
    final db = FirebaseDatabase.instance.ref().child('users').child(user);

    await db.child('favorite').child(namaMakanan.trim()).set({
      'namaMakanan': namaMakanan,
      'deskripsiMasakan': deskripsiMasakan,
      'waktuMasak': waktuMasak,
      'kalori': kalori,
      'bahan': bahan.toString().replaceAll(RegExp(r'[\[\]]'), ''),
      'instruksi': instruksi.toString().replaceAll(RegExp(r'[\[\]]'), '').replaceAll(',', '.'),
      'urlGambarOnline': urlGambar
    });
  }

  @override
  Future<void> removeFavoriteRecipe({
    required String? currentUser,
    required String namaMakanan
  }) async {
    String user = currentUser.toString();
    final db = FirebaseDatabase.instance.ref().child('users').child(user).child('favorite');
    await db.child(namaMakanan).remove();
  }

  @override
  Future<void> setFavoriteStatus(String title, bool isFavorite) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(title, isFavorite);
  }

  @override
  Future<Map<String, bool>> getAllFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    Map<String, bool> favorites = {};
    for (var key in keys) {
      favorites[key] = prefs.getBool(key) ?? false;
    }
    return favorites;
  }

  @override
  Recipe _getRecipeFromRTDB(Map<String, dynamic> data) {
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

  void dispose() {
    _authStateChangesSubscription.cancel();
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