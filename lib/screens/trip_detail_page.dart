import 'package:flutter/material.dart';
import '../models/itinerary_trip_models.dart';
import '../services/google_maps_service.dart';
import '../theme.dart';
import '../widgets/interactive_itinerary_map.dart';
import '../widgets/place_detail_dialog.dart';
import '../widgets/trip_ai_assistant_panel.dart';

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
  bool isMapExpanded = false;
  late TabController _mobileTabController;

  @override
  void initState() {
    super.initState();
    activeDayIndex = 0;
    _mobileTabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _mobileTabController.dispose();
    super.dispose();
  }

  void _applyAiSuggestion(TripAiSuggestion suggestion) {
    setState(() {
      if (suggestion.id == 'sug_late_start') {
        // Shift Day 2 morning starts from 08:00 to 10:30
        if (widget.trip.days.length >= 2) {
          final day2 = widget.trip.days[1];
          day2.walkingEstimate = '10,200 steps (Pace: Relaxed)';
          if (day2.stops.isNotEmpty) {
            day2.stops[0].time = '10:30';
            day2.stops[0].whyRecommended =
                'Updated by AI: Shifted from 08:00 to 10:30 AM to match Notebook preference ("No rushing early mornings").';
          }
          if (day2.stops.length >= 2) {
            day2.stops[1].time = '13:30';
          }
          if (day2.stops.length >= 3) {
            day2.stops[2].time = '15:30';
          }
        }
      } else if (suggestion.id == 'sug_walking_gap') {
        // Bridge Day 3 walking gap
        if (widget.trip.days.length >= 3) {
          final day3 = widget.trip.days[2];
          day3.walkingEstimate = '11,400 steps (Pace: Balanced)';
          if (day3.stops.isNotEmpty) {
            day3.stops[0].travelMethod = 'Ginza Line Subway (2 stops, 4 min) or via Kappabashi';
            day3.stops[0].distanceToNext = 'Ginza Line transit (4 min)';
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
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _addRecommendedPlaceToDay(TripRecommendation rec) {
    final targetDay = widget.trip.days.firstWhere(
      (d) => d.dayNumber == rec.targetDayNumber,
      orElse: () => widget.trip.days.first,
    );

    setState(() {
      targetDay.stops.add(rec.placeData);
      widget.trip.placesCount++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${rec.title}" to Day ${targetDay.dayNumber}! 🗺'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleOptimizeDay(ItineraryDayData day) {
    setState(() {
      day.walkingEstimate = '${(int.tryParse(day.walkingEstimate.split(' ').first.replaceAll(',', '')) ?? 12000) - 1500} steps (Optimized)';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✦ Day ${day.dayNumber} route optimized! Walking distance reduced.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addNewCustomStop(ItineraryDayData day) {
    final newStop = ItineraryPlaceStop(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      time: '17:30',
      name: 'Scenic Local Stop',
      category: 'Sightseeing',
      categoryIcon: '📍',
      address: 'Central District, ${widget.trip.destination}',
      description: 'Added manually to day schedule.',
      duration: '1 hour',
      estimatedCost: 'Free entry',
      distanceToNext: '500m',
      travelMethod: 'Walk',
      rating: 4.6,
      reviewCount: 1200,
      whyRecommended: 'Added by traveller.',
      googleMapsUrl: 'https://maps.google.com',
      lat: day.stops.isNotEmpty ? day.stops.last.lat + 0.005 : 35.66,
      lng: day.stops.isNotEmpty ? day.stops.last.lng + 0.005 : 139.70,
    );

    setState(() {
      day.stops.add(newStop);
      widget.trip.placesCount++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added new stop to itinerary!'), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1040;
        final isTablet = constraints.maxWidth >= 720 && constraints.maxWidth < 1040;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
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
  // APP BAR: Trip Info & Connected Chatroom
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
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: widget.trip.themeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.trip.days.length} Days',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: widget.trip.themeColor,
                  ),
                ),
              ),
            ],
          ),
          Text(
            '${widget.trip.destination} · ${widget.trip.startDate} – ${widget.trip.endDate} · 👥 ${widget.trip.travellers.length} Travellers',
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.normal),
          ),
        ],
      ),
      actions: [
        // Connected Chatroom Button (Section 5 & 23)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: FilledButton.tonalIcon(
            onPressed: () {
              if (widget.onNavigateToChat != null) {
                widget.onNavigateToChat!(widget.trip.chatId);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Navigating to Chat: ${widget.trip.chatName}...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            icon: const Icon(Icons.forum_outlined, size: 16, color: coral),
            label: Text(
              'Chat: ${widget.trip.chatName}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: coral),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFFECEB),
              side: BorderSide(color: coral.withValues(alpha: 0.3)),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  // ====================================================
  // 1. DESKTOP WORKSPACE (3 Columns: Days | Itinerary+Map | AI)
  // ====================================================
  Widget _buildDesktopLayout() {
    final activeDay = widget.trip.days[activeDayIndex];

    return Row(
      children: [
        // Left Column: Day Selector & Travellers (260px)
        SizedBox(
          width: 260,
          child: _buildDaysAndTravellersSidebar(),
        ),
        const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),

        // Center Column: Day Timeline & Interactive Map (Flex: 5)
        Expanded(
          flex: 5,
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              // Day Timeline Header
              _buildDayHeaderCard(activeDay),
              const SizedBox(height: 16),

              // Interactive Map Component
              SizedBox(
                height: 320,
                child: InteractiveItineraryMap(
                  stops: activeDay.stops,
                  dayTitle: activeDay.title,
                  currentDayNumber: activeDay.dayNumber,
                  onStopSelected: (stop) => PlaceDetailDialog.show(context, stop),
                ),
              ),
              const SizedBox(height: 20),

              // Day-by-Day Timeline Stops
              _buildDayTimeline(activeDay),
              const SizedBox(height: 24),

              // System Recommendations: "TripNest Suggestions"
              _buildRecommendationsSection(activeDay),
            ],
          ),
        ),
        const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),

        // Right Column: TripNest AI Assistant (360px)
        SizedBox(
          width: 360,
          child: TripAiAssistantPanel(
            trip: widget.trip,
            onApplySuggestion: _applyAiSuggestion,
            onDiscussTopicInChat: (prompt) {
              if (widget.onNavigateToChat != null) {
                widget.onNavigateToChat!(widget.trip.chatId);
              }
            },
          ),
        ),
      ],
    );
  }

  // ====================================================
  // 2. TABLET WORKSPACE (2 Columns)
  // ====================================================
  Widget _buildTabletLayout() {
    final activeDay = widget.trip.days[activeDayIndex];

    return Row(
      children: [
        // Left Column: Timeline & Map
        Expanded(
          flex: 6,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildDayTabsHorizontal(),
              const SizedBox(height: 14),
              _buildDayHeaderCard(activeDay),
              const SizedBox(height: 14),
              SizedBox(
                height: 280,
                child: InteractiveItineraryMap(
                  stops: activeDay.stops,
                  dayTitle: activeDay.title,
                  currentDayNumber: activeDay.dayNumber,
                  onStopSelected: (stop) => PlaceDetailDialog.show(context, stop),
                ),
              ),
              const SizedBox(height: 16),
              _buildDayTimeline(activeDay),
            ],
          ),
        ),
        const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),

        // Right Column: AI Assistant & Travellers
        SizedBox(
          width: 330,
          child: TripAiAssistantPanel(
            trip: widget.trip,
            onApplySuggestion: _applyAiSuggestion,
          ),
        ),
      ],
    );
  }

  // ====================================================
  // 3. MOBILE WORKSPACE (Tabs: Timeline, Map, AI, Flock)
  // ====================================================
  Widget _buildMobileLayout() {
    final activeDay = widget.trip.days[activeDayIndex];

    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _mobileTabController,
            labelColor: coral,
            indicatorColor: coral,
            tabs: const [
              Tab(icon: Icon(Icons.timeline, size: 18), text: 'Timeline'),
              Tab(icon: Icon(Icons.map_outlined, size: 18), text: 'Map'),
              Tab(icon: Text('🐦', style: TextStyle(fontSize: 16)), text: 'AI Assistant'),
              Tab(icon: Icon(Icons.people_outline, size: 18), text: 'Flock'),
            ],
          ),
        ),
        _buildDayTabsHorizontal(),
        Expanded(
          child: TabBarView(
            controller: _mobileTabController,
            children: [
              // Tab 1: Day Timeline
              ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  _buildDayHeaderCard(activeDay),
                  const SizedBox(height: 14),
                  _buildDayTimeline(activeDay),
                  const SizedBox(height: 20),
                  _buildRecommendationsSection(activeDay),
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
              // Tab 3: AI Assistant
              TripAiAssistantPanel(
                trip: widget.trip,
                onApplySuggestion: _applyAiSuggestion,
              ),
              // Tab 4: Travellers
              _buildTravellersListMobile(),
            ],
          ),
        ),
      ],
    );
  }

  // ====================================================
  // COMPONENT: Days & Travellers Sidebar (Desktop)
  // ====================================================
  Widget _buildDaysAndTravellersSidebar() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Text(
              'ITINERARY DAYS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Color(0xFF64748B),
                letterSpacing: 0.6,
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Days List
          Expanded(
            flex: 6,
            child: ListView.builder(
              itemCount: widget.trip.days.length,
              itemBuilder: (context, index) {
                final day = widget.trip.days[index];
                final isSelected = activeDayIndex == index;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: isSelected ? coral.withValues(alpha: 0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected ? Border.all(color: coral.withValues(alpha: 0.3)) : null,
                  ),
                  child: ListTile(
                    onTap: () => setState(() => activeDayIndex = index),
                    dense: true,
                    leading: CircleAvatar(
                      radius: 13,
                      backgroundColor: isSelected ? coral : const Color(0xFFF1F5F9),
                      child: Text(
                        '${day.dayNumber}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: isSelected ? Colors.white : const Color(0xFF475569),
                        ),
                      ),
                    ),
                    title: Text(
                      'Day ${day.dayNumber}',
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                        fontSize: 13,
                        color: isSelected ? coral : const Color(0xFF0F172A),
                      ),
                    ),
                    subtitle: Text(
                      '${day.stops.length} stops · ${day.date}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Travellers Section (Section 10)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              children: [
                const Text(
                  'TRAVELLERS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.6,
                  ),
                ),
                const Spacer(),
                Text(
                  '${widget.trip.travellers.length}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: ListView.builder(
              itemCount: widget.trip.travellers.length,
              itemBuilder: (context, index) {
                final t = widget.trip.travellers[index];
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 12,
                    backgroundColor: t.avatarColor,
                    child: Text(
                      t.avatarLetter,
                      style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    t.name,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                  ),
                  subtitle: Text(
                    '${t.mbti} · ${t.travelStyle}',
                    style: const TextStyle(fontSize: 10.5, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: t.chatId != null
                      ? IconButton(
                          icon: const Icon(Icons.chat_bubble_outline, size: 15, color: coral),
                          tooltip: 'Chat with ${t.name}',
                          onPressed: () {
                            if (widget.onNavigateToChat != null) {
                              widget.onNavigateToChat!(t.chatId!);
                            }
                          },
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayTabsHorizontal() {
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
              selectedColor: coral.withValues(alpha: 0.15),
              labelStyle: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? coral : const Color(0xFF334155),
              ),
              onSelected: (_) => setState(() => activeDayIndex = index),
            ),
          );
        },
      ),
    );
  }

  // ====================================================
  // COMPONENT: Day Header Card (Walking, Cost & Actions)
  // ====================================================
  Widget _buildDayHeaderCard(ItineraryDayData day) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: coral,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'DAY ${day.dayNumber}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                day.date,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
              ),
              const Spacer(),
              FilledButton.tonalIcon(
                onPressed: () => _handleOptimizeDay(day),
                icon: const Icon(Icons.auto_fix_high, size: 14, color: coral),
                label: const Text('✦ Optimize This Day', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: coral)),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFFECEB),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            day.title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            day.summary,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.directions_walk, size: 14, color: Color(0xFF475569)),
                        const SizedBox(width: 4),
                        Text(
                          day.walkingEstimate,
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.payments_outlined, size: 14, color: Color(0xFF475569)),
                        const SizedBox(width: 4),
                        Text(
                          day.estimatedCost,
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (day.stops.isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: () {
                        final dirUrl = GoogleMapsService.getFullDayDirectionsUrl(day.stops);
                        GoogleMapsService.openFullDayRouteInGoogleMaps(day.stops);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening Google Maps route for Day ${day.dayNumber} (${day.stops.length} stops):\n$dirUrl'),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'Directions',
                              onPressed: () => GoogleMapsService.openFullDayRouteInGoogleMaps(day.stops),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.directions, size: 13, color: Color(0xFF2563EB)),
                      label: Text('Route (${day.stops.length})', style: const TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        side: const BorderSide(color: Color(0xFFBFDBFE)),
                      ),
                    ),
                  OutlinedButton.icon(
                    onPressed: () => _addNewCustomStop(day),
                    icon: const Icon(Icons.add, size: 14),
                    label: const Text('Add Stop', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ====================================================
  // COMPONENT: Day-by-Day Timeline
  // ====================================================
  Widget _buildDayTimeline(ItineraryDayData day) {
    if (day.stops.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        child: const Text('No stops planned for this day yet.'),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < day.stops.length; i++) ...[
          _buildStopCard(day.stops[i], i + 1, () {
            setState(() {
              day.stops.removeAt(i);
              widget.trip.placesCount--;
            });
          }),
          if (i < day.stops.length - 1)
            _buildTransitConnector(day.stops[i]),
        ],
      ],
    );
  }

  Widget _buildStopCard(ItineraryPlaceStop stop, int stepIndex, VoidCallback onRemove) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: stop.isHighlight ? coral.withValues(alpha: 0.4) : const Color(0xFFE2E8F0),
          width: stop.isHighlight ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => PlaceDetailDialog.show(context, stop, onRemove: onRemove),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Number & Time
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: stop.isHighlight ? coral : const Color(0xFF0F172A),
                        child: Text(
                          '$stepIndex',
                          style: const TextStyle(fontSize: 10.5, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stop.time,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // Stop Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              stop.categoryIcon,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              stop.category,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                            ),
                            if (stop.isHighlight) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'PRIORITY',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFFB45309)),
                                ),
                              ),
                            ],
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Color(0xFFF59E0B), size: 13),
                                const SizedBox(width: 2),
                                Text(
                                  '${stop.rating}',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          stop.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          stop.description,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        // Notebook Connection Rationale
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '🪺 ${stop.whyRecommended}',
                            style: const TextStyle(fontSize: 10.5, color: Color(0xFF9A3412), fontStyle: FontStyle.italic),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 8),

              // Bottom Actions: Meta & Google Maps
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    '⏱ ${stop.duration} · 💰 ${stop.estimatedCost}',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      GoogleMapsService.openPlaceInGoogleMaps(stop);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening Google Maps URL: ${stop.googleMapsUrl}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.open_in_new, size: 12, color: Color(0xFF2563EB)),
                    label: const Text('View on Google Maps', style: TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransitConnector(ItineraryPlaceStop stop) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const SizedBox(width: 25),
          Container(
            width: 2,
            height: 24,
            color: const Color(0xFFCBD5E1),
          ),
          const SizedBox(width: 14),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_downward, size: 11, color: Color(0xFF64748B)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      '${stop.travelMethod} (${stop.distanceToNext})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10.5, color: Color(0xFF475569), fontWeight: FontWeight.w600),
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
  // COMPONENT: Recommendations ("TripNest Suggestions")
  // ====================================================
  Widget _buildRecommendationsSection(ItineraryDayData day) {
    final relevantRecs = widget.trip.recommendations
        .where((r) => r.targetDayNumber == day.dayNumber)
        .toList();

    if (relevantRecs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('✨ ', style: TextStyle(fontSize: 16)),
            const Text(
              'TripNest Suggestions',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              '· Places You Might Love',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (final rec in relevantRecs) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFED7AA)),
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
                Text(rec.categoryIcon, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              rec.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF0F172A)),
                            ),
                          ),
                          const Icon(Icons.star, color: Color(0xFFF59E0B), size: 12),
                          const SizedBox(width: 2),
                          Text('${rec.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        rec.whyRecommended,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF7C2D12)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '📍 ${rec.distance} · ${rec.travelTime}',
                        style: const TextStyle(fontSize: 10.5, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton.tonalIcon(
                  onPressed: () => _addRecommendedPlaceToDay(rec),
                  icon: const Icon(Icons.add, size: 14),
                  label: Text('Add to Day ${day.dayNumber}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    backgroundColor: const Color(0xFFFFECEB),
                    foregroundColor: coral,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTravellersListMobile() {
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
            title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
