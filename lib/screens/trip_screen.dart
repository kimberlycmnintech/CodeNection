import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';
import 'chat_notebook.dart';
import 'itinerary.dart';

class TripScreen extends StatefulWidget {
  final TripData trip;
  final SocialData data;
  final VoidCallback onBack;
  const TripScreen({super.key, required this.trip, required this.data, required this.onBack});
  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  int tab = 0;

  void handleGenerateItinerary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AIGenerationScreen(
          onComplete: () {
            Navigator.pop(context); // close loading
            setState(() {
              tab = 3; // jump to Itinerary tab
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Itinerary generated successfully!')));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      OverviewTab(trip: widget.trip),
      ChatTab(trip: widget.trip),
      NotebookTab(trip: widget.trip, onGenerate: handleGenerateItinerary),
      ItineraryTab(trip: widget.trip),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.trip.name,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: widget.onBack,
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to trips',
        ),
        actions: const [Icon(Icons.ios_share), SizedBox(width: 14)],
        bottom: TripTabs(
          selected: tab,
          onSelect: (value) => setState(() => tab = value),
        ),
      ),
      body: screens[tab],
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff20252b),
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add place manually'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Place name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  widget.trip.places.add(controller.text.trim());
                });
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class TripTabs extends StatelessWidget implements PreferredSizeWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const TripTabs({super.key, required this.selected, required this.onSelect});
  @override
  Size get preferredSize => const Size.fromHeight(42);
  @override
  Widget build(BuildContext context) => SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Row(
      children: ['Overview', 'Chat', 'Notebook', 'Itinerary']
          .asMap()
          .entries
          .map(
            (entry) => Expanded(
              child: InkWell(
                onTap: () => onSelect(entry.key),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 11,
                        color: selected == entry.key
                            ? coral
                            : Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 2,
                      color: selected == entry.key ? coral : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}

class OverviewTab extends StatefulWidget {
  final TripData trip;
  const OverviewTab({super.key, required this.trip});
  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(12),
    children: [
      Text(
        widget.trip.name,
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
      ),
      Text(
        '${widget.trip.startDate} - ${widget.trip.endDate}',
        style: TextStyle(color: Colors.grey.shade600),
      ),
      const SizedBox(height: 14),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Solo matching',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Let other solo travellers ask to join this trip',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: widget.trip.soloMatching,
                onChanged: (value) =>
                    setState(() => widget.trip.soloMatching = value),
              ),
            ],
          ),
        ),
      ),
      stepCard(
        'Explore things to do',
        'Add places from popular blogs',
        'Explore',
      ),
      const SizedBox(height: 18),
      const Text(
        'Reservations and attachments',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icons.flight,
          Icons.hotel,
          Icons.train,
          Icons.attach_file,
        ].map((icon) => Icon(icon, color: Colors.grey.shade700)).toList(),
      ),
      const Divider(height: 32),
      const Text(
        'Notes',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      Text(
        'Write or paste general notes here, e.g. how to get around, local tips, reminders',
        style: TextStyle(
          color: Colors.grey.shade500,
          fontStyle: FontStyle.italic,
        ),
      ),
    ],
  );
}
