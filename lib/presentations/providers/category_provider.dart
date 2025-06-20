import 'package:app_resep_makanan/data/repositories/category_repository_impl.dart';
import 'package:app_resep_makanan/domain/repositories/category_repository.dart';
import 'package:flutter/material.dart';

import '../../domain/usecases/category/set_selected.dart';

class CategoryProvider with ChangeNotifier {
  CategoryRepository categoryRepository;
  SetSelected setSelectedUseCase;

  CategoryProvider({required this.categoryRepository, required this.setSelectedUseCase});

  void setSelectedCategory(int index, BuildContext context) {
    setSelectedUseCase.call(index, context);
    notifyListeners();
  }
}


