import 'package:app_resep_makanan/data/repositories/recipe_repository_impl.dart';

class GetAllLocalFavoriteRecipesUseCase {
  final RecipeRepositoryImpl _recipeRepo;

  GetAllLocalFavoriteRecipesUseCase(this._recipeRepo);

  Future<Map<String, bool>> call() async {
    return await _recipeRepo.getAllFavorites();
  }
}