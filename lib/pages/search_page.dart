import 'package:app_resep_makanan/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:app_resep_makanan/models/category_model.dart';
import 'package:app_resep_makanan/models/recipe_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryModel = Provider.of<CategoryModel>(context, listen: false);
      categoryModel.setSelectedCategory(0, context);
    });

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              const SizedBox(height: 70.0),
              const Center(
                child: Text(
                  'Search',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    color: Color(0xFF97A2B0),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(
                      'assets/icons/black_search.svg',
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFE6EBF2),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFE6EBF2),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFE6EBF2),
                      width: 1.5,
                    ),
                  ),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Resep Populer',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Consumer<CategoryModel>(
                builder: (context, categoryModel, child) {
                  List<Recipe> recipes = categoryModel.categoryRecipes;

                  List<Recipe> filteredRecipes = recipes
                      .where((recipe) => recipe.namaMakanan
                          .toLowerCase()
                          .contains(_searchQuery))
                      .toList();

                  return filteredRecipes.isEmpty
                      ? const Center(
                          heightFactor: 5.0,
                          child: Text(
                            'No recipes found',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ))
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
                          itemCount: filteredRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = filteredRecipes[index];
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
            ],
          ),
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
