package mx.ipn.escom.foodlab.views.ui

import mx.ipn.escom.foodlab.views.model.CatalogRecipe

object CatalogData {

    fun recipes(): MutableList<CatalogRecipe> =
        mutableListOf(
            CatalogRecipe(1, "Tacos de pollo", "Mexicana", "35 min"),
            CatalogRecipe(2, "Ensalada fresca", "Ensaladas", "15 min"),
            CatalogRecipe(3, "Sopa de verduras", "Sopas", "40 min"),
            CatalogRecipe(4, "Pizza casera", "Italiana", "50 min"),
            CatalogRecipe(5, "Pasta con vegetales", "Pastas", "30 min"),
            CatalogRecipe(6, "Hamburguesa casera", "Comida rápida", "35 min"),
            CatalogRecipe(7, "Hot cakes con fruta", "Desayuno", "20 min"),
            CatalogRecipe(8, "Huevos con verduras", "Desayuno", "18 min"),
            CatalogRecipe(9, "Chilaquiles verdes", "Desayuno", "30 min"),
            CatalogRecipe(10, "Brownies", "Postres", "45 min"),
            CatalogRecipe(11, "Pastel de chocolate", "Postres", "60 min"),
            CatalogRecipe(12, "Gelatina de frutas", "Postres", "25 min"),
            CatalogRecipe(13, "Quesadillas", "Mexicana", "15 min"),
            CatalogRecipe(14, "Arroz con verduras", "Casera", "35 min"),
            CatalogRecipe(15, "Sándwich de pollo", "Casera", "20 min"),
            CatalogRecipe(16, "Tostadas de aguacate", "Saludable", "12 min")
        )
}