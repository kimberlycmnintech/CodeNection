import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/itinerary_trip_models.dart';
import '../services/google_maps_service.dart';
import '../widgets/interactive_itinerary_map.dart';
import '../widgets/place_detail_dialog.dart';
import '../widgets/trip_ai_assistant_panel.dart';
import '../widgets/travel_memories_dialog.dart';
import 'ai_notebook_screen.dart';
import 'trip_ai_assistant_screen.dart';

class TripDetailPage extends StatefulWidget {
  final TripFolderItem trip;
  final VoidCallback onBack;
  final Function(String chatId)? onNavigateToChat;

  const TripDetailPage({
    super.key,
    required this.trip,
    required this.onBack,
    this.onNavigateToChat,
  });

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> with SingleTickerProviderStateMixin {
  late int activeDayIndex;
  late TabController _mobileTabController;
  final ScrollController _daysScrollController = ScrollController();
  double _mapWidth = 540.0;
  bool _showDayPath = false;
  int? _selectedStopIndex;

  @override
  void initState() {
    super.initState();
    activeDayIndex = 0;
    _mobileTabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _mobileTabController.dispose();
    _daysScrollController.dispose();
    super.dispose();
  }

  void _applyAiSuggestion(TripAiSuggestion suggestion) {
    setState(() {
      if (suggestion.id == 'sug_late_start') {
        if (widget.trip.days.length >= 2) {
          final day2 = widget.trip.days[1];
          day2.walkingEstimate = '10,200 steps (Pace: Relaxed)';
          if (day2.stops.isNotEmpty) {
            day2.stops[0].time = '10:30';
          }
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('✨ ', style: TextStyle(fontSize: 16)),
            Expanded(
              child: Text(
                'Itinerary Updated! "${suggestion.title}" applied.',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1040;
        final isTablet = constraints.maxWidth >= 700 && constraints.maxWidth < 1040;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F7FB),
          appBar: _buildWorkspaceAppBar(),
          body: isDesktop
              ? _buildDesktopLayout()
              : isTablet
                  ? _buildTabletLayout()
                  : _buildMobileLayout(),
        );
      },
    );
  }

  // ====================================================
  // TOP APP BAR: Clean Navigation Header with Stacked Avatars
  // ====================================================
  PreferredSizeWidget _buildWorkspaceAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
        tooltip: 'Back to My Itineraries',
        onPressed: widget.onBack,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.trip.name,
                style: GoogleFonts.playfairDisplay(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0ECFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.trip.days.length} Days',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${widget.trip.destination} · ${widget.trip.startDate} – ${widget.trip.endDate}',
            style: GoogleFonts.inter(
              fontSize: 11.5,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        if (widget.onNavigateToChat != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: OutlinedButton.icon(
              onPressed: () => widget.onNavigateToChat!('tokyo_squad'),
              icon: const Icon(Icons.chat_bubble_outline, size: 16, color: Color(0xFF2563EB)),
              label: Text(
                'Chat: Tokyo Squad',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2563EB),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFBFDBFE)),
                backgroundColor: const Color(0xFFEFF6FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildStackedAvatars(widget.trip.travellers),
        ),
      ],
    );
  }

  Widget _buildStackedAvatars(List<TravellerInfo> travellers) {
    const avatarPhotos = [
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=120',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=120',
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=120',
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 28,
          width: (avatarPhotos.length * 18.0) + 12.0,
          child: Stack(
            children: [
              for (int i = 0; i < avatarPhotos.length; i++)
                Positioned(
                  left: i * 18.0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(avatarPhotos[i]),
                      backgroundColor: const Color(0xFFCBD5E1),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '+2',
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
      ],
    );
  }

  // ====================================================
  // 1. DESKTOP LAYOUT (Left Sidebar | Timeline + AI | Resizable Map)
  // ====================================================
  Widget _buildDesktopLayout() {
    final activeDay = widget.trip.days[activeDayIndex];

    return Padding(
      padding: const EdgeInsets.only(bottom: 76.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Column: Days List & AI Tools (260px)
          SizedBox(
            width: 260,
            child: _buildSidebarLeftColumn(),
          ),
          const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),

          // Center Column: Day Timeline
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                _buildCenterDayHeader(activeDay),
                const SizedBox(height: 14),
                _buildTimelineStops(activeDay),
              ],
            ),
          ),

          // Sizeable / Resizable Boundary Handle between Itinerary and Map
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (details) {
              setState(() {
                _mapWidth = (_mapWidth - details.delta.dx).clamp(340.0, 950.0);
              });
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: Container(
                width: 12,
                color: const Color(0xFFF1F5F9),
                child: Center(
                  child: Container(
                    width: 4,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Right Column: Interactive Map (Full Height)
          SizedBox(
            width: _mapWidth,
            child: InteractiveItineraryMap(
              stops: activeDay.stops,
              allDays: widget.trip.days,
              activeDayIndex: activeDayIndex,
              dayTitle: activeDay.title,
              currentDayNumber: activeDay.dayNumber,
              showHeaderOverlay: true,
              showPath: _showDayPath,
              selectedStopIndex: _selectedStopIndex,
              onSelectedStopIndexChanged: (index) {
                setState(() {
                  _selectedStopIndex = index;
                  if (index != null) {
                    _showDayPath = true;
                  }
                });
              },
              onStopSelected: (stop) {
                final idx = activeDay.stops.indexOf(stop);
                setState(() {
                  _selectedStopIndex = idx >= 0 ? idx : null;
                  if (idx >= 0) _showDayPath = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }



  // ====================================================
  // 2. TABLET LAYOUT (2 Columns)
  // ====================================================
  Widget _buildTabletLayout() {
    final activeDay = widget.trip.days[activeDayIndex];

    return Padding(
      padding: const EdgeInsets.only(bottom: 76.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 250,
            child: _buildSidebarLeftColumn(),
          ),
          const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                _buildCenterDayHeader(activeDay),
                const SizedBox(height: 16),
                SizedBox(
                  height: 280,
                  child: InteractiveItineraryMap(
                    stops: activeDay.stops,
                    allDays: widget.trip.days,
                    activeDayIndex: activeDayIndex,
                    dayTitle: activeDay.title,
                    currentDayNumber: activeDay.dayNumber,
                    onStopSelected: (stop) => PlaceDetailDialog.show(context, stop),
                  ),
                ),
                const SizedBox(height: 18),
                _buildTimelineStops(activeDay),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================
  // 3. MOBILE LAYOUT (Tabs)
  // ====================================================
  Widget _buildMobileLayout() {
    final activeDay = widget.trip.days[activeDayIndex];

    return Padding(
      padding: const EdgeInsets.only(bottom: 76.0),
      child: Column(
        children: [
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _mobileTabController,
            labelColor: const Color(0xFF2563EB),
            indicatorColor: const Color(0xFF2563EB),
            tabs: const [
              Tab(icon: Icon(Icons.timeline, size: 18), text: 'Timeline'),
              Tab(icon: Icon(Icons.map_outlined, size: 18), text: 'Map'),
              Tab(icon: Text('🐦', style: TextStyle(fontSize: 16)), text: 'AI Tools'),
              Tab(icon: Icon(Icons.people_outline, size: 18), text: 'Flock'),
            ],
          ),
        ),
        _buildDayHorizontalPicker(),
        Expanded(
          child: TabBarView(
            controller: _mobileTabController,
            children: [
              // Tab 1: Timeline
              ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  _buildCenterDayHeader(activeDay),
                  const SizedBox(height: 14),
                  _buildTimelineStops(activeDay),
                ],
              ),
              // Tab 2: Map
              Padding(
                padding: const EdgeInsets.all(12),
                child: InteractiveItineraryMap(
                  stops: activeDay.stops,
                  allDays: widget.trip.days,
                  activeDayIndex: activeDayIndex,
                  dayTitle: activeDay.title,
                  currentDayNumber: activeDay.dayNumber,
                  onStopSelected: (stop) => PlaceDetailDialog.show(context, stop),
                ),
              ),
              // Tab 3: AI Assistant Drawer
              TripAiAssistantPanel(
                trip: widget.trip,
                onApplySuggestion: _applyAiSuggestion,
              ),
              // Tab 4: Flock Travellers
              _buildTravellersMobileList(),
            ],
          ),
        ),
      ],
    ),
  );
}

  // ====================================================
  // COLUMN 1: LEFT SIDEBAR (`Itinerary Days` & `AI Tools`)
  // ====================================================
  Widget _buildSidebarLeftColumn() {
    final dayCount = widget.trip.days.length;
    final dynamicMaxHeight = dayCount > 4 ? 220.0 : (dayCount * 56.0);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Section Title: Itinerary Days
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF0F172A)),
                const SizedBox(width: 8),
                Text(
                  'Itinerary Days',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Days List with Scrollbar
            Container(
              constraints: BoxConstraints(maxHeight: dynamicMaxHeight),
              child: Scrollbar(
                controller: _daysScrollController,
                thumbVisibility: dayCount > 4,
                child: ListView.builder(
                  controller: _daysScrollController,
                  shrinkWrap: true,
                  physics: dayCount > 4
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  itemCount: dayCount,
                  itemBuilder: (context, index) {
                    final day = widget.trip.days[index];
                    final isSelected = activeDayIndex == index;
                    final dayColor = DayColorPalette.getColorForDay(day.dayNumber);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? dayColor.withValues(alpha: 0.10) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? dayColor.withValues(alpha: 0.5) : const Color(0xFFF1F5F9),
                          width: 1.2,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () => setState(() {
                            activeDayIndex = index;
                            _showDayPath = false;
                            _selectedStopIndex = null;
                          }),
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          leading: CircleAvatar(
                            radius: 13,
                            backgroundColor: isSelected ? dayColor : dayColor.withValues(alpha: 0.15),
                            child: Text(
                              '${day.dayNumber}',
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? Colors.white : dayColor,
                              ),
                            ),
                          ),
                          title: Text(
                            'Day ${day.dayNumber}',
                            style: GoogleFonts.inter(
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                              fontSize: 13,
                              color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF334155),
                            ),
                          ),
                          subtitle: Text(
                            '${day.stops.length} stops • ${day.date}',
                            style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 12),

            // Section Title: Tools
            Row(
              children: [
                const Icon(Icons.auto_awesome, size: 16, color: Color(0xFF2563EB)),
                const SizedBox(width: 8),
                Text(
                  'Tools',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Tool Card 1: AI Assistant Hub
            _buildAiToolCard(
              icon: Icons.explore_outlined,
              title: 'AI Assistant Hub',
              subtitle: 'Full chat & tools',
              iconBgColor: const Color(0xFFEFF6FF),
              iconColor: const Color(0xFF2563EB),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TripAiAssistantScreen(
                      trip: widget.trip,
                      onApplySuggestion: _applyAiSuggestion,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            // Tool Card 2: AI Notebook
            _buildAiToolCard(
              icon: Icons.sticky_note_2_outlined,
              title: 'AI Notebook',
              subtitle: 'Your travel notes',
              iconBgColor: const Color(0xFFEFF6FF),
              iconColor: const Color(0xFF2563EB),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AiNotebookScreen(
                      trip: widget.trip,
                      onNavigateToChat: widget.onNavigateToChat,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            // Tool Card 3: Memories
            _buildAiToolCard(
              icon: Icons.auto_stories_outlined,
              title: 'Memories',
              subtitle: 'Relive your trip memories',
              iconBgColor: const Color(0xFFEFF6FF),
              iconColor: const Color(0xFF2563EB),
              onTap: () => _showDailyTravelLogSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiToolCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Color iconBgColor = const Color(0xFFEFF6FF),
    Color iconColor = const Color(0xFF2563EB),
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: iconColor),
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
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      color: const Color(0xFF64748B),
                    ),
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

  // ====================================================
  // DAILY TRAVEL LOG / MEMORIES POPUP (CENTER POPUP & 3D BOOK)
  // ====================================================
  void _showDailyTravelLogSheet(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => TravelMemoriesDialog(
        trip: widget.trip,
        initialDayIndex: activeDayIndex,
      ),
    );
  }

  // ====================================================
  // COLUMN 2: CENTER TIMELINE (Day Header & Stop Cards)
  // ====================================================
  Widget _buildCenterDayHeader(ItineraryDayData day) {
    final dayColor = DayColorPalette.getColorForDay(day.dayNumber);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: dayColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'DAY ${day.dayNumber}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              day.date,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          day.title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${day.stops.length} stops • A day of coffee, nature and city vibes in ${widget.trip.destination.split(',').first}.',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            color: const Color(0xFF64748B),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineStops(ItineraryDayData day) {
    if (day.stops.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        alignment: Alignment.center,
        child: Text(
          'No stops planned for Day ${day.dayNumber} yet.',
          style: GoogleFonts.inter(color: const Color(0xFF64748B)),
        ),
      );
    }

    final dayColor = DayColorPalette.getColorForDay(day.dayNumber);

    return Column(
      children: [
        for (int i = 0; i < day.stops.length; i++) ...[
          _buildSingleStopCard(day.stops[i], i + 1, i == day.stops.length - 1, dayColor),
          if (i < day.stops.length - 1)
            _buildWalkTransitConnector(day.stops[i]),
        ],
      ],
    );
  }

  /// Builds a single stop card matching the reference mockup
  Widget _buildSingleStopCard(ItineraryPlaceStop stop, int stepIndex, bool isLast, Color stepColor) {
    final photoUrl = stop.imageUrl ??
        'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left: Step Number + Time Column with vertical timeline line
          SizedBox(
            width: 44,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 12.5,
                  backgroundColor: stepColor,
                  child: Text(
                    '$stepIndex',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stop.time,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                if (!isLast) ...[
                  const SizedBox(height: 6),
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: const Color(0xFFCBD5E1),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Main Stop Floating Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  final isDesktop = MediaQuery.of(context).size.width >= 1040;
                  if (isDesktop) {
                    setState(() {
                      _selectedStopIndex = stepIndex - 1;
                      _showDayPath = true;
                    });
                  } else {
                    PlaceDetailDialog.show(context, stop);
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Square Cover Photo (~100x100)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          photoUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 100,
                            height: 100,
                            color: const Color(0xFFF1F5F9),
                            child: const Icon(Icons.image_outlined, color: Color(0xFF94A3B8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Right Content Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Header & Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(stop.categoryIcon, style: const TextStyle(fontSize: 13)),
                                    const SizedBox(width: 4),
                                    Text(
                                      stop.category,
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${stop.rating}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.more_vert_rounded, size: 16, color: Color(0xFF94A3B8)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),

                            // Stop Title
                            Text(
                              stop.name,
                              style: GoogleFonts.inter(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                                height: 1.2,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 3),

                            // Description
                            Text(
                              stop.description,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: const Color(0xFF64748B),
                                height: 1.35,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),

                            // Metadata Footer Row (Duration · Cost · Google Maps Link)
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFF64748B)),
                                    const SizedBox(width: 4),
                                    Text(
                                      stop.duration,
                                      style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B), fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const Text('·', style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 12)),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '💰 ${stop.estimatedCost}',
                                      style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B), fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const Text('·', style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 12)),
                                InkWell(
                                  onTap: () => GoogleMapsService.openPlaceInGoogleMaps(stop),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF2563EB)),
                                      const SizedBox(width: 2),
                                      Text(
                                        'View on Maps ↗',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF2563EB),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Walk/Transit Connector between timeline stops
  Widget _buildWalkTransitConnector(ItineraryPlaceStop stop) {
    final walkText = stop.travelMethod.contains('Walk')
        ? stop.travelMethod
        : 'Walk ${stop.distanceToNext} (about 10 min)';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 44,
          height: 38,
          child: Center(
            child: Container(
              width: 1.5,
              height: 38,
              color: const Color(0xFFCBD5E1),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Row(
            children: [
              const Icon(Icons.directions_walk_rounded, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  walkText,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



  Widget _buildDayHorizontalPicker() {
    return Container(
      height: 44,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: widget.trip.days.length,
        itemBuilder: (context, index) {
          final isSelected = activeDayIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text('Day ${index + 1} (${widget.trip.days[index].date})'),
              selected: isSelected,
              selectedColor: const Color(0xFFEFF6FF),
              labelStyle: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF475569),
              ),
              onSelected: (_) => setState(() {
                activeDayIndex = index;
                _showDayPath = false;
                _selectedStopIndex = null;
              }),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTravellersMobileList() {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: widget.trip.travellers.length,
      itemBuilder: (context, index) {
        final t = widget.trip.travellers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: t.avatarColor,
              child: Text(t.avatarLetter, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            title: Text(t.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            subtitle: Text('${t.mbti} · ${t.travelStyle}\nInterests: ${t.interests.join(", ")}'),
            trailing: t.chatId != null
                ? FilledButton.tonalIcon(
                    onPressed: () {
                      if (widget.onNavigateToChat != null) {
                        widget.onNavigateToChat!(t.chatId!);
                      }
                    },
                    icon: const Icon(Icons.chat, size: 14),
                    label: const Text('Chat'),
                  )
                : null,
          ),
        );
      },
    );
  }
}
