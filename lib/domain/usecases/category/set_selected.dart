import 'package:app_resep_makanan/data/repositories/category_repository_impl.dart';
import 'package:flutter/material.dart';

class SetSelected {
  final CategoryRepositoryImpl categoryRepository;

  SetSelected(this.categoryRepository);

  void call(int index, BuildContext context) {
    categoryRepository.setSelectedCategory(index, context);
  }
}