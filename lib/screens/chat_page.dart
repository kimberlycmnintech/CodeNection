import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../models/chat_planning_models.dart';
import '../theme.dart';
import '../widgets/planning_check_card.dart';
import '../widgets/ai_prompt_modal.dart';

class ChatPage extends StatefulWidget {
  final SocialData data;
  final TripData trip;
  final Function(int)? onNavigateToTab;

  const ChatPage({
    super.key,
    required this.data,
    required this.trip,
    this.onNavigateToTab,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class FriendRequestItem {
  final String id;
  final String name;
  final String avatarUrl;
  final String avatarLetter;
  final Color avatarColor;
  final String bio;
  final String destination;
  final String time;
  final String note;
  final String mbti;

  const FriendRequestItem({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.avatarLetter,
    required this.avatarColor,
    required this.bio,
    required this.destination,
    required this.time,
    required this.note,
    required this.mbti,
  });
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  late List<ChatConversation> conversations;
  late ChatConversation activeConversation;
  late List<FriendRequestItem> _friendRequests;
  bool _showFriendRequestsInline = true;

  final TextEditingController _msgInputController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final FocusNode _msgFocusNode = FocusNode();

  Timer? _badgeTimer;
  Timer? _aiTimer;

  // Selection Mode state
  bool isSelectionMode = false;
  final Set<String> selectedMessageIds = {};

  // Drag & drop highlight state
  bool isHoveringNotebook = false;
  bool isHoveringMobileNest = false;

  // Itinerary update state
  bool isItineraryUpdating = false;
  bool showUpdatedBadge = false;

  // Resizable boundary state between AI Notebook & Itinerary
  double _notebookHeightRatio = 0.52;

  @override
  void initState() {
    super.initState();
    _initializeDemoData();
  }

  @override
  void dispose() {
    _badgeTimer?.cancel();
    _aiTimer?.cancel();
    _msgInputController.dispose();
    _chatScrollController.dispose();
    _msgFocusNode.dispose();
    super.dispose();
  }

  void _initializeDemoData() {
    // ----------------------------------------------------
    // INITIAL SAMPLE CONVERSATION DATA
    // ----------------------------------------------------
    final tokyoMessages = [
      ChatMessage(
        id: 'msg_0',
        senderName: 'Daniel',
        isMe: false,
        text: 'Hotel budget ≤ RM250/night so we have more for food.',
        timestamp: '10:22 AM',
        category: MessageCategory.budget,
        categoryLabel: 'Budget',
        categoryIcon: '💰',
        isSavedToNotebook: true,
      ),
      ChatMessage(
        id: 'msg_1',
        senderName: 'Maya',
        isMe: false,
        text: 'I really want to visit TeamLab Borderless.',
        timestamp: '10:24 AM',
        category: MessageCategory.places,
        categoryLabel: 'Must Visit',
        categoryIcon: '📍',
        isSavedToNotebook: true,
      ),
      ChatMessage(
        id: 'msg_2',
        senderName: 'You',
        isMe: true,
        text: 'Same! Maybe Day 2?',
        timestamp: '10:25 AM',
        category: MessageCategory.schedule,
        categoryLabel: 'Schedule',
        categoryIcon: '🕐',
      ),
      ChatMessage(
        id: 'msg_3',
        senderName: 'Daniel',
        isMe: false,
        text: 'I found a great café near Shibuya for breakfast.',
        timestamp: '10:27 AM',
        category: MessageCategory.food,
        categoryLabel: 'Café & Food',
        categoryIcon: '☕',
      ),
      ChatMessage(
        id: 'msg_4',
        senderName: 'Sarah',
        isMe: false,
        text: 'Can we avoid too much walking? Max ~15k steps please!',
        timestamp: '10:29 AM',
        category: MessageCategory.walking,
        categoryLabel: 'Walking Tolerance',
        categoryIcon: '🚶',
        isSavedToNotebook: true,
      ),
      ChatMessage(
        id: 'msg_5',
        senderName: 'You',
        isMe: true,
        text: "Let's start around 10:30 instead of 8am to keep it relaxed.",
        timestamp: '10:31 AM',
        category: MessageCategory.schedule,
        categoryLabel: 'Schedule',
        categoryIcon: '🕐',
        isSavedToNotebook: true,
      ),
      ChatMessage(
        id: 'msg_6',
        senderName: 'Maya',
        isMe: false,
        text: 'We should ride the scenic Yurikamome train line at sunset.',
        timestamp: '10:33 AM',
        category: MessageCategory.places,
        categoryLabel: 'Transit & Views',
        categoryIcon: '🚆',
      ),
      ChatMessage(
        id: 'msg_7',
        senderName: 'Sarah',
        isMe: false,
        text: 'Coffee tasting session at Bear Pond Espresso sounds super relaxing.',
        timestamp: '10:35 AM',
        category: MessageCategory.food,
        categoryLabel: 'Café',
        categoryIcon: '☕',
      ),
    ];

    // Initial Notebook Items
    final tokyoNotebook = [
      NotebookItem(
        id: 'nb_1',
        originalMessage: tokyoMessages[1],
        structuredTitle: 'TeamLab Borderless',
        category: '📍 Must Visit',
        categoryIcon: '📍',
        badgeColor: const Color(0xFFEF4444),
        contributorName: 'Maya',
        timestamp: '10:24 AM',
        userNotes: 'Book morning tickets online in advance.',
      ),
      NotebookItem(
        id: 'nb_2',
        originalMessage: tokyoMessages[4],
        structuredTitle: 'Walking Limit: Max 15k steps/day',
        category: '🚶 Walking Preference',
        categoryIcon: '🚶',
        badgeColor: const Color(0xFF10B981),
        contributorName: 'Sarah',
        timestamp: '10:29 AM',
        userNotes: 'Take metro between distant hubs.',
      ),
      NotebookItem(
        id: 'nb_3',
        originalMessage: tokyoMessages[5],
        structuredTitle: 'Schedule: Late morning starts (~10:30 AM)',
        category: '🕐 Schedule',
        categoryIcon: '🕐',
        badgeColor: const Color(0xFF3B82F6),
        contributorName: 'You',
        timestamp: '10:31 AM',
        userNotes: 'No rushing early mornings.',
      ),
      NotebookItem(
        id: 'nb_4',
        originalMessage: tokyoMessages[0],
        structuredTitle: 'Hotel budget ≤ RM250/night',
        category: '💰 Budget',
        categoryIcon: '💰',
        badgeColor: const Color(0xFF8B5CF6),
        contributorName: 'Daniel',
        timestamp: '10:22 AM',
        userNotes: 'Keep accommodation below RM250/night.',
      ),
    ];

    // Initial Itinerary Days
    final tokyoItinerary = [
      ItineraryDay(
        dayNumber: 1,
        date: 'Thu, Nov 12',
        summary: 'Arrival & Shibuya Vibes',
        walkingEstimate: '11,200 steps',
        stops: [
          ItineraryStop(
            time: '14:00',
            name: 'Check-in at Shibuya Hotel',
            category: 'Accommodation',
            notes: 'Budget verified (< RM250/night)',
            distance: 'Express Train from Narita',
          ),
          ItineraryStop(
            time: '16:30',
            name: 'Shibuya Crossing & Hachiko',
            category: 'Sightseeing',
            notes: 'Classic Tokyo landmark view',
            distance: '5 min walk',
          ),
          ItineraryStop(
            time: '19:00',
            name: 'Nonbei Yokocho Izakaya Dinner',
            category: 'Food',
            notes: 'Local yakitori alleys',
            distance: '8 min walk',
          ),
        ],
      ),
      ItineraryDay(
        dayNumber: 2,
        date: 'Fri, Nov 13',
        summary: 'TeamLab & Modern Tokyo',
        walkingEstimate: '9,400 steps',
        stops: [
          ItineraryStop(
            time: '10:30',
            name: 'TeamLab Borderless (Priority Stop)',
            category: 'Activities',
            notes: 'Saved from Maya’s discussion',
            distance: 'Direct Yurikamome line',
            isHighlight: true,
          ),
          ItineraryStop(
            time: '14:00',
            name: 'Ginza Lunch & Café',
            category: 'Food',
            notes: 'Daniel’s café recommendation',
            distance: '12 min transit',
            isHighlight: true,
          ),
          ItineraryStop(
            time: '16:30',
            name: 'Tokyo Station Character Street',
            category: 'Shopping',
            notes: 'Easy indoor walking',
            distance: '10 min walk',
          ),
        ],
      ),
      ItineraryDay(
        dayNumber: 3,
        date: 'Sat, Nov 14',
        summary: 'Vintage Shopping & Café Hopping',
        walkingEstimate: '10,800 steps',
        stops: [
          ItineraryStop(
            time: '11:00',
            name: 'Shimokitazawa Vintage Boutiques',
            category: 'Shopping',
            notes: 'Relaxed thrift browsing',
            distance: 'Odakyu line from Shinjuku',
          ),
          ItineraryStop(
            time: '14:30',
            name: 'Bear Pond Espresso',
            category: 'Café',
            notes: 'Specialty coffee stop',
            distance: '3 min walk',
          ),
        ],
      ),
    ];

    conversations = [
      ChatConversation(
        id: 'tokyo_squad',
        name: 'Tokyo Squad',
        destination: 'Tokyo, Japan',
        isGroup: true,
        memberCount: 4,
        lastMessage: "Let's start around 10:30 instead of 8am...",
        timestamp: '5m',
        unreadCount: 2,
        avatarLetter: 'T',
        avatarColor: coral,
        messages: tokyoMessages,
        notebookItems: tokyoNotebook,
        itinerary: tokyoItinerary,
      ),
      ChatConversation(
        id: 'maya_direct',
        name: 'Maya',
        destination: 'Tokyo Adventure',
        isGroup: false,
        memberCount: 2,
        lastMessage: 'I saved the TeamLab tickets in my wallet!',
        timestamp: '2m',
        unreadCount: 1,
        avatarLetter: 'M',
        avatarColor: const Color(0xFF10B981),
        messages: [
          ChatMessage(
            id: 'm_1',
            senderName: 'Maya',
            isMe: false,
            text: 'Hey! Are you excited for Tokyo next month?',
            timestamp: '9:40 AM',
            category: MessageCategory.general,
            categoryLabel: 'General',
            categoryIcon: '💬',
          ),
          ChatMessage(
            id: 'm_2',
            senderName: 'You',
            isMe: true,
            text: 'Super excited! Definitely want to eat good ramen.',
            timestamp: '9:42 AM',
            category: MessageCategory.food,
            categoryLabel: 'Food',
            categoryIcon: '🍜',
          ),
          ChatMessage(
            id: 'm_3',
            senderName: 'Maya',
            isMe: false,
            text: 'I saved the TeamLab tickets in my wallet!',
            timestamp: '9:45 AM',
            category: MessageCategory.activities,
            categoryLabel: 'Activities',
            categoryIcon: '🎯',
          ),
        ],
        notebookItems: [],
        itinerary: [],
      ),
      ChatConversation(
        id: 'daniel_direct',
        name: 'Daniel',
        destination: 'Seoul Weekend',
        isGroup: false,
        memberCount: 2,
        lastMessage: 'Found a boutique hotel near Hongdae under RM220.',
        timestamp: '1h',
        unreadCount: 0,
        avatarLetter: 'D',
        avatarColor: const Color(0xFF3B82F6),
        messages: [
          ChatMessage(
            id: 'd_1',
            senderName: 'Daniel',
            isMe: false,
            text: 'Found a boutique hotel near Hongdae under RM220.',
            timestamp: '8:15 AM',
            category: MessageCategory.budget,
            categoryLabel: 'Budget & Stay',
            categoryIcon: '🏨',
          ),
        ],
        notebookItems: [],
        itinerary: [],
      ),
      ChatConversation(
        id: 'japan_2026',
        name: 'Japan 2026',
        destination: 'Kyoto & Osaka',
        isGroup: true,
        memberCount: 5,
        lastMessage: 'Fushimi Inari morning hike is locked in!',
        timestamp: 'Yesterday',
        unreadCount: 0,
        avatarLetter: 'J',
        avatarColor: const Color(0xFF8B5CF6),
        messages: [
          ChatMessage(
            id: 'j_1',
            senderName: 'Ken',
            isMe: false,
            text: 'Fushimi Inari morning hike is locked in!',
            timestamp: 'Yesterday',
            category: MessageCategory.places,
            categoryLabel: 'Sightseeing',
            categoryIcon: '⛩️',
          ),
        ],
        notebookItems: [],
        itinerary: [],
      ),
    ];

    activeConversation = conversations.first;

    // Initial Friend Requests List
    _friendRequests = [
      const FriendRequestItem(
        id: 'fr_sophia',
        name: 'Sophia Chen',
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=120',
        avatarLetter: 'S',
        avatarColor: Color(0xFFEC4899),
        bio: 'Landscape Photographer • Nature Lover',
        destination: 'Banff, Canada',
        time: '12m ago',
        note: 'Saw your Canadian Rockies trip! Day 1 coffee & hike looks amazing, would love to connect.',
        mbti: 'ENFP',
      ),
      const FriendRequestItem(
        id: 'fr_liam',
        name: 'Liam Brooks',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=120',
        avatarLetter: 'L',
        avatarColor: Color(0xFF3B82F6),
        bio: 'Solo Hiker • Mountain Trail Enthusiast',
        destination: 'Banff, Canada',
        time: '2h ago',
        note: 'Heading to Banff around the same dates in June. Let\'s sync plans!',
        mbti: 'ISTP',
      ),
      const FriendRequestItem(
        id: 'fr_elena',
        name: 'Elena Rostova',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=120',
        avatarLetter: 'E',
        avatarColor: Color(0xFF8B5CF6),
        bio: 'Café Enthusiast • Cultural Explorer',
        destination: 'Tokyo, Japan',
        time: '1d ago',
        note: 'Loved your Tokyo squad ideas! Would love to share tips.',
        mbti: 'INFJ',
      ),
    ];
  }

  // ----------------------------------------------------
  // Dynamic Planning Topics Calculation
  // ----------------------------------------------------
  List<PlanningTopic> get currentPlanningTopics {
    final nb = activeConversation.notebookItems;
    final hasActivities = nb.any((item) =>
        item.category.contains('Must Visit') ||
        item.category.contains('Activities') ||
        item.structuredTitle.toLowerCase().contains('teamlab'));
    final hasSchedule = nb.any((item) =>
        item.category.contains('Schedule') ||
        item.structuredTitle.toLowerCase().contains('start'));
    final hasWalking = nb.any((item) =>
        item.category.contains('Walking') ||
        item.structuredTitle.toLowerCase().contains('step'));
    final hasFood = nb.any((item) =>
        item.category.contains('Food') ||
        item.structuredTitle.toLowerCase().contains('café'));
    final hasBudget = nb.any((item) =>
        item.category.contains('Budget') ||
        item.structuredTitle.toLowerCase().contains('hotel'));
    final hasTransport = nb.any((item) =>
        item.category.contains('Transportation') ||
        item.structuredTitle.toLowerCase().contains('train') ||
        item.structuredTitle.toLowerCase().contains('metro'));

    return [
      const PlanningTopic(
        key: 'destination',
        title: 'Destination (Tokyo)',
        isDiscussed: true,
      ),
      const PlanningTopic(
        key: 'dates',
        title: 'Travel Dates',
        isDiscussed: true,
      ),
      PlanningTopic(
        key: 'activities',
        title: 'Activities',
        isDiscussed: hasActivities,
        suggestedMessage: 'What attractions are on everyone’s bucket list for Tokyo?',
      ),
      PlanningTopic(
        key: 'budget',
        title: 'Budget & Stays',
        isDiscussed: hasBudget,
        suggestedMessage: "Let's cap our hotel budget below RM250 per night.",
      ),
      PlanningTopic(
        key: 'schedule',
        title: 'Schedule & Pace',
        isDiscussed: hasSchedule,
        suggestedMessage: 'What time do we prefer heading out each morning?',
      ),
      PlanningTopic(
        key: 'walking',
        title: 'Walking Tolerance',
        isDiscussed: hasWalking,
        suggestedMessage: 'How much walking per day is comfortable for the group?',
      ),
      PlanningTopic(
        key: 'transportation',
        title: 'Transportation',
        isDiscussed: hasTransport,
        suggestedMessage: 'How should we get around Tokyo? Subway pass or Suica card?',
      ),
      PlanningTopic(
        key: 'food',
        title: 'Food Preferences',
        isDiscussed: hasFood,
        suggestedMessage: 'Any specific ramen, sushi, or café spots we must hit?',
      ),
    ];
  }

  // ----------------------------------------------------
  // Actions: Add Message / Bunch to Notebook
  // ----------------------------------------------------
  void _savePayloadToNotebook(ChatDragPayload payload) {
    int savedCount = 0;
    String lastTitle = '';

    for (final msg in payload.messages) {
      if (activeConversation.notebookItems.any((item) => item.originalMessage.id == msg.id)) {
        continue;
      }

      String title = msg.text;
      String category = '📍 Places';
      String icon = '📍';
      Color color = const Color(0xFFEF4444);

      final lower = msg.text.toLowerCase();
      if (lower.contains('teamlab')) {
        title = 'TeamLab Borderless';
        category = '📍 Must Visit';
        icon = '📍';
        color = const Color(0xFFEF4444);
      } else if (lower.contains('café') || lower.contains('food') || lower.contains('ramen')) {
        title = 'Café / Food in Shibuya';
        category = '☕ Food & Cafés';
        icon = '☕';
        color = const Color(0xFFF59E0B);
      } else if (lower.contains('walking') || lower.contains('step')) {
        title = 'Walking Limit: Max 15k steps/day';
        category = '🚶 Walking Preference';
        icon = '🚶';
        color = const Color(0xFF10B981);
      } else if (lower.contains('10:30') || lower.contains('start') || lower.contains('schedule')) {
        title = 'Late morning starts (~10:30 AM)';
        category = '🕐 Schedule';
        icon = '🕐';
        color = const Color(0xFF3B82F6);
      } else if (lower.contains('hotel') || lower.contains('rm250') || lower.contains('budget')) {
        title = 'Hotel budget ≤ RM250/night';
        category = '💰 Budget';
        icon = '💰';
        color = const Color(0xFF8B5CF6);
      } else if (lower.contains('subway') || lower.contains('train') || lower.contains('suica') || lower.contains('transport')) {
        title = 'Transit: Tokyo Subway 72-hr pass';
        category = '🚆 Transportation';
        icon = '🚆';
        color = const Color(0xFF06B6D4);
      }

      final newItem = NotebookItem(
        id: 'nb_${DateTime.now().millisecondsSinceEpoch}_$savedCount',
        originalMessage: msg,
        structuredTitle: title,
        category: category,
        categoryIcon: icon,
        badgeColor: color,
        contributorName: msg.senderName,
        timestamp: msg.timestamp,
      );

      msg.isSavedToNotebook = true;
      activeConversation.notebookItems.add(newItem);
      savedCount++;
      lastTitle = title;
    }

    setState(() {
      if (payload.isBunch || isSelectionMode) {
        isSelectionMode = false;
        selectedMessageIds.clear();
      }
    });

    if (savedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selected message(s) are already in the Notebook.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('🐦 ', style: TextStyle(fontSize: 16)),
            Expanded(
              child: Text(
                payload.isBunch || savedCount > 1
                    ? 'Saved bunch of $savedCount conversations to Notebook! 🪺'
                    : 'Saved to Notebook ✓ ("$lastTitle")',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 2500),
      ),
    );
  }

  void _addSelectedMessagesToNotebook() {
    final selectedMsgs = activeConversation.messages
        .where((m) => selectedMessageIds.contains(m.id))
        .toList();
    _savePayloadToNotebook(ChatDragPayload.bunch(selectedMsgs));
  }

  void _sendMessage() {
    final text = _msgInputController.text.trim();
    if (text.isEmpty) return;

    final newMsg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderName: 'You',
      isMe: true,
      text: text,
      timestamp: 'Now',
      category: MessageCategory.general,
      categoryLabel: 'Message',
      categoryIcon: '💬',
    );

    setState(() {
      activeConversation.messages.add(newMsg);
      _msgInputController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onDiscussMissingTopic(String suggestedMessage) {
    setState(() {
      _msgInputController.text = suggestedMessage;
    });
    _msgFocusNode.requestFocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Suggested question placed into chat input! You can edit and send.'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ----------------------------------------------------
  // Notebook -> AI Prompt -> Live Itinerary Update
  // ----------------------------------------------------
  void _openAiPromptModal() {
    final nb = activeConversation.notebookItems;
    final priorities = nb.map((i) => '• ${i.structuredTitle}').join('\n');

    final prompt = '''Create a ${activeConversation.destination} itinerary for ${activeConversation.memberCount} travellers.

Priorities:
${priorities.isNotEmpty ? priorities : '• TeamLab Borderless\n• Shibuya Crossing\n• Café hopping'}

Preferences:
• Late morning starts (~10:30 AM)
• Maximum 15k steps/day
• Hotel budget below RM250/night

Avoid:
• Excessive rushing and back-and-forth transit''';

    showDialog(
      context: context,
      builder: (_) => AiPromptModal(
        initialPrompt: prompt,
        onSendToItinerary: _applyAiItineraryUpdate,
      ),
    );
  }

  void _applyAiItineraryUpdate(String promptText) {
    setState(() {
      isItineraryUpdating = true;
    });

    // Simulated AI Thinking Transition (bird micro-interaction)
    _aiTimer?.cancel();
    _aiTimer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        isItineraryUpdating = false;
        showUpdatedBadge = true;

        // Enhance Day 2 with structured times & walking info
        if (activeConversation.itinerary.length >= 2) {
          final day2 = activeConversation.itinerary[1];
          activeConversation.itinerary[1] = ItineraryDay(
            dayNumber: day2.dayNumber,
            date: day2.date,
            summary: 'TeamLab Borderless & Ginza Gourmet',
            walkingEstimate: '8,600 steps (Pace: Relaxed)',
            stops: [
              ItineraryStop(
                time: '10:30',
                name: 'TeamLab Borderless (Priority Entry)',
                category: 'Activities',
                notes: 'Digital art exhibits · Preserved from Maya’s discussion',
                distance: 'Direct transit (15 min)',
                isHighlight: true,
              ),
              ItineraryStop(
                time: '13:30',
                name: 'Ginza Café & Lunch Stop',
                category: 'Food',
                notes: 'Resting legs · Daniel’s coffee spot',
                distance: '10 min metro',
                isHighlight: true,
              ),
              ItineraryStop(
                time: '15:30',
                name: 'Tokyo Station Galleries',
                category: 'Sightseeing',
                notes: 'Indoor strolling (< 3,000 steps)',
                distance: '6 min walk',
                isHighlight: true,
              ),
            ],
          );
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Text('✨ ', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(
                  'Itinerary Updated! Day 2 restructured from your Notebook decisions.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFF0B2240),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );

      _badgeTimer?.cancel();
      _badgeTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) setState(() => showUpdatedBadge = false);
      });
    });
  }

  // ----------------------------------------------------
  // Build Main Layout (Responsive)
  // ----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 960;
        final isTablet = constraints.maxWidth >= 700 && constraints.maxWidth < 960;

        return Scaffold(
          backgroundColor: tripzenBg,
          body: isDesktop
              ? _buildDesktopLayout()
              : isTablet
                  ? _buildTabletLayout()
                  : _buildMobileLayout(),
        );
      },
    );
  }

  void _openTripsFolder() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    if (widget.onNavigateToTab != null) {
      widget.onNavigateToTab!(1); // Navigate to Trips / My Itineraries tab
    }
  }

  // ====================================================
  // 1. DESKTOP LAYOUT (3 Columns: Conversations | Chat | Notebook + Itinerary)
  // ====================================================
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left Column: Conversations List (280px)
        SizedBox(
          width: 280,
          child: _buildConversationListPanel(),
        ),
        const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),

        // Center Column: Chat Stream & Input (Flex)
        Expanded(
          flex: 5,
          child: _buildChatArea(isMobile: false),
        ),
        const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),

        // Right Column: Top AI Notebook + Bottom Live Itinerary (380px) with Resizable Divider
        SizedBox(
          width: 380,
          child: Column(
            children: [
              // Top-Right: AI Notebook (Drop Target)
              Expanded(
                flex: (_notebookHeightRatio * 100).round(),
                child: _buildDesktopNotebookDropZone(),
              ),
              
              // Resizable Boundary Drag Handle
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _notebookHeightRatio += details.delta.dy / 600.0;
                    _notebookHeightRatio = _notebookHeightRatio.clamp(0.2, 0.8);
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeUpDown,
                  child: Container(
                    height: 10,
                    color: const Color(0xFFF1F5F9),
                    child: Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom-Right: Live Itinerary Panel
              Expanded(
                flex: ((1.0 - _notebookHeightRatio) * 100).round(),
                child: _buildItineraryPanel(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ====================================================
  // 2. TABLET LAYOUT (2 Columns: Conversations/Chat | Notebook/Itinerary Tabs)
  // ====================================================
  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: _buildChatArea(isMobile: false),
        ),
        const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),
        SizedBox(
          width: 340,
          child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 48,
                  backgroundColor: Colors.white,
                  elevation: 0.5,
                  bottom: const TabBar(
                    labelColor: coral,
                    indicatorColor: coral,
                    tabs: [
                      Tab(text: '🪺 Travel Notebook'),
                      Tab(text: '🗺 Live Itinerary'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    _buildDesktopNotebookDropZone(),
                    _buildItineraryPanel(),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
  }

  // ====================================================
  // 3. MOBILE LAYOUT (Chat with Floating 🪺 Drop Target & Bottom Controls)
  // ====================================================
  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tripzenCard,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.menu, color: tripzenDark),
          onPressed: _openMobileConversationsDrawer,
          tooltip: 'Conversations',
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  activeConversation.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                if (activeConversation.isGroup) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: coral.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '👥 ${activeConversation.memberCount}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: coral,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Text(
              activeConversation.destination,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          // Friend Requests Button with Notification Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.person_add_outlined, size: 21, color: Color(0xFF0F172A)),
                onPressed: () => _showFriendRequestsSheet(context),
                tooltip: 'Friend Requests',
              ),
              if (_friendRequests.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_friendRequests.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),

          // ------------------------------------------------
          // MOBILE FLOATING NOTEBOOK DROP TARGET (🪺)
          // ------------------------------------------------
          DragTarget<ChatDragPayload>(
            onWillAcceptWithDetails: (details) {
              setState(() => isHoveringMobileNest = true);
              return true;
            },
            onLeave: (_) {
              setState(() => isHoveringMobileNest = false);
            },
            onAcceptWithDetails: (details) {
              setState(() => isHoveringMobileNest = false);
              _savePayloadToNotebook(details.data);
            },
            builder: (context, candidateData, rejectedData) {
              final isTargetActive = candidateData.isNotEmpty || isHoveringMobileNest;
              final payload = candidateData.isNotEmpty ? candidateData.first : null;
              final isBunch = payload?.isBunch ?? false;
              final count = payload?.count ?? 1;

              return AnimatedScale(
                scale: isTargetActive ? 1.25 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 12),
                  padding: EdgeInsets.all(isTargetActive ? 5 : 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isTargetActive ? const Color(0xFFFFECEB) : Colors.transparent,
                    border: Border.all(
                      color: isTargetActive ? coral : Colors.grey.shade300,
                      width: isTargetActive ? 2.5 : 1.0,
                    ),
                    boxShadow: isTargetActive
                        ? [
                            BoxShadow(
                              color: coral.withValues(alpha: 0.5),
                              blurRadius: 14,
                              spreadRadius: 3,
                            ),
                          ]
                        : null,
                  ),
                  child: IconButton(
                    onPressed: _openMobileNotebookModal,
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isTargetActive ? '🐦' : '🪺',
                          style: TextStyle(fontSize: isTargetActive ? 22 : 20),
                        ),
                        if (isTargetActive && isBunch) ...[
                          const SizedBox(width: 2),
                          Text(
                            '+$count',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: coral,
                            ),
                          ),
                        ],
                      ],
                    ),
                    tooltip: 'Travel Notebook (Drop message or bunch here to save)',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Selection Action Bar (when active)
          if (isSelectionMode) _buildSelectionActionBar(),

          // Chat Messages & Input
          Expanded(
            child: _buildChatArea(isMobile: true),
          ),

          // Mobile Bottom Controls: Notebook & Live Itinerary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _openMobileNotebookModal,
                      icon: const Text('🪺', style: TextStyle(fontSize: 16)),
                      label: Text(
                        'Notebook (${activeConversation.notebookItems.length})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0F172A),
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _openMobileItineraryModal,
                      icon: const Icon(Icons.map_outlined, size: 16),
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Itinerary', style: TextStyle(fontSize: 12)),
                          if (showUpdatedBadge) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0B2240),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================
  // FRIEND REQUESTS LOGIC & UI
  // ====================================================
  void _acceptFriendRequest(FriendRequestItem req, {VoidCallback? onAction}) {
    setState(() {
      _friendRequests.removeWhere((r) => r.id == req.id);

      final newConv = ChatConversation(
        id: 'chat_${req.id}',
        name: req.name,
        destination: req.destination,
        isGroup: false,
        memberCount: 2,
        lastMessage: 'Connected! Say hi to your new travel buddy.',
        timestamp: 'Just now',
        unreadCount: 0,
        avatarLetter: req.avatarLetter,
        avatarColor: req.avatarColor,
        messages: [
          ChatMessage(
            id: 'msg_welcome_${DateTime.now().millisecondsSinceEpoch}',
            senderName: req.name,
            isMe: false,
            text: req.note.isNotEmpty ? req.note : 'Hey there! Excited to connect and plan our trips together.',
            timestamp: 'Just now',
            category: MessageCategory.general,
            categoryLabel: 'Introduction',
            categoryIcon: '👋',
          ),
        ],
        notebookItems: [],
        itinerary: [],
      );

      conversations.insert(0, newConv);
      activeConversation = newConv;
    });

    onAction?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Connected with ${req.name}! You can now chat together.'),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _declineFriendRequest(FriendRequestItem req, {VoidCallback? onAction}) {
    setState(() {
      _friendRequests.removeWhere((r) => r.id == req.id);
    });

    onAction?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Declined request from ${req.name}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showFriendRequestsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.72,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.person_add_rounded, size: 20, color: Color(0xFF2563EB)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Friend Requests',
                                style: GoogleFonts.inter(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              if (_friendRequests.isNotEmpty) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${_friendRequests.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            '${_friendRequests.length} travel buddies want to connect',
                            style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              const SizedBox(height: 12),
              Expanded(
                child: _friendRequests.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🎉', style: TextStyle(fontSize: 40)),
                            const SizedBox(height: 12),
                            Text(
                              'No Pending Requests',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'You\'re all caught up with your travel connections!',
                              style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _friendRequests.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final req = _friendRequests[index];
                          return _buildFriendRequestCard(req, onAction: () {
                            setSheetState(() {});
                          });
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendRequestsBanner() {
    if (_friendRequests.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF16A34A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Header
          InkWell(
            onTap: () {
              setState(() {
                _showFriendRequestsInline = !_showFriendRequestsInline;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person_add_rounded,
                      size: 16,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Friend Requests',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${_friendRequests.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${_friendRequests.length} pending travel connections',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _showFriendRequestsInline
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          // Collapsible Request Cards List
          if (_showFriendRequestsInline) ...[
            const Divider(height: 1, color: Color(0xFFDCFCE7)),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: _friendRequests.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final req = _friendRequests[index];
                return _buildFriendRequestCard(req);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFriendRequestCard(FriendRequestItem req, {VoidCallback? onAction}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 17,
                backgroundImage: NetworkImage(req.avatarUrl),
                backgroundColor: req.avatarColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          req.name,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            req.mbti,
                            style: GoogleFonts.inter(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${req.destination} • ${req.time}',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (req.note.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '"${req.note}"',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF475569),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: FilledButton(
                    onPressed: () => _acceptFriendRequest(req, onAction: onAction),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Accept',
                          style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                height: 30,
                child: OutlinedButton(
                  onPressed: () => _declineFriendRequest(req, onAction: onAction),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF64748B),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Decline',
                    style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ====================================================
  // COMPONENT: Conversation List Panel
  // ====================================================
  Widget _buildConversationListPanel() {
    final directChats = conversations.where((c) => !c.isGroup).toList();
    final groupChats = conversations.where((c) => c.isGroup).toList();

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header matching reference mockup
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Travel Discussions',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Plan together, share ideas and travel better.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.person_add_outlined, size: 20, color: Color(0xFF2563EB)),
                      onPressed: () => _showFriendRequestsSheet(context),
                      tooltip: 'Friend Requests',
                      visualDensity: VisualDensity.compact,
                    ),
                    if (_friendRequests.isNotEmpty)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${_friendRequests.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.edit_square, size: 18, color: Color(0xFF64748B)),
                  onPressed: () {},
                  tooltip: 'New conversation',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Search Bar matching reference mockup
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search chats...',
                hintStyle: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xFF819EE5)),
                ),
              ),
            ),
          ),

          // List Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 4),
              children: [
                // FRIEND REQUESTS INLINE BANNER
                if (_friendRequests.isNotEmpty) ...[
                  _buildFriendRequestsBanner(),
                  const SizedBox(height: 4),
                ],

                // DIRECT CHATS SECTION
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
                  child: Text(
                    'DIRECT CHATS',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                ...directChats.map((conv) => _buildConversationTile(conv)),

                const SizedBox(height: 10),

                // GROUP CHATROOMS SECTION
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
                  child: Text(
                    'GROUP CHATROOMS',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                ...groupChats.map((conv) => _buildConversationTile(conv)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(ChatConversation conv) {
    final isSelected = activeConversation.id == conv.id;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF1F5F9) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: isSelected ? Border.all(color: const Color(0xFFCBD5E1), width: 1.0) : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        onTap: () {
          setState(() {
            activeConversation = conv;
            isSelectionMode = false;
            selectedMessageIds.clear();
          });
        },
        leading: CircleAvatar(
          backgroundColor: conv.avatarColor.withValues(alpha: 0.18),
          radius: 19,
          child: Text(
            conv.avatarLetter,
            style: TextStyle(
              color: conv.avatarColor,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                conv.name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                  fontSize: 13.5,
                  color: const Color(0xFF0F172A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              conv.timestamp,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? const Color(0xFF475569) : Colors.grey.shade500,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    conv.destination,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (conv.isGroup) ...[
                  const SizedBox(width: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.people_outline_rounded, size: 12, color: Color(0xFF64748B)),
                      const SizedBox(width: 2),
                      Text(
                        '${conv.memberCount}',
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(
              conv.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        trailing: conv.unreadCount > 0
            ? Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F172A),
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }

  // ====================================================
  // COMPONENT: Chat Area (Messages + Selection + Input)
  // ====================================================
  Widget _buildChatArea({required bool isMobile}) {
    return Column(
      children: [
        // Desktop / Tablet Header
        if (!isMobile) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: activeConversation.avatarColor.withValues(alpha: 0.15),
                  radius: 18,
                  child: Text(
                    activeConversation.avatarLetter,
                    style: TextStyle(
                      color: activeConversation.avatarColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              activeConversation.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (activeConversation.isGroup) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFCBD5E1)),
                              ),
                              child: Text(
                                '👥 ${activeConversation.memberCount} travellers',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${activeConversation.destination} • Collaborative Planning Room',
                        style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Selection Mode Toggle Button
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      isSelectionMode = !isSelectionMode;
                      if (!isSelectionMode) selectedMessageIds.clear();
                    });
                  },
                  icon: Icon(
                    isSelectionMode ? Icons.check_box : Icons.check_box_outline_blank,
                    size: 15,
                    color: const Color(0xFF475569),
                  ),
                  label: Text(
                    isSelectionMode ? 'Cancel Selection' : 'Select Messages',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
        ],

        // Selection Action Banner (Desktop)
        if (isSelectionMode) _buildSelectionActionBar(),

        // Informational Hint matching reference mockup
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: const Color(0xFFF1F5F9),
          child: Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tip: Long press or drag messages into the Travel Notebook to save key ideas, places, or decisions.',
                  style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF475569), fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),

        // Message Stream
        Expanded(
          child: ListView.builder(
            controller: _chatScrollController,
            padding: const EdgeInsets.all(16),
            itemCount: activeConversation.messages.length,
            itemBuilder: (context, index) {
              final msg = activeConversation.messages[index];
              return _buildDraggableMessageRow(msg);
            },
          ),
        ),

        // Message Input Bar
        _buildMessageInputBar(),
      ],
    );
  }

  // ====================================================
  // DRAG FEEDBACK: Single Message Drag Effect
  // ====================================================
  Widget _buildSingleDragFeedback(ChatMessage msg) {
    return Material(
      color: Colors.transparent,
      elevation: 14,
      borderRadius: BorderRadius.circular(16),
      child: Transform.rotate(
        angle: -0.06, // Realistic physical tilt (~ -3.5 deg)
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A), // Dark slate flight card
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: coral, width: 2),
            boxShadow: [
              BoxShadow(
                color: coral.withValues(alpha: 0.45),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Flight Header
              Row(
                children: [
                  const Text('🐦', style: TextStyle(fontSize: 15)),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: coral.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'NESTING DECISION',
                      style: TextStyle(
                        color: coral,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    msg.categoryIcon,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Sender & text
              Row(
                children: [
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.white24,
                    child: Text(
                      msg.senderName.substring(0, 1),
                      style: const TextStyle(fontSize: 8.5, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    msg.senderName,
                    style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                msg.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '🪺 Drop on Notebook to save',
                  style: TextStyle(color: Colors.white60, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ====================================================
  // DRAG FEEDBACK: Bunch of Conversations (3D Stack of Cards)
  // ====================================================
  Widget _buildBunchDragFeedback(List<ChatMessage> msgs) {
    return Material(
      color: Colors.transparent,
      elevation: 18,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 300,
        height: 145,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Layer 3: Bottom card (offset and tilted right)
            Positioned(
              left: 14,
              top: 14,
              right: 0,
              bottom: 0,
              child: Transform.rotate(
                angle: 0.08,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                ),
              ),
            ),
            // Layer 2: Middle card (offset and tilted left)
            Positioned(
              left: 7,
              top: 7,
              right: 7,
              bottom: 7,
              child: Transform.rotate(
                angle: -0.04,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: coral.withValues(alpha: 0.4)),
                  ),
                ),
              ),
            ),
            // Layer 1: Front highlighted card
            Transform.rotate(
              angle: -0.03,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: coral, width: 2.2),
                  boxShadow: [
                    BoxShadow(
                      color: coral.withValues(alpha: 0.5),
                      blurRadius: 24,
                      spreadRadius: 3,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with count badge
                    Row(
                      children: [
                        const Text('🪺', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF5A5F), Color(0xFFFF7E40)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'BUNCH OF ${msgs.length} CONVERSATIONS 🐦',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Previews of messages
                    ...msgs.take(2).map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 12),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  '${m.senderName}: "${m.text}"',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white, fontSize: 11.5),
                                ),
                              ),
                            ],
                          ),
                        )),
                    if (msgs.length > 2)
                      Text(
                        '+ ${msgs.length - 2} more messages...',
                        style: const TextStyle(color: Colors.white54, fontSize: 10.5, fontStyle: FontStyle.italic),
                      ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: coral.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Drop on Notebook to nest all ${msgs.length} decisions',
                        style: const TextStyle(color: Color(0xFFFFB4AB), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====================================================
  // COMPONENT: Draggable & Selectable Message Row
  // ====================================================
  Widget _buildDraggableMessageRow(ChatMessage msg) {
    final isSelected = selectedMessageIds.contains(msg.id);
    final isPartOfMultiSelect = isSelectionMode && isSelected && selectedMessageIds.length > 1;

    // Payload: either bunch or single message
    final payload = isPartOfMultiSelect
        ? ChatDragPayload.bunch(
            activeConversation.messages
                .where((m) => selectedMessageIds.contains(m.id))
                .toList(),
          )
        : ChatDragPayload.single(msg);

    // Dynamic drag feedback widget with physical tilt and glowing card
    final feedbackWidget = payload.isBunch
        ? _buildBunchDragFeedback(payload.messages)
        : _buildSingleDragFeedback(msg);

    // In-transit silhouette
    final childWhenDraggingWidget = Opacity(
      opacity: 0.35,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: coral, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🐦 ', style: TextStyle(fontSize: 13)),
            Text(
              isPartOfMultiSelect ? 'Bunch in flight to Notebook...' : 'In flight to Notebook...',
              style: const TextStyle(color: coral, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    // Message Bubble Content
    Widget bubbleContent = GestureDetector(
      onTap: () {
        if (isSelectionMode) {
          setState(() {
            if (selectedMessageIds.contains(msg.id)) {
              selectedMessageIds.remove(msg.id);
            } else {
              selectedMessageIds.add(msg.id);
            }
          });
        }
      },
      onLongPress: () {
        setState(() {
          isSelectionMode = true;
          if (selectedMessageIds.contains(msg.id)) {
            selectedMessageIds.remove(msg.id);
          } else {
            selectedMessageIds.add(msg.id);
          }
        });
      },
      onSecondaryTap: () {
        // Desktop Right Click shortcut
        _savePayloadToNotebook(ChatDragPayload.single(msg));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: const BoxConstraints(maxWidth: 440),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isMe ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? coral : const Color(0xFFE2E8F0),
            width: isSelected ? 2.0 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Sender name (Category badge removed per design)
            if (!msg.isMe) ...[
              Text(
                msg.senderName,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
            ],

            // Message text
            Text(
              msg.text,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                color: const Color(0xFF0F172A),
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 5),

            // Timestamp & Save to Notebook Action
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.timestamp,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                if (!msg.isMe) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => _savePayloadToNotebook(ChatDragPayload.single(msg)),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            msg.isSavedToNotebook
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_outline_rounded,
                            size: 14,
                            color: msg.isSavedToNotebook
                                ? const Color(0xFFC2410C)
                                : const Color(0xFF64748B),
                          ),
                          if (!msg.isSavedToNotebook) ...[
                            const SizedBox(width: 3),
                            Text(
                              'Save to Notebook',
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );

    // Wrap with Draggable for Drag-and-Drop to Notebook
    Widget draggableRow = LongPressDraggable<ChatDragPayload>(
      delay: const Duration(milliseconds: 150),
      data: payload,
      feedback: feedbackWidget,
      childWhenDragging: childWhenDraggingWidget,
      child: bubbleContent,
    );

    // Row layout with flush left/right alignment logic
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSelectionMode && !msg.isMe)
              Checkbox(
                value: isSelected,
                activeColor: coral,
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      selectedMessageIds.add(msg.id);
                    } else {
                      selectedMessageIds.remove(msg.id);
                    }
                  });
                },
              ),
            if (!msg.isMe) ...[
              CircleAvatar(
                radius: 15,
                backgroundColor: msg.senderName == 'Maya'
                    ? const Color(0xFFD1FAE5)
                    : msg.senderName == 'Daniel'
                        ? const Color(0xFFDBEAFE)
                        : const Color(0xFFFEE2E2),
                child: Text(
                  msg.senderName.substring(0, 1),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: msg.senderName == 'Maya'
                        ? const Color(0xFF047857)
                        : msg.senderName == 'Daniel'
                            ? const Color(0xFF1D4ED8)
                            : const Color(0xFFB91C1C),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(child: draggableRow),
            if (msg.isMe) ...[
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 15,
                backgroundColor: Color(0xFF0F172A),
                child: Text(
                  'Y',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            if (isSelectionMode && msg.isMe)
              Checkbox(
                value: isSelected,
                activeColor: coral,
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      selectedMessageIds.add(msg.id);
                    } else {
                      selectedMessageIds.remove(msg.id);
                    }
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  // ====================================================
  // COMPONENT: Selection Action Bar (Supports Dragging the Bunch)
  // ====================================================
  Widget _buildSelectionActionBar() {
    final count = selectedMessageIds.length;
    final allSelected = count == activeConversation.messages.length && count > 0;
    final selectedMsgs = activeConversation.messages
        .where((m) => selectedMessageIds.contains(m.id))
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      color: const Color(0xFFFFF1F2),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 6,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: coral, size: 18),
              const SizedBox(width: 6),
              Text(
                '$count selected',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (allSelected) {
                      selectedMessageIds.clear();
                    } else {
                      selectedMessageIds.addAll(activeConversation.messages.map((m) => m.id));
                    }
                  });
                },
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                ),
                child: Text(
                  allSelected ? 'Deselect All' : 'Select All',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: coral),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (count > 0) ...[
                // Draggable Bunch Handle!
                Draggable<ChatDragPayload>(
                  data: ChatDragPayload.bunch(selectedMsgs),
                  feedback: _buildBunchDragFeedback(selectedMsgs),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF5A5F), Color(0xFFFF7E40)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: coral.withValues(alpha: 0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.drag_indicator, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Drag Bunch ($count)',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              TextButton(
                onPressed: () {
                  setState(() {
                    isSelectionMode = false;
                    selectedMessageIds.clear();
                  });
                },
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
              const SizedBox(width: 6),
              FilledButton.icon(
                onPressed: count == 0 ? null : _addSelectedMessagesToNotebook,
                icon: const Text('🪺', style: TextStyle(fontSize: 13)),
                label: Text(
                  'Add $count to Notebook',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: coral,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ====================================================
  // COMPONENT: Message Input Bar
  // ====================================================
  Widget _buildMessageInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF475569), size: 20),
                onPressed: () {},
                tooltip: 'Attach options',
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _msgInputController,
                focusNode: _msgFocusNode,
                decoration: InputDecoration(
                  hintText: 'Type a message... (Long press to save to Notebook)',
                  hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: const Color(0xFF0F172A),
              radius: 21,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                onPressed: _sendMessage,
                tooltip: 'Send message',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====================================================
  // COMPONENT: Desktop Notebook Drop Zone (Top-Right)
  // ====================================================
  Widget _buildDesktopNotebookDropZone() {
    return DragTarget<ChatDragPayload>(
      onWillAcceptWithDetails: (details) {
        setState(() => isHoveringNotebook = true);
        return true;
      },
      onLeave: (_) {
        setState(() => isHoveringNotebook = false);
      },
      onAcceptWithDetails: (details) {
        setState(() => isHoveringNotebook = false);
        _savePayloadToNotebook(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty || isHoveringNotebook;
        final payload = candidateData.isNotEmpty ? candidateData.first : null;
        final isBunch = payload?.isBunch ?? false;
        final count = payload?.count ?? 1;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isHovering ? const Color(0xFFFFF7ED) : Colors.white,
            border: Border.all(
              color: isHovering ? coral : Colors.transparent,
              width: isHovering ? 2.5 : 0.0,
            ),
            boxShadow: isHovering
                ? [
                    BoxShadow(
                      color: coral.withValues(alpha: 0.25),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              // Notebook Header matching reference mockup
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                color: Colors.white,
                child: Row(
                  children: [
                    const Icon(Icons.collections_bookmark_rounded, color: Color(0xFF0F172A), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI NOTEBOOK',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: const Color(0xFF0F172A),
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${activeConversation.notebookItems.length} decisions',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),

              // Drop Hint Banner if dragged
              if (isHovering)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  color: coral.withValues(alpha: 0.15),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🐦 ', style: TextStyle(fontSize: 16)),
                        Expanded(
                          child: Text(
                            isBunch
                                ? 'Release to nest bunch of $count conversations in AI Notebook! 🪺'
                                : 'Release to nest this decision in AI Notebook! 🪺',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: coral,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Planning Check
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(14),
                  children: [
                    // Planning Check Card (Section 1.F & 1.G)
                    PlanningCheckCard(
                      topics: currentPlanningTopics,
                      onDiscussTopic: _onDiscussMissingTopic,
                      onGenerateItinerary: _openAiPromptModal,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ignore: unused_element
  Widget _buildNotebookItemCard(NotebookItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: item.badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.category,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: item.badgeColor,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'by ${item.contributorName}',
                style: const TextStyle(fontSize: 10.5, color: Colors.grey),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: () {
                  setState(() {
                    activeConversation.notebookItems.removeWhere((i) => i.id == item.id);
                  });
                },
                child: const Icon(Icons.close, size: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.structuredTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Color(0xFF0F172A),
            ),
          ),
          if (item.userNotes != null) ...[
            const SizedBox(height: 2),
            Text(
              item.userNotes!,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }

  // ====================================================
  // COMPONENT: Live Itinerary Panel (Bottom-Right)
  // ====================================================
  Widget _buildItineraryPanel() {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // Itinerary Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 14, 10),
            color: Colors.white,
            child: Row(
              children: [
                const Icon(Icons.map_rounded, color: Color(0xFF0F172A), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'LIVE ITINERARY',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      color: const Color(0xFF0F172A),
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Header Shortcut: Direct to Trips Folder
                InkWell(
                  onTap: _openTripsFolder,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.folder_open_rounded, size: 13, color: Color(0xFF2563EB)),
                        const SizedBox(width: 4),
                        Text(
                          'Trips Folder',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1D4ED8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                if (showUpdatedBadge)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: const Text(
                      'Updated ✨',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF15803D),
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${activeConversation.itinerary.length} Days',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Itinerary List
          Expanded(
            child: isItineraryUpdating
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: coral),
                        const SizedBox(height: 12),
                        const Text('🐦', style: TextStyle(fontSize: 24)),
                        const SizedBox(height: 6),
                        Text(
                          'TripNest is restructuring your schedule...',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: activeConversation.itinerary.length,
                    itemBuilder: (context, index) {
                      final day = activeConversation.itinerary[index];
                      return _buildItineraryDayCard(day);
                    },
                  ),
          ),

          // Bottom Action Button: Go To Trips Folder
          Container(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 38,
              child: FilledButton.icon(
                onPressed: _openTripsFolder,
                icon: const Icon(Icons.folder_shared_outlined, size: 16),
                label: Text(
                  'Open in Trips Folder',
                  style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryDayCard(ItineraryDay day) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: day.dayNumber <= 2,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B2240),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Day ${day.dayNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  day.summary,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '${day.date} · 🚶 ${day.walkingEstimate}',
              style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
            ),
          ),
          children: day.stops.map((stop) {
            return Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: stop.isHighlight ? const Color(0xFFFFFBEB) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: stop.isHighlight ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.time,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: coral,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stop.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          stop.notes,
                          style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ====================================================
  // MOBILE MODALS: Notebook & Itinerary Overlays
  // ====================================================
  void _openMobileNotebookModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  const Text('🪺', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  const Text(
                    'Travel Notebook',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Planning Check Card
                  PlanningCheckCard(
                    topics: currentPlanningTopics,
                    onDiscussTopic: (msg) {
                      Navigator.pop(context);
                      _onDiscussMissingTopic(msg);
                    },
                    onGenerateItinerary: () {
                      Navigator.pop(context);
                      _openAiPromptModal();
                    },
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Saved Discussions (Conversation Style)',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Displayed as Conversation-Style Bubbles (Section 9)
                  if (activeConversation.notebookItems.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'No saved discussions yet.\nDrag a message to the top-right 🪺 nest or long-press to save!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...activeConversation.notebookItems.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Contributor header + Category
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: item.badgeColor.withValues(alpha: 0.15),
                                  child: Text(
                                    item.contributorName.substring(0, 1),
                                    style: TextStyle(
                                      color: item.badgeColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  item.contributorName,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: item.badgeColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.category,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w800,
                                      color: item.badgeColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Authentic Conversation-Style Bubble
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.originalMessage.text,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Decided: ${item.structuredTitle}',
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: item.badgeColor,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 16, color: Colors.grey),
                                        onPressed: () {
                                          setState(() {
                                            activeConversation.notebookItems.removeWhere((i) => i.id == item.id);
                                          });
                                          Navigator.pop(context);
                                          _openMobileNotebookModal();
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openMobileItineraryModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.map_rounded, color: Color(0xFF0B2240), size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    'Live Itinerary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0B2240),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _buildItineraryPanel(),
            ),
          ],
        ),
      ),
    );
  }

  void _openMobileConversationsDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: _buildConversationListPanel(),
      ),
    );
  }
}
