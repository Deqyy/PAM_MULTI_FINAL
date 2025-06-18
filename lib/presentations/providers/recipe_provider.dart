import 'dart:async';

import 'package:app_resep_makanan/domain/entities/recipe_model.dart';
import 'package:app_resep_makanan/data/repositories/recipe_repository_impl.dart';
import 'package:app_resep_makanan/domain/usecases/recipe/add_favorite_recipe.dart';
import 'package:app_resep_makanan/domain/usecases/recipe/get_recipes_stream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../domain/usecases/recipe/get_favorite_recipes_stream.dart';

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> _favoriteRecipes = [];
  // String? currentUser = FirebaseAuth.instance.currentUser?.displayName;
  // final _dbRef = FirebaseDatabase.instance.ref();
  //
  // static const String RECIPE_PATH = 'recipe';
  // static const String FAV_RECIPE_PATH = 'users';
  //
  //
  List<Recipe> get recipes => _recipes;
  List<Recipe> get favoriteRecipes => _favoriteRecipes;

  late final StreamSubscription<DatabaseEvent> _recipeStream;
  late final StreamSubscription<DatabaseEvent> _favRecipeStream;

  final GetRecipesStream getRecipesStreamUseCase;
  final GetFavoriteRecipesStream getFavoriteRecipesStreamUseCase;
  // final AddFavoriteRecipe addFavoriteRecipeUseCase;

  final RecipeRepositoryImpl recipeRepo; // = RecipeRepositoryImpl();

  StreamSubscription? _recipeStreamSubscription;
  StreamSubscription? _favRecipeStreamSubscription;

  RecipeProvider(
      {required this.recipeRepo, required this.getRecipesStreamUseCase, required this.getFavoriteRecipesStreamUseCase}) {
    _listenToRecipes();
    _listenToFavRecipes();
  }

  // void _listenToRecipes() {
  //   // _recipeStream = _dbRef.child(RECIPE_PATH).onValue.listen((event) {
  //   //     final Map<String, dynamic> recipes = Map<String, dynamic>.from(event.snapshot.value as Map);
  //   //     _recipes = recipes.values.map((asJson) => recipeRepo.getRecipeFromRTDB(Map<String, dynamic>.from(asJson))).toList();
  //   //   notifyListeners();
  //   // });
  //   recipeRepo.listenToRecipes();
  //   notifyListeners();
  // }

  void _listenToRecipes() {
    _recipeStreamSubscription = getRecipesStreamUseCase.execute().listen((newRecipes) {
      _recipes = newRecipes;
      notifyListeners(); // This is where notifyListeners belongs
    }, onError: (error) {
      // Handle errors from the stream, e.g., print or log
      print("Error fetching recipes: $error");
    });
  }

  // void _listenToFavRecipes() {
  //   _favRecipeStream = _dbRef.child(FAV_RECIPE_PATH).child(currentUser!).child('favorite').onValue.listen((event) {
  //       final Map<String, dynamic> recipes = Map<String, dynamic>.from(event.snapshot.value as Map);
  //       _favoriteRecipes = recipes.values.map((asJson) => recipeRepo.getRecipeFromRTDB(Map<String, dynamic>.from(asJson))).toList();
  //     notifyListeners();
  //   });
  // }

  void _listenToFavRecipes() {
    _favRecipeStreamSubscription = getFavoriteRecipesStreamUseCase.execute().listen((newFavoriteRecipes) {
      _favoriteRecipes = newFavoriteRecipes;
      notifyListeners(); // This is where notifyListeners belongs for favorites
    }, onError: (error) {
      print("Error fetching favorite recipes: $error");
    });
  }

  @override
  void dispose() {
    _recipeStream.cancel();
    _favRecipeStream.cancel();
    super.dispose();
  }

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
  //   addFavoriteRecipeUseCase.execute(currentUser: currentUser,
  //       namaMakanan: namaMakanan,
  //       deskripsiMasakan: deskripsiMasakan,
  //       waktuMasak: waktuMasak,
  //       kalori: kalori,
  //       bahan: bahan,
  //       instruksi: instruksi,
  //       urlGambar: urlGambar);
  // }
}
