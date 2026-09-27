//Seccion 6: Estructura de la aplicación
import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../state/recipe_store.dart';
import 'collections_screen.dart';
import 'text_input_screen.dart';

class StructureScreen extends StatefulWidget {
  const StructureScreen({super.key});

  @override
  State<StructureScreen> createState() => _StructureScreenState();
}

class _StructureScreenState extends State<StructureScreen> {
  final RecipeStore _store = RecipeStore.instance;

  int _selectedDestination = 0;

  void _openNewRecipe() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TextInputScreen()),
    );
  }

  void _openRecipes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CollectionsScreen()),
    );
  }

  void _openSearch() {
    showSearch<void>(
      context: context,
      delegate: _RecipeSearchDelegate(recipes: _store.recipes),
    );
  }

  void _openFavorites() {
    final favorites = _store.recipes
        .where((recipe) => recipe.isFavorite)
        .toList();

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Tus favoritas',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  favorites.isEmpty
                      ? 'Todavía no has marcado recetas como favoritas.'
                      : '${favorites.length} recetas guardadas como favoritas.',
                ),
                const SizedBox(height: 18),
                if (favorites.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.favorite_border_rounded, size: 60),
                          SizedBox(height: 12),
                          Text(
                            'Marca una receta como favorita desde FoodLab.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: favorites.length,
                      separatorBuilder: (_, _) => const Divider(),
                      itemBuilder: (context, index) {
                        final recipe = favorites[index];

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              recipe.imagePath,
                              width: 54,
                              height: 54,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(recipe.name),
                          subtitle: Text(
                            '${recipe.category} • '
                            '${recipe.portions} porciones',
                          ),
                          trailing: IconButton(
                            tooltip: 'Quitar de favoritos',
                            onPressed: () {
                              _store.toggleFavorite(recipe.id);

                              Navigator.pop(context);

                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${recipe.name} ya no está en favoritos',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.favorite_rounded),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openProfile() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  child: Icon(
                    Icons.person_rounded,
                    size: 42,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Mi espacio FoodLab',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Organiza tus recetas y preferencias.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),
                ListTile(
                  leading: const Icon(Icons.menu_book_rounded),
                  title: const Text('Recetas creadas'),
                  trailing: Text('${_store.recipes.length}'),
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_rounded),
                  title: const Text('Recetas favoritas'),
                  trailing: Text(
                    '${_store.recipes.where((recipe) => recipe.isFavorite).length}',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleBottomNavigation(int index) {
    setState(() {
      _selectedDestination = index;
    });

    switch (index) {
      case 0:
        Navigator.pop(context);
        break;

      case 1:
        _openRecipes();
        break;

      case 2:
        _openProfile();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diseño de FoodLab'),
        actions: [
          IconButton(
            tooltip: 'Buscar recetas',
            onPressed: _openSearch,
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            tooltip: 'Favoritos',
            onPressed: _openFavorites,
            icon: const Icon(Icons.favorite_border_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Así se organiza FoodLab',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Accede rápidamente a tus recetas y organiza '
              'la información de tu cocina.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 28),

            const _SectionTitle(
              title: 'Acciones rápidas',
              description: 'Accede a las funciones principales sin salir de esta pantalla.',
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.add_rounded,
                        label: 'Nueva',
                        onTap: _openNewRecipe,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.search_rounded,
                        label: 'Buscar',
                        onTap: _openSearch,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.favorite_border_rounded,
                        label: 'Favoritas',
                        onTap: _openFavorites,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            const _SectionTitle(
              title: 'Receta destacada',
              description: 'Una propuesta para preparar hoy.',
            ),

            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                height: 230,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/pasta_pollo.png',
                      fit: BoxFit.cover,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.78),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      right: 18,
                      bottom: 18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'RECOMENDACIÓN DEL DÍA',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Pasta cremosa con pollo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: _openRecipes,
                            icon: const Icon(Icons.restaurant_menu_rounded),
                            label: const Text('Explorar recetas'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            const _SectionTitle(
              title: 'Plan del día',
              description:
                  'Sigue un orden sencillo desde la elección hasta servir.',
            ),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  children: [
                    _PlanStep(
                      number: '1',
                      title: 'Elegir receta',
                      description: 'Selecciona lo que quieres preparar.',
                    ),
                    _StepDivider(),
                    _PlanStep(
                      number: '2',
                      title: 'Revisar ingredientes',
                      description: 'Comprueba que tengas todo lo necesario.',
                    ),
                    _StepDivider(),
                    _PlanStep(
                      number: '3',
                      title: 'Preparar',
                      description: 'Sigue las instrucciones paso a paso.',
                    ),
                    _StepDivider(),
                    _PlanStep(
                      number: '4',
                      title: 'Servir',
                      description: 'Presenta el platillo y disfruta.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            const _SectionTitle(
              title: 'Distribución nutricional',
              description:
                  'Una referencia visual de la composición del platillo.',
            ),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ejemplo por porción',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: _NutritionBlock(
                            value: '50%',
                            label: 'Vegetales',
                            icon: Icons.eco_rounded,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: _NutritionBlock(
                            value: '30%',
                            label: 'Proteína',
                            icon: Icons.egg_alt_outlined,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: _NutritionBlock(
                            value: '20%',
                            label: 'Otros',
                            icon: Icons.grain_rounded,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(flex: 5, child: _ProportionBar()),
                        SizedBox(width: 4),
                        Expanded(flex: 3, child: _ProportionBar()),
                        SizedBox(width: 4),
                        Expanded(flex: 2, child: _ProportionBar()),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            const _SectionTitle(
              title: 'Organiza tu cocina',
              description:
                  'Consulta rápidamente la información de preparación.',
            ),

            const Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.timer_outlined,
                    value: '35 min',
                    label: 'Preparación',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    icon: Icons.people_outline_rounded,
                    value: '4',
                    label: 'Porciones',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.local_fire_department_outlined,
                    value: '420',
                    label: 'Calorías',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    icon: Icons.star_outline_rounded,
                    value: '4.8',
                    label: 'Valoración',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const _SectionTitle(
              title: 'Tu espacio',
              description: 'Accede a las áreas principales de FoodLab.',
            ),

            Row(
              children: [
                Expanded(
                  child: _AdaptiveCard(
                    icon: Icons.menu_book_rounded,
                    title: 'Recetas',
                    description: 'Consulta tu colección.',
                    onTap: _openRecipes,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _AdaptiveCard(
                    icon: Icons.favorite_outline_rounded,
                    title: 'Favoritas',
                    description: 'Revisa las recetas que guardaste.',
                    onTap: _openFavorites,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedDestination,
        onDestinationSelected: _handleBottomNavigation,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Recetas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class _RecipeSearchDelegate extends SearchDelegate<void> {
  final List<Recipe> recipes;

  _RecipeSearchDelegate({required this.recipes});

  @override
  String get searchFieldLabel => 'Buscar receta';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          tooltip: 'Limpiar',
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear_rounded),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Regresar',
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  List<Recipe> _results() {
    final text = query.trim().toLowerCase();

    if (text.isEmpty) {
      return recipes;
    }

    return recipes.where((recipe) {
      return recipe.name.toLowerCase().contains(text) ||
          recipe.category.toLowerCase().contains(text) ||
          recipe.ingredients.any(
            (ingredient) => ingredient.toLowerCase().contains(text),
          );
    }).toList();
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildRecipeList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildRecipeList(context);
  }

  Widget _buildRecipeList(BuildContext context) {
    final results = _results();

    if (recipes.isEmpty) {
      return const _SearchEmptyState(
        icon: Icons.menu_book_outlined,
        title: 'Todavía no tienes recetas',
        message: 'Crea una receta para comenzar a utilizar la búsqueda.',
      );
    }

    if (results.isEmpty) {
      return const _SearchEmptyState(
        icon: Icons.search_off_rounded,
        title: 'Sin resultados',
        message: 'Prueba buscando otro nombre, categoría o ingrediente.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final recipe = results[index];

        return Card(
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                recipe.imagePath,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(recipe.name),
            subtitle: Text(
              '${recipe.category} • '
              '${recipe.portions} porciones',
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              _showRecipe(context, recipe);
            },
          ),
        );
      },
    );
  }

  void _showRecipe(BuildContext context, Recipe recipe) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    recipe.imagePath,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  recipe.name,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  '${recipe.category} • '
                  '${recipe.portions} porciones',
                ),
                const SizedBox(height: 16),
                Text('${recipe.ingredients.length} ingredientes'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _SearchEmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 70, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 7),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _PlanStep({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            number,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              Text(description),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepDivider extends StatelessWidget {
  const _StepDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(),
    );
  }
}

class _NutritionBlock extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _NutritionBlock({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ProportionBar extends StatelessWidget {
  const _ProportionBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 9,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _InfoCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _AdaptiveCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _AdaptiveCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(
                icon,
                size: 34,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    Text(description),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String description;

  const _SectionTitle({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(description),
        ],
      ),
    );
  }
}
