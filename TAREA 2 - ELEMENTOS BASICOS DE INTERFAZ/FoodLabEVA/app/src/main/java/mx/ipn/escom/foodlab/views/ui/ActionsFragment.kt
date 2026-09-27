package mx.ipn.escom.foodlab.views.ui

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import com.google.android.material.button.MaterialButton
import com.google.android.material.button.MaterialButtonToggleGroup
import com.google.android.material.floatingactionbutton.ExtendedFloatingActionButton
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.google.android.material.progressindicator.LinearProgressIndicator
import com.google.android.material.snackbar.Snackbar
import com.google.android.material.textfield.TextInputEditText
import mx.ipn.escom.foodlab.views.R
import mx.ipn.escom.foodlab.views.model.Recipe
import mx.ipn.escom.foodlab.views.state.RecipeViewModel

class ActionsFragment : Fragment(R.layout.fragment_actions) {

    private val recipeViewModel: RecipeViewModel by activityViewModels()

    private lateinit var textRecipeName: TextView
    private lateinit var textRecipeInfo: TextView
    private lateinit var textIngredients: TextView

    private var currentRecipe: Recipe? = null

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        textRecipeName = view.findViewById(R.id.textRecipeName)
        textRecipeInfo = view.findViewById(R.id.textRecipeInfo)
        textIngredients = view.findViewById(R.id.textIngredients)

        val editNewIngredient =
            view.findViewById<TextInputEditText>(R.id.editNewIngredient)

        val btnSave =
            view.findViewById<MaterialButton>(R.id.btnSave)

        val btnShare =
            view.findViewById<MaterialButton>(R.id.btnShare)

        val btnFavorite =
            view.findViewById<MaterialButton>(R.id.btnFavorite)

        val btnStart =
            view.findViewById<MaterialButton>(R.id.btnStart)

        val btnDisabled =
            view.findViewById<MaterialButton>(R.id.btnDisabled)

        val progress =
            view.findViewById<LinearProgressIndicator>(R.id.progressLoading)

        val fabFavorite =
            view.findViewById<FloatingActionButton>(R.id.fabFavorite)

        val fabStart =
            view.findViewById<ExtendedFloatingActionButton>(R.id.fabStart)

        val toggle =
            view.findViewById<MaterialButtonToggleGroup>(
                R.id.togglePreparation
            )

        view.findViewById<View>(R.id.btnBack).setOnClickListener {
            parentFragmentManager.popBackStack()
        }

        currentRecipe = recipeViewModel.latestRecipe

        renderRecipe()

        btnSave.setOnClickListener {
            val recipe = currentRecipe

            if (recipe == null) {
                showNoRecipe(view)
                return@setOnClickListener
            }

            recipeViewModel.saveRecipe(recipe)

            Snackbar.make(
                view,
                "${recipe.name} se guardó correctamente",
                Snackbar.LENGTH_SHORT
            ).show()
        }

        btnShare.setOnClickListener {
            val recipe = currentRecipe

            if (recipe == null) {
                showNoRecipe(view)
                return@setOnClickListener
            }

            val message = buildString {
                append("FoodLab - ${recipe.name}\n\n")
                append("Categoría: ${recipe.category}\n")
                append("Porciones: ${recipe.portions}\n\n")
                append("Ingredientes:\n")
                recipe.ingredients.forEach {
                    append("• $it\n")
                }
            }

            val intent = Intent(Intent.ACTION_SEND).apply {
                type = "text/plain"
                putExtra(Intent.EXTRA_SUBJECT, recipe.name)
                putExtra(Intent.EXTRA_TEXT, message)
            }

            startActivity(
                Intent.createChooser(
                    intent,
                    "Compartir receta"
                )
            )
        }

        view.findViewById<View>(R.id.btnCancel).setOnClickListener {
            Snackbar.make(
                view,
                "Preparación cancelada",
                Snackbar.LENGTH_SHORT
            ).show()
        }

        btnFavorite.setOnClickListener {
            toggleFavorite(view, btnFavorite)
        }

        fabFavorite.setOnClickListener {
            toggleFavorite(view, btnFavorite)
        }

        view.findViewById<View>(R.id.btnShopping).setOnClickListener {
            val recipe = currentRecipe

            if (recipe == null) {
                showNoRecipe(view)
            } else {
                Snackbar.make(
                    view,
                    "${recipe.ingredients.size} ingredientes agregados a tu lista",
                    Snackbar.LENGTH_SHORT
                ).show()
            }
        }

        toggle.addOnButtonCheckedListener { _, checkedId, isChecked ->

            if (!isChecked) return@addOnButtonCheckedListener

            val message = when (checkedId) {
                R.id.btnPrepare ->
                    "Modo preparación seleccionado"

                R.id.btnServe ->
                    "Modo presentación seleccionado"

                else -> return@addOnButtonCheckedListener
            }

            Snackbar.make(
                view,
                message,
                Snackbar.LENGTH_SHORT
            ).show()
        }

        btnStart.setOnClickListener {
            startPreparation(
                view,
                btnStart,
                btnDisabled,
                progress
            )
        }

        fabStart.setOnClickListener {
            startPreparation(
                view,
                btnStart,
                btnDisabled,
                progress
            )
        }

        btnDisabled.setOnClickListener {

            val recipe = currentRecipe ?: return@setOnClickListener

            recipeViewModel.finishRecipe(recipe)

            btnDisabled.isEnabled = false
            btnDisabled.text = "Preparación finalizada"

            Snackbar.make(
                view,
                "¡${recipe.name} está lista!",
                Snackbar.LENGTH_LONG
            ).show()
        }

        view.findViewById<View>(R.id.btnAddIngredient)
            .setOnClickListener {

                val recipe = currentRecipe

                if (recipe == null) {
                    showNoRecipe(view)
                    return@setOnClickListener
                }

                val ingredient =
                    editNewIngredient.text
                        ?.toString()
                        ?.trim()
                        .orEmpty()

                if (ingredient.isBlank()) {
                    Snackbar.make(
                        view,
                        "Escribe un ingrediente",
                        Snackbar.LENGTH_SHORT
                    ).show()

                    return@setOnClickListener
                }

                recipeViewModel.addIngredient(
                    recipe,
                    ingredient
                )

                editNewIngredient.text?.clear()

                renderRecipe()

                Snackbar.make(
                    view,
                    "$ingredient agregado",
                    Snackbar.LENGTH_SHORT
                ).setAction("Deshacer") {
                    recipeViewModel.removeIngredient(
                        recipe,
                        ingredient
                    )
                    renderRecipe()
                }.show()
            }
    }

    private fun renderRecipe() {

        val recipe = currentRecipe

        if (recipe == null) {
            textRecipeName.text = "Crea una receta primero"
            textRecipeInfo.text =
                "Registra una receta desde la primera sección."
            textIngredients.text =
                "Todavía no hay ingredientes."
            return
        }

        textRecipeName.text = recipe.name

        textRecipeInfo.text =
            "${recipe.category} • ${recipe.portions} porciones"

        textIngredients.text =
            if (recipe.ingredients.isEmpty()) {
                "Todavía no hay ingredientes."
            } else {
                recipe.ingredients.joinToString("\n") {
                    "• $it"
                }
            }
    }

    private fun toggleFavorite(
        view: View,
        button: MaterialButton
    ) {

        val recipe = currentRecipe

        if (recipe == null) {
            showNoRecipe(view)
            return
        }

        recipeViewModel.toggleFavorite(recipe)

        button.text =
            if (recipe.isFavorite) {
                "En favoritas"
            } else {
                "Favorita"
            }

        Snackbar.make(
            view,
            if (recipe.isFavorite) {
                "${recipe.name} se agregó a favoritas"
            } else {
                "${recipe.name} se eliminó de favoritas"
            },
            Snackbar.LENGTH_SHORT
        ).show()
    }

    private fun startPreparation(
        view: View,
        startButton: MaterialButton,
        finishButton: MaterialButton,
        progress: LinearProgressIndicator
    ) {

        val recipe = currentRecipe

        if (recipe == null) {
            showNoRecipe(view)
            return
        }

        startButton.isEnabled = false
        startButton.text = "Preparando..."
        progress.visibility = View.VISIBLE

        Handler(Looper.getMainLooper()).postDelayed({

            if (!isAdded) {
                return@postDelayed
            }

            progress.visibility = View.GONE

            startButton.isEnabled = true
            startButton.text = "Reiniciar preparación"

            finishButton.isEnabled = true

            Snackbar.make(
                view,
                "Preparación de ${recipe.name} iniciada",
                Snackbar.LENGTH_SHORT
            ).show()

        }, 1500)
    }

    private fun showNoRecipe(view: View) {
        Snackbar.make(
            view,
            "Primero crea una receta en FoodLab",
            Snackbar.LENGTH_LONG
        ).show()
    }
}