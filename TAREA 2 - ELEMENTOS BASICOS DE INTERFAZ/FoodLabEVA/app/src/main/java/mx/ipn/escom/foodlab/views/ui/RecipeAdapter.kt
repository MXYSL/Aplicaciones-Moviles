package mx.ipn.escom.foodlab.views.ui

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import mx.ipn.escom.foodlab.views.R
import mx.ipn.escom.foodlab.views.model.CatalogRecipe

class RecipeAdapter(
    private val recipes: MutableList<CatalogRecipe>,
    private val onClick: (CatalogRecipe) -> Unit
) : RecyclerView.Adapter<RecipeAdapter.RecipeViewHolder>() {

    class RecipeViewHolder(view: View) :
        RecyclerView.ViewHolder(view) {

        val name: TextView =
            view.findViewById(R.id.textRecipeName)

        val category: TextView =
            view.findViewById(R.id.textRecipeCategory)

        val time: TextView =
            view.findViewById(R.id.textRecipeTime)
    }

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): RecipeViewHolder {

        val view = LayoutInflater
            .from(parent.context)
            .inflate(
                R.layout.item_recipe,
                parent,
                false
            )

        return RecipeViewHolder(view)
    }

    override fun onBindViewHolder(
        holder: RecipeViewHolder,
        position: Int
    ) {

        val recipe = recipes[position]

        holder.name.text = recipe.name
        holder.category.text = recipe.category
        holder.time.text = recipe.time

        holder.itemView.setOnClickListener {
            onClick(recipe)
        }
    }

    override fun getItemCount(): Int =
        recipes.size

    fun removeAt(position: Int): CatalogRecipe {
        val recipe = recipes.removeAt(position)
        notifyItemRemoved(position)
        return recipe
    }

    fun restore(
        recipe: CatalogRecipe,
        position: Int
    ) {
        recipes.add(position, recipe)
        notifyItemInserted(position)
    }
}