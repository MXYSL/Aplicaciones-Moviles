// Screen 4 Colecciones y listas
import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../state/recipe_store.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen>
    with SingleTickerProviderStateMixin {
  final RecipeStore _store = RecipeStore.instance;

  late final TabController _tabController;

  final Set<String> _deletedDemoRecipes = {};

  final List<_DemoRecipe> _demoRecipes = const [
    _DemoRecipe(
      id: 'demo-01',
      name: 'Pasta al parmesano',
      category: 'Pasta',
      imagePath: 'assets/images/pasta.png',
      portions: 4,
      time: 25,
      featured: true,
    ),
    _DemoRecipe(
      id: 'demo-02',
      name: 'Ensalada fresca',
      category: 'Ensalada',
      imagePath: 'assets/images/ensalada.png',
      portions: 2,
      time: 15,
      featured: true,
    ),
    _DemoRecipe(
      id: 'demo-03',
      name: 'Sopa casera',
      category: 'Sopa',
      imagePath: 'assets/images/sopa.png',
      portions: 4,
      time: 45,
    ),
    _DemoRecipe(
      id: 'demo-04',
      name: 'Tacos tradicionales',
      category: 'Tacos',
      imagePath: 'assets/images/tacos.png',
      portions: 4,
      time: 30,
      featured: true,
    ),
    _DemoRecipe(
      id: 'demo-05',
      name: 'Pizza margarita',
      category: 'Pizza',
      imagePath: 'assets/images/pizza.png',
      portions: 4,
      time: 50,
    ),
    _DemoRecipe(
      id: 'demo-06',
      name: 'Hamburguesa clásica',
      category: 'Hamburguesa',
      imagePath: 'assets/images/hamburguesa.png',
      portions: 2,
      time: 35,
    ),
    _DemoRecipe(
      id: 'demo-07',
      name: 'Cheesecake con frutos rojos',
      category: 'Postre',
      imagePath: 'assets/images/postre.png',
      portions: 8,
      time: 60,
      featured: true,
    ),
    _DemoRecipe(
      id: 'demo-08',
      name: 'Desayuno completo',
      category: 'Desayuno',
      imagePath: 'assets/images/desayuno.png',
      portions: 2,
      time: 20,
    ),
    _DemoRecipe(
      id: 'demo-09',
      name: 'Pasta cremosa',
      category: 'Pasta',
      imagePath: 'assets/images/pasta.png',
      portions: 3,
      time: 30,
    ),
    _DemoRecipe(
      id: 'demo-10',
      name: 'Ensalada de temporada',
      category: 'Ensalada',
      imagePath: 'assets/images/ensalada.png',
      portions: 3,
      time: 15,
    ),
    _DemoRecipe(
      id: 'demo-11',
      name: 'Sopa de pollo',
      category: 'Sopa',
      imagePath: 'assets/images/sopa.png',
      portions: 5,
      time: 55,
    ),
    _DemoRecipe(
      id: 'demo-12',
      name: 'Tacos de pollo',
      category: 'Tacos',
      imagePath: 'assets/images/tacos.png',
      portions: 4,
      time: 35,
    ),
    _DemoRecipe(
      id: 'demo-13',
      name: 'Pizza de vegetales',
      category: 'Pizza',
      imagePath: 'assets/images/pizza.png',
      portions: 4,
      time: 45,
    ),
    _DemoRecipe(
      id: 'demo-14',
      name: 'Hamburguesa con vegetales',
      category: 'Hamburguesa',
      imagePath: 'assets/images/hamburguesa.png',
      portions: 2,
      time: 30,
    ),
    _DemoRecipe(
      id: 'demo-15',
      name: 'Postre de frutos rojos',
      category: 'Postre',
      imagePath: 'assets/images/postre.png',
      portions: 6,
      time: 40,
    ),
    _DemoRecipe(
      id: 'demo-16',
      name: 'Bowl especial FoodLab',
      category: 'Especial',
      imagePath: 'assets/images/receta_generica.png',
      portions: 2,
      time: 25,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_RecipeItem> get _allRecipes {
    final items = <_RecipeItem>[];

    for (final recipe in _store.recipes.reversed) {
      items.add(
        _RecipeItem(
          id: recipe.id,
          name: recipe.name,
          category: recipe.category,
          imagePath: recipe.imagePath,
          portions: recipe.portions,
          time: 30,
          isUserRecipe: true,
          recipe: recipe,
        ),
      );
    }

    for (final recipe in _demoRecipes) {
      if (_deletedDemoRecipes.contains(recipe.id)) {
        continue;
      }

      items.add(
        _RecipeItem(
          id: recipe.id,
          name: recipe.name,
          category: recipe.category,
          imagePath: recipe.imagePath,
          portions: recipe.portions,
          time: recipe.time,
          featured: recipe.featured,
        ),
      );
    }

    return items;
  }

  Future<void> _refreshRecipes() async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Catálogo actualizado')));
  }

  void _deleteRecipe(_RecipeItem item) {
    if (item.isUserRecipe) {
      _store.removeRecipe(item.id);
    } else {
      setState(() {
        _deletedDemoRecipes.add(item.id);
      });
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${item.name} eliminada del catálogo'),
          action: item.isUserRecipe
              ? null
              : SnackBarAction(
                  label: 'Deshacer',
                  onPressed: () {
                    setState(() {
                      _deletedDemoRecipes.remove(item.id);
                    });
                  },
                ),
        ),
      );
  }

  void _showRecipeDetail(_RecipeItem item) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset(
                    item.imagePath,
                    width: double.infinity,
                    height: 230,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.category} • '
                  '${item.portions} porciones • '
                  '${item.time} min',
                ),
                if (item.isUserRecipe && item.recipe != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Ingredientes',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  for (final ingredient in item.recipe!.ingredients)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 19,
                          ),
                          const SizedBox(width: 9),
                          Expanded(child: Text(ingredient)),
                        ],
                      ),
                    ),
                ] else ...[
                  const SizedBox(height: 20),
                  const Text(
                    'Explora esta receta como parte del catálogo de FoodLab.',
                  ),
                ],
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cerrar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, child) {
        final recipes = _allRecipes;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Explora recetas'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.view_list_rounded), text: 'Recetas'),
                Tab(icon: Icon(Icons.grid_view_rounded), text: 'Galería'),
                Tab(
                  icon: Icon(Icons.restaurant_menu_rounded),
                  text: 'Colecciones',
                ),
              ],
            ),
          ),
          body: recipes.isEmpty
              ? _EmptyCatalog(
                  onRefresh: () {
                    setState(() {
                      _deletedDemoRecipes.clear();
                    });
                  },
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildListTab(recipes),
                    _buildGridTab(recipes),
                    _buildCollectionsTab(recipes),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildListTab(List<_RecipeItem> recipes) {
    return RefreshIndicator(
      onRefresh: _refreshRecipes,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
        children: [
          Text(
            'Todas las recetas',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            '${recipes.length} recetas disponibles. '
            'Desliza una hacia la izquierda para eliminarla.',
          ),
          const SizedBox(height: 18),

          if (_store.recipes.isNotEmpty) ...[
            _ListSectionHeader(
              icon: Icons.person_outline_rounded,
              title: 'Tus recetas',
              subtitle: '${_store.recipes.length} creadas en FoodLab',
            ),
            const SizedBox(height: 8),

            for (final item in recipes.where((item) => item.isUserRecipe))
              _DismissibleRecipe(
                item: item,
                onDelete: () {
                  _deleteRecipe(item);
                },
                onTap: () {
                  _showRecipeDetail(item);
                },
              ),

            const SizedBox(height: 18),
          ],

          const _ListSectionHeader(
            icon: Icons.auto_awesome_outlined,
            title: 'Descubre nuevas ideas',
            subtitle: 'Recetas disponibles en el catálogo',
          ),
          const SizedBox(height: 8),

          for (final item in recipes.where((item) => !item.isUserRecipe))
            _DismissibleRecipe(
              item: item,
              onDelete: () {
                _deleteRecipe(item);
              },
              onTap: () {
                _showRecipeDetail(item);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildGridTab(List<_RecipeItem> recipes) {
    return RefreshIndicator(
      onRefresh: _refreshRecipes,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: recipes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          final item = recipes[index];

          return _RecipeGridCard(
            item: item,
            onTap: () {
              _showRecipeDetail(item);
            },
          );
        },
      ),
    );
  }

  Widget _buildCollectionsTab(List<_RecipeItem> recipes) {
    final breakfast = recipes.where(
      (recipe) =>
          recipe.category.toLowerCase() == 'desayuno' ||
          recipe.name.toLowerCase().contains('desayuno'),
    );

    final desserts = recipes.where(
      (recipe) =>
          recipe.category.toLowerCase() == 'postre' ||
          recipe.name.toLowerCase().contains('postre') ||
          recipe.name.toLowerCase().contains('cheesecake'),
    );

    final featured = recipes.where(
      (recipe) => recipe.featured || recipe.isUserRecipe,
    );

    return RefreshIndicator(
      onRefresh: _refreshRecipes,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
        children: [
          Text(
            'Colecciones FoodLab',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            'Encuentra recetas organizadas según el momento y el tipo de platillo.',
          ),

          const SizedBox(height: 26),

          _CollectionSection(
            title: 'Para comenzar el día',
            subtitle: 'Ideas para preparar un desayuno.',
            icon: Icons.free_breakfast_rounded,
            recipes: breakfast.toList(),
            onTap: _showRecipeDetail,
          ),

          const SizedBox(height: 28),

          _CollectionSection(
            title: 'Algo dulce',
            subtitle: 'Postres para terminar la comida.',
            icon: Icons.cake_outlined,
            recipes: desserts.toList(),
            onTap: _showRecipeDetail,
          ),

          const SizedBox(height: 28),

          _CollectionSection(
            title: 'Recomendaciones',
            subtitle: 'Una selección para explorar FoodLab.',
            icon: Icons.star_outline_rounded,
            recipes: featured.toList(),
            onTap: _showRecipeDetail,
          ),
        ],
      ),
    );
  }
}

class _DismissibleRecipe extends StatelessWidget {
  final _RecipeItem item;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _DismissibleRecipe({
    required this.item,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: ValueKey(item.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            Icons.delete_outline_rounded,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
        onDismissed: (_) {
          onDelete();
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      item.imagePath,
                      width: 82,
                      height: 82,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(item.category),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            const Icon(Icons.schedule_rounded, size: 16),
                            const SizedBox(width: 4),
                            Text('${item.time} min'),
                            const SizedBox(width: 12),
                            const Icon(Icons.people_outline_rounded, size: 16),
                            const SizedBox(width: 4),
                            Text('${item.portions}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecipeGridCard extends StatelessWidget {
  final _RecipeItem item;
  final VoidCallback onTap;

  const _RecipeGridCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(item.imagePath, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                '${item.category} • ${item.time} min',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<_RecipeItem> recipes;
  final ValueChanged<_RecipeItem> onTap;

  const _CollectionSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.recipes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(subtitle),
        const SizedBox(height: 12),

        if (recipes.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const Icon(Icons.restaurant_menu_rounded),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Todavía no hay recetas en esta colección.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recipes.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = recipes[index];

                return SizedBox(
                  width: 155,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        onTap(item);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: Image.asset(
                                item.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              item.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _ListSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ListSectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyCatalog extends StatelessWidget {
  final VoidCallback onRefresh;

  const _EmptyCatalog({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 90,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Tu catálogo está vacío',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Agrega nuevas recetas o recupera las sugerencias de FoodLab.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Mostrar sugerencias'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeItem {
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final int portions;
  final int time;
  final bool featured;
  final bool isUserRecipe;
  final Recipe? recipe;

  const _RecipeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.portions,
    required this.time,
    this.featured = false,
    this.isUserRecipe = false,
    this.recipe,
  });
}

class _DemoRecipe {
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final int portions;
  final int time;
  final bool featured;

  const _DemoRecipe({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.portions,
    required this.time,
    this.featured = false,
  });
}
