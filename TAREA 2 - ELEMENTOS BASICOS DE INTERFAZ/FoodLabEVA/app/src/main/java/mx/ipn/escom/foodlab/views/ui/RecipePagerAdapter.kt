package mx.ipn.escom.foodlab.views.ui

import androidx.fragment.app.Fragment
import androidx.viewpager2.adapter.FragmentStateAdapter
import mx.ipn.escom.foodlab.views.ui.catalog.RecipeCollectionsFragment
import mx.ipn.escom.foodlab.views.ui.catalog.RecipeGridFragment
import mx.ipn.escom.foodlab.views.ui.catalog.RecipeListFragment

class RecipePagerAdapter(
    fragment: Fragment
) : FragmentStateAdapter(fragment) {

    override fun getItemCount(): Int = 3

    override fun createFragment(
        position: Int
    ): Fragment =
        when (position) {
            0 -> RecipeListFragment()
            1 -> RecipeGridFragment()
            else -> RecipeCollectionsFragment()
        }
}