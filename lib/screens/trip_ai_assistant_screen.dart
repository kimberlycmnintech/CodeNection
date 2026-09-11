import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/itinerary_trip_models.dart';

class TripAiAssistantScreen extends StatefulWidget {
  final TripFolderItem trip;
  final Function(TripAiSuggestion suggestion)? onApplySuggestion;

  const TripAiAssistantScreen({
    super.key,
    required this.trip,
    this.onApplySuggestion,
  });

  @override
  State<TripAiAssistantScreen> createState() => _TripAiAssistantScreenState();
}

class _TripAiAssistantScreenState extends State<TripAiAssistantScreen> {
  final TextEditingController _queryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isThinking = false;
  final List<String> _appliedRecommendationIds = [];

  late List<_AssistantChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      _AssistantChatMessage(
        id: 'msg_1',
        sender: 'You',
        text: 'Can you make Day 2 less tiring? It looks a bit packed.',
        timestamp: '10:24',
        isAi: false,
      ),
      _AssistantChatMessage(
        id: 'msg_2',
        sender: 'TripNest AI',
        text:
            "Sure! I can make Day 2 more relaxed by reducing the number of spots and rearranging the order to minimize backtracking. I'll keep the must-see places and suggest a better pace with more breaks.",
        timestamp: '10:24',
        isAi: true,
        improvedPlanCard: _ImprovedPlanData(
          title: 'A more relaxed Day 2',
          subtitle: 'Same highlights, better flow, and more time to enjoy.',
          imageUrl:
              'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=600',
        ),
      ),
      _AssistantChatMessage(
        id: 'msg_3',
        sender: 'You',
        text: 'Great! Also, can you suggest some cheaper food options around Hongdae?',
        timestamp: '10:26',
        isAi: false,
      ),
      _AssistantChatMessage(
        id: 'msg_4',
        sender: 'TripNest AI',
        text:
            'Absolutely! Here are some budget-friendly and highly-rated food options around Hongdae, popular with locals and travellers.',
        timestamp: '10:26',
        isAi: true,
        foodCards: [
          _FoodOptionData(
            name: 'Hongdae Kimbap',
            priceRange: '₩4,500 ~ 7,000',
            rating: 4.5,
            imageUrl:
                'https://images.unsplash.com/photo-1553163147-622ab57be1c7?w=300',
          ),
          _FoodOptionData(
            name: 'Mapo Tteokbokki',
            priceRange: '₩3,000 ~ 6,000',
            rating: 4.4,
            imageUrl:
                'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=300',
          ),
          _FoodOptionData(
            name: 'Cafe Layered',
            priceRange: '₩5,000 ~ 8,000',
            rating: 4.6,
            imageUrl:
                'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=300',
          ),
        ],
      ),
    ];
  }

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendUserMessage(String queryText) {
    final text = queryText.trim();
    if (text.isEmpty) return;

    _queryController.clear();
    setState(() {
      _messages.add(
        _AssistantChatMessage(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          sender: 'You',
          text: text,
          timestamp: 'Just now',
          isAi: false,
        ),
      );
      _isThinking = true;
    });

    _scrollToBottom();

    Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _isThinking = false;
        _messages.add(_generateAiResponse(text));
      });
      _scrollToBottom();
    });
  }

  _AssistantChatMessage _generateAiResponse(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('tiring') || lower.contains('day 2') || lower.contains('walking')) {
      return _AssistantChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'TripNest AI',
        text:
            'I shifted the Day 2 schedule to start after 10:30 AM and reduced total walking steps by ~3,500. The route order has been updated automatically!',
        timestamp: 'Just now',
        isAi: true,
      );
    } else if (lower.contains('food') || lower.contains('eat') || lower.contains('hongdae')) {
      return _AssistantChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'TripNest AI',
        text:
            'Added 3 top-rated local dining spots to your Hongdae exploration list. You can view them on the map anytime!',
        timestamp: 'Just now',
        isAi: true,
      );
    }

    return _AssistantChatMessage(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'TripNest AI',
      text:
          'Got it! I analyzed your trip details for "${widget.trip.destination}". All stops and transit links are aligned with your travel style preferences.',
      timestamp: 'Just now',
      isAi: true,
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _applyRecommendation(String id, String title) {
    setState(() {
      if (!_appliedRecommendationIds.contains(id)) {
        _appliedRecommendationIds.add(id);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✨ Applied "$title" to your itinerary!'),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          tooltip: 'Back to Itinerary',
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome, color: Color(0xFF2563EB), size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              'TripNest AI Assistant',
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 950;

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Main Chat & Assistant Dashboard (Width ~65%)
                Expanded(
                  flex: 65,
                  child: _buildLeftChatColumn(),
                ),
                const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),
                // Right Column: Version, Planning Check & Recommendations (Width ~35%)
                Expanded(
                  flex: 35,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildRightSidebar(),
                  ),
                ),
              ],
            );
          }

          // Single Column Layout for Tablet / Mobile
          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _buildLeftChatColumn(isEmbedded: true),
                const SizedBox(height: 16),
                _buildRightSidebar(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ====================================================
  // LEFT COLUMN: MAIN CHAT & ASSISTANT DASHBOARD
  // ====================================================
  Widget _buildLeftChatColumn({bool isEmbedded = false}) {
    final bodyContent = ListView(
      controller: isEmbedded ? null : _scrollController,
      shrinkWrap: isEmbedded,
      physics: isEmbedded ? const NeverScrollableScrollPhysics() : null,
      padding: const EdgeInsets.all(18),
      children: [
        // 1. TOP HERO HEADER BANNER
        _buildHeroHeaderBanner(),
        const SizedBox(height: 20),

        // 2. QUICK ACTION SUGGESTION CARDS ("How can I help you today?")
        _buildQuickSuggestionsSection(),
        const SizedBox(height: 24),

        // 3. CONVERSATIONAL STREAM BUBBLES
        for (final msg in _messages) ...[
          _buildChatMessageBubble(msg),
          const SizedBox(height: 16),
        ],

        if (_isThinking) ...[
          Padding(
            padding: const EdgeInsets.only(left: 42, bottom: 16),
            child: Row(
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2563EB)),
                ),
                const SizedBox(width: 10),
                Text(
                  'TripNest AI is thinking...',
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ],
    );

    if (isEmbedded) {
      return Column(
        children: [
          bodyContent,
          _buildBottomInputDock(),
        ],
      );
    }

    return Column(
      children: [
        Expanded(child: bodyContent),
        _buildBottomInputDock(),
      ],
    );
  }

  /// 1. Top Hero Header Banner
  Widget _buildHeroHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEBF3FE), Color(0xFFDCEBFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBFDBFE).withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bird Avatar Circle
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🐦', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TripNest AI Assistant',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ask, optimize, and improve your plan.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Get personalised recommendations, make changes, and plan a better trip with AI.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Quick Action Suggestion Cards
  Widget _buildQuickSuggestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How can I help you today?',
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Here are some popular ways to plan smarter for your ${widget.trip.destination.split(',').first} trip.',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.directions_run_rounded,
                title: 'Make Day 2 less tiring',
                subtitle: 'Rearrange the itinerary to reduce walking and transit time.',
                onTap: () => _sendUserMessage('Can you make Day 2 less tiring? It looks a bit packed.'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.restaurant_rounded,
                title: 'Find cheaper food options',
                subtitle: 'Suggest budget-friendly restaurants and street food.',
                onTap: () => _sendUserMessage('Can you suggest some cheaper food options around Hongdae?'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.place_outlined,
                title: 'Reduce walking distance',
                subtitle: 'Optimize the route to minimize walking between spots.',
                onTap: () => _sendUserMessage('Optimize route to reduce overall walking distance.'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: const Color(0xFF2563EB)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      color: const Color(0xFF64748B),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  /// 3. Chat Message Bubbles (User vs AI)
  Widget _buildChatMessageBubble(_AssistantChatMessage msg) {
    if (!msg.isAi) {
      // User Message Bubble (Right aligned)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 480),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0ECFB),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                    topRight: Radius.circular(4),
                  ),
                ),
                child: Text(
                  msg.text,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    color: const Color(0xFF0F172A),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            msg.timestamp,
            style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8)),
          ),
        ],
      );
    }

    // AI Response Bubble (Left aligned)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF2563EB),
                shape: BoxShape.circle,
              ),
              child: const Center(child: Text('🐦', style: TextStyle(fontSize: 16))),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TripNest AI',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF475569)),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                        topLeft: Radius.circular(4),
                      ),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            color: const Color(0xFF0F172A),
                            height: 1.4,
                          ),
                        ),

                        // Embedded Improved Plan Card
                        if (msg.improvedPlanCard != null) ...[
                          const SizedBox(height: 12),
                          _buildEmbeddedImprovedPlanCard(msg.improvedPlanCard!),
                        ],

                        // Embedded Food Option Cards Row
                        if (msg.foodCards != null && msg.foodCards!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildEmbeddedFoodCardsRow(msg.foodCards!),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    msg.timestamp,
                    style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Embedded Improved Plan Card inside AI response bubble
  Widget _buildEmbeddedImprovedPlanCard(_ImprovedPlanData data) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              data.imageUrl,
              width: 72,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, size: 10, color: Color(0xFF15803D)),
                      const SizedBox(width: 4),
                      Text(
                        'Improved Plan',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF15803D)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.title,
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                ),
                Text(
                  data.subtitle,
                  style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }

  /// Embedded Food Option Cards Row inside AI response bubble
  Widget _buildEmbeddedFoodCardsRow(List<_FoodOptionData> foodList) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final item in foodList) ...[
            Container(
              width: 165,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item.imageUrl,
                      width: double.infinity,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
                    ],
                  ),
                  Text(
                    item.priceRange,
                    style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 3),
                      Text(
                        '${item.rating}',
                        style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFF334155)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Bottom Input Dock Bar
  Widget _buildBottomInputDock() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_file_rounded, size: 20, color: Color(0xFF94A3B8)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _queryController,
              onSubmitted: _sendUserMessage,
              decoration: InputDecoration(
                hintText: 'Ask TripNest AI anything about your trip...',
                hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Text(
            'Press Enter to send',
            style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () => _sendUserMessage(_queryController.text),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF2563EB),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================
  // RIGHT SIDEBAR WIDGETS (Planning Check, Recommendations)
  // ====================================================
  Widget _buildRightSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. PLANNING CHECK CARD
        _buildPlanningCheckCard(),
        const SizedBox(height: 16),

        // 2. AI RECOMMENDATIONS CARD
        _buildAiRecommendationsCard(),
      ],
    );
  }



  /// 2. Planning Check Card
  Widget _buildPlanningCheckCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          Row(
            children: [
              const Icon(Icons.verified_outlined, size: 18, color: Color(0xFF2563EB)),
              const SizedBox(width: 8),
              Text(
                'Planning Check',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              // Progress Ring 85%
              Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 62,
                    height: 62,
                    child: CircularProgressIndicator(
                      value: 0.85,
                      strokeWidth: 6,
                      backgroundColor: Color(0xFFE2E8F0),
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  Text(
                    '85%',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A)),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Great progress!',
                      style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Your trip is well planned. A few small improvements can make it even better.',
                      style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B), height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Checklist items
          _buildChecklistItem('Key attractions added', '12 / 12', isDone: true),
          _buildChecklistItem('Food & dining options', '8 / 10', isDone: true),
          _buildChecklistItem('Transit & routes optimized', '4 / 4', isDone: true),
          _buildChecklistItem('Free time & buffer', '2 / 4', isDone: false),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String title, String count, {required bool isDone}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.remove_circle_outline,
            size: 16,
            color: isDone ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155)),
            ),
          ),
          Text(
            count,
            style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  /// 3. AI Recommendations Card
  Widget _buildAiRecommendationsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.lightbulb_outline_rounded, size: 18, color: Color(0xFF2563EB)),
                  const SizedBox(width: 8),
                  Text(
                    'AI Recommendations',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                  ),
                ],
              ),
              Text(
                'See all',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF2563EB)),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            'Personalized suggestions to make your trip even better.',
            style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B)),
          ),
          const SizedBox(height: 14),

          // Recommendation Item 1
          _buildRecommendationItemCard(
            id: 'rec_1',
            imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=300',
            title: 'Add a café break on Day 1',
            subtitle: "You'll be near Anthracite Coffee Roasters. A great spot to rest and enjoy local vibes.",
          ),
          const SizedBox(height: 12),

          // Recommendation Item 2
          _buildRecommendationItemCard(
            id: 'rec_2',
            imageUrl: 'https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=300',
            title: 'Try budget-friendly eats in Hongdae',
            subtitle: 'I found 5 highly-rated food spots under ₩7,000 near your Day 3 route.',
          ),
          const SizedBox(height: 12),

          // Recommendation Item 3
          _buildRecommendationItemCard(
            id: 'rec_3',
            imageUrl: 'https://images.unsplash.com/photo-1578637387939-43c525550085?w=300',
            title: 'Go later to Namsan Tower',
            subtitle: 'Sunset offers better views and fewer crowds.',
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItemCard({
    required String id,
    required String imageUrl,
    required String title,
    required String subtitle,
  }) {
    final isApplied = _appliedRecommendationIds.contains(id);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl,
            width: 54,
            height: 54,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
                ],
              ),
              Text(
                subtitle,
                style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B), height: 1.3),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  FilledButton(
                    onPressed: isApplied ? null : () => _applyRecommendation(id, title),
                    style: FilledButton.styleFrom(
                      backgroundColor: isApplied ? const Color(0xFFDCFCE7) : const Color(0xFF2563EB),
                      foregroundColor: isApplied ? const Color(0xFF15803D) : Colors.white,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      isApplied ? 'Applied ✓' : 'Apply change',
                      style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Previewing "$title"...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    child: Text(
                      'Preview',
                      style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFF2563EB)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Data models for the chat thread
class _AssistantChatMessage {
  final String id;
  final String sender;
  final String text;
  final String timestamp;
  final bool isAi;
  final _ImprovedPlanData? improvedPlanCard;
  final List<_FoodOptionData>? foodCards;

  _AssistantChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    required this.isAi,
    this.improvedPlanCard,
    this.foodCards,
  });
}

class _ImprovedPlanData {
  final String title;
  final String subtitle;
  final String imageUrl;

  _ImprovedPlanData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

class _FoodOptionData {
  final String name;
  final String priceRange;
  final double rating;
  final String imageUrl;

  _FoodOptionData({
    required this.name,
    required this.priceRange,
    required this.rating,
    required this.imageUrl,
  });
}
