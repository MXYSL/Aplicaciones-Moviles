package mx.ipn.escom.foodlab.views.ui
import mx.ipn.escom.foodlab.views.MainActivity
import android.os.Bundle
import android.view.View
import androidx.fragment.app.Fragment
import com.google.android.material.snackbar.Snackbar
import mx.ipn.escom.foodlab.views.R

class HomeFragment : Fragment(R.layout.fragment_home) {

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        view.findViewById<View>(R.id.cardFeatured).setOnClickListener {
            (requireActivity() as MainActivity)
                .openFragment(CollectionsFragment())
        }

        view.findViewById<View>(R.id.cardCreateRecipe).setOnClickListener {
            (requireActivity() as MainActivity)
                .openFragment(TextInputFragment())
        }

        view.findViewById<View>(R.id.cardActions).setOnClickListener {
            (requireActivity() as MainActivity)
                .openFragment(ActionsFragment())
        }

        view.findViewById<View>(R.id.cardCustomize).setOnClickListener {
            (requireActivity() as MainActivity)
                .openFragment(SelectionFragment())
        }

        view.findViewById<View>(R.id.cardExplore).setOnClickListener {
            (requireActivity() as MainActivity)
                .openFragment(CollectionsFragment())
        }

        view.findViewById<View>(R.id.cardProgress).setOnClickListener {
            showComingSoon(view, "Cocina en progreso")
        }

        view.findViewById<View>(R.id.cardDesign).setOnClickListener {
            showComingSoon(view, "Diseño de FoodLab")
        }
    }

    private fun showComingSoon(view: View, section: String) {
        Snackbar.make(
            view,
            "$section estará disponible en la siguiente etapa",
            Snackbar.LENGTH_SHORT
        ).show()
    }
}