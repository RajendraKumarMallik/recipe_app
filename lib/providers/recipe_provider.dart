import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../database/recipe_database.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  Future<void> loadRecipes() async {
    _recipes = await RecipeDatabase.instance.fetchAllRecipes();
    notifyListeners();
  }

  Future<void> addRecipe(Recipe recipe) async {
    await RecipeDatabase.instance.insertRecipe(recipe);
    await loadRecipes();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await RecipeDatabase.instance.updateRecipe(recipe);
    await loadRecipes();
  }

  Future<void> deleteRecipe(int id) async {
    await RecipeDatabase.instance.deleteRecipe(id);
    await loadRecipes();
  }

  List<Recipe> searchRecipes(String query) {
    return _recipes.where((recipe) {
      final titleLower = recipe.title.toLowerCase();
      final ingredientsLower = recipe.ingredients.join(', ').toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          ingredientsLower.contains(searchLower);
    }).toList();
  }
}
