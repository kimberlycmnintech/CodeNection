import 'package:flutter/material.dart';
import '../theme.dart';

class AiPromptModal extends StatefulWidget {
  final String initialPrompt;
  final Function(String updatedPrompt) onSendToItinerary;

  const AiPromptModal({
    super.key,
    required this.initialPrompt,
    required this.onSendToItinerary,
  });

  @override
  State<AiPromptModal> createState() => _AiPromptModalState();
}

class _AiPromptModalState extends State<AiPromptModal> {
  late TextEditingController _controller;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialPrompt);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF5A5F), Color(0xFFFF7E40)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'TRIPNEST UNDERSTANDS',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: coral,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text('✨', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'AI Planning Prompt',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B2240),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'TripNest distilled your shared Notebook discussions into this structured travel prompt. You can review and edit it before updating the itinerary.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),

              // Prompt Text Box
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F8F4), // Authentic cream background
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      height: 1.5,
                      color: Color(0xFF1E293B),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Edit planning prompt...',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Action Buttons
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _controller.text = widget.initialPrompt;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reset to original prompt')),
                      );
                    },
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Reset'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: () {
                          final updated = _controller.text.trim();
                          Navigator.pop(context);
                          widget.onSendToItinerary(updated);
                        },
                        icon: const Icon(Icons.send_rounded, size: 16),
                        label: const Text(
                          'Send to Itinerary ✨',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: coral,
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
