import 'package:flutter/material.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explora recetas')),
      body: const Center(child: Text('Sección 4 • Listas y colecciones')),
    );
  }
}
