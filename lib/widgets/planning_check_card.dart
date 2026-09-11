import 'package:flutter/material.dart';
import '../models/chat_planning_models.dart';

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
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$percentage%',
              style: const TextStyle(
                color: Color(0xFF0F172A),
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
          backgroundColor: const Color(0xFFE2E8F0),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F172A)),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: topic.isDiscussed
                  ? const Color(0xFFD1FAE5)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: topic.isDiscussed
                    ? const Color(0xFFA7F3D0)
                    : const Color(0xFFCBD5E1),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  topic.isDiscussed ? Icons.check_circle : Icons.circle_outlined,
                  size: 13,
                  color: topic.isDiscussed ? const Color(0xFF059669) : const Color(0xFF64748B),
                ),
                const SizedBox(width: 5),
                Text(
                  topic.title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: topic.isDiscussed
                        ? const Color(0xFF065F46)
                        : const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),

      if (firstMissing != null) ...[
        const SizedBox(height: 14),
        // "Discuss this" Prompt Banner matching reference mockup
        InkWell(
          onTap: () {
            if (firstMissing.suggestedMessage != null) {
              onDiscussTopic(firstMissing.suggestedMessage!);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your flock hasn't discussed ${firstMissing.title.toLowerCase()} yet.",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92400E),
                        ),
                      ),
                      if (firstMissing.suggestedMessage != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          '"${firstMissing.suggestedMessage}"',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontStyle: FontStyle.italic,
                            color: Colors.brown.shade800,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 18, color: Color(0xFF92400E)),
              ],
            ),
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
                backgroundColor: const Color(0xFF0F172A),
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
