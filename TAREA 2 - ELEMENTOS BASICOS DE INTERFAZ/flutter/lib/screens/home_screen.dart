// Menu principal
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
      _SectionData(
        title: 'Crea tu receta',
        icon: Icons.edit_note_rounded,
        screen: const TextInputScreen(),
      ),
      _SectionData(
        title: 'Acciones de cocina',
        icon: Icons.touch_app_rounded,
        screen: const ActionsScreen(),
      ),
      _SectionData(
        title: 'Personaliza tu menú',
        icon: Icons.tune_rounded,
        screen: const SelectionScreen(),
      ),
      _SectionData(
        title: 'Explora recetas',
        icon: Icons.menu_book_rounded,
        screen: const CollectionsScreen(),
      ),
      _SectionData(
        title: 'Cocina en progreso',
        icon: Icons.soup_kitchen_rounded,
        screen: const FeedbackScreen(),
      ),
      _SectionData(
        title: 'Diseño de FoodLab',
        icon: Icons.dashboard_customize_rounded,
        screen: const StructureScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.eco_rounded),
            SizedBox(width: 8),
            Text('FoodLab', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          children: [
            Text(
              'Catálogo interactivo de\ninterfaces móviles',
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold, height: 1.15),
            ),

            const SizedBox(height: 10),

            Text(
              'Explora, prepara y organiza tus recetas.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 26),

            _FeaturedRecipe(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CollectionsScreen()),
                );
              },
            ),

            const SizedBox(height: 30),

            Text(
              'Explora FoodLab',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sections.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.12,
              ),
              itemBuilder: (context, index) {
                final section = sections[index];

                return _SectionCard(
                  section: section,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => section.screen),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedRecipe extends StatelessWidget {
  final VoidCallback onTap;

  const _FeaturedRecipe({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 190,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset('assets/images/pasta_pollo.png', fit: BoxFit.cover),
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
              const Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RECETA DESTACADA',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Pasta con pollo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final _SectionData section;
  final VoidCallback onTap;

  const _SectionCard({required this.section, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  section.icon,
                  size: 29,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                section.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionData {
  final String title;
  final IconData icon;
  final Widget screen;

  const _SectionData({
    required this.title,
    required this.icon,
    required this.screen,
  });
}
