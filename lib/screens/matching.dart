import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';
import '../widgets/travel_id_badge.dart';

class FindBuddyScreen extends StatelessWidget {
  final SocialData data;
  final String destination;
  
  const FindBuddyScreen({super.key, required this.data, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Buddies', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Recommended for $destination',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Based on your travel style, budget, and dates.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ...data.potentialMatches.map((match) => Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => MatchDetailModal(match: match, data: data),
              ),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: coral.withValues(alpha: 0.2),
                          child: Text(
                            match.name.substring(0, 1),
                            style: const TextStyle(color: coral, fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    match.name,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 4),
                                  if (match.verified) const Icon(Icons.verified, color: Colors.blue, size: 16),
                                ],
                              ),
                              Text('${match.compatibilityScore}% Match', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Chip(label: Text(match.mbti), visualDensity: VisualDensity.compact),
                        Chip(label: Text(match.budgetStyle), visualDensity: VisualDensity.compact),
                        Chip(label: Text(match.travelPace), visualDensity: VisualDensity.compact),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class MatchDetailModal extends StatelessWidget {
  final UserProfile match;
  final SocialData data;

  const MatchDetailModal({super.key, required this.match, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: const BoxDecoration(
        color: Color(0xFFF4F6F9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 14),

              // Title / Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.badge_outlined, color: Color(0xFF0B2240), size: 20),
                  const SizedBox(width: 6),
                  Text(
                    '${match.name}\'s Official Travel Pass',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0B2240),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ==========================================
              // PICTURE 2 FORMAT: TRAVEL ID BADGE (LANYARD)
              // ==========================================
              TravelIdBadge(
                profile: match,
                animateFlipOnMount: true,
                enableTapToFlip: true,
              ),

              const SizedBox(height: 16),

              // Match Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Compatibility Score', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${match.compatibilityScore}% Match', style: const TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Reliability Rating', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${match.reliabilityScore}% Reliable', style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Destination Preference', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        Text(
                          match.preferredDestination != 'Unknown' && match.preferredDestination.isNotEmpty
                              ? '📍 ${match.preferredDestination}'
                              : '❓ Flexible (Unknown)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: match.preferredDestination != 'Unknown' && match.preferredDestination.isNotEmpty
                                ? const Color(0xFF0B2240)
                                : Colors.orange.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Travel Dates', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        Text(
                          match.preferredDateRange != 'Unknown' && match.preferredDateRange.isNotEmpty
                              ? '📅 ${match.preferredDateRange}'
                              : '❓ Flexible (Unknown)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: match.preferredDateRange != 'Unknown' && match.preferredDateRange.isNotEmpty
                                ? const Color(0xFF0B2240)
                                : Colors.orange.shade800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Pair Up Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    data.matchRequests.add(MatchRequest(match.username, TripData()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Pairing request sent to ${match.name}! 🎉'),
                        backgroundColor: coral,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.handshake_rounded),
                  label: Text('Request Pair with ${match.name}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  style: FilledButton.styleFrom(
                    backgroundColor: coral,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
