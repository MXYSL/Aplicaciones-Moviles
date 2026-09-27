package mx.ipn.escom.foodlab.views.ui

import android.os.Bundle
import android.view.View
import android.widget.ArrayAdapter
import android.widget.AutoCompleteTextView
import android.widget.RadioGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import com.google.android.material.button.MaterialButton
import com.google.android.material.checkbox.MaterialCheckBox
import com.google.android.material.datepicker.MaterialDatePicker
import com.google.android.material.materialswitch.MaterialSwitch
import com.google.android.material.slider.RangeSlider
import com.google.android.material.slider.Slider
import com.google.android.material.snackbar.Snackbar
import com.google.android.material.timepicker.MaterialTimePicker
import com.google.android.material.timepicker.TimeFormat
import mx.ipn.escom.foodlab.views.R
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class SelectionFragment : Fragment(R.layout.fragment_selection) {

    private var selectedDate = "Sin fecha"
    private var selectedTime = "Sin hora"

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val checkVegetables =
            view.findViewById<MaterialCheckBox>(R.id.checkVegetables)

        val radioMeal =
            view.findViewById<RadioGroup>(R.id.radioMeal)

        val switchVegetarian =
            view.findViewById<MaterialSwitch>(R.id.switchVegetarian)

        val sliderPortions =
            view.findViewById<Slider>(R.id.sliderPortions)

        val rangeTime =
            view.findViewById<RangeSlider>(R.id.rangeTime)

        val textPortions =
            view.findViewById<TextView>(R.id.textPortions)

        val textTime =
            view.findViewById<TextView>(R.id.textTime)

        val autoCuisine =
            view.findViewById<AutoCompleteTextView>(R.id.autoCuisine)

        val btnDate =
            view.findViewById<MaterialButton>(R.id.btnDate)

        val btnTime =
            view.findViewById<MaterialButton>(R.id.btnTime)

        view.findViewById<View>(R.id.btnBack).setOnClickListener {
            parentFragmentManager.popBackStack()
        }

        // Checkbox con tres estados:
        // indeterminado -> marcado -> desmarcado.
        checkVegetables.checkedState =
            MaterialCheckBox.STATE_INDETERMINATE

        checkVegetables.setOnClickListener {
            checkVegetables.checkedState =
                when (checkVegetables.checkedState) {
                    MaterialCheckBox.STATE_INDETERMINATE ->
                        MaterialCheckBox.STATE_CHECKED

                    MaterialCheckBox.STATE_CHECKED ->
                        MaterialCheckBox.STATE_UNCHECKED

                    else ->
                        MaterialCheckBox.STATE_INDETERMINATE
                }
        }

        val cuisines = listOf(
            "Mexicana",
            "Italiana",
            "Mediterránea",
            "Asiática",
            "Casera",
            "Vegetariana"
        )

        autoCuisine.setAdapter(
            ArrayAdapter(
                requireContext(),
                android.R.layout.simple_dropdown_item_1line,
                cuisines
            )
        )

        sliderPortions.addOnChangeListener { _, value, _ ->
            textPortions.text =
                "Porciones: ${value.toInt()}"
        }

        rangeTime.addOnChangeListener { slider, _, _ ->

            val values = slider.values

            if (values.size >= 2) {
                textTime.text =
                    "Tiempo de preparación: " +
                            "${values[0].toInt()} - " +
                            "${values[1].toInt()} min"
            }
        }

        btnDate.setOnClickListener {

            val picker =
                MaterialDatePicker.Builder
                    .datePicker()
                    .setTitleText("¿Cuándo cocinarás?")
                    .build()

            picker.addOnPositiveButtonClickListener { selection ->

                val formatter = SimpleDateFormat(
                    "dd/MM/yyyy",
                    Locale("es", "MX")
                )

                selectedDate =
                    formatter.format(Date(selection))

                btnDate.text = selectedDate
            }

            picker.show(
                parentFragmentManager,
                "foodlab_date"
            )
        }

        btnTime.setOnClickListener {

            val picker =
                MaterialTimePicker.Builder()
                    .setTimeFormat(TimeFormat.CLOCK_24H)
                    .setHour(14)
                    .setMinute(0)
                    .setTitleText("¿A qué hora cocinarás?")
                    .build()

            picker.addOnPositiveButtonClickListener {

                selectedTime = String.format(
                    Locale.getDefault(),
                    "%02d:%02d",
                    picker.hour,
                    picker.minute
                )

                btnTime.text = selectedTime
            }

            picker.show(
                parentFragmentManager,
                "foodlab_time"
            )
        }

        view.findViewById<View>(R.id.btnApplyPreferences)
            .setOnClickListener {

                val meal = when (radioMeal.checkedRadioButtonId) {
                    R.id.radioBreakfast -> "Desayuno"
                    R.id.radioDinner -> "Cena"
                    else -> "Comida"
                }

                val vegetarian =
                    if (switchVegetarian.isChecked) {
                        "vegetariano"
                    } else {
                        "general"
                    }

                val portions =
                    sliderPortions.value.toInt()

                Snackbar.make(
                    view,
                    "$meal · $vegetarian · $portions porciones · " +
                            "$selectedDate · $selectedTime",
                    Snackbar.LENGTH_LONG
                ).show()
            }
    }
}