import 'package:flutter/foundation.dart';

import '../models/recipe.dart';

class RecipeStore extends ChangeNotifier {
  RecipeStore._();

  static final RecipeStore instance = RecipeStore._();

  final List<Recipe> _recipes = [];

  List<Recipe> get recipes => List.unmodifiable(_recipes);

  Recipe? get latestRecipe {
    if (_recipes.isEmpty) {
      return null;
    }

    return _recipes.last;
  }

  void addRecipe(Recipe recipe) {
    _recipes.add(recipe);
    notifyListeners();
  }

  void removeRecipe(String id) {
    _recipes.removeWhere((recipe) => recipe.id == id);
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final recipe = _findRecipe(id);

    if (recipe == null) {
      return;
    }

    recipe.isFavorite = !recipe.isFavorite;
    notifyListeners();
  }

  void markAsSaved(String id) {
    final recipe = _findRecipe(id);

    if (recipe == null) {
      return;
    }

    recipe.isSaved = true;
    notifyListeners();
  }

  void markAsFinished(String id) {
    final recipe = _findRecipe(id);

    if (recipe == null) {
      return;
    }

    recipe.isFinished = true;
    notifyListeners();
  }

  void addIngredient(String id, String ingredient) {
    final recipe = _findRecipe(id);

    if (recipe == null) {
      return;
    }

    recipe.ingredients.add(ingredient);
    recipe.isSaved = false;

    notifyListeners();
  }

  void removeIngredient(String id, int index) {
    final recipe = _findRecipe(id);

    if (recipe == null) {
      return;
    }

    if (index < 0 || index >= recipe.ingredients.length) {
      return;
    }

    recipe.ingredients.removeAt(index);
    recipe.isSaved = false;

    notifyListeners();
  }

  Recipe? _findRecipe(String id) {
    for (final recipe in _recipes) {
      if (recipe.id == id) {
        return recipe;
      }
    }

    return null;
  }
}
