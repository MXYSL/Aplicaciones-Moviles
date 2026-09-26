class RecipeHelper {
  static String getImage({
    required String name,
    required String category,
    required List<String> ingredients,
  }) {
    final text = [name, category, ...ingredients].join(' ').toLowerCase();

    if (text.contains('pasta') && text.contains('pollo')) {
      return 'assets/images/pasta_pollo.png';
    }

    if (text.contains('pasta')) {
      return 'assets/images/pasta.png';
    }

    if (text.contains('ensalada')) {
      return 'assets/images/ensalada.png';
    }

    if (text.contains('sopa')) {
      return 'assets/images/sopa.png';
    }

    if (text.contains('taco')) {
      return 'assets/images/tacos.png';
    }

    if (text.contains('pizza')) {
      return 'assets/images/pizza.png';
    }

    if (text.contains('hamburguesa')) {
      return 'assets/images/hamburguesa.png';
    }

    if (text.contains('postre') ||
        text.contains('pastel') ||
        text.contains('chocolate')) {
      return 'assets/images/postre.png';
    }

    if (text.contains('desayuno') ||
        text.contains('huevo') ||
        text.contains('hotcake')) {
      return 'assets/images/desayuno.png';
    }

    return 'assets/images/receta_generica.png';
  }

  static List<String> getSteps({
    required String name,
    required String category,
    required List<String> ingredients,
  }) {
    final text = [name, category, ...ingredients].join(' ').toLowerCase();

    if (text.contains('pasta')) {
      return [
        'Prepara todos los ingredientes y corta los vegetales o acompañamientos.',
        'Hierve suficiente agua con una pizca de sal y cocina la pasta hasta que esté al dente.',
        'Calienta una sartén y cocina los vegetales, pollo u otros ingredientes principales.',
        'Agrega la pasta cocida a la sartén y mezcla todos los ingredientes.',
        'Ajusta la sazón, agrega el queso o complemento final y prepara el platillo para servir.',
      ];
    }

    if (text.contains('ensalada')) {
      return [
        'Lava y desinfecta todos los ingredientes.',
        'Corta los vegetales y demás ingredientes en porciones pequeñas.',
        'Coloca los ingredientes en un recipiente amplio.',
        'Agrega el aderezo y mezcla cuidadosamente.',
        'Sirve la ensalada y agrega los complementos finales.',
      ];
    }

    if (text.contains('sopa')) {
      return [
        'Lava, corta y prepara todos los ingredientes.',
        'Calienta una olla y cocina los ingredientes base.',
        'Agrega agua o caldo y mezcla cuidadosamente.',
        'Cocina a fuego medio hasta que todos los ingredientes estén suaves.',
        'Ajusta la sazón y sirve la sopa caliente.',
      ];
    }

    if (text.contains('taco')) {
      return [
        'Prepara y corta todos los ingredientes.',
        'Cocina el relleno principal hasta alcanzar el punto deseado.',
        'Calienta las tortillas.',
        'Distribuye el relleno sobre cada tortilla.',
        'Agrega los complementos y sirve los tacos calientes.',
      ];
    }

    if (text.contains('pizza')) {
      return [
        'Prepara la masa y los ingredientes que utilizarás.',
        'Extiende la masa hasta obtener el tamaño deseado.',
        'Agrega salsa, queso y los ingredientes seleccionados.',
        'Hornea la pizza hasta que la masa esté cocida y el queso se derrita.',
        'Retira del horno, corta en porciones y sirve.',
      ];
    }

    if (text.contains('hamburguesa')) {
      return [
        'Prepara la carne y los demás ingredientes.',
        'Cocina la carne hasta alcanzar el término deseado.',
        'Calienta ligeramente el pan.',
        'Coloca la carne, vegetales y complementos sobre el pan.',
        'Cierra la hamburguesa y sírvela acompañada de tu guarnición.',
      ];
    }

    if (text.contains('postre') ||
        text.contains('pastel') ||
        text.contains('chocolate')) {
      return [
        'Organiza y mide todos los ingredientes.',
        'Prepara la mezcla siguiendo las cantidades de la receta.',
        'Coloca la preparación en el recipiente correspondiente.',
        'Cocina, hornea o refrigera según el tipo de postre.',
        'Decora el postre y déjalo listo para servir.',
      ];
    }

    if (text.contains('desayuno') ||
        text.contains('huevo') ||
        text.contains('hotcake')) {
      return [
        'Prepara todos los ingredientes del desayuno.',
        'Calienta la sartén o utensilio que utilizarás.',
        'Cocina los ingredientes principales.',
        'Agrega los acompañamientos seleccionados.',
        'Sirve inmediatamente mientras está caliente.',
      ];
    }

    return [
      'Organiza y prepara todos los ingredientes.',
      'Lava, corta o mide los ingredientes según sea necesario.',
      'Cocina los ingredientes principales de la receta.',
      'Integra todos los ingredientes y ajusta la sazón.',
      'Realiza los últimos detalles y prepara el platillo para servir.',
    ];
  }
}
