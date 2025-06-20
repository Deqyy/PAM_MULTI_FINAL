import 'package:app_resep_makanan/data/repositories/recipe_repository_impl.dart';

class RemoveFavoriteRecipeUseCase {
  final RecipeRepositoryImpl _recipeRepo;

  RemoveFavoriteRecipeUseCase(this._recipeRepo);

  Future<void> call({
    required String? currentUser,
    required String namaMakanan,
  }) async {
    await _recipeRepo.removeFavoriteRecipe(
      currentUser: currentUser,
      namaMakanan: namaMakanan,
    );
  }
}