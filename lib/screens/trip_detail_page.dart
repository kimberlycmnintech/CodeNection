import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/itinerary_trip_models.dart';
import '../services/google_maps_service.dart';
import '../widgets/interactive_itinerary_map.dart';
import '../widgets/place_detail_dialog.dart';
import '../widgets/trip_ai_assistant_panel.dart';
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
  double _mapWidth = 380.0;

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
        content: Text('✨ Applied "${suggestion.title}"!'),
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
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildStackedAvatars(widget.trip.travellers),
        ),
      ],
    );
  }

  Widget _buildStackedAvatars(List<TravellerInfo> travellers) {
    final displayList = travellers.take(3).toList();
    final extraCount = travellers.length > 3 ? (travellers.length - 3) : 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 28,
          width: (displayList.length * 20.0) + 10.0,
          child: Stack(
            children: [
              for (int i = 0; i < displayList.length; i++)
                Positioned(
                  left: i * 18.0,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 11.5,
                      backgroundColor: displayList[i].avatarColor,
                      child: Text(
                        displayList[i].avatarLetter,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (extraCount > 0) ...[
          const SizedBox(width: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '+$extraCount',
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ====================================================
  // 1. DESKTOP LAYOUT (Left Sidebar | Timeline | Resizable Map)
  // ====================================================
  Widget _buildDesktopLayout() {
    final activeDay = widget.trip.days[activeDayIndex];

    return Padding(
      padding: const EdgeInsets.only(bottom: 76.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Column: Days List & AI Tools (265px)
          SizedBox(
            width: 265,
            child: _buildSidebarLeftColumn(),
          ),
          const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),

          // Center Column: Day Timeline
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildCenterDayHeader(activeDay),
                const SizedBox(height: 18),
                _buildTimelineStops(activeDay),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Interactive Resizable Border Handle
          _buildResizableDivider(),

          // Right Column: Full-Height Interactive Map (Resizable Width: _mapWidth)
          SizedBox(
            width: _mapWidth,
            child: _buildRightMapColumn(activeDay),
          ),
        ],
      ),
    );
  }

  /// Resizable divider handle between Timeline and Map
  Widget _buildResizableDivider() {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (details) {
          setState(() {
            // Dragging left increases map width, dragging right decreases map width
            _mapWidth = (_mapWidth - details.delta.dx).clamp(240.0, 680.0);
          });
        },
        child: Container(
          width: 12,
          color: const Color(0xFFF1F5F9),
          child: Center(
            child: Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 2, height: 2, color: Colors.white),
                  const SizedBox(height: 3),
                  Container(width: 2, height: 2, color: Colors.white),
                  const SizedBox(height: 3),
                  Container(width: 2, height: 2, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
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

                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFECF3FE) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF819EE5).withValues(alpha: 0.4) : const Color(0xFFF1F5F9),
                          width: 1.2,
                        ),
                      ),
                      child: ListTile(
                        onTap: () => setState(() => activeDayIndex = index),
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        leading: CircleAvatar(
                          radius: 13,
                          backgroundColor: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
                          child: Text(
                            '${day.dayNumber}',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? Colors.white : const Color(0xFF475569),
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
                          '${day.stops.length} stops · ${day.date}',
                          style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B)),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 10),

            // Section Title: AI Tools (sitting directly under Itinerary Days)
            Row(
              children: [
                const Icon(Icons.auto_awesome_outlined, size: 16, color: Color(0xFF2563EB)),
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

            // Tool Card 1: TripNest AI Assistant
            _buildAiToolCard(
              icon: Icons.auto_awesome_rounded,
              title: 'TripNest AI Assistant',
              subtitle: 'Ready to help',
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

            // Tool Card 2: Memories
            _buildAiToolCard(
              icon: Icons.photo_album_rounded,
              title: 'Memories',
              subtitle: 'Photos, feelings & moments',
              iconBgColor: const Color(0xFFFFF1F2),
              iconColor: const Color(0xFFF43F5E),
              onTap: () {
                widget.onBack();
              },
            ),
            const SizedBox(height: 8),

            // Tool Card 3: AI Notebook
            _buildAiToolCard(
              icon: Icons.collections_bookmark_rounded,
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
                    ),
                  ),
                );
              },
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
  // COLUMN 2: CENTER TIMELINE (Day Header & Stop Cards)
  // ====================================================
  Widget _buildCenterDayHeader(ItineraryDayData day) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Day ${day.dayNumber} • ${day.date}',
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${day.stops.length} stops · A day of coffee, nature and city vibes in ${widget.trip.destination.split(',').first}.',
          style: GoogleFonts.inter(
            fontSize: 13,
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

    return Column(
      children: [
        for (int i = 0; i < day.stops.length; i++) ...[
          _buildSingleStopCard(day.stops[i], i + 1),
          if (i < day.stops.length - 1)
            _buildWalkTransitConnector(day.stops[i]),
        ],
      ],
    );
  }

  /// Builds a single stop card matching the reference mockup
  Widget _buildSingleStopCard(ItineraryPlaceStop stop, int stepIndex) {
    final photoUrl = stop.imageUrl ??
        'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Step Number + Time Column
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              stop.time,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 5),
            CircleAvatar(
              radius: 13,
              backgroundColor: const Color(0xFF2563EB),
              child: Text(
                '$stepIndex',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 14),

        // Main Stop Floating Card
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => PlaceDetailDialog.show(context, stop),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Square Cover Photo (~105x105)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        photoUrl,
                        width: 105,
                        height: 105,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 105,
                          height: 105,
                          color: const Color(0xFFCBD5E1),
                          child: const Icon(Icons.image, color: Colors.white),
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
                          const SizedBox(height: 4),

                          // Stop Title (Clean Legible Inter Bold Font)
                          Text(
                            stop.name,
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                              height: 1.2,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Description
                          Text(
                            stop.description,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: const Color(0xFF64748B),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),

                          // Metadata Footer Row (Duration | Cost | Google Maps Link)
                          Wrap(
                            spacing: 0,
                            runSpacing: 4,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFF64748B)),
                                  const SizedBox(width: 4),
                                  Text(
                                    stop.duration,
                                    style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('·', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFFCBD5E1))),
                                  const SizedBox(width: 8),
                                  Text(
                                    '🌿 ${stop.estimatedCost}',
                                    style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('·', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFFCBD5E1))),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () => GoogleMapsService.openPlaceInGoogleMaps(stop),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF2563EB)),
                                        const SizedBox(width: 3),
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
    );
  }

  /// Walk/Transit Connector Banner pill between timeline stops
  Widget _buildWalkTransitConnector(ItineraryPlaceStop stop) {
    final walkText = stop.travelMethod.contains('Walk')
        ? stop.travelMethod
        : 'Walk ${stop.distanceToNext} (about 10 min)';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Align with the circle (26px wide + 14px gap)
          const SizedBox(width: 40),
          const Icon(Icons.directions_walk_rounded, size: 14, color: Color(0xFF94A3B8)),
          const SizedBox(width: 6),
          Text(
            walkText,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================
  // COLUMN 3: RIGHT FULL-HEIGHT INTERACTIVE MAP
  // ====================================================
  Widget _buildRightMapColumn(ItineraryDayData day) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: InteractiveItineraryMap(
              stops: day.stops,
              dayTitle: day.title,
              currentDayNumber: day.dayNumber,
              onStopSelected: (stop) => PlaceDetailDialog.show(context, stop),
            ),
          ),

          // Top Left Overlay Badge: [ 🗺️ Day 1 Route ] [ 3 Stops ]
          Positioned(
            top: 12,
            left: 12,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.map_outlined, size: 13, color: Color(0xFF2563EB)),
                      const SizedBox(width: 5),
                      Text(
                        'Day ${day.dayNumber} Route',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${day.stops.length} Stops',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Top Right Overlay Button: [ 📍 Directions ]
          Positioned(
            top: 12,
            right: 12,
            child: InkWell(
              onTap: () => GoogleMapsService.openFullDayRouteInGoogleMaps(day.stops),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.navigation_outlined, size: 13, color: Color(0xFF0F172A)),
                    const SizedBox(width: 5),
                    Text(
                      'Directions',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
              onSelected: (_) => setState(() => activeDayIndex = index),
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
