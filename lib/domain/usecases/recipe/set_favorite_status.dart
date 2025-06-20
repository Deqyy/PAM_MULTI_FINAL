import 'package:app_resep_makanan/data/repositories/recipe_repository_impl.dart';

class SetFavoriteStatusUseCase {
  final RecipeRepositoryImpl _recipeRepo;

  SetFavoriteStatusUseCase(this._recipeRepo);

  Future<void> call(namaMakanan, newIsFavorite) async {
    await _recipeRepo.setFavoriteStatus(namaMakanan, newIsFavorite);
  }

}