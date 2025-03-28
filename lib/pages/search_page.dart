import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Eventos')),
      body: const Center(
        child: Text('Aquí podrás buscar eventos.'),
      ),
    );
  }
}