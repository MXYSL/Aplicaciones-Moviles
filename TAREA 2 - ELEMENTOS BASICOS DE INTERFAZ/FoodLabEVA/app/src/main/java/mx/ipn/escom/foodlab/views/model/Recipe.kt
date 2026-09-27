package mx.ipn.escom.foodlab.views.model

data class Recipe(
    val id: Long = System.currentTimeMillis(),
    var name: String,
    var email: String,
    var phone: String,
    var password: String,
    var portions: Int,
    var ingredients: MutableList<String>,
    var category: String,
    var isFavorite: Boolean = false,
    var isSaved: Boolean = false,
    var isFinished: Boolean = false
)