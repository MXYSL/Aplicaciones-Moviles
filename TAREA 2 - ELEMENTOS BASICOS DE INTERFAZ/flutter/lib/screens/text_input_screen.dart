//Screen 1 Crear receta
import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../state/recipe_store.dart';
import '../utils/recipe_helper.dart';

class TextInputScreen extends StatefulWidget {
  const TextInputScreen({super.key});

  @override
  State<TextInputScreen> createState() => _TextInputScreenState();
}

class _TextInputScreenState extends State<TextInputScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _portionsController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _searchController = TextEditingController();

  bool _hidePassword = true;
  String? _selectedDish;

  final List<String> _dishSuggestions = [
    'Pasta',
    'Ensalada',
    'Sopa',
    'Tacos',
    'Pizza',
    'Hamburguesa',
    'Postre',
    'Desayuno',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _portionsController.dispose();
    _ingredientsController.dispose();
    _searchController.dispose();

    super.dispose();
  }

  void _addRecipe() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDish == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona el tipo de platillo.')),
      );
      return;
    }

    final ingredients = _ingredientsController.text
        .split(RegExp(r'[\n,]+'))
        .map((ingredient) => ingredient.trim())
        .where((ingredient) => ingredient.isNotEmpty)
        .toList();

    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un ingrediente.')),
      );
      return;
    }

    final name = _nameController.text.trim();
    final category = _selectedDish!;

    final imagePath = RecipeHelper.getImage(
      name: name,
      category: category,
      ingredients: ingredients,
    );

    final steps = RecipeHelper.getSteps(
      name: name,
      category: category,
      ingredients: ingredients,
    );

    final recipe = Recipe(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      portions: int.tryParse(_portionsController.text.trim()) ?? 1,
      ingredients: ingredients,
      category: category,
      imagePath: imagePath,
      steps: steps,
    );

    RecipeStore.instance.addRecipe(recipe);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Receta "$name" agregada al catálogo.')),
    );

    _showCreatedRecipe(recipe);
  }

  Future<void> _showCreatedRecipe(Recipe recipe) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Receta creada'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  recipe.imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                recipe.name,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text('${recipe.category} • ${recipe.portions} porciones'),
              const SizedBox(height: 10),
              Text('${recipe.ingredients.length} ingredientes guardados.'),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Continuar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crea tu receta')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Nueva receta',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Completa la información para agregar una nueva receta a FoodLab.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 24),

            Text(
              'Información de la receta',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('Escribe un nombre para identificar tu receta.'),
            const SizedBox(height: 12),

            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nombre de la receta',
                hintText: 'Ej. Pasta cremosa con pollo',
                prefixIcon: Icon(Icons.restaurant_menu_rounded),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Escribe el nombre de la receta';
                }

                if (value.trim().length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres';
                }

                return null;
              },
            ),

            const SizedBox(height: 28),

            Text(
              'Datos del chef',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('Agrega los datos de contacto del autor de la receta.'),
            const SizedBox(height: 12),

            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                hintText: 'chef@foodlab.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa un correo electrónico';
                }

                final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                if (!emailPattern.hasMatch(value.trim())) {
                  return 'Ingresa un correo válido';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Teléfono de contacto',
                hintText: '55 1234 5678',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'Privacidad',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Puedes asignar una clave si deseas proteger tu receta.',
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _passwordController,
              obscureText: _hidePassword,
              decoration: InputDecoration(
                labelText: 'Clave de receta privada',
                hintText: 'Mínimo 4 caracteres',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                  icon: Icon(
                    _hidePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty && value.length < 4) {
                  return 'La clave debe tener al menos 4 caracteres';
                }

                return null;
              },
            ),

            const SizedBox(height: 28),

            Text(
              'Detalles de preparación',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('Indica para cuántas personas está pensada la receta.'),
            const SizedBox(height: 12),

            TextFormField(
              controller: _portionsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de porciones',
                hintText: 'Ej. 4',
                prefixIcon: Icon(Icons.people_outline_rounded),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Indica el número de porciones';
                }

                final portions = int.tryParse(value);

                if (portions == null || portions <= 0) {
                  return 'Ingresa un número válido';
                }

                return null;
              },
            ),

            const SizedBox(height: 28),

            Text(
              'Ingredientes',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('Escribe los ingredientes y cantidades necesarias.'),
            const SizedBox(height: 12),

            TextFormField(
              controller: _ingredientsController,
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: 7,
              decoration: const InputDecoration(
                labelText: 'Lista de ingredientes',
                hintText: 'Ej. 250 g de pasta, pollo, crema, ajo, queso...',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.list_alt_rounded),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'Tipo de platillo',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Escribe y selecciona la categoría que mejor describa tu receta.',
            ),
            const SizedBox(height: 12),

            Autocomplete<String>(
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }

                return _dishSuggestions.where(
                  (option) => option.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ),
                );
              },
              onSelected: (value) {
                setState(() {
                  _selectedDish = value;
                });
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        hintText: 'Ej. Pasta',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                    );
                  },
            ),

            if (_selectedDish != null) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  avatar: const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18,
                  ),
                  label: Text(_selectedDish!),
                ),
              ),
            ],

            const SizedBox(height: 28),

            Text(
              '¿Ya existe una receta similar?',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('Busca en FoodLab antes de agregar una nueva receta.'),
            const SizedBox(height: 12),

            SearchBar(
              controller: _searchController,
              hintText: 'Buscar receta...',
              leading: const Icon(Icons.search_rounded),
              trailing: [
                IconButton(
                  onPressed: _searchController.clear,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
              onSubmitted: (value) {
                if (value.trim().isEmpty) {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Buscando "${value.trim()}" en FoodLab...'),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            FilledButton.icon(
              onPressed: _addRecipe,
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Agregar al catálogo'),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Revisa la información antes de agregar tu receta.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
