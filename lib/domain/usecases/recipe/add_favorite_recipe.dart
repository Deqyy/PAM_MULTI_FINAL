import 'package:app_resep_makanan/data/repositories/recipe_repository_impl.dart';

class AddFavoriteRecipeUseCase {
  final RecipeRepositoryImpl _recipeRepo;

  AddFavoriteRecipeUseCase(this._recipeRepo);

  Future<void> call({
  required String? currentUser,
  required String namaMakanan,
  required String deskripsiMasakan,
  required String waktuMasak,
  required String kalori,
  required List<String> bahan,
  required List<String> instruksi,
  required String urlGambar
}) async {
    _recipeRepo.addFavoriteRecipe(
      currentUser: currentUser,
      namaMakanan: namaMakanan,
      deskripsiMasakan: deskripsiMasakan,
      waktuMasak: waktuMasak,
      kalori: kalori,
      bahan: bahan,
      instruksi: instruksi,
      urlGambar: urlGambar,);
  }
}