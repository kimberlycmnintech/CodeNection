import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/itinerary_trip_models.dart';
import '../models/models.dart';
import '../theme.dart';
import '../widgets/trip_calendar_view.dart';
import 'trip_detail_page.dart';

class ItineraryPage extends StatefulWidget {
  final TripData trip;
  final SocialData data;
  final VoidCallback? onOpenTrip;
  final Function(String chatId)? onNavigateToChat;

  const ItineraryPage({
    super.key,
    required this.trip,
    required this.data,
    this.onOpenTrip,
    this.onNavigateToChat,
  });

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  late List<TripFolderItem> _trips;
  TripFolderItem? _openTripDetail;
  String _searchQuery = '';
  TripStatus? _selectedStatusFilter; // null means 'All'
  bool _isCalendarView = false;
  String _sortBy = 'lastAccessed'; // 'lastAccessed', 'name', 'date'

  @override
  void initState() {
    super.initState();
    _trips = TripRepository.getDemoTrips();
  }

  void _openTripWorkspace(TripFolderItem trip) {
    setState(() {
      _openTripDetail = trip;
    });
  }

  void _closeTripWorkspace() {
    setState(() {
      _openTripDetail = null;
    });
  }

  void _showCreateTripDialog() {
    final nameController = TextEditingController();
    final destController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text(
              'New Trip',
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                fontSize: 22,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Trip Name',
                hintText: 'e.g. Kyoto Autumn Journey',
                hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: destController,
              decoration: InputDecoration(
                labelText: 'Destination',
                hintText: 'e.g. Kyoto, Japan',
                hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.inter(color: const Color(0xFF64748B))),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final dest = destController.text.trim();
              if (name.isEmpty) return;

              final newTrip = TripFolderItem(
                id: 'trip_${DateTime.now().millisecondsSinceEpoch}',
                name: name,
                destination: dest.isNotEmpty ? dest : 'New Destination',
                startDate: '1 Feb',
                endDate: '5 Feb 2027',
                startDateTime: DateTime(2027, 2, 1),
                endDateTime: DateTime(2027, 2, 5),
                daysLeftBadge: '14 days left',
                tags: const ['City', 'Food', 'Culture'],
                coverImageUrl: 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=800',
                status: TripStatus.upcoming,
                chatId: 'japan_2026',
                chatName: 'New Flock Chat',
                travellers: [
                  const TravellerInfo(
                    id: 't_you_new',
                    name: 'You',
                    avatarLetter: 'Y',
                    avatarColor: coral,
                    mbti: 'INFJ',
                    interests: ['Explorer'],
                    travelStyle: 'Planner',
                  ),
                ],
                days: [
                  ItineraryDayData(
                    dayNumber: 1,
                    date: 'Mon, Feb 1',
                    title: 'Arrival & Welcome',
                    summary: 'First day settling in and exploring nearby neighborhood.',
                    walkingEstimate: '6,000 steps',
                    estimatedCost: 'RM50',
                    stops: [],
                  ),
                ],
                placesCount: 0,
                lastUpdated: 'Just now',
                notebookDecisionsCount: 0,
                mapPreviewUrl: 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=400',
                themeColor: const Color(0xFF6366F1),
                recommendations: [],
                aiSuggestions: [],
              );

              setState(() {
                _trips.insert(0, newTrip);
              });
              Navigator.pop(ctx);
              _openTripWorkspace(newTrip);
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text('Create Trip', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  List<TripFolderItem> get _filteredTrips {
    final list = _trips.where((t) {
      if (_selectedStatusFilter != null && t.status != _selectedStatusFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return t.name.toLowerCase().contains(query) ||
            t.destination.toLowerCase().contains(query) ||
            t.chatName.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    if (_sortBy == 'name') {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortBy == 'date') {
      list.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
    } else {
      // lastAccessed - most recently updated first
      list.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    // If a Trip Folder is opened, display the dedicated TripDetailPage Workspace!
    if (_openTripDetail != null) {
      return TripDetailPage(
        trip: _openTripDetail!,
        onBack: _closeTripWorkspace,
        onNavigateToChat: widget.onNavigateToChat,
      );
    }

    // Otherwise, render the "My Itineraries" main dashboard matching the reference mockup!
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // TOP HEADER: TITLE & NEW TRIP BUTTON
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Itineraries',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Plan, experience, and remember what matters.',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  FilledButton.icon(
                    onPressed: _showCreateTripDialog,
                    icon: const Icon(Icons.add, size: 18, color: Colors.white),
                    label: Text(
                      'New Trip',
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ==========================================
              // SEARCH BAR
              // ==========================================
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search trips, destinations, or chatrooms...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13.5,
                    color: const Color(0xFF94A3B8),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                    color: Color(0xFF94A3B8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.5),
                  ),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
              const SizedBox(height: 16),

              // ==========================================
              // TOP-LEVEL VIEW SWITCHER: ALL TRIPS vs CALENDAR
              // ==========================================
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0).withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTopLevelViewTab(
                        label: 'All Trips',
                        icon: Icons.folder_outlined,
                        count: _trips.length,
                        isSelected: !_isCalendarView,
                        onTap: () => setState(() => _isCalendarView = false),
                      ),
                    ),
                    Expanded(
                      child: _buildTopLevelViewTab(
                        label: 'Calendar',
                        icon: Icons.calendar_month_rounded,
                        isSelected: _isCalendarView,
                        onTap: () => setState(() => _isCalendarView = true),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ==========================================
              // SUB-FILTERS & SORT ROW (UNDER ALL TRIPS)
              // ==========================================
              if (!_isCalendarView) ...[
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildCustomFilterChip(
                              label: 'All (${_trips.length})',
                              icon: Icons.grid_view_rounded,
                              isSelected: _selectedStatusFilter == null,
                              onTap: () => setState(() => _selectedStatusFilter = null),
                            ),
                            const SizedBox(width: 8),
                            _buildCustomFilterChip(
                              label: 'Upcoming',
                              icon: Icons.calendar_today_outlined,
                              isSelected: _selectedStatusFilter == TripStatus.upcoming,
                              onTap: () => setState(() => _selectedStatusFilter = TripStatus.upcoming),
                            ),
                            const SizedBox(width: 8),
                            _buildCustomFilterChip(
                              label: 'Ongoing',
                              icon: Icons.access_time_rounded,
                              isSelected: _selectedStatusFilter == TripStatus.ongoing,
                              onTap: () => setState(() => _selectedStatusFilter = TripStatus.ongoing),
                            ),
                            const SizedBox(width: 8),
                            _buildCustomFilterChip(
                              label: 'Past',
                              icon: Icons.history_rounded,
                              isSelected: _selectedStatusFilter == TripStatus.completed,
                              onTap: () => setState(() => _selectedStatusFilter = TripStatus.completed),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Sort Menu Dropdown Button
                    PopupMenuButton<String>(
                      initialValue: _sortBy,
                      onSelected: (val) => setState(() => _sortBy = val),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.sort_rounded, size: 16, color: Color(0xFF475569)),
                            const SizedBox(width: 6),
                            Text(
                              'Sort: ${_sortBy == "date" ? "Travel Date" : _sortBy == "name" ? "Trip Name" : "Last Accessed"}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF475569)),
                          ],
                        ),
                      ),
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          value: 'lastAccessed',
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF64748B)),
                              const SizedBox(width: 8),
                              Text('Last Accessed', style: GoogleFonts.inter(fontSize: 13)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'name',
                          child: Row(
                            children: [
                              const Icon(Icons.sort_by_alpha_rounded, size: 16, color: Color(0xFF64748B)),
                              const SizedBox(width: 8),
                              Text('Trip Name', style: GoogleFonts.inter(fontSize: 13)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'date',
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF64748B)),
                              const SizedBox(width: 8),
                              Text('Travel Date', style: GoogleFonts.inter(fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
              ],

              // ==========================================
              // ITINERARY CARDS LIST OR CALENDAR VIEW
              // ==========================================
              _isCalendarView
                  ? TripCalendarView(
                      trips: _trips,
                      onOpenTrip: _openTripWorkspace,
                    )
                  : _buildTripList(_filteredTrips),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  /// Top-Level View Tab (All Trips vs Calendar)
  Widget _buildTopLevelViewTab({
    required String label,
    required IconData icon,
    int? count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
            const SizedBox(width: 7),
            Text(
              count != null ? '$label ($count)' : label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom Filter Chip matching reference mockup
  Widget _buildCustomFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDDE7F7) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFF819EE5).withValues(alpha: 0.5) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the list of horizontal trip cards
  Widget _buildTripList(List<TripFolderItem> trips) {
    if (trips.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Text('🗺️', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              'No itineraries found',
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try adjusting your search or create a new trip.',
              style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Column(
      children: trips.map((trip) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _buildHorizontalTripCard(trip),
      )).toList(),
    );
  }

  /// Builds a single horizontal trip card matching reference mockup
  Widget _buildHorizontalTripCard(TripFolderItem trip) {
    final imageWidth = 175.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () => _openTripWorkspace(trip),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ==========================================
                // LEFT IMAGE SECTION WITH STATUS BADGES
                // ==========================================
                SizedBox(
                  width: imageWidth,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        trip.coverImageUrl ?? trip.mapPreviewUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFCBD5E1),
                          child: const Icon(Icons.landscape, color: Colors.white, size: 36),
                        ),
                      ),

                      // Overlay Status Badge
                      Positioned(
                        top: 12,
                        left: 12,
                        child: _buildTripCardStatusBadge(trip),
                      ),

                      // Overlay Memories Badge (For completed trips)
                      if (trip.status == TripStatus.completed)
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.photo_library_outlined, size: 12, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  '24 memories',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Icon(Icons.chevron_right_rounded, size: 14, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ==========================================
                // RIGHT DETAILS SECTION
                // ==========================================
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top Header: Days/Places + Menu Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.map_outlined,
                                  size: 15,
                                  color: Color(0xFF94A3B8),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${trip.daysCount ?? trip.days.length} Days • ${trip.placesCount} Places',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.more_horiz_rounded,
                              color: Color(0xFF94A3B8),
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Italic Serif Title
                        Text(
                          trip.name,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFF0F172A),
                            height: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),

                        // Location Row
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              trip.destination,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Date Range Row
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 13,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${trip.startDate} – ${trip.endDate}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Travellers Row with Stacked Avatars & Text Label
                        Row(
                          children: [
                            _buildCardTravellerAvatars(trip.travellers),
                            const SizedBox(width: 8),
                            Text(
                              _getTravellersLabelText(trip),
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Tag Pills Row
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: _getTripTagsList(trip).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                tag,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF475569),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripCardStatusBadge(TripFolderItem trip) {
    if (trip.status == TripStatus.completed) {
      return Container(
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
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF475569)),
            const SizedBox(width: 5),
            Text(
              'Completed',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      );
    } else if (trip.status == TripStatus.ongoing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: Color(0xFF16A34A),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              trip.daysLeftBadge ?? 'Ongoing • Day 3',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF15803D),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.white),
            const SizedBox(width: 5),
            Text(
              trip.daysLeftBadge ?? '24 days left',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildCardTravellerAvatars(List<TravellerInfo> travellers) {
    final displayList = travellers.take(2).toList();
    final extraCount = travellers.length > 2 ? (travellers.length - 2) : 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 24,
          width: (displayList.length * 15.0) + 8.0,
          child: Stack(
            children: [
              for (int i = 0; i < displayList.length; i++)
                Positioned(
                  left: i * 13.0,
                  child: CircleAvatar(
                    radius: 11,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 9.5,
                      backgroundColor: displayList[i].avatarColor,
                      child: Text(
                        displayList[i].avatarLetter,
                        style: const TextStyle(
                          fontSize: 8.5,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+$extraCount',
              style: GoogleFonts.inter(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _getTravellersLabelText(TripFolderItem trip) {
    final names = trip.travellers.where((t) => t.name != 'You').map((t) => t.name).toList();
    if (names.isEmpty) return 'With You';
    if (names.length == 1) return 'With ${names[0]}';
    if (names.length == 2) return 'With ${names[0]}, ${names[1]}';
    return 'With ${names[0]}, ${names[1]} +${names.length - 2}';
  }

  List<String> _getTripTagsList(TripFolderItem trip) {
    if (trip.name.contains('Rockies')) {
      return ['🍃 Nature', '🏔️ Hiking', '📷 Scenery', '+1'];
    } else if (trip.name.contains('Santorini')) {
      return ['☂️ Beaches', '🔆 Relaxation', '📷 Photography', '+1'];
    } else {
      return ['🏢 City', '🍴 Food', '🏛️ Culture', '+2'];
    }
  }
}
