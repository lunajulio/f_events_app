import 'package:flutter/material.dart';

import 'all_events.dart';
import 'my_events.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> dummyEvents = const [
    {'title': 'Flutter Basics', 'location': 'Room A', 'date': 'Mar 26, 10:00 AM'},
    {'title': 'Dart Deep Dive', 'location': 'Room B', 'date': 'Mar 26, 1:00 PM'},
    {'title': 'State Management', 'location': 'Room C', 'date': 'Mar 27, 9:00 AM'},
    {'title': 'AI in Flutter', 'location': 'Room D', 'date': 'Mar 27, 3:00 PM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Eventos Destacados',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: dummyEvents.length,
                itemBuilder: (context, index) {
                  final event = dummyEvents[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(event['title']!),
                      subtitle: Text('${event['location']} • ${event['date']}'),
                      leading: const Icon(Icons.event),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AllEventsPage()));
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
              child: const Text('Todos los Eventos'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MyEventsPage()));
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
              child: const Text('Mis Eventos'),
            ),
          ],
        ),
      ),
    );
  }
}