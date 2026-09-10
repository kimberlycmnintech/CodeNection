import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';
import 'itinerary.dart';

class ChatPage extends StatefulWidget {
  final SocialData data;
  final TripData trip;

  const ChatPage({
    super.key,
    required this.data,
    required this.trip,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.trip.chatMessages.isEmpty) {
      widget.trip.chatMessages.addAll([
        'Hey everyone! Looking forward to exploring ${widget.trip.destination} together ✈️',
        'I found this amazing place called Narisawa, definitely need to add it to our list!',
        'Agreed! Long press this message to pin it to our shared Travel Notebook 📌',
      ]);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      widget.trip.chatMessages.add(text);
      _msgController.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 60,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _saveToNotebook(String message) {
    setState(() {
      if (!widget.trip.notebookItems.contains(message)) {
        widget.trip.notebookItems.add(message);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved to Travel Notebook! 📌'),
            backgroundColor: coral,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _handleGenerateFromNotebook() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AIGenerationScreen(
          onComplete: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Itinerary updated from Notebook!')),
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
            Text(
              widget.trip.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Color(0xFF1E293B),
              ),
            ),
            const Text(
              'Trip Chat & Shared Notebook',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: coral,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: coral,
          indicatorWeight: 3,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 16),
                  const SizedBox(width: 6),
                  Text('Chat (${widget.trip.chatMessages.length})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.push_pin_outlined, size: 16),
                  const SizedBox(width: 6),
                  Text('Notebook (${widget.trip.notebookItems.length})'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ----------------------------------------------------
          // TAB 1: Chat Stream
          // ----------------------------------------------------
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: coral.withValues(alpha: 0.08),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 15, color: coral),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tip: Long press any message to pin it to your Travel Notebook.',
                        style: TextStyle(fontSize: 11.5, color: coral, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.trip.chatMessages.length,
                  itemBuilder: (context, index) {
                    final msg = widget.trip.chatMessages[index];
                    final isMe = index % 2 == 1;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: GestureDetector(
                        onLongPress: () => _saveToNotebook(msg),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.78,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isMe ? coral : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isMe ? 16 : 4),
                              bottomRight: Radius.circular(isMe ? 4 : 16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment:
                                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg,
                                style: TextStyle(
                                  color: isMe ? Colors.white : const Color(0xFF1E293B),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isMe ? 'You' : 'Travel Buddy',
                                    style: TextStyle(
                                      color: isMe ? Colors.white70 : Colors.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                  if (widget.trip.notebookItems.contains(msg)) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.push_pin,
                                      size: 11,
                                      color: isMe ? Colors.white : coral,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Message Input Bar
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                color: Colors.white,
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _msgController,
                          decoration: InputDecoration(
                            hintText: 'Type a message... (Long press to pin)',
                            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            filled: true,
                            fillColor: const Color(0xfff8f9fa),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: coral,
                        radius: 21,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white, size: 18),
                          onPressed: _sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ----------------------------------------------------
          // TAB 2: Travel Notebook
          // ----------------------------------------------------
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shared Travel Notebook',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Places and ideas pinned from chat conversations.',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: widget.trip.notebookItems.isEmpty ? null : _handleGenerateFromNotebook,
                        icon: const Icon(Icons.auto_awesome, size: 16),
                        label: const Text('Generate AI Itinerary from Notebook'),
                        style: FilledButton.styleFrom(
                          backgroundColor: coral,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: widget.trip.notebookItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.push_pin_outlined, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            const Text(
                              'No pinned notes yet',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Long-press any chat message to save places here.',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: widget.trip.notebookItems.length,
                        itemBuilder: (context, index) {
                          final item = widget.trip.notebookItems[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            elevation: 0.5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFFFECEB),
                                child: Icon(Icons.push_pin, color: coral, size: 18),
                              ),
                              title: Text(item, style: const TextStyle(fontWeight: FontWeight.w600)),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    widget.trip.notebookItems.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
