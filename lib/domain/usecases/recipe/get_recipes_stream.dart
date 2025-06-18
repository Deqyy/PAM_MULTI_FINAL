import 'package:app_resep_makanan/data/repositories/recipe_repository_impl.dart';

import '../../entities/recipe_model.dart';

class GetRecipesStream {
  final RecipeRepositoryImpl recipeRepository;

  GetRecipesStream(this.recipeRepository);

  Stream<List<Recipe>> execute() {
    return recipeRepository.getRecipesStream();
  }
}