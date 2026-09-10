import 'package:flutter/material.dart';
import '../models/chat_planning_models.dart';
import '../theme.dart';

class PlanningCheckCard extends StatelessWidget {
  final List<PlanningTopic> topics;
  final Function(String message) onDiscussTopic;
  final VoidCallback onGenerateItinerary;

  const PlanningCheckCard({
    super.key,
    required this.topics,
    required this.onDiscussTopic,
    required this.onGenerateItinerary,
  });

  @override
  Widget build(BuildContext context) {
    final discussedCount = topics.where((t) => t.isDiscussed).length;
    final totalCount = topics.length;
    final progress = totalCount > 0 ? (discussedCount / totalCount) : 0.0;
    final percentage = (progress * 100).toInt();

    final missingTopics = topics.where((t) => !t.isDiscussed).toList();
    final firstMissing = missingTopics.isNotEmpty ? missingTopics.first : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('✨', style: TextStyle(fontSize: 14)),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Planning Check',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Your trip is taking shape!',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: coral.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: coral,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(coral),
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 14),

          // Checklist of Topics
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: topics.map((topic) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: topic.isDiscussed
                      ? const Color(0xFFECFDF5)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: topic.isDiscussed
                        ? const Color(0xFFA7F3D0)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      topic.isDiscussed ? Icons.check_circle : Icons.radio_button_unchecked,
                      size: 13,
                      color: topic.isDiscussed ? const Color(0xFF059669) : Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      topic.title,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: topic.isDiscussed
                            ? const Color(0xFF065F46)
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          if (firstMissing != null) ...[
            const SizedBox(height: 14),
            // "Discuss this" Prompt
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('💡', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Your flock hasn't discussed ${firstMissing.title.toLowerCase()} yet.",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (firstMissing.suggestedMessage != null)
                    Text(
                      '"${firstMissing.suggestedMessage}"',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontStyle: FontStyle.italic,
                        color: Colors.brown.shade800,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        if (firstMissing.suggestedMessage != null) {
                          onDiscussTopic(firstMissing.suggestedMessage!);
                        }
                      },
                      icon: const Icon(Icons.chat_outlined, size: 14, color: coral),
                      label: const Text(
                        'Discuss this',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: coral,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Generate Itinerary Button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onGenerateItinerary,
              icon: const Icon(Icons.auto_awesome, size: 16),
              label: const Text(
                'Generate Itinerary',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: coral,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
