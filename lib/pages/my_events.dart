import 'package:flutter/material.dart';

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Eventos')),
      body: const Center(child: Text('Aquí se mostrarán tus eventos suscritos')),
    );
  }
}