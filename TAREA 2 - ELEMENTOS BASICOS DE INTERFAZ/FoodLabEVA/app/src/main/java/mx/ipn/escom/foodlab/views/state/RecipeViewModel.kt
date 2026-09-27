package mx.ipn.escom.foodlab.views.state

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import mx.ipn.escom.foodlab.views.model.Recipe

class RecipeViewModel : ViewModel() {

    private val _recipes = MutableLiveData<MutableList<Recipe>>(mutableListOf())
    val recipes: LiveData<MutableList<Recipe>> = _recipes

    val latestRecipe: Recipe?
        get() = _recipes.value?.lastOrNull()

    fun addRecipe(recipe: Recipe) {
        val current = _recipes.value ?: mutableListOf()
        current.add(recipe)
        _recipes.value = current
    }

    fun toggleFavorite(recipe: Recipe) {
        recipe.isFavorite = !recipe.isFavorite
        notifyChanges()
    }

    fun saveRecipe(recipe: Recipe) {
        recipe.isSaved = true
        notifyChanges()
    }

    fun finishRecipe(recipe: Recipe) {
        recipe.isFinished = true
        notifyChanges()
    }

    fun addIngredient(recipe: Recipe, ingredient: String) {
        if (ingredient.isNotBlank()) {
            recipe.ingredients.add(ingredient.trim())
            notifyChanges()
        }
    }

    fun removeIngredient(recipe: Recipe, ingredient: String) {
        recipe.ingredients.remove(ingredient)
        notifyChanges()
    }

    private fun notifyChanges() {
        _recipes.value = _recipes.value
    }
}