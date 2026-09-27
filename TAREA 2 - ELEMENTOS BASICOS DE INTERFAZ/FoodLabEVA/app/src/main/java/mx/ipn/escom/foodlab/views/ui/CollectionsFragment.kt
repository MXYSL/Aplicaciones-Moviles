package mx.ipn.escom.foodlab.views.ui

import android.os.Bundle
import android.view.View
import androidx.fragment.app.Fragment
import androidx.viewpager2.widget.ViewPager2
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import mx.ipn.escom.foodlab.views.R

class CollectionsFragment :
    Fragment(R.layout.fragment_collections) {

    override fun onViewCreated(
        view: View,
        savedInstanceState: Bundle?
    ) {
        super.onViewCreated(view, savedInstanceState)

        val tabs =
            view.findViewById<TabLayout>(
                R.id.tabLayout
            )

        val pager =
            view.findViewById<ViewPager2>(
                R.id.viewPager
            )

        pager.adapter =
            RecipePagerAdapter(this)

        TabLayoutMediator(
            tabs,
            pager
        ) { tab, position ->

            tab.text =
                when (position) {
                    0 -> "Recetas"
                    1 -> "Galería"
                    else -> "Colecciones"
                }

        }.attach()

        view.findViewById<View>(R.id.btnBack)
            .setOnClickListener {
                parentFragmentManager.popBackStack()
            }
    }
}