import 'package:flutter/material.dart';

class AllEventsPage extends StatelessWidget {
  const AllEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos los Eventos')),
      body: const Center(child: Text('Aquí se mostrarán todos los eventos')),
    );
  }
}