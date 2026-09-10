import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';

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
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 40,
              backgroundColor: coral.withValues(alpha: 0.2),
              child: Text(match.name.substring(0, 1), style: const TextStyle(color: coral, fontWeight: FontWeight.bold, fontSize: 32)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${match.name} · ${match.age}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                if (match.verified) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.verified, color: Colors.blue, size: 24),
                ],
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Compatibility', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${match.compatibilityScore}%', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Reliability', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${match.reliabilityScore}%', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Align(alignment: Alignment.centerLeft, child: Text('Travel Style', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: [
                Chip(label: Text(match.mbti)),
                Chip(label: Text(match.budgetStyle)),
                Chip(label: Text(match.travelPace)),
                Chip(label: Text(match.walkingTolerance)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match request sent to ${match.name}!')));
                },
                style: FilledButton.styleFrom(backgroundColor: coral),
                child: const Text('Send Match Request', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
