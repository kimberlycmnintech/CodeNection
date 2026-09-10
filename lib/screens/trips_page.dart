import 'package:flutter/material.dart';
import '../models/models.dart';

class TripsPage extends StatelessWidget {
  final TripData trip;
  final VoidCallback onOpenTrip;
  const TripsPage({super.key, required this.trip, required this.onOpenTrip});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Your trips',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
          tooltip: 'Search trips',
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Plan and revisit your adventures',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 18),
        InkWell(
          onTap: onOpenTrip,
          borderRadius: BorderRadius.circular(14),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${trip.destination} · ${trip.places.length} places',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.archive_outlined),
          label: const Text('Archived trips'),
        ),
      ],
    ),
  );
}
