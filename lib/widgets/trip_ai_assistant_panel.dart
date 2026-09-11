import 'dart:async';
import 'package:flutter/material.dart';
import '../models/itinerary_trip_models.dart';
import '../theme.dart';

class TripAiAssistantPanel extends StatefulWidget {
  final TripFolderItem trip;
  final Function(TripAiSuggestion suggestion) onApplySuggestion;
  final Function(String topicPrompt)? onDiscussTopicInChat;
  final Function(ItineraryPlanVersion version)? onVersionChanged;

  const TripAiAssistantPanel({
    super.key,
    required this.trip,
    required this.onApplySuggestion,
    this.onDiscussTopicInChat,
    this.onVersionChanged,
  });

  @override
  State<TripAiAssistantPanel> createState() => _TripAiAssistantPanelState();
}

class _TripAiAssistantPanelState extends State<TripAiAssistantPanel> {
  final TextEditingController _queryController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final List<AiItineraryChatMessage> _chatHistory = [];
  bool isThinking = false;
  String? animatingSuggestionId;

  @override
  void initState() {
    super.initState();
    _initializeChatHistory();
  }

  @override
  void dispose() {
    _queryController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _initializeChatHistory() {
    _chatHistory.addAll([
      AiItineraryChatMessage(
        id: 'msg_ai_init',
        sender: 'TripNest AI',
        text:
            'Hello! I’ve reviewed your ${widget.trip.chatName} Notebook (${widget.trip.notebookDecisionsCount} decisions). I detected a few timing & walking opportunities to improve your itinerary.',
        timestamp: 'Just now',
        isAi: true,
      ),
    ]);
  }

  void _handleApplySuggestion(TripAiSuggestion suggestion) {
    setState(() {
      animatingSuggestionId = suggestion.id;
    });

    Timer(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        animatingSuggestionId = null;
        suggestion.isApplied = true;
      });
      widget.onApplySuggestion(suggestion);

      // Add confirmation to chat stream
      _chatHistory.add(
        AiItineraryChatMessage(
          id: 'applied_${DateTime.now().millisecondsSinceEpoch}',
          sender: 'TripNest AI',
          text: '✨ Applied "${suggestion.title}" to Day ${suggestion.targetDayNumber}! The itinerary schedule and map route have been updated.',
          timestamp: 'Just now',
          isAi: true,
        ),
      );
      _scrollToBottom();
    });
  }

  void _handleSendUserQuery(String queryText) {
    final text = queryText.trim();
    if (text.isEmpty) return;

    _queryController.clear();
    setState(() {
      _chatHistory.add(
        AiItineraryChatMessage(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          sender: 'You',
          text: text,
          timestamp: 'Now',
          isAi: false,
        ),
      );
      isThinking = true;
    });
    _scrollToBottom();

    Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        isThinking = false;
        final response = _generateAiResponse(text);
        _chatHistory.add(response);
      });
      _scrollToBottom();
    });
  }

  AiItineraryChatMessage _generateAiResponse(String query) {
    final lower = query.toLowerCase();

    if (lower.contains('tiring') || lower.contains('less tiring') || lower.contains('day 2')) {
      final unapplied = widget.trip.aiSuggestions.firstWhere(
        (s) => s.targetDayNumber == 2 && !s.isApplied,
        orElse: () => widget.trip.aiSuggestions.first,
      );
      return AiItineraryChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'TripNest AI',
        text:
            'Yes! Your Notebook mentions that the group prefers a relaxed morning pace (~10:30 AM). Day 2 was originally set for 08:00 AM with 13,800 steps. I can shift TeamLab Borderless to 10:30 AM and arrange an easy transit link.',
        timestamp: 'Now',
        isAi: true,
        attachedSuggestion: unapplied.isApplied ? null : unapplied,
      );
    } else if (lower.contains('early') || lower.contains('wake up') || lower.contains('sleep in') || lower.contains('morning')) {
      return AiItineraryChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'TripNest AI',
        text:
            'Understood! In the Notebook, you agreed: "No rushing early mornings." All days have been structured to start after 10:00 AM so everyone gets proper rest.',
        timestamp: 'Now',
        isAi: true,
      );
    } else if (lower.contains('walking') || lower.contains('steps') || lower.contains('too much walking')) {
      return AiItineraryChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'TripNest AI',
        text:
            'Sarah requested keeping daily walking below 15,000 steps. Day 3 originally estimated 15,400 steps due to the Asakusa-Ueno stretch. Taking the Ginza Line subway or adding Kappabashi reduces this to ~11,200 steps!',
        timestamp: 'Now',
        isAi: true,
      );
    } else if (lower.contains('café') || lower.contains('coffee') || lower.contains('shibuya')) {
      return AiItineraryChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'TripNest AI',
        text:
            'Daniel suggested a cozy café in Shibuya in your group chat. We’ve slotted Blue Bottle Kitaya Park into Day 1 at 10:30 AM, and Fuglen Tokyo is available as a nearby alternative!',
        timestamp: 'Now',
        isAi: true,
      );
    } else if (lower.contains('budget') || lower.contains('hotel') || lower.contains('rm250')) {
      return AiItineraryChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'TripNest AI',
        text:
            'Your Notebook has a locked decision: "Hotel budget ≤ RM250/night". Average daily activities and dining currently total ~RM140/pax, well within your group’s target.',
        timestamp: 'Now',
        isAi: true,
      );
    }

    return AiItineraryChatMessage(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'TripNest AI',
      text:
          'I checked your ${widget.trip.chatName} Notebook for "$query". The group’s priorities are: relaxed morning starts, under 15k steps, and good food spots. Would you like me to optimize any particular day?',
      timestamp: 'Now',
      isAi: true,
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent + 60,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // --------------------------------------------------
          // PANEL HEADER
          // --------------------------------------------------
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('🐦', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TripNest AI Assistant',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14.5,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Notebook intelligence & auto-optimizer',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, color: Color(0xFF059669), size: 12),
                      SizedBox(width: 4),
                      Text(
                        'Active',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --------------------------------------------------
          // SCROLLABLE AI SECTIONS
          // --------------------------------------------------
          Expanded(
            child: ListView(
              controller: _chatScrollController,
              padding: const EdgeInsets.all(14),
              children: [
                // 1. ITINERARY VERSION SELECTOR
                _buildVersionSelector(),
                const SizedBox(height: 14),

                // 2. PLANNING CHECK & MISSING TOPIC DETECTION
                _buildPlanningCheckCard(),
                const SizedBox(height: 14),

                // 3. PENDING AI NOTEBOOK SUGGESTIONS
                ...widget.trip.aiSuggestions.where((s) => !s.isApplied && !s.isIgnored).map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildSuggestionCard(s),
                      ),
                    ),

                // 4. CONVERSATIONAL STREAM
                const Divider(height: 24, color: Color(0xFFE2E8F0)),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Trip Planning Chat',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF64748B), letterSpacing: 0.5),
                  ),
                ),
                ..._chatHistory.map((m) => _buildChatBubble(m)),

                if (isThinking)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Text('🐦 ', style: TextStyle(fontSize: 14)),
                        Text(
                          'Analyzing Notebook and route options...',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // --------------------------------------------------
          // QUICK PROMPT CHIPS
          // --------------------------------------------------
          Container(
            height: 38,
            color: const Color(0xFFF8FAFC),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              children: [
                _buildPromptChip('Can we make Day 2 less tiring?'),
                _buildPromptChip('We don\'t want to wake up early'),
                _buildPromptChip('Which day has too much walking?'),
                _buildPromptChip('Find a café near Shibuya'),
              ],
            ),
          ),

          // --------------------------------------------------
          // AI QUERY INPUT BAR
          // --------------------------------------------------
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _queryController,
                    decoration: InputDecoration(
                      hintText: 'Ask TripNest AI anything about your trip...',
                      hintStyle: TextStyle(fontSize: 12.5, color: Colors.grey.shade500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: coral, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                    onSubmitted: _handleSendUserQuery,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: coral,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_upward_rounded, size: 18, color: Colors.white),
                    padding: EdgeInsets.zero,
                    onPressed: () => _handleSendUserQuery(_queryController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionSelector() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.alt_route, size: 14, color: Color(0xFF475569)),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'ITINERARY VERSION',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF64748B), letterSpacing: 0.5),
                ),
              ),
              if (widget.trip.currentVersion == ItineraryPlanVersion.balanced)
                const Text(
                  'Recommended ✨',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: coral),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildVersionBtn('⚖️ Balanced', ItineraryPlanVersion.balanced),
              const SizedBox(width: 6),
              _buildVersionBtn('💰 Budget', ItineraryPlanVersion.budget),
              const SizedBox(width: 6),
              _buildVersionBtn('✨ Comfort', ItineraryPlanVersion.comfort),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVersionBtn(String label, ItineraryPlanVersion version) {
    final isSelected = widget.trip.currentVersion == version;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            widget.trip.currentVersion = version;
          });
          if (widget.onVersionChanged != null) {
            widget.onVersionChanged!(version);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? coral : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? coral : const Color(0xFFCBD5E1)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF334155),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanningCheckCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🧠 ', style: TextStyle(fontSize: 14)),
              const Expanded(
                child: Text(
                  'PLANNING CHECK',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF166534),
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('85% Prepared', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Wrap(
            spacing: 10,
            runSpacing: 4,
            children: [
              Text('✓ Accommodation', style: TextStyle(fontSize: 11, color: Color(0xFF166534), fontWeight: FontWeight.w600)),
              Text('✓ Budget', style: TextStyle(fontSize: 11, color: Color(0xFF166534), fontWeight: FontWeight.w600)),
              Text('✓ Activities', style: TextStyle(fontSize: 11, color: Color(0xFF166534), fontWeight: FontWeight.w600)),
              Text('✓ Food', style: TextStyle(fontSize: 11, color: Color(0xFF166534), fontWeight: FontWeight.w600)),
              Text('✓ Travel Pace', style: TextStyle(fontSize: 11, color: Color(0xFF166534), fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF9C3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFDE047)),
            ),
            child: Row(
              children: [
                const Text('⚠ ', style: TextStyle(fontSize: 13)),
                const Expanded(
                  child: Text(
                    'Transportation: Your flock hasn’t discussed how to get between Shibuya & TeamLab.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF854D0E), fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 6),
                TextButton(
                  onPressed: () {
                    const prompt = 'How should we travel between Shibuya and TeamLab? Subway pass or Suica?';
                    if (widget.onDiscussTopicInChat != null) {
                      widget.onDiscussTopicInChat!(prompt);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Question sent to chatroom!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    backgroundColor: const Color(0xFFFEF08A),
                  ),
                  child: const Text(
                    'Discuss This',
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF713F12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(TripAiSuggestion suggestion) {
    final isAnimating = animatingSuggestionId == suggestion.id;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAnimating ? const Color(0xFFFFF1F2) : const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isAnimating ? coral : const Color(0xFFFED7AA),
          width: isAnimating ? 2.0 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(isAnimating ? '🐦' : '✨', style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'AI NOTEBOOK SUGGESTION',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                    color: coral,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Day ${suggestion.targetDayNumber}',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF7C2D12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            suggestion.title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 4),
          Text(
            suggestion.explanation,
            style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.35),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Text('💬 ', style: TextStyle(fontSize: 11)),
                Expanded(
                  child: Text(
                    suggestion.sourceNotebookQuote,
                    style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF334155)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              TextButton(
                onPressed: () => setState(() => suggestion.isIgnored = true),
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                child: const Text('Ignore', style: TextStyle(color: Colors.grey, fontSize: 11.5)),
              ),
              FilledButton.icon(
                onPressed: isAnimating ? null : () => _handleApplySuggestion(suggestion),
                icon: Text(isAnimating ? '🐦' : '✨', style: const TextStyle(fontSize: 12)),
                label: Text(
                  isAnimating ? 'Flying to Itinerary...' : 'Apply Change',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: coral,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(AiItineraryChatMessage msg) {
    return Align(
      alignment: msg.isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: msg.isAi ? const Color(0xFFF1F5F9) : coral,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(msg.isAi ? 4 : 12),
            bottomRight: Radius.circular(msg.isAi ? 12 : 4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (msg.isAi)
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🐦 ', style: TextStyle(fontSize: 11)),
                  Text(
                    'TripNest AI',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5, color: Color(0xFF475569)),
                  ),
                ],
              ),
            if (msg.isAi) const SizedBox(height: 3),
            Text(
              msg.text,
              style: TextStyle(
                fontSize: 12.5,
                color: msg.isAi ? const Color(0xFF0F172A) : Colors.white,
                height: 1.35,
              ),
            ),
            if (msg.attachedSuggestion != null) ...[
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => _handleApplySuggestion(msg.attachedSuggestion!),
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: coral,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Apply Changes Now ✨', style: TextStyle(fontSize: 11)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPromptChip(String prompt) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(prompt, style: const TextStyle(fontSize: 11, color: Color(0xFF334155))),
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFCBD5E1)),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        onPressed: () => _handleSendUserQuery(prompt),
      ),
    );
  }
}
