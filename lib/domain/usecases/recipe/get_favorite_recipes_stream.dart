import '../../../data/repositories/recipe_repository_impl.dart';
import '../../entities/recipe_model.dart';

class GetFavoriteRecipesStream {
  final RecipeRepositoryImpl recipeRepository;

  GetFavoriteRecipesStream(this.recipeRepository);

  Stream<List<Recipe>> execute() {
    return recipeRepository.getFavoriteRecipesStream();
  }
}