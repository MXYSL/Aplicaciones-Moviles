package mx.ipn.escom.foodlab.views.ui

import android.os.Bundle
import android.util.Patterns
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.ArrayAdapter
import android.widget.AutoCompleteTextView
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import com.google.android.material.snackbar.Snackbar
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import mx.ipn.escom.foodlab.views.MainActivity
import mx.ipn.escom.foodlab.views.R
import mx.ipn.escom.foodlab.views.model.Recipe
import mx.ipn.escom.foodlab.views.state.RecipeViewModel

class TextInputFragment : Fragment(R.layout.fragment_text_input) {

    private val recipeViewModel: RecipeViewModel by activityViewModels()

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val layoutName = view.findViewById<TextInputLayout>(R.id.layoutName)
        val layoutPassword = view.findViewById<TextInputLayout>(R.id.layoutPassword)
        val layoutEmail = view.findViewById<TextInputLayout>(R.id.layoutEmail)
        val layoutPhone = view.findViewById<TextInputLayout>(R.id.layoutPhone)
        val layoutPortions = view.findViewById<TextInputLayout>(R.id.layoutPortions)
        val layoutIngredients = view.findViewById<TextInputLayout>(R.id.layoutIngredients)
        val layoutCategory = view.findViewById<TextInputLayout>(R.id.layoutCategory)

        val editName = view.findViewById<TextInputEditText>(R.id.editName)
        val editPassword = view.findViewById<TextInputEditText>(R.id.editPassword)
        val editEmail = view.findViewById<TextInputEditText>(R.id.editEmail)
        val editPhone = view.findViewById<TextInputEditText>(R.id.editPhone)
        val editPortions = view.findViewById<TextInputEditText>(R.id.editPortions)
        val editIngredients = view.findViewById<TextInputEditText>(R.id.editIngredients)
        val editSearch = view.findViewById<TextInputEditText>(R.id.editSearch)

        val autoCategory =
            view.findViewById<AutoCompleteTextView>(R.id.autoCategory)

        val textSearchResult =
            view.findViewById<TextView>(R.id.textSearchResult)

        val categories = listOf(
            "Comida mexicana",
            "Desayuno",
            "Ensaladas",
            "Pastas",
            "Sopas",
            "Postres",
            "Comida rápida"
        )

        val categoryAdapter = ArrayAdapter(
            requireContext(),
            android.R.layout.simple_dropdown_item_1line,
            categories
        )

        autoCategory.setAdapter(categoryAdapter)

        view.findViewById<View>(R.id.btnBack).setOnClickListener {
            parentFragmentManager.popBackStack()
        }

        editSearch.setOnEditorActionListener { _, actionId, _ ->

            if (actionId == EditorInfo.IME_ACTION_SEARCH) {

                val search = editSearch.text
                    ?.toString()
                    ?.trim()
                    ?.lowercase()
                    .orEmpty()

                textSearchResult.text = when {
                    search.contains("taco") ->
                        "Sugerencia: tacos de pollo con aguacate y cilantro."

                    search.contains("ensalada") ->
                        "Sugerencia: ensalada fresca con vegetales."

                    search.contains("sopa") ->
                        "Sugerencia: sopa de verduras."

                    search.contains("pizza") ->
                        "Sugerencia: pizza casera con vegetales."

                    search.contains("pasta") ->
                        "Sugerencia: pasta con vegetales o pollo."

                    search.isBlank() ->
                        "Escribe algo para buscar una idea."

                    else ->
                        "No encontramos esa idea. Puedes crearla en FoodLab."
                }

                true
            } else {
                false
            }
        }

        view.findViewById<View>(R.id.btnCreateRecipe).setOnClickListener {

            clearErrors(
                layoutName,
                layoutPassword,
                layoutEmail,
                layoutPhone,
                layoutPortions,
                layoutIngredients,
                layoutCategory
            )

            val name = editName.text?.toString()?.trim().orEmpty()
            val password = editPassword.text?.toString()?.trim().orEmpty()
            val email = editEmail.text?.toString()?.trim().orEmpty()
            val phone = editPhone.text?.toString()?.trim().orEmpty()
            val portionsText = editPortions.text?.toString()?.trim().orEmpty()
            val ingredientsText =
                editIngredients.text?.toString()?.trim().orEmpty()
            val category = autoCategory.text?.toString()?.trim().orEmpty()

            var valid = true

            if (name.length < 3) {
                layoutName.error = "Escribe el nombre de la receta."
                valid = false
            }

            if (password.length < 6) {
                layoutPassword.error =
                    "Utiliza al menos 6 caracteres."
                valid = false
            }

            if (!Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
                layoutEmail.error =
                    "Ingresa un correo electrónico válido."
                valid = false
            }

            if (phone.length < 10) {
                layoutPhone.error =
                    "Ingresa un número telefónico válido."
                valid = false
            }

            val portions = portionsText.toIntOrNull()

            if (portions == null || portions <= 0) {
                layoutPortions.error =
                    "Ingresa una cantidad válida."
                valid = false
            }

            if (ingredientsText.isBlank()) {
                layoutIngredients.error =
                    "Agrega al menos un ingrediente."
                valid = false
            }

            if (category.isBlank()) {
                layoutCategory.error =
                    "Selecciona una categoría."
                valid = false
            }

            if (!valid) {
                Snackbar.make(
                    view,
                    "Revisa los datos de la receta",
                    Snackbar.LENGTH_SHORT
                ).show()

                return@setOnClickListener
            }

            val ingredients = ingredientsText
                .split("\n", ",")
                .map { it.trim() }
                .filter { it.isNotBlank() }
                .toMutableList()

            val recipe = Recipe(
                name = name,
                email = email,
                phone = phone,
                password = password,
                portions = portions!!,
                ingredients = ingredients,
                category = category
            )

            recipeViewModel.addRecipe(recipe)

            Snackbar.make(
                view,
                "$name se agregó a FoodLab",
                Snackbar.LENGTH_LONG
            ).setAction("Preparar") {
                (requireActivity() as MainActivity)
                    .openFragment(ActionsFragment())
            }.show()
        }
    }

    private fun clearErrors(vararg layouts: TextInputLayout) {
        layouts.forEach {
            it.error = null
            it.isErrorEnabled = false
        }
    }
}