import 'package:firebase_database/firebase_database.dart';

class RecipeController {
  Future<void> addFavoriteRecipe({
    required String? currentUser,
    required String namaMakanan,
    required String deskripsiMasakan,
    required String waktuMasak,
    required String kalori,
    required List<String> bahan,
    required List<String> instruksi,
    required String urlGambar
  }) async {
    String user = currentUser.toString();
    final db = FirebaseDatabase.instance.ref().child('users').child(user);

    await db.child('favorite').child(namaMakanan.trim()).set({
      'namaMakanan': namaMakanan,
      'deskripsiMasakan': deskripsiMasakan,
      'waktuMasak': waktuMasak,
      'kalori': kalori,
      'bahan': bahan.toString().replaceAll(RegExp(r'[\[\]]'), ''),
      'instruksi': instruksi.toString().replaceAll(RegExp(r'[\[\]]'), '').replaceAll(',', '.'),
      'urlGambarOnline': urlGambar
    });
  }

  Future<void> removeFavoriteRecipe({
    required String? currentUser,
    required String namaMakanan
  }) async {
    String user = currentUser.toString();
    final db = FirebaseDatabase.instance.ref().child('users').child(user).child('favorite');
    await db.child(namaMakanan).remove();
  }

  
}
