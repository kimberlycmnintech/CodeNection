import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';

class ChatTab extends StatefulWidget {
  final TripData trip;
  const ChatTab({super.key, required this.trip});
  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final msgController = TextEditingController();

  void sendMessage() {
    if (msgController.text.trim().isNotEmpty) {
      setState(() {
        widget.trip.chatMessages.add(msgController.text.trim());
        msgController.clear();
      });
    }
  }

  void saveToNotebook(String message) {
    setState(() {
      if (!widget.trip.notebookItems.contains(message)) {
        widget.trip.notebookItems.add(message);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved to Notebook!')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: widget.trip.chatMessages.length,
            itemBuilder: (context, index) {
              final msg = widget.trip.chatMessages[index];
              return Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onLongPress: () => saveToNotebook(msg),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: coral.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(msg),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: msgController,
                  decoration: InputDecoration(
                    hintText: 'Type a message... (Long press to save)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onSubmitted: (_) => sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: coral,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  onPressed: sendMessage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NotebookTab extends StatelessWidget {
  final TripData trip;
  final VoidCallback onGenerate;
  const NotebookTab({super.key, required this.trip, required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: coral.withValues(alpha: 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('AI Notebook', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Ideas, links, and messages saved from chat.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: trip.notebookItems.isEmpty ? null : onGenerate,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Generate Itinerary from Notebook'),
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: trip.notebookItems.isEmpty
              ? const Center(child: Text('No items saved yet.\nLong-press chat messages to add them here.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: trip.notebookItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.push_pin, color: coral),
                        title: Text(trip.notebookItems[index]),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
