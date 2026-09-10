import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';
import 'matching.dart';

class PairingPage extends StatefulWidget {
  final SocialData data;
  final TripData trip;

  const PairingPage({
    super.key,
    required this.data,
    required this.trip,
  });

  @override
  State<PairingPage> createState() => _PairingPageState();
}

class _PairingPageState extends State<PairingPage> {
  String selectedFilter = 'All';
  final Set<String> sentRequests = {};

  List<UserProfile> get filteredMatches {
    final list = widget.data.potentialMatches;
    if (selectedFilter == 'High Match') {
      return list.where((m) => m.compatibilityScore >= 80).toList();
    } else if (selectedFilter == 'Relaxed') {
      return list.where((m) => m.travelPace.toLowerCase().contains('relax') || m.travelPace.toLowerCase().contains('balance')).toList();
    } else if (selectedFilter == 'Budget') {
      return list.where((m) => m.budgetStyle.toLowerCase().contains('budget')).toList();
    }
    return list;
  }

  void _sendMatchRequest(UserProfile match) {
    setState(() {
      sentRequests.add(match.username);
      widget.data.matchRequests.add(MatchRequest(match.username, widget.trip));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pairing request sent to ${match.name}! 🎉'),
        backgroundColor: coral,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myProfile = widget.data.myProfile;
    final destination = widget.trip.destination.isNotEmpty ? widget.trip.destination : 'Kyoto, Japan';

    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF5A5F), Color(0xFFFF7E40)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Travel Pairing',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  'Find companions who match your rhythm',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --------------------------------------------------
          // 1. User Travel DNA Hero Card
          // --------------------------------------------------
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: coral.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: coral.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt, color: coral, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'YOUR TRAVEL DNA',
                            style: TextStyle(
                              color: coral,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      destination,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  myProfile.name.isNotEmpty ? myProfile.name : 'Adventurer',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Matching based on your pace (${myProfile.travelPace}), vibe (${myProfile.destinationVibe}), and planning style (${myProfile.planningStyle}).',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _buildDnaChip(myProfile.travelPace, Icons.speed),
                    _buildDnaChip(myProfile.destinationVibe, Icons.location_city),
                    _buildDnaChip(myProfile.budgetStyle, Icons.savings_outlined),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --------------------------------------------------
          // 2. Filter Pills Row
          // --------------------------------------------------
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', 'All Buddies (${widget.data.potentialMatches.length})'),
                const SizedBox(width: 8),
                _buildFilterChip('High Match', '🔥 80%+ Match'),
                const SizedBox(width: 8),
                _buildFilterChip('Relaxed', '🌿 Relaxed / Balanced'),
                const SizedBox(width: 8),
                _buildFilterChip('Budget', '💰 Budget Explorer'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // --------------------------------------------------
          // 3. Recommended Buddies Section Header
          // --------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended for $destination',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                '${filteredMatches.length} available',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // --------------------------------------------------
          // 4. Buddy Match Cards
          // --------------------------------------------------
          ...filteredMatches.map((match) {
            final isRequested = sentRequests.contains(match.username);
            return Card(
              margin: const EdgeInsets.only(bottom: 14),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: match.compatibilityScore >= 90
                      ? coral.withValues(alpha: 0.3)
                      : Colors.grey.shade200,
                  width: match.compatibilityScore >= 90 ? 1.5 : 1.0,
                ),
              ),
              child: InkWell(
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => MatchDetailModal(match: match, data: widget.data),
                ),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: coral.withValues(alpha: 0.15),
                                child: Text(
                                  match.name.substring(0, 1),
                                  style: const TextStyle(
                                    color: coral,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                              if (match.verified)
                                const Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 9,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.verified, color: Colors.blue, size: 16),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 14),

                          // Name and scores
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${match.name}, ${match.age}',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDCFCE7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.favorite, color: Color(0xFF16A34A), size: 12),
                                          const SizedBox(width: 3),
                                          Text(
                                            '${match.compatibilityScore}% Match',
                                            style: const TextStyle(
                                              color: Color(0xFF15803D),
                                              fontWeight: FontWeight.w800,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.shield_outlined, color: Color(0xFF2563EB), size: 12),
                                          const SizedBox(width: 3),
                                          Text(
                                            '${match.reliabilityScore}% Reliable',
                                            style: const TextStyle(
                                              color: Color(0xFF1D4ED8),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Tags
                      Row(
                        children: [
                          _buildMiniBadge(match.mbti),
                          const SizedBox(width: 6),
                          _buildMiniBadge(match.budgetStyle),
                          const SizedBox(width: 6),
                          _buildMiniBadge(match.travelPace),
                        ],
                      ),

                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 10),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => MatchDetailModal(match: match, data: widget.data),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                visualDensity: VisualDensity.compact,
                              ),
                              child: const Text('View Profile', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: isRequested ? null : () => _sendMatchRequest(match),
                              icon: Icon(
                                isRequested ? Icons.check : Icons.favorite_border,
                                size: 16,
                              ),
                              label: Text(
                                isRequested ? 'Request Sent' : 'Pair Up',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: isRequested ? Colors.green : coral,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          // --------------------------------------------------
          // 5. Why Pairing Works Info Card
          // --------------------------------------------------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.verified_user_outlined, color: coral, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'TripNest Safe Pairing Guarantee',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Verified traveler identity with Official Travel Passes.\n'
                  '• Compatibility computed across 5 core travel dimensions.\n'
                  '• Commitment contracts ensure high reliability and zero flaking.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDnaChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 12),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = selectedFilter == key;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => selectedFilter = key),
      selectedColor: coral.withValues(alpha: 0.18),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        color: isSelected ? coral : Colors.grey.shade800,
      ),
      side: BorderSide(
        color: isSelected ? coral : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildMiniBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }
}
