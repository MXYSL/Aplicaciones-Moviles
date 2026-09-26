// Screen 2: Acciones de cocina
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/recipe.dart';
import '../state/recipe_store.dart';

class ActionsScreen extends StatefulWidget {
  const ActionsScreen({super.key});

  @override
  State<ActionsScreen> createState() => _ActionsScreenState();
}

class _ActionsScreenState extends State<ActionsScreen> {
  final RecipeStore _store = RecipeStore.instance;

  String _mode = 'Preparar';
  bool _isLoading = false;
  bool _preparationStarted = false;

  int _currentStep = 0;
  int _timerSeconds = 0;

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _message(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _toggleFavorite(Recipe recipe) {
    _store.toggleFavorite(recipe.id);

    _message(
      recipe.isFavorite
          ? 'Receta agregada a favoritos'
          : 'Receta eliminada de favoritos',
    );
  }

  Future<void> _addIngredient(Recipe recipe) async {
    final controller = TextEditingController();

    final ingredient = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Agregar ingrediente'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Ingrediente',
              hintText: 'Ej. 2 tomates',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final text = controller.text.trim();

                if (text.isNotEmpty) {
                  Navigator.pop(dialogContext, text);
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (ingredient == null) {
      return;
    }

    _store.addIngredient(recipe.id, ingredient);

    _message('$ingredient agregado');
  }

  Future<void> _shareRecipe(Recipe recipe) async {
    final text =
        '''
FoodLab - ${recipe.name}

Categoría: ${recipe.category}
Porciones: ${recipe.portions}

Ingredientes:
${recipe.ingredients.map((item) => '• $item').join('\n')}
''';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Compartir receta'),
          content: SingleChildScrollView(child: Text(text)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cerrar'),
            ),
            FilledButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: text));

                if (!dialogContext.mounted) return;

                Navigator.pop(dialogContext);

                _message('Receta copiada al portapapeles');
              },
              icon: const Icon(Icons.copy_rounded),
              label: const Text('Copiar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _startPreparation() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _preparationStarted = true;
      _currentStep = 0;
      _mode = 'Preparar';
    });

    _message('Preparación iniciada');
  }

  void _finishRecipe(Recipe recipe) {
    _store.markAsFinished(recipe.id);

    setState(() {
      _preparationStarted = false;
      _mode = 'Servir';
    });

    _message('¡${recipe.name} está lista para servir!');
  }

  Future<void> _configureTimer() async {
    int selectedMinutes = 5;

    final minutes = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Temporizador de cocina'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$selectedMinutes minutos',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: selectedMinutes.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    label: '$selectedMinutes min',
                    onChanged: (value) {
                      setDialogState(() {
                        selectedMinutes = value.round();
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, selectedMinutes);
                  },
                  child: const Text('Iniciar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (minutes == null) {
      return;
    }

    _timer?.cancel();

    setState(() {
      _timerSeconds = minutes * 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_timerSeconds <= 1) {
        timer.cancel();

        setState(() {
          _timerSeconds = 0;
        });

        _message('¡Tiempo terminado!');
      } else {
        setState(() {
          _timerSeconds--;
        });
      }
    });
  }

  String _formatTimer() {
    final minutes = _timerSeconds ~/ 60;
    final seconds = _timerSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, child) {
        final recipe = _store.latestRecipe;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Acciones de cocina'),
            actions: [
              if (recipe != null)
                IconButton(
                  tooltip: 'Favorito',
                  onPressed: () {
                    _toggleFavorite(recipe);
                  },
                  icon: Icon(
                    recipe.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                  ),
                ),
            ],
          ),
          floatingActionButton: recipe == null
              ? null
              : FloatingActionButton(
                  heroTag: 'addIngredient',
                  onPressed: () {
                    _addIngredient(recipe);
                  },
                  child: const Icon(Icons.add_rounded),
                ),
          body: recipe == null
              ? _EmptyRecipe(
                  onBack: () {
                    Navigator.pop(context);
                  },
                )
              : _buildRecipeContent(recipe),
        );
      },
    );
  }

  Widget _buildRecipeContent(Recipe recipe) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Cocina tu receta',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'Sigue la preparación y lleva tu platillo hasta el momento de servir.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),

        const SizedBox(height: 20),

        ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.asset(
            recipe.imagePath,
            height: 210,
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
        const SizedBox(height: 4),
        Text('${recipe.category} • ${recipe.portions} porciones'),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  _store.markAsSaved(recipe.id);
                  _message('Receta guardada');
                },
                icon: Icon(
                  recipe.isSaved ? Icons.check_rounded : Icons.save_outlined,
                ),
                label: Text(recipe.isSaved ? 'Guardada' : 'Guardar'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _shareRecipe(recipe);
                },
                icon: const Icon(Icons.share_outlined),
                label: const Text('Compartir'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: recipe.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                label: 'Favorito',
                selected: recipe.isFavorite,
                onPressed: () {
                  _toggleFavorite(recipe);
                },
              ),
            ),
            Expanded(
              child: _QuickAction(
                icon: Icons.timer_outlined,
                label: _timerSeconds > 0 ? _formatTimer() : 'Temporizador',
                selected: _timerSeconds > 0,
                onPressed: _configureTimer,
              ),
            ),
            Expanded(
              child: _QuickAction(
                icon: Icons.add_shopping_cart_rounded,
                label: 'Compras',
                selected: false,
                onPressed: () {
                  _message(
                    '${recipe.ingredients.length} ingredientes agregados a compras',
                  );
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'Preparar',
                icon: Icon(Icons.soup_kitchen_rounded),
                label: Text('Preparar'),
              ),
              ButtonSegment(
                value: 'Servir',
                icon: Icon(Icons.room_service_rounded),
                label: Text('Servir'),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: (selection) {
              setState(() {
                _mode = selection.first;
              });
            },
          ),
        ),

        const SizedBox(height: 24),

        if (_mode == 'Preparar')
          _buildPreparation(recipe)
        else
          _buildServing(recipe),

        const SizedBox(height: 28),

        Text(
          'Ingredientes',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                for (
                  int index = 0;
                  index < recipe.ingredients.length;
                  index++
                ) ...[
                  Row(
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Text(recipe.ingredients[index])),
                      IconButton(
                        onPressed: () {
                          _store.removeIngredient(recipe.id, index);
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  if (index < recipe.ingredients.length - 1) const Divider(),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        FloatingActionButton.extended(
          heroTag: 'extendedIngredient',
          onPressed: () {
            _addIngredient(recipe);
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('Agregar ingrediente'),
        ),

        const SizedBox(height: 90),
      ],
    );
  }

  Widget _buildPreparation(Recipe recipe) {
    if (!_preparationStarted && !recipe.isFinished) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '¿Listo para cocinar?',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text('FoodLab te guiará paso a paso durante la preparación.'),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: _isLoading ? null : _startPreparation,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow_rounded),
            label: Text(
              _isLoading ? 'Preparando guía...' : 'Iniciar preparación',
            ),
          ),
        ],
      );
    }

    if (recipe.isFinished) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 10),
              const Text(
                'Preparación completada',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tu platillo está listo. Cambia a Servir para ver la presentación final.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final step = recipe.steps[_currentStep];

    final progress = (_currentStep + 1) / recipe.steps.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Paso ${_currentStep + 1} de ${recipe.steps.length}',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Text('${(progress * 100).round()}%'),
              ],
            ),

            const SizedBox(height: 12),

            LinearProgressIndicator(value: progress),

            const SizedBox(height: 22),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  const Icon(Icons.restaurant_rounded, size: 42),
                  const SizedBox(height: 12),
                  Text(
                    step,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _currentStep == 0
                        ? null
                        : () {
                            setState(() {
                              _currentStep--;
                            });
                          },
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Anterior'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      if (_currentStep < recipe.steps.length - 1) {
                        setState(() {
                          _currentStep++;
                        });
                      } else {
                        _finishRecipe(recipe);
                      }
                    },
                    icon: Icon(
                      _currentStep == recipe.steps.length - 1
                          ? Icons.check_rounded
                          : Icons.arrow_forward_rounded,
                    ),
                    label: Text(
                      _currentStep == recipe.steps.length - 1
                          ? 'Finalizar'
                          : 'Siguiente',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServing(Recipe recipe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Así puede lucir tu platillo',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'Utiliza esta presentación como referencia al momento de servir.',
        ),
        const SizedBox(height: 14),

        ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.asset(
            recipe.imagePath,
            height: 240,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _ServingTip(
                  icon: Icons.restaurant_rounded,
                  text: 'Sirve el platillo inmediatamente después de terminar la preparación.',
                ),
                const Divider(),
                _ServingTip(
                  icon: Icons.auto_awesome_rounded,
                  text: 'Añade los complementos finales para mejorar la presentación.',
                ),
                const Divider(),
                _ServingTip(
                  icon: Icons.people_outline_rounded,
                  text:
                      'Esta receta está calculada para ${recipe.portions} porciones.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        selected
            ? IconButton.filled(onPressed: onPressed, icon: Icon(icon))
            : IconButton.filledTonal(onPressed: onPressed, icon: Icon(icon)),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ServingTip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ServingTip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _EmptyRecipe extends StatelessWidget {
  final VoidCallback onBack;

  const _EmptyRecipe({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Todavía no hay recetas',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Primero crea una receta en Crea tu receta y después vuelve para comenzar a cocinar.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
