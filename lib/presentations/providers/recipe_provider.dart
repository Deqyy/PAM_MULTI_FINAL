import 'dart:async';

import 'package:app_resep_makanan/domain/entities/recipe_model.dart';
import 'package:app_resep_makanan/data/repositories/recipe_repository_impl.dart';
import 'package:app_resep_makanan/domain/usecases/recipe/add_favorite_recipe.dart';
import 'package:app_resep_makanan/domain/usecases/recipe/get_all_local_favorite_recipes.dart';
import 'package:app_resep_makanan/domain/usecases/recipe/get_recipes_stream.dart';
import 'package:app_resep_makanan/domain/usecases/recipe/remove_favorite_recipe.dart';
import 'package:app_resep_makanan/domain/usecases/recipe/set_favorite_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../domain/usecases/recipe/get_favorite_recipes_stream.dart';

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> _favoriteRecipes = [];

  List<Recipe> get recipes => _recipes;
  List<Recipe> get favoriteRecipes => _favoriteRecipes;


  final GetRecipesStream getRecipesStreamUseCase;
  final GetFavoriteRecipesStream getFavoriteRecipesStreamUseCase;
  final GetAllLocalFavoriteRecipesUseCase getAllLocalFavoriteRecipesUseCase;
  final SetFavoriteStatusUseCase setFavoriteStatusUseCase;
  final AddFavoriteRecipeUseCase addFavoriteRecipeUseCase;
  final RemoveFavoriteRecipeUseCase removeFavoriteRecipeUseCase;

  final RecipeRepositoryImpl recipeRepo;

  StreamSubscription? _recipeStreamSubscription;
  StreamSubscription? _favRecipeStreamSubscription;
  StreamSubscription? _authStateSubscription;



  final Map<String, bool> _localFavoriteStatuses = {};
  Map<String, bool> get localFavoriteStatuses => _localFavoriteStatuses;

  // final FavoriteService _favoriteService = FavoriteService();
  // final RecipeController _recipeController = RecipeController();

  RecipeProvider(
      {required this.recipeRepo, required this.getRecipesStreamUseCase,
        required this.getFavoriteRecipesStreamUseCase,
        required this.getAllLocalFavoriteRecipesUseCase,
        required this.setFavoriteStatusUseCase,
        required this.addFavoriteRecipeUseCase,
        required this.removeFavoriteRecipeUseCase}) {
    _listenToRecipes();
    _listenToFavRecipes();
    _loadAllLocalFavorites(); // Load all favorites from SharedPreferences on init

    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      _favRecipeStreamSubscription?.cancel(); // Cancel old subscription
      _listenToFavRecipes(); // Start new subscription with potentially new user
    });
  }

  void _listenToRecipes() {
    _recipeStreamSubscription = getRecipesStreamUseCase.execute().listen((newRecipes) {
      _recipes = newRecipes;
      notifyListeners(); // This is where notifyListeners belongs
    }, onError: (error) {
      // Handle errors from the stream, e.g., print or log
      print("Error fetching recipes: $error");
    });
  }

  void _listenToFavRecipes() {
    _favRecipeStreamSubscription = getFavoriteRecipesStreamUseCase.execute().listen((newFavoriteRecipes) {
      _favoriteRecipes = newFavoriteRecipes;

      // 1. Clear existing local statuses to reflect the latest database state
      _localFavoriteStatuses.clear();
      // 2. Populate _localFavoriteStatuses based on recipes from the database
      for (var recipe in newFavoriteRecipes) {
        _localFavoriteStatuses[recipe.namaMakanan] = true; // Mark as true if present in DB favorites
      }

      notifyListeners(); // This is where notifyListeners belongs for favorites
    }, onError: (error) {
      print("Error fetching favorite recipes: $error");
      _favoriteRecipes.clear();
      _localFavoriteStatuses.clear();
      notifyListeners();
    });
  }

  Future<void> _loadAllLocalFavorites() async {
    final allFavs = await getAllLocalFavoriteRecipesUseCase.call();
    _localFavoriteStatuses.clear();
    _localFavoriteStatuses.addAll(allFavs);
    notifyListeners();
  }

  Future<void> toggleRecipeFavoriteStatus({
    required String? currentUser,
    required String namaMakanan,
    required String deskripsiMasakan,
    required String waktuMasak,
    required String kalori,
    required List<String> bahan,
    required List<String> instruksi,
    required String urlGambar,
    required bool currentIsFavorite,
  }) async {
    final bool newIsFavorite = !currentIsFavorite;

    // 1. Update local state immediately for a responsive UI
    _localFavoriteStatuses[namaMakanan] = newIsFavorite;
    notifyListeners();

    // 2. Update SharedPreferences
    await setFavoriteStatusUseCase.call(namaMakanan, newIsFavorite);

    // 3. Update Firebase
    if (newIsFavorite) {
      await addFavoriteRecipeUseCase.call(
        currentUser: currentUser,
        namaMakanan: namaMakanan,
        deskripsiMasakan: deskripsiMasakan,
        waktuMasak: waktuMasak,
        kalori: kalori,
        bahan: bahan,
        instruksi: instruksi,
        urlGambar: urlGambar,
      );
    } else {
      await removeFavoriteRecipeUseCase.call(
        currentUser: currentUser,
        namaMakanan: namaMakanan,
      );
    }
  }

  @override
  void dispose() {
    _recipeStreamSubscription?.cancel();
    _favRecipeStreamSubscription?.cancel();
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
