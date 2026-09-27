package mx.ipn.escom.foodlab.views.ui.catalog

import android.os.Bundle
import android.view.View
import android.widget.TextView
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.snackbar.Snackbar
import mx.ipn.escom.foodlab.views.R
import mx.ipn.escom.foodlab.views.model.CatalogRecipe
import mx.ipn.escom.foodlab.views.ui.CatalogData
import mx.ipn.escom.foodlab.views.ui.RecipeAdapter

class RecipeListFragment :
    Fragment(R.layout.fragment_recipe_list) {

    private lateinit var recipes: MutableList<CatalogRecipe>
    private lateinit var adapter: RecipeAdapter
    private lateinit var recycler: RecyclerView
    private lateinit var emptyState: View

    override fun onViewCreated(
        view: View,
        savedInstanceState: Bundle?
    ) {
        super.onViewCreated(view, savedInstanceState)

        recycler =
            view.findViewById(R.id.recyclerRecipes)

        emptyState =
            view.findViewById(R.id.emptyState)

        val swipeRefresh =
            view.findViewById<SwipeRefreshLayout>(
                R.id.swipeRefresh
            )

        recipes = CatalogData.recipes()

        adapter = RecipeAdapter(recipes) {
            showRecipeDetail(it)
        }

        recycler.layoutManager =
            LinearLayoutManager(requireContext())

        recycler.adapter = adapter

        val touchHelper = ItemTouchHelper(
            object : ItemTouchHelper.SimpleCallback(
                0,
                ItemTouchHelper.LEFT or ItemTouchHelper.RIGHT
            ) {

                override fun onMove(
                    recyclerView: RecyclerView,
                    viewHolder: RecyclerView.ViewHolder,
                    target: RecyclerView.ViewHolder
                ): Boolean = false

                override fun onSwiped(
                    viewHolder: RecyclerView.ViewHolder,
                    direction: Int
                ) {

                    val position =
                        viewHolder.bindingAdapterPosition

                    val removed =
                        adapter.removeAt(position)

                    updateEmptyState()

                    Snackbar.make(
                        view,
                        "${removed.name} eliminada",
                        Snackbar.LENGTH_LONG
                    ).setAction("Deshacer") {

                        adapter.restore(
                            removed,
                            position
                        )

                        updateEmptyState()
                    }.show()
                }
            }
        )

        touchHelper.attachToRecyclerView(recycler)

        swipeRefresh.setOnRefreshListener {

            recipes.clear()
            recipes.addAll(CatalogData.recipes())

            adapter.notifyDataSetChanged()

            updateEmptyState()

            swipeRefresh.isRefreshing = false

            Snackbar.make(
                view,
                "Catálogo actualizado",
                Snackbar.LENGTH_SHORT
            ).show()
        }

        updateEmptyState()
    }

    private fun updateEmptyState() {
        emptyState.isVisible = recipes.isEmpty()
        recycler.isVisible = recipes.isNotEmpty()
    }

    private fun showRecipeDetail(
        recipe: CatalogRecipe
    ) {

        val dialog =
            BottomSheetDialog(requireContext())

        val text = TextView(requireContext()).apply {
            setPadding(48, 40, 48, 48)

            text =
                "${recipe.name}\n\n" +
                        "${recipe.category}\n" +
                        "${recipe.time}\n\n" +
                        "Seleccionaste esta receta para consultar sus detalles."

            textSize = 18f
        }

        dialog.setContentView(text)
        dialog.show()
    }
}