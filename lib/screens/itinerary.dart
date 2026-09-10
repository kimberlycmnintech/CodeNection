import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';

class ItineraryTab extends StatefulWidget {
  final TripData trip;
  const ItineraryTab({super.key, required this.trip});

  @override
  State<ItineraryTab> createState() => _ItineraryTabState();
}

class _ItineraryTabState extends State<ItineraryTab> {
  bool isContractSigned = false;

  void signContract() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Travel Commitment Contract'),
        content: const Text('By signing, you agree to travel on these dates. Canceling without a valid reason will negatively impact your Reliability Score.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => isContractSigned = true);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contract signed! Have a great trip!')));
            },
            child: const Text('Agree & Sign'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.trip.places.isEmpty) {
      return const Center(child: Text('No itinerary generated yet.\nGo to Notebook to generate.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)));
    }
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (!isContractSigned)
          Card(
            color: Colors.blue.shade50,
            child: ListTile(
              leading: const Icon(Icons.handshake, color: Colors.blue),
              title: const Text('Lock in your trip'),
              subtitle: const Text('Sign the commitment contract with your buddy.'),
              trailing: FilledButton(onPressed: signContract, child: const Text('Sign')),
            ),
          )
        else
          Card(
            color: Colors.green.shade50,
            child: const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Contract Signed', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              subtitle: Text('You are committed to this trip!'),
            ),
          ),
        const SizedBox(height: 16),
        const Text(
          'Day 1 - Generated Itinerary',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        ...widget.trip.places.asMap().entries.map(
          (entry) => Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 13,
                backgroundColor: const Color(0xffe9efff),
                child: Text(
                  '${entry.key + 1}',
                  style: const TextStyle(
                    color: Color(0xff315fca),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                entry.value,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Added via AI from Notebook'),
              trailing: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?w=140',
                  width: 60,
                  height: 58,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AIGenerationScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const AIGenerationScreen({super.key, required this.onComplete});

  @override
  State<AIGenerationScreen> createState() => _AIGenerationScreenState();
}

class _AIGenerationScreenState extends State<AIGenerationScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), widget.onComplete);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: coral),
            const SizedBox(height: 24),
            const Text(
              'Nesti is analyzing your Notebook...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Generating Day-by-Day Itinerary', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
