import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  Future<void> setFavoriteStatus(String title, bool isFavorite) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(title, isFavorite); 
  }

  Future<bool> getFavoriteStatus(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(title) ?? false; 
  }

  Future<Map<String, bool>> getAllFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    Map<String, bool> favorites = {};
    for (var key in keys) {
      favorites[key] = prefs.getBool(key) ?? false;
    }
    return favorites; 
  }
}