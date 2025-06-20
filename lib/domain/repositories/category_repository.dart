import 'package:flutter/material.dart';

import '../entities/recipe_model.dart';

abstract class CategoryRepository {
  int get selectedCategory;
  List<String> get categories;
  List<Recipe> get categoryRecipes;

  void setSelectedCategory(int index, BuildContext context);
}