import 'package:app_resep_makanan/presentations/providers/recipe_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'popup_recipe.dart';

class RecipeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String calories;
  final String time;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;

  const RecipeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.calories,
    required this.time,
    required this.description,
    required this.ingredients,
    required this.instructions,
  });

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopupRecipe(
          imageUrl: imageUrl,
          title: title,
          time: time,
          description: description,
          ingredients: ingredients,
          instructions: instructions,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? currentUser = FirebaseAuth.instance.currentUser?.displayName;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      color: const Color(0xFFFFFFFF),
      child: GestureDetector(
        onTap: () {
          _showPopup(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      imageUrl,
                      height: 100.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: Selector<RecipeProvider, bool>(
                      selector: (context, recipeProvider) =>
                      recipeProvider.localFavoriteStatuses[title] ?? false,
                      builder: (context, isFavorite, child) {
                        return GestureDetector(
                          onTap: () {
                            Provider.of<RecipeProvider>(context, listen: false)
                                .toggleRecipeFavoriteStatus(
                              currentUser: currentUser,
                              namaMakanan: title,
                              deskripsiMasakan: description,
                              waktuMasak: time,
                              kalori: calories,
                              bahan: ingredients,
                              instruksi: instructions,
                              urlGambar: imageUrl,
                              currentIsFavorite: isFavorite,
                            );
                          },
                          child: Container(
                            height: 30.0,
                            width: 30.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4.0,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                isFavorite
                                    ? 'assets/icons/orange-heart.svg'
                                    : 'assets/icons/heart.svg',
                                width: 20.0,
                                height: 20.0,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 60.0,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/fire.svg',
                        width: 16.0,
                        height: 16.0,
                        color: const Color(0xFF97A2B0),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '$calories Kcal',
                        style: const TextStyle(
                          fontSize: 11.0,
                          color: Color(0xFF97A2B0),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10.0),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/clock.svg',
                        width: 16.0,
                        height: 16.0,
                        color: const Color(0xFF97A2B0),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 11.0,
                          color: Color(0xFF97A2B0),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}