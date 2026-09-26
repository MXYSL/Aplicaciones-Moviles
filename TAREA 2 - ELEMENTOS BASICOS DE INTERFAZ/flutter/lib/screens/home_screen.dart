// Menu principal de la app
import 'package:flutter/material.dart';

import 'actions_screen.dart';
import 'collections_screen.dart';
import 'feedback_screen.dart';
import 'selection_screen.dart';
import 'structure_screen.dart';
import 'text_input_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      const _SectionData(
        title: 'Crea tu receta',
        subtitle: 'Entrada de texto',
        description: 'Captura y valida los datos de una nueva receta.',
        icon: Icons.edit_note_rounded,
        screen: TextInputScreen(),
      ),
      const _SectionData(
        title: 'Acciones de cocina',
        subtitle: 'Botones y acciones',
        description: 'Prueba diferentes botones y acciones interactivas.',
        icon: Icons.touch_app_rounded,
        screen: ActionsScreen(),
      ),
      const _SectionData(
        title: 'Personaliza tu menú',
        subtitle: 'Selección',
        description: 'Selecciona ingredientes, categorías y preferencias.',
        icon: Icons.tune_rounded,
        screen: SelectionScreen(),
      ),
      const _SectionData(
        title: 'Explora recetas',
        subtitle: 'Listas y colecciones',
        description: 'Explora recetas mediante listas, cuadrículas y pestañas.',
        icon: Icons.restaurant_menu_rounded,
        screen: CollectionsScreen(),
      ),
      const _SectionData(
        title: 'Cocina en progreso',
        subtitle: 'Información y feedback',
        description: 'Visualiza progreso, avisos y respuestas del sistema.',
        icon: Icons.soup_kitchen_rounded,
        screen: FeedbackScreen(),
      ),
      const _SectionData(
        title: 'Diseño de FoodLab',
        subtitle: 'Contenedores y estructura',
        description: 'Conoce cómo se organiza la interfaz de la aplicación.',
        icon: Icons.dashboard_customize_rounded,
        screen: StructureScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.eco_rounded),
            SizedBox(width: 10),
            Text('FoodLab', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Catálogo interactivo de\ninterfaces móviles',
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold, height: 1.15),
            ),
            const SizedBox(height: 8),
            Text(
              'Explora, prepara y organiza tus recetas mientras descubres los componentes básicos de una interfaz móvil.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // Receta destacada
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.secondaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface
                          .withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.ramen_dining_rounded, size: 40),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RECETA DESTACADA',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pasta con vegetales',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Una receta rápida para comenzar a explorar FoodLab.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            Text(
              'Explora el catálogo',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('Selecciona una categoría para probar sus componentes.'),
            const SizedBox(height: 16),

            ...sections.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SectionCard(number: entry.key + 1, data: entry.value),
              ),
            ),

            const SizedBox(height: 12),
            Center(
              child: Text(
                'FoodLab • Catálogo de componentes Flutter',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final int number;
  final _SectionData data;

  const _SectionCard({required this.number, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => data.screen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  data.icon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$number. ${data.title}',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.subtitle,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionData {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Widget screen;

  const _SectionData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.screen,
  });
}
