import 'package:app_resep_makanan/models/recipe_provider.dart';
import 'package:app_resep_makanan/services/auth_service.dart';
import 'package:app_resep_makanan/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 70.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Spacer(),
                  const SizedBox(width: 40),
                  const Text(
                    'Akun Saya',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/setting.svg',
                      width: 24.0,
                      height: 24.0,
                    ),
                    onPressed: () {
                      // INI SETTING
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 2.0,
                      offset: Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 2.0,
                      offset: Offset(4, 0),
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 2.0,
                      offset: Offset(-4, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/9385/9385289.png',
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: FutureBuilder<String?>(
                        future: AuthService().getCurrentUser(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data ?? 'Nama',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        AuthService().signOut(context: context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Favorit Saya',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Consumer<RecipeProvider>(builder: (context, value, child) {
                return value.favoriteRecipes.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 2.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: value.favoriteRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = value.favoriteRecipes[index];
                          return RecipeCard(
                            key: ValueKey(recipe.namaMakanan),
                            imageUrl: recipe.urlGambar,
                            title: recipe.namaMakanan,
                            calories: recipe.kalori.toString(),
                            time: recipe.waktuMasak.toString(),
                            description: recipe.deskripsiMasakan,
                            ingredients: recipe.bahan,
                            instructions: recipe.instruksi,
                          );
                        },
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
