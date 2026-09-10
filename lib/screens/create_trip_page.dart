import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';
import 'matching.dart';

class CreateTripPage extends StatefulWidget {
  final SocialData data;
  final void Function(String name, String destination) onCreate;
  const CreateTripPage({super.key, required this.data, required this.onCreate});
  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final nameController = TextEditingController();
  final destinationController = TextEditingController();

  void proceedToMatch() {
    final destination = destinationController.text.trim();
    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add a destination first to find a buddy.')));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FindBuddyScreen(data: widget.data, destination: destination)),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Create a trip', style: TextStyle(fontWeight: FontWeight.bold)),
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Start planning somewhere new',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Add the basics now. You can fill in places, reservations, and expenses later.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 28),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Trip name',
            hintText: 'Summer in Japan',
            prefixIcon: Icon(Icons.luggage_outlined),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: destinationController,
          decoration: const InputDecoration(
            labelText: 'Destination',
            hintText: 'Tokyo, Japan',
            prefixIcon: Icon(Icons.place_outlined),
          ),
        ),
        const SizedBox(height: 26),
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            onPressed: () {
              final name = nameController.text.trim();
              final destination = destinationController.text.trim();
              if (name.isEmpty || destination.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add a trip name and destination first.')),
                );
                return;
              }
              widget.onCreate(name, destination);
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Build this trip alone'),
            style: FilledButton.styleFrom(backgroundColor: Colors.grey.shade800),
          ),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('OR', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            onPressed: proceedToMatch,
            icon: const Icon(Icons.people),
            label: const Text('Find a Travel Buddy', style: TextStyle(fontWeight: FontWeight.bold)),
            style: FilledButton.styleFrom(backgroundColor: coral),
          ),
        ),
      ],
    ),
  );
}
