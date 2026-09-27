import 'dart:async';

import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../state/recipe_store.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final RecipeStore _store = RecipeStore.instance;

  double _progress = 0.35;
  bool _isCooking = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCooking() {
    _timer?.cancel();

    setState(() {
      _progress = 0;
      _isCooking = true;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _progress += 0.1;

        if (_progress >= 1) {
          _progress = 1;
          _isCooking = false;
          timer.cancel();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Preparación terminada!')),
          );
        }
      });
    });
  }

  void _showSavedMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Receta guardada correctamente'),
          action: SnackBarAction(
            label: 'Ver',
            onPressed: () {
              _showInfoDialog();
            },
          ),
        ),
      );
  }

  void _showUndoMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Ingrediente eliminado'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Ingrediente recuperado')),
                );
            },
          ),
        ),
      );
  }

  void _showToastStyleMessage() {
    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 24,
          right: 24,
          bottom: 90,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(blurRadius: 12, color: Colors.black26),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Cambios guardados',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2), () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }

  Future<void> _confirmDelete(Recipe? recipe) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.delete_outline_rounded),
          title: const Text('¿Eliminar esta receta?'),
          content: Text(
            recipe == null
                ? 'Esta acción quitará la receta seleccionada.'
                : 'Se eliminará "${recipe.name}" de tus recetas.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    if (recipe != null) {
      _store.removeRecipe(recipe.id);
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Receta eliminada')));
  }

  void _showIngredients(Recipe? recipe) {
    final ingredients =
        recipe?.ingredients ?? ['Pasta', 'Pollo', 'Crema', 'Ajo', 'Queso'];

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingredientes',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                ...ingredients.map((ingredient) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.check_circle_outline_rounded),
                    title: Text(ingredient),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showInfoDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.check_circle_outline_rounded),
          title: const Text('Todo listo'),
          content: const Text(
            'Los cambios de tu receta se guardaron '
            'correctamente en FoodLab.',
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, _) {
        final recipe = _store.latestRecipe;

        final favorites = _store.recipes
            .where((item) => item.isFavorite)
            .length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Cocina en progreso'),
            actions: [
              IconButton(
                tooltip: 'Guardar',
                onPressed: _showSavedMessage,
                icon: const Icon(Icons.bookmark_outline_rounded),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Prepara ',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'algo delicioso',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Consulta el avance de tu receta y recibe '
                'información mientras cocinas.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 24),

              _RecipeCard(recipe: recipe),

              const SizedBox(height: 28),

              Text(
                'Preparación',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _progress >= 1
                                  ? 'Receta terminada'
                                  : 'Progreso de tu receta',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            '${(_progress * 100).round()}%',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Progreso lineal determinado.
                      LinearProgressIndicator(
                        value: _progress,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      const SizedBox(height: 22),

                      // Progreso circular determinado.
                      Row(
                        children: [
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: CircularProgressIndicator(
                              value: _progress,
                              strokeWidth: 5,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _progress >= 1
                                  ? 'Tu receta está lista para servir.'
                                  : 'Continúa con la preparación.',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isCooking ? null : _startCooking,
                          icon: Icon(
                            _progress >= 1
                                ? Icons.refresh_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          label: Text(
                            _isCooking
                                ? 'Preparando...'
                                : _progress >= 1
                                ? 'Preparar de nuevo'
                                : 'Continuar preparación',
                          ),
                        ),
                      ),

                      if (_isCooking) ...[
                        const SizedBox(height: 22),

                        // Progreso lineal indeterminado.
                        const LinearProgressIndicator(),

                        const SizedBox(height: 16),

                        // Progreso circular indeterminado.
                        const Row(
                          children: [
                            SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text('Actualizando la preparación...'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Text(
                'Mientras esperas',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buscando nuevas ideas…',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'FoodLab está preparando '
                              'recomendaciones para tu próxima receta.',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Text(
                'Avisos',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _showToastStyleMessage,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Guardar cambios'),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: _showUndoMessage,
                        icon: const Icon(Icons.remove_circle_outline_rounded),
                        label: const Text('Quitar ingrediente'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Text(
                'Más información',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.restaurant_menu_rounded),
                      title: const Text('Ver ingredientes'),
                      subtitle: const Text(
                        'Consulta lo necesario para preparar el platillo.',
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_up_rounded),
                      onTap: () {
                        _showIngredients(recipe);
                      },
                    ),

                    const Divider(height: 1),

                    ListTile(
                      leading: const Icon(Icons.delete_outline_rounded),
                      title: const Text('Eliminar receta'),
                      subtitle: const Text(
                        'FoodLab pedirá confirmación antes de eliminarla.',
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        _confirmDelete(recipe);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Text(
                'Tu FoodLab',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.favorite_rounded,
                      value: '$favorites',
                      label: 'Favoritas',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Badge(
                      label: Text('${_store.recipes.length}'),
                      child: _SummaryCard(
                        icon: Icons.menu_book_rounded,
                        value: '${_store.recipes.length}',
                        label: 'Recetas',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Text(
                'Inspiración',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 190,
                      width: double.infinity,
                      child: Image.network(
                        'https://images.unsplash.com/'
                        'photo-1547592180-85f173990554'
                        '?auto=format&fit=crop&w=1000&q=80',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            alignment: Alignment.center,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 44,
                                ),
                                SizedBox(height: 8),
                                Text('No se pudo cargar la imagen'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Descubre nuevas combinaciones',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Prueba nuevos ingredientes y '
                            'encuentra ideas para tu próxima comida.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe? recipe;

  const _RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final imagePath = recipe?.imagePath ?? 'assets/images/pasta_pollo.png';

    final name = recipe?.name ?? 'Pasta cremosa con pollo';

    final category = recipe?.category ?? 'Comida';

    final portions = recipe?.portions ?? 4;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            height: 190,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.restaurant_rounded, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(category)),
                    const Icon(Icons.people_outline_rounded, size: 18),
                    const SizedBox(width: 6),
                    Text('$portions porciones'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 3),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
