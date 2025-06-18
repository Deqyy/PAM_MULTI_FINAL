import 'package:app_resep_makanan/domain/repositories/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/recipe_model.dart';
import '../../presentations/providers/recipe_provider.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  int _selectedCategory = 0;
  final List<String> _categories = ['Breakfast', 'Lunch', 'Dinner'];
  List<Recipe> _categoryRecipes = [];

  @override
  int get selectedCategory => _selectedCategory;
  @override
  List<String> get categories => _categories;
  @override
  List<Recipe> get categoryRecipes => _categoryRecipes;

  void setSelectedCategory(int index, BuildContext context) {
    _selectedCategory = index;
    // notifyListeners();
    _loadRecipesForCategory(context, index);
  }

  void _loadRecipesForCategory(BuildContext context, int categoryIndex) {
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);

    List<Recipe> allRecipes = recipeProvider.recipes;
    _categoryRecipes = [];

    int startIndex = 0;
    int endIndex = 4;

    switch (categoryIndex) {
      case 0: // Breakfast
        startIndex = 0;
        endIndex = 4;
        break;
      case 1: // Lunch
        startIndex = 4;
        endIndex = 8;
        break;
      case 2: // Dinner
        startIndex = 8;
        endIndex = 12;
        break;
      default:
        _categoryRecipes = [];
        break;
    }

    if (endIndex > allRecipes.length) {
      endIndex = allRecipes.length;
    }

    _categoryRecipes = allRecipes.sublist(startIndex, endIndex);

    // notifyListeners();
  }
}