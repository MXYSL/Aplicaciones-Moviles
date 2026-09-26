import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cocina en progreso')),
      body: const Center(child: Text('Sección 5 • Información y feedback')),
    );
  }
}
