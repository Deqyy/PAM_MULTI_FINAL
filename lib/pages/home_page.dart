import 'package:app_resep_makanan/models/recipe_model.dart';
import 'package:app_resep_makanan/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:app_resep_makanan/models/category_model.dart';
import 'package:app_resep_makanan/widgets/recipe_card.dart';
import 'package:app_resep_makanan/pages/search_page.dart';
import 'package:app_resep_makanan/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    HomeContent(),
    ProfilePage(),
    SearchPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showFab = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavBarItem('assets/icons/home.svg', 0),
            const SizedBox(),
            buildNavBarItem('assets/icons/profile.svg', 1),
          ],
        ),
      ),
      floatingActionButton: Visibility(
          visible: !showFab,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF042628),
            onPressed: () => _onItemTapped(2),
            shape: CircleBorder(),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              color: Colors.white,
              height: 30.0,
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildNavBarItem(String svgPath, int index) {
    return IconButton(
      onPressed: () => _onItemTapped(index),
      icon: SvgPicture.asset(
        svgPath,
        color: _selectedIndex == index
            ? const Color(0xFF70B9BE)
            : const Color(0xFF97A2B0),
        height: 35.0,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryModel = Provider.of<CategoryModel>(context, listen: false);
      categoryModel.setSelectedCategory(0, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CategoryModel>(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color(0xFFE7E9EB),
          ],
          stops: [0.98, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 30.0),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/sun.svg',
                  height: 30.0,
                  width: 30.0,
                ),
                const SizedBox(width: 10.0),
                const Text(
                  'Hello!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            FutureBuilder<String?>(
              future: AuthService().getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading user');
                } else {
                  return Text(
                    snapshot.data ?? 'Nama User',
                    style: const TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      height: 1.5,
                    ),
                    textAlign: TextAlign.start,
                  );
                }
              },
            ),
            const SizedBox(height: 30.0),
            const Text(
              'Disarankan',
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Center(
              child: SvgPicture.asset(
                'assets/images/card-sample.svg',
                width: 400.0,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Kategori',
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryButton(context, 0, 'Breakfast'),
                _buildCategoryButton(context, 1, 'Lunch'),
                _buildCategoryButton(context, 2, 'Dinner'),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Resep Populer',
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Consumer<CategoryModel>(
              builder: (context, categoryModel, child) {
                List<Recipe> recipes = categoryModel.categoryRecipes;

                return recipes.isEmpty
                    ? const Center(child: CircularProgressIndicator())
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
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = recipes[index];
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
              },
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, int index, String label) {
    final categoryModel = Provider.of<CategoryModel>(context);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: categoryModel.selectedCategory == index
                ? const Color(0xFF70B9BE)
                : const Color(0xFFF1F5F5),
            foregroundColor: categoryModel.selectedCategory == index
                ? Colors.white
                : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onPressed: () {
            categoryModel.setSelectedCategory(index, context);
          },
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
