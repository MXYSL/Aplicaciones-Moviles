import 'package:flutter/material.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personaliza tu menú')),
      body: const Center(child: Text('Sección 3 • Selección')),
    );
  }
}
