package mx.ipn.escom.foodlab.views.ui.catalog

import android.os.Bundle
import android.view.View
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetDialog
import mx.ipn.escom.foodlab.views.R
import mx.ipn.escom.foodlab.views.model.CatalogRecipe
import mx.ipn.escom.foodlab.views.ui.CatalogData
import mx.ipn.escom.foodlab.views.ui.RecipeAdapter

class RecipeGridFragment :
    Fragment(R.layout.fragment_recipe_grid) {

    override fun onViewCreated(
        view: View,
        savedInstanceState: Bundle?
    ) {
        super.onViewCreated(view, savedInstanceState)

        val recycler =
            view.findViewById<RecyclerView>(
                R.id.recyclerGrid
            )

        recycler.layoutManager =
            GridLayoutManager(
                requireContext(),
                2
            )

        recycler.adapter =
            RecipeAdapter(
                CatalogData.recipes()
            ) {
                showDetail(it)
            }
    }

    private fun showDetail(recipe: CatalogRecipe) {

        val dialog =
            BottomSheetDialog(requireContext())

        val text = TextView(requireContext()).apply {

            setPadding(48, 40, 48, 48)

            this.text =
                "${recipe.name}\n\n" +
                        "${recipe.category}\n" +
                        recipe.time

            textSize = 18f
        }

        dialog.setContentView(text)
        dialog.show()
    }
}