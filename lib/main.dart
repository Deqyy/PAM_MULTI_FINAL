  import 'package:app_resep_makanan/data/repositories/category_repository_impl.dart';
import 'package:app_resep_makanan/data/repositories/recipe_repository_impl.dart';
import 'package:app_resep_makanan/domain/usecases/category/set_selected.dart';
import 'package:app_resep_makanan/domain/usecases/recipe/add_favorite_recipe.dart';
import 'package:app_resep_makanan/domain/usecases/recipe/get_favorite_recipes_stream.dart';
import 'package:app_resep_makanan/domain/usecases/recipe/get_recipes_stream.dart';
import 'package:app_resep_makanan/presentations/providers/auth_provider.dart';
import 'package:app_resep_makanan/presentations/providers/recipe_provider.dart';
  import 'package:app_resep_makanan/presentations/widgets/wrapper.dart';
  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'presentations/pages/home_page.dart';
  import 'presentations/pages/create_acc.dart';
  import 'presentations/pages/landing_page.dart';
  import 'presentations/pages/login_page.dart';
  import 'presentations/providers/category_provider.dart';
  import 'presentations/pages/search_page.dart';
  import 'presentations/pages/profile_page.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'firebase_options.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(
      MyApp()
    );
  }

  class MyApp extends StatelessWidget {
    // const MyApp({super.key});
    CategoryRepositoryImpl categoryRepository = CategoryRepositoryImpl();
    RecipeRepositoryImpl recipeRepository = RecipeRepositoryImpl();
    @override
    Widget build(BuildContext context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<CategoryProvider>(create: (_) => CategoryProvider(categoryRepository: categoryRepository, setSelectedUseCase: SetSelected(categoryRepository))),
          ChangeNotifierProvider<RecipeProvider>(create: (_) => RecipeProvider(recipeRepo: recipeRepository, getRecipesStreamUseCase: GetRecipesStream(recipeRepository), getFavoriteRecipesStreamUseCase: GetFavoriteRecipesStream(recipeRepository))),
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ],
        child: Builder(builder: (BuildContext context) {
          return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => const Wrapper(),
            '/landing': (context) => LandingPage(),
            '/home': (context) => HomePage(),
            '/login': (context) => LoginPage(),
            '/createacc': (context) => CreateAcc(),
            '/search': (context) => SearchPage(),
            '/profile': (context) => ProfilePage(),
            },
          );
        }),
      );
    }
  }
