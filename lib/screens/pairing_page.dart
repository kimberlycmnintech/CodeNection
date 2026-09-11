import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme.dart';
import 'matching.dart';

class PairingPage extends StatefulWidget {
  final SocialData data;
  final TripData trip;
  final VoidCallback? onNavigateToChat;

  const PairingPage({
    super.key,
    required this.data,
    required this.trip,
    this.onNavigateToChat,
  });

  @override
  State<PairingPage> createState() => _PairingPageState();
}

class _PairingPageState extends State<PairingPage> {
  // Navigation / View State
  bool _showingMatches = false;

  // Questionnaire / Preference State
  bool _isDestinationUnknown = false;
  bool _isDateUnknown = false;
  String _selectedDestination = '';
  String _selectedDateRange = '';

  // Filter Pills for Matches view
  String _selectedFilter = 'All';
  final Set<String> _sentRequests = {};

  // Restored Pairing Preferences State
  String _selectedTravelPace = 'Balanced';
  String _selectedBudgetStyle = 'Budget Explorer';
  String _selectedSocialStyle = 'Balanced';
  String _selectedWalkingTolerance = 'Medium';
  final Set<String> _selectedInterests = {'Food', 'Cafés', 'Photography'};
  String _selectedMbti = 'Not specified';

  void _resetPreferences() {
    setState(() {
      _selectedTravelPace = 'Balanced';
      _selectedBudgetStyle = 'Budget Explorer';
      _selectedSocialStyle = 'Balanced';
      _selectedWalkingTolerance = 'Medium';
      _selectedInterests.clear();
      _selectedInterests.addAll(['Food', 'Cafés', 'Photography']);
      _selectedMbti = 'Not specified';
    });
  }


  // ----------------------------------------------------
  // Handle Start Pairing Button Click
  // ----------------------------------------------------
  void _onStartPairingPressed() {
    final myProfile = widget.data.myProfile;
    if (!myProfile.verified) {
      _showPicture1VerificationModal();
    } else {
      setState(() => _showingMatches = true);
    }
  }

  // ----------------------------------------------------
  // ID VERIFICATION MODAL (PICTURE 1 FORMAT - ALL IN ENGLISH)
  // ----------------------------------------------------
  void _showPicture1VerificationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(26, 18, 26, 36),
          decoration: const BoxDecoration(
            color: Color(0xFF000000), // Pure black background like Picture 1
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                // Top Blue Circle with Camera Icon (Picture 1 format)
                Center(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0284C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Title: We need to verify your authenticity (English)
                Center(
                  child: Text(
                    'We need to verify your authenticity',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle context paragraph
                Text(
                  'We detected unverified traveler status on your account. Personal profiles are protected to ensure the safety and trust of all travelers. Here is how to unlock full pairing features:',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF94A3B8),
                    fontSize: 13,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 24),

                // Item 1
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Complete a short video selfie check to proceed',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You need to prove you are a real traveler and that your account complies with TripNest safety guidelines. Without proof, pairing features remain locked.',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF94A3B8),
                              fontSize: 12.5,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Item 2
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prove to the community that you are real',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'If you have eligible profile photos, you\'ll get a Photo Verification badge for your profile.',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF94A3B8),
                              fontSize: 12.5,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // White pill button: Verify Now (进行验证)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.data.myProfile.verified = true;
                        _showingMatches = true;
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Identity verified! Photo Verified badge unlocked. 🎉'),
                          backgroundColor: Color(0xFF16A34A),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF000000),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Verify Now',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }




  // ----------------------------------------------------
  // SHORT MESSAGE COMPOSER DIALOG BEFORE SENDING PAIR REQUEST
  // ----------------------------------------------------
  void _openPairMessageComposer(UserProfile match) {
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header with Avatar & Name
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      match.avatarUrl ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Send Pair Request to ${match.name}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'Include an optional message to introduce yourself',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Quick Intro Chips
              const Text(
                'Quick Intros:',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  'Love your travel vibe! 👋',
                  'Heading to the same destination! 📍',
                  'Let\'s explore together! ☕',
                ].map((chipText) {
                  return ActionChip(
                    label: Text(chipText, style: const TextStyle(fontSize: 11)),
                    backgroundColor: Colors.grey.shade100,
                    side: BorderSide(color: Colors.grey.shade300),
                    onPressed: () {
                      noteController.text = chipText;
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              // Message Input
              TextFormField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Write a short message (optional)... e.g. Hey ${match.name}! Would love to connect for the upcoming trip!',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        final note = noteController.text.trim();
                        setState(() {
                          _sentRequests.add(match.username);
                          widget.data.matchRequests.add(
                            MatchRequest(match.username, widget.trip, note: note.isNotEmpty ? note : null),
                          );
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Pair request sent to ${match.name}! 🎉'),
                            backgroundColor: coral,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: const Text('Send Request', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: FilledButton.styleFrom(
                        backgroundColor: coral,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        },
    );
  }



  // ----------------------------------------------------
  // Recommendation Engine: High to Low Relevance
  // ----------------------------------------------------
  List<UserProfile> get sortedAndFilteredMatches {
    var matches = widget.data.potentialMatches.where((m) => m.isOpenToPair).toList();

    if (!_isDestinationUnknown && _selectedDestination.isNotEmpty) {
      final dest = _selectedDestination.toLowerCase().split(',')[0].trim();
      matches = matches.where((m) {
        return m.preferredDestination == 'Unknown' ||
            m.preferredDestination.toLowerCase().contains(dest);
      }).toList();
    } else if (!_isDestinationUnknown && _selectedDestination.isEmpty) {
      // Default Picture 2 pairing screen demonstrates Maya and John (2 candidates found)
      matches = matches.where((m) => m.name == 'Maya' || m.name == 'John').toList();
    }

    if (!_isDateUnknown && _selectedDateRange.isNotEmpty) {
      matches = matches.where((m) {
        return m.preferredDateRange == 'Unknown' || m.preferredDateRange == _selectedDateRange;
      }).toList();
    }

    if (_selectedFilter == 'High Match') {
      matches = matches.where((m) => m.compatibilityScore >= 80).toList();
    } else if (_selectedFilter == 'Relaxed') {
      matches = matches.where((m) => m.travelPace.toLowerCase().contains('relax') || m.travelPace.toLowerCase().contains('balance')).toList();
    } else if (_selectedFilter == 'Budget') {
      matches = matches.where((m) => m.budgetStyle.toLowerCase().contains('budget')).toList();
    }

    matches.sort((a, b) => b.compatibilityScore.compareTo(a.compatibilityScore));
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    final myProfile = widget.data.myProfile;

    return Scaffold(
      backgroundColor: iceBg,
      appBar: AppBar(
        backgroundColor: iceBg,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.landscape_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Travel Pairing',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (myProfile.verified)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, size: 11, color: Color(0xFF0284C7)),
                            SizedBox(width: 3),
                            Text(
                              'VERIFIED',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0284C7),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                Text(
                  'Find travel companions matching your rhythm',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'Notifications',
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded, color: Color(0xFF0F172A), size: 24),
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '1',
                      style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(
                myProfile.avatarUrl ?? 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500',
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --------------------------------------------------
          // VIEW STATE 1: PRE-PAIRING PREFERENCE SETUP
          // --------------------------------------------------
          if (!_showingMatches) ...[
            // 1. Section Heading & Helper Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set your pairing preferences',
                  style: boldItalicTitle(20, color: darkSlate),
                ),
                const SizedBox(height: 4),
                Text(
                  'We\'ll use your destination, travel timing, and travel style to find the most compatible travel companions.',
                  style: bodyFont(12.5),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 1. Destination
            _buildDestinationQuestionnaireCard(),
            const SizedBox(height: 14),

            // 2. Travel Dates
            _buildDateQuestionnaireCard(),
            const SizedBox(height: 14),

            // 3. Your Match Style (Summary card with Edit button)
            _buildMatchStyleCard(),

            const SizedBox(height: 22),

            // 5. Start Pairing Action Button (Large Dark Navy CTA)
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: _onStartPairingPressed,
                icon: const Icon(Icons.auto_awesome_rounded, size: 20),
                label: const Text(
                  'Start Pairing',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 6. Safe Pairing Guarantee Card
            _buildSafePairingCard(),
          ]

          // --------------------------------------------------
          // VIEW STATE 2: RECOMMENDED BUDDIES MATCHES LIST (PICTURE 2)
          // --------------------------------------------------
          else ...[
            // Top Controls Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => setState(() => _showingMatches = false),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.tune_rounded, size: 16, color: Color(0xFF0F172A)),
                        SizedBox(width: 8),
                        Text(
                          'Edit Trip Parameters',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF64748B)),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.people_outline_rounded, size: 16, color: Color(0xFF0F172A)),
                      const SizedBox(width: 6),
                      Text(
                        '${sortedAndFilteredMatches.length} candidates found',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Filter Pills Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterPill('All', 'All Buddies (${sortedAndFilteredMatches.length})', hasCheck: true),
                  const SizedBox(width: 10),
                  _buildFilterPill('High Match', '🔥 80%+ Match'),
                  const SizedBox(width: 10),
                  _buildFilterPill('Relaxed', '🌿 Relaxed / Balanced'),
                  const SizedBox(width: 10),
                  _buildFilterPill('Budget', '💰 Budget Explorer'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section Header: Recommended Buddies + Sort Dropdown
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.group_rounded, color: Color(0xFF0F172A), size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recommended Buddies',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Travel farther together. People who match your style, destination and vibe.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.swap_vert_rounded, size: 16, color: Colors.grey.shade700),
                      const SizedBox(width: 4),
                      Text(
                        'High to Low Relevance',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.grey.shade700),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Match Cards List
            if (sortedAndFilteredMatches.isEmpty)
              _buildEmptyMatchState()
            else
              ...sortedAndFilteredMatches.map((match) => _buildBuddyCard(match)),
          ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ===========================================================================
  // QUESTIONNAIRE CARDS (PICTURE 2 STYLE)
  // ===========================================================================
  Widget _buildDestinationQuestionnaireCard() {
    String displayText = 'Search for a city, country, or region';
    bool isPlaceholder = true;

    if (_isDestinationUnknown) {
      displayText = 'Not sure where to go yet';
      isPlaceholder = false;
    } else if (_selectedDestination.isNotEmpty) {
      displayText = _selectedDestination;
      isPlaceholder = false;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.explore_outlined, color: darkSlate, size: 22),
              const SizedBox(width: 8),
              Text(
                'Where would you like to go?',
                style: boldTitle(17, color: darkSlate),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Tell us your destination (or let us know you\'re still deciding).',
            style: bodyFont(12.5),
          ),
          const SizedBox(height: 16),

          // Interactive Search Box Trigger
          InkWell(
            onTap: _openDestinationPickerModal,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isDestinationUnknown ? Colors.orange.shade300 : const Color(0xFFCBD5E1),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isDestinationUnknown ? Icons.help_outline_rounded : Icons.search_rounded,
                    color: _isDestinationUnknown ? Colors.orange.shade800 : const Color(0xFF64748B),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      displayText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: isPlaceholder ? FontWeight.w500 : FontWeight.w600,
                        color: isPlaceholder
                            ? const Color(0xFF94A3B8)
                            : (_isDestinationUnknown ? Colors.orange.shade900 : darkSlate),
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B), size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDestinationPickerModal() {
    final searchCtrl = TextEditingController();

    final popularDestinations = [
      {'name': 'Tokyo, Japan', 'image': 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=200'},
      {'name': 'Osaka, Japan', 'image': 'https://images.unsplash.com/photo-1590559899731-a382839e5549?w=200'},
      {'name': 'Kyoto, Japan', 'image': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=200'},
      {'name': 'Seoul, South Korea', 'image': 'https://images.unsplash.com/photo-1538485399081-7191377e8241?w=200'},
      {'name': 'Bangkok, Thailand', 'image': 'https://images.unsplash.com/photo-1508009603885-50cf7c579365?w=200'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text('Where would you like to go?', style: boldTitle(18, color: darkSlate)),
                  const SizedBox(height: 12),

                  // Search Field
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF3B82F6), width: 1.2),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: searchCtrl,
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: 'Search for a city, country, or region',
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                            ),
                            onSubmitted: (val) {
                              if (val.trim().isNotEmpty) {
                                setState(() {
                                  _selectedDestination = val.trim();
                                  _isDestinationUnknown = false;
                                });
                                Navigator.pop(ctx);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Popular destinations', style: boldTitle(14, color: darkSlate)),
                      Text('See more', style: bodyFont(12, color: azureBlue, weight: FontWeight.w700)),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ...popularDestinations.map((dest) {
                    final isSelected = !_isDestinationUnknown && _selectedDestination == dest['name'];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          dest['image']!,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        dest['name']!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? azureBlue : darkSlate,
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: azureBlue, size: 20) : null,
                      onTap: () {
                        setState(() {
                          _selectedDestination = dest['name']!;
                          _isDestinationUnknown = false;
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  }),

                  const Divider(height: 20),

                  // "Not sure where to go yet" option inside dropdown
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isDestinationUnknown = true;
                        _selectedDestination = '';
                      });
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isDestinationUnknown ? Colors.orange.shade50 : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _isDestinationUnknown ? Colors.orange : Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.help_outline_rounded, color: darkSlate, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Not sure where to go yet',
                                  style: boldTitle(14, color: darkSlate),
                                ),
                                Text(
                                  'I\'m open to suggestions',
                                  style: bodyFont(12),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDateQuestionnaireCard() {
    String displayText = 'Select travel dates';
    bool isPlaceholder = true;

    if (_isDateUnknown) {
      displayText = 'Not sure yet';
      isPlaceholder = false;
    } else if (_selectedDateRange.isNotEmpty) {
      displayText = _selectedDateRange;
      isPlaceholder = false;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, color: darkSlate, size: 22),
              const SizedBox(width: 8),
              Text(
                'When are you planning to travel?',
                style: boldTitle(17, color: darkSlate),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Select your travel dates (or choose if you\'re flexible).',
            style: bodyFont(12.5),
          ),
          const SizedBox(height: 16),

          // Single Full-Width Date Input Field
          InkWell(
            onTap: _openCalendarPickerModal,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isDateUnknown
                      ? Colors.orange.shade300
                      : (!isPlaceholder ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1)),
                  width: !isPlaceholder ? 1.4 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isDateUnknown ? Icons.help_outline_rounded : Icons.calendar_today_rounded,
                    color: _isDateUnknown ? Colors.orange.shade800 : const Color(0xFF64748B),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      displayText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: isPlaceholder ? FontWeight.w500 : FontWeight.w700,
                        color: isPlaceholder
                            ? const Color(0xFF94A3B8)
                            : (_isDateUnknown ? Colors.orange.shade900 : darkSlate),
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B), size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openCalendarPickerModal() {
    int activeTab = 0; // 0: Exact dates, 1: Flexible dates, 2: Not sure yet

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return Container(
                width: 640,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Sidebar Tabs
                        SizedBox(
                          width: 160,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCalendarTabItem(
                                0,
                                Icons.calendar_month_rounded,
                                'Exact dates',
                                'I have fixed dates',
                                activeTab,
                                (idx) => setDialogState(() => activeTab = idx),
                              ),
                              const SizedBox(height: 8),
                              _buildCalendarTabItem(
                                1,
                                Icons.waves_rounded,
                                'Flexible dates',
                                'Flexible within period',
                                activeTab,
                                (idx) {
                                  setState(() {
                                    _selectedDateRange = 'Flexible dates';
                                    _isDateUnknown = false;
                                  });
                                  Navigator.pop(ctx);
                                },
                              ),
                              const SizedBox(height: 8),
                              _buildCalendarTabItem(
                                2,
                                Icons.help_outline_rounded,
                                'Not sure yet',
                                'Match open dates',
                                activeTab,
                                (idx) {
                                  setState(() {
                                    _selectedDateRange = 'Not sure yet';
                                    _isDateUnknown = true;
                                  });
                                  Navigator.pop(ctx);
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),
                        const VerticalDivider(width: 1),
                        const SizedBox(width: 16),

                        // Right Calendar Grid (April 2026 & May 2026)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('<   April 2026', style: boldTitle(14, color: darkSlate)),
                                  Text('May 2026   >', style: boldTitle(14, color: darkSlate)),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Interactive Calendar Grid Preview
                              Table(
                                children: [
                                  TableRow(
                                    children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                                        .map((day) => Center(
                                              child: Text(day, style: bodyFont(10, weight: FontWeight.w700)),
                                            ))
                                        .toList(),
                                  ),
                                  const TableRow(children: [SizedBox(height: 6), SizedBox(), SizedBox(), SizedBox(), SizedBox(), SizedBox(), SizedBox()]),
                                  TableRow(
                                    children: [
                                      _calendarDay('29', isMuted: true),
                                      _calendarDay('30', isMuted: true),
                                      _calendarDay('31', isMuted: true),
                                      _calendarDay('1'),
                                      _calendarDay('2'),
                                      _calendarDay('3'),
                                      _calendarDay('4'),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      _calendarDay('5'),
                                      _calendarDay('6'),
                                      _calendarDay('7'),
                                      _calendarDay('8'),
                                      _calendarDay('9'),
                                      _calendarDay('10'),
                                      _calendarDay('11'),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      _calendarDay('12', isSelected: true),
                                      _calendarDay('13', isHighlight: true),
                                      _calendarDay('14', isHighlight: true),
                                      _calendarDay('15', isHighlight: true),
                                      _calendarDay('16', isHighlight: true),
                                      _calendarDay('17', isHighlight: true),
                                      _calendarDay('18', isHighlight: true),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      _calendarDay('19', isHighlight: true),
                                      _calendarDay('20', isHighlight: true),
                                      _calendarDay('21', isHighlight: true),
                                      _calendarDay('22', isSelected: true),
                                      _calendarDay('23'),
                                      _calendarDay('24'),
                                      _calendarDay('25'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 14),

                    // Bottom Row Summary & Confirm Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Selected: Apr 12, 2026 – Apr 22, 2026 (11 days)',
                          style: bodyFont(12.5, color: darkSlate, weight: FontWeight.w700),
                        ),
                        FilledButton(
                          onPressed: () {
                            setState(() {
                              _selectedDateRange = 'Apr 12 - Apr 22, 2026';
                              _isDateUnknown = false;
                            });
                            Navigator.pop(ctx);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _calendarDay(String day, {bool isSelected = false, bool isHighlight = false, bool isMuted = false}) {
    Color bg = Colors.transparent;
    Color textColor = darkSlate;
    BorderRadius radius = BorderRadius.circular(8);

    if (isSelected) {
      bg = azureBlue;
      textColor = Colors.white;
    } else if (isHighlight) {
      bg = const Color(0xFFDBEAFE);
      textColor = azureBlue;
      radius = BorderRadius.zero;
    } else if (isMuted) {
      textColor = Colors.black26;
    }

    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected || isHighlight ? FontWeight.bold : FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }


  Widget _buildCalendarTabItem(
    int index,
    IconData icon,
    String title,
    String subtitle,
    int activeIndex,
    ValueChanged<int> onTap,
  ) {
    final isSelected = index == activeIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? const Color(0xFF1E40AF) : darkSlate,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }





  // ===========================================================================
  // MATCH STYLE SUMMARY CARD (MAIN PAGE)
  // ===========================================================================
  Widget _buildMatchStyleCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: darkSlate, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Your Match Style',
                    style: boldTitle(17, color: darkSlate),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: _openMatchStyleEditorModal,
                icon: const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF0F172A)),
                label: const Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Your preferred travel pace, budget, walking tolerance, and vibe.',
            style: bodyFont(12.5),
          ),
          const SizedBox(height: 16),

          // Interactive Summary Box (Tapping also triggers the Picture 1 editor modal)
          InkWell(
            onTap: _openMatchStyleEditorModal,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildSummaryTag('$_selectedTravelPace Pace', Icons.speed_rounded),
                      _buildSummaryTag(_selectedBudgetStyle, Icons.account_balance_wallet_outlined),
                      _buildSummaryTag('$_selectedWalkingTolerance Walking', Icons.directions_walk_rounded),
                      _buildSummaryTag(_selectedSocialStyle, Icons.people_outline_rounded),
                      if (_selectedMbti != 'Not specified')
                        _buildSummaryTag('MBTI: $_selectedMbti', Icons.psychology_outlined),
                      _buildSummaryTag(_selectedInterests.join(', '), Icons.interests_outlined),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Tap to customize preferences',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right_rounded, size: 16, color: Colors.blue.shade700),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PICTURE 1 MODAL PREFERENCE EDITOR
  // ===========================================================================
  void _openMatchStyleEditorModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.88,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 6),
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header with Close & Reset
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Match Style Preferences',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                setModalState(() {
                                  _resetPreferences();
                                });
                                setState(() {});
                              },
                              icon: const Icon(Icons.refresh_rounded, size: 15, color: Color(0xFF64748B)),
                              label: const Text('Reset', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(Icons.close_rounded, size: 20, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Scrollable Picture 1 Body
                  Flexible(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      children: [
                        _buildPicture1PreferencesContent(setModalState),
                      ],
                    ),
                  ),

                  // Bottom Save CTA
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      10,
                      20,
                      MediaQuery.of(ctx).viewInsets.bottom > 0
                          ? MediaQuery.of(ctx).viewInsets.bottom + 12
                          : 20,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {});
                          Navigator.pop(ctx);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Save & Update Match Style',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPicture1PreferencesContent(StateSetter setModalState) {
    final interestsList = [
      'Food',
      'Cafés',
      'Shopping',
      'Nature',
      'Photography',
      'Nightlife',
      'Culture',
      'Anime / Gaming',
      'Museums',
      'Outdoor Activities',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Helper exactly as in Picture 1
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.tune_rounded, color: Color(0xFF0F172A), size: 18),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'What kind of travel buddy are you looking for?',
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Adjust these preferences to help us find someone who matches your travel style.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: const Color(0xFF64748B),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),

        // 1. Travel Pace
        _buildPreferenceCategoryHeader('Travel Pace', Icons.speed_rounded),
        const SizedBox(height: 8),
        Row(
          children: ['Relaxed', 'Balanced', 'Packed'].map((pace) {
            final isSel = _selectedTravelPace == pace;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: InkWell(
                  onTap: () {
                    setModalState(() => _selectedTravelPace = pace);
                    setState(() => _selectedTravelPace = pace);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSel ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSel ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        pace,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isSel ? FontWeight.w700 : FontWeight.w600,
                          color: isSel ? Colors.white : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 18),

        // 2. Budget Style
        _buildPreferenceCategoryHeader('Budget Style', Icons.account_balance_wallet_outlined),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildSegmentedChoiceItem('Budget Explorer', _selectedBudgetStyle, (v) {
              setModalState(() => _selectedBudgetStyle = v);
              setState(() => _selectedBudgetStyle = v);
            }),
            _buildSegmentedChoiceItem('Balanced Spend', _selectedBudgetStyle, (v) {
              setModalState(() => _selectedBudgetStyle = v);
              setState(() => _selectedBudgetStyle = v);
            }),
            _buildSegmentedChoiceItem('Comfort & Luxury', _selectedBudgetStyle, (v) {
              setModalState(() => _selectedBudgetStyle = v);
              setState(() => _selectedBudgetStyle = v);
            }),
          ],
        ),

        const SizedBox(height: 18),

        // 3. Social Style
        _buildPreferenceCategoryHeader('Social Style', Icons.people_outline_rounded),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildSegmentedChoiceItem('Independent', _selectedSocialStyle, (v) {
              setModalState(() => _selectedSocialStyle = v);
              setState(() => _selectedSocialStyle = v);
            }),
            _buildSegmentedChoiceItem('Balanced', _selectedSocialStyle, (v) {
              setModalState(() => _selectedSocialStyle = v);
              setState(() => _selectedSocialStyle = v);
            }),
            _buildSegmentedChoiceItem('Together Most of the Time', _selectedSocialStyle, (v) {
              setModalState(() => _selectedSocialStyle = v);
              setState(() => _selectedSocialStyle = v);
            }, labelOverride: 'Together Most'),
          ],
        ),

        const SizedBox(height: 18),

        // 4. Walking Tolerance
        _buildPreferenceCategoryHeader('Walking Tolerance', Icons.directions_walk_rounded),
        const SizedBox(height: 4),
        Text(
          'How much walking are you comfortable with during a normal travel day?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildSegmentedChoiceItem('Low', _selectedWalkingTolerance, (v) {
              setModalState(() => _selectedWalkingTolerance = v);
              setState(() => _selectedWalkingTolerance = v);
            }),
            _buildSegmentedChoiceItem('Medium', _selectedWalkingTolerance, (v) {
              setModalState(() => _selectedWalkingTolerance = v);
              setState(() => _selectedWalkingTolerance = v);
            }),
            _buildSegmentedChoiceItem('High', _selectedWalkingTolerance, (v) {
              setModalState(() => _selectedWalkingTolerance = v);
              setState(() => _selectedWalkingTolerance = v);
            }),
          ],
        ),

        const SizedBox(height: 18),

        // 5. Interests (Multi-select)
        _buildPreferenceCategoryHeader('Interests', Icons.local_activity_outlined, subtitle: 'Multi-select'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: interestsList.map((interest) {
            final isSel = _selectedInterests.contains(interest);
            return InkWell(
              onTap: () {
                setModalState(() {
                  if (isSel) {
                    if (_selectedInterests.length > 1) {
                      _selectedInterests.remove(interest);
                    }
                  } else {
                    _selectedInterests.add(interest);
                  }
                });
                setState(() {});
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                decoration: BoxDecoration(
                  color: isSel ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSel ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSel) ...[
                      const Icon(Icons.check, size: 12, color: Colors.white),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      interest,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        color: isSel ? Colors.white : const Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 18),

        // 6. Optional Personality / MBTI
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              const Icon(Icons.psychology_outlined, size: 18, color: Color(0xFF64748B)),
              const SizedBox(width: 8),
              const Text(
                'Personality / MBTI',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(Optional)',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
              const Spacer(),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedMbti,
                  isDense: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFF64748B)),
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                  items: [
                    'Not specified',
                    'ENFP', 'INFJ', 'INTJ', 'INTP',
                    'ENTP', 'ENTJ', 'ENFJ', 'INFP',
                    'ISTP', 'ISFP', 'ESTP', 'ESFP',
                    'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ'
                  ].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setModalState(() => _selectedMbti = val);
                      setState(() => _selectedMbti = val);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceCategoryHeader(String title, IconData icon, {String? subtitle}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF475569)),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(width: 6),
          Text(
            '($subtitle)',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ],
    );
  }

  Widget _buildSegmentedChoiceItem(
    String value,
    String currentValue,
    ValueChanged<String> onSelected, {
    String? labelOverride,
  }) {
    final isSel = currentValue == value;
    final displayLabel = labelOverride ?? value;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          onTap: () => onSelected(value),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              color: isSel ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSel ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
            ),
            child: Center(
              child: Text(
                displayLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w600,
                  color: isSel ? Colors.white : const Color(0xFF334155),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryTag(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF0284C7)),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // BUDDY MATCH CARD (PICTURE 2 FORMAT)
  // ===========================================================================
  Widget _buildBuddyCard(UserProfile match) {
    final isRequested = _sentRequests.contains(match.username);
    final isMaya = match.name.toLowerCase().contains('maya') || match.compatibilityScore >= 90;
    final isJohn = match.name.toLowerCase().contains('john');
    final hasFixedDest = match.preferredDestination != 'Unknown' && match.preferredDestination.isNotEmpty;
    final hasFixedDate = match.preferredDateRange != 'Unknown' && match.preferredDateRange.isNotEmpty;

    // Destination text
    final String destTitle = hasFixedDest
        ? match.preferredDestination
        : 'Destination not shared yet';
    final String? destSubtitle = hasFixedDest
        ? null
        : 'They\'ll share after connecting';

    // Dates text
    final String dateTitle = hasFixedDate
        ? match.preferredDateRange
        : 'Travel dates still flexible';
    final String? dateSubtitle = hasFixedDate
        ? null
        : 'Open to similar time frames';

    // Tags
    final List<String> tags = isMaya
        ? ['ENFP', 'Budget Explorer', 'Balanced Pace']
        : isJohn
            ? ['ISTP', 'Comfortable', 'Packed Itinerary']
            : [match.mbti, match.budgetStyle, match.travelPace];

    // Why you match bullet items
    final List<String> matchReasons = isMaya
        ? [
            'Similar budget expectations',
            'Overlapping travel dates',
            'Compatible travel pace',
          ]
        : isJohn
            ? [
                'Similar travel style',
                'Open to flexible plans',
                'Potential for great adventures',
              ]
            : [
                'Shared core travel interests',
                'Harmonious travel pace',
                'Verified safety track record',
              ];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------
            // 1. TOP ROW: AVATAR & USER PROFILE INFO
            // ------------------------------------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Square Avatar (84x84) with rounded corners & blue verified check
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        match.avatarUrl ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500',
                        width: 84,
                        height: 84,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 84,
                          height: 84,
                          color: const Color(0xFFE2E8F0),
                          child: const Icon(Icons.person, size: 40, color: Color(0xFF64748B)),
                        ),
                      ),
                    ),
                    if (match.verified)
                      Positioned(
                        bottom: -3,
                        right: -3,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: Color(0xFF0284C7),
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 16),

                // Name, Best Match Badge, Scores
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + Best Match Pill + Chevron
                      Row(
                        children: [
                          Text(
                            '${match.name}, ${match.age}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.2,
                            ),
                          ),
                          if (isMaya) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF047857),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.military_tech_rounded, color: Color(0xFFFDE047), size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    'Best Match',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const Spacer(),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => MatchDetailModal(match: match, data: widget.data),
                            ),
                            icon: const Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF94A3B8),
                              size: 24,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Match & Reliability Score Badges
                      Row(
                        children: [
                          // Match Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.favorite_rounded, color: Color(0xFF16A34A), size: 13),
                                const SizedBox(width: 4),
                                Text(
                                  '${match.compatibilityScore}% Match',
                                  style: const TextStyle(
                                    color: Color(0xFF15803D),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Reliability Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.shield_rounded, color: Color(0xFF2563EB), size: 13),
                                const SizedBox(width: 4),
                                Text(
                                  '${match.reliabilityScore}% Reliable',
                                  style: const TextStyle(
                                    color: Color(0xFF1D4ED8),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11.5,
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
              ],
            ),

            const SizedBox(height: 14),

            // ------------------------------------------------
            // 2. DESTINATION & TRAVEL DATES BOXES (SIDE-BY-SIDE)
            // ------------------------------------------------
            Row(
              children: [
                // Destination Box
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Row(
                      crossAxisAlignment: destSubtitle != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on_rounded, size: 16, color: Color(0xFF0F172A)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                destTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              if (destSubtitle != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    destSubtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      color: Color(0xFF64748B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Date Range Box
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Row(
                      crossAxisAlignment: dateSubtitle != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_month_rounded, size: 16, color: Color(0xFF0F172A)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                dateTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              if (dateSubtitle != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    dateSubtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      color: Color(0xFF64748B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ------------------------------------------------
            // 3. TAG PILLS (MBTI, BUDGET, PACE)
            // ------------------------------------------------
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            // ------------------------------------------------
            // 4. "WHY YOU MATCH" CONTAINER & ARTISTIC STAMP
            // ------------------------------------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isMaya ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isMaya ? const Color(0xFFDCFCE7) : const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  // Sparkle + "Why you match" Label
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: isMaya ? const Color(0xFF059669) : const Color(0xFF0284C7),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Why you match',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  // 3 Bullet Points
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: matchReasons.map((reason) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.5),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF10B981),
                                size: 15,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  reason,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF334155),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Artistic stamp on the right
                  if (isMaya)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomPaint(
                          size: const Size(36, 32),
                          painter: ToriiGatePainter(color: const Color(0xFF0D9488).withValues(alpha: 0.35)),
                        ),
                        const SizedBox(width: 6),
                        Transform.rotate(
                          angle: -0.08,
                          child: Text(
                            'Same\nVibe\nFurther',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.caveat(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0D9488),
                              height: 1.05,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomPaint(
                          size: const Size(44, 30),
                          painter: MountainPeaksPainter(color: const Color(0xFF0284C7).withValues(alpha: 0.35)),
                        ),
                        const SizedBox(width: 6),
                        Transform.rotate(
                          angle: -0.08,
                          child: Text(
                            'Different\nPaths\nSame Direction',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.caveat(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0284C7),
                              height: 1.05,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ------------------------------------------------
            // 5. ACTION BUTTONS: VIEW PROFILE & PAIR UP
            // ------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: OutlinedButton.icon(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => MatchDetailModal(match: match, data: widget.data),
                      ),
                      icon: const Icon(Icons.person_outline_rounded, size: 17, color: Color(0xFF0F172A)),
                      label: const Text(
                        'View Profile',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: FilledButton.icon(
                      onPressed: isRequested ? null : () => _openPairMessageComposer(match),
                      icon: Icon(
                        isRequested ? Icons.check_circle_rounded : Icons.favorite_border_rounded,
                        size: 17,
                        color: Colors.white,
                      ),
                      label: Text(
                        isRequested ? 'Request Sent' : 'Pair Up',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: isRequested ? const Color(0xFF16A34A) : const Color(0xFF0F172A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyMatchState() {
    return Container(
      padding: const EdgeInsets.all(28),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            'No Pair Candidates Found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Try selecting "Unknown" for destination or date to expand your pairing options across more travelers.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildSafePairingCard() {
    return Container(
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
            '• Flexible and fixed trip options clearly disclosed upfront.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String key, String label, {bool hasCheck = false}) {
    final isSelected = _selectedFilter == key;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = key),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected && hasCheck) ...[
              const Icon(Icons.check, size: 14, color: Colors.white),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// CUSTOM PAINTERS FOR PICTURE 2 ARTISTIC STAMPS
// ===========================================================================
class ToriiGatePainter extends CustomPainter {
  final Color color;
  ToriiGatePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    // Main top curved beam (Kasagi)
    final topBeam = Path()
      ..moveTo(0, size.height * 0.18)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.08, size.width, size.height * 0.18)
      ..lineTo(size.width * 0.94, size.height * 0.28)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.18, size.width * 0.06, size.height * 0.28)
      ..close();
    canvas.drawPath(topBeam, fillPaint);
    canvas.drawPath(topBeam, paint);

    // Second straight beam (Nuki)
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.42),
      Offset(size.width * 0.88, size.height * 0.42),
      paint..strokeWidth = 2.0,
    );

    // Two Pillars (Hashira)
    canvas.drawLine(
      Offset(size.width * 0.26, size.height * 0.28),
      Offset(size.width * 0.22, size.height),
      paint..strokeWidth = 2.6,
    );
    canvas.drawLine(
      Offset(size.width * 0.74, size.height * 0.28),
      Offset(size.width * 0.78, size.height),
      paint..strokeWidth = 2.6,
    );

    // Center Strut (Gakuzuka)
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.24),
      Offset(size.width * 0.5, size.height * 0.42),
      paint..strokeWidth = 1.8,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MountainPeaksPainter extends CustomPainter {
  final Color color;
  MountainPeaksPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    // Peak 1 (High center peak)
    final peak1 = Path()
      ..moveTo(size.width * 0.12, size.height)
      ..lineTo(size.width * 0.52, size.height * 0.15)
      ..lineTo(size.width * 0.92, size.height)
      ..close();
    canvas.drawPath(peak1, fillPaint);
    canvas.drawPath(peak1, paint);

    // Peak 2 (Left foreground peak)
    final peak2 = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.28, size.height * 0.45)
      ..lineTo(size.width * 0.62, size.height)
      ..close();
    canvas.drawPath(peak2, fillPaint);
    canvas.drawPath(peak2, paint);

    // Peak 3 (Right peak)
    final peak3 = Path()
      ..moveTo(size.width * 0.68, size.height)
      ..lineTo(size.width * 0.84, size.height * 0.58)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(peak3, fillPaint);
    canvas.drawPath(peak3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
