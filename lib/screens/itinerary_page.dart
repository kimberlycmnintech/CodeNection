import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';
import 'itinerary.dart';

class ItineraryPage extends StatefulWidget {
  final TripData trip;
  final SocialData data;
  final VoidCallback? onOpenTrip;

  const ItineraryPage({
    super.key,
    required this.trip,
    required this.data,
    this.onOpenTrip,
  });

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  void _addSamplePlace() {
    setState(() {
      widget.trip.places.add('Fushimi Inari Shrine');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added Fushimi Inari Shrine to itinerary!')),
    );
  }

  void _handleGenerateItinerary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AIGenerationScreen(
          onComplete: () {
            Navigator.pop(context);
            setState(() {
              if (!widget.trip.places.contains('Arashiyama Bamboo Grove')) {
                widget.trip.places.add('Arashiyama Bamboo Grove');
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('AI Itinerary updated with recommended stops!')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trip Itinerary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF1E293B),
              ),
            ),
            Text(
              '${widget.trip.name} · ${widget.trip.destination}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: coral),
            tooltip: 'Generate with AI',
            onPressed: _handleGenerateItinerary,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: coral),
            tooltip: 'Add Stop',
            onPressed: _addSamplePlace,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Trip dates and summary bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: coral.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.calendar_month, color: coral, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.trip.startDate} - ${widget.trip.endDate}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${widget.trip.places.length} places planned',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: _handleGenerateItinerary,
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('AI Auto-Plan', style: TextStyle(fontSize: 12)),
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    backgroundColor: const Color(0xffffe2de),
                    foregroundColor: coral,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Itinerary Tab Content
          Expanded(
            child: ItineraryTab(trip: widget.trip),
          ),
        ],
      ),
    );
  }
}
