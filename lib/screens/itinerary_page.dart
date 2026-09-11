import 'package:flutter/material.dart';
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
  String _sortBy = 'date'; // 'date', 'updated', 'places'

  @override
<<<<<<< Updated upstream
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
        title: const Row(
=======
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mintBg,
      appBar: AppBar(
        backgroundColor: mintBg,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
>>>>>>> Stashed changes
          children: [
            Text('🪺 ', style: TextStyle(fontSize: 20)),
            Text('Create New Trip Folder', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Trip Name',
                hintText: 'e.g. Kyoto Autumn Journey',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: destController,
              decoration: const InputDecoration(
                labelText: 'Destination',
                hintText: 'e.g. Kyoto, Japan',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
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
            style: FilledButton.styleFrom(backgroundColor: coral),
            child: const Text('Create Folder'),
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

    if (_sortBy == 'places') {
      list.sort((a, b) => b.placesCount.compareTo(a.placesCount));
    } else if (_sortBy == 'name') {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else {
      list.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
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

    // Otherwise, render the "My Itineraries" main dashboard with Trip Folders & Calendar
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // --------------------------------------------------
            // 1. HEADER SECTION
            // --------------------------------------------------
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🪺 ', style: TextStyle(fontSize: 24)),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'My Itineraries',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F172A),
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                'Every conversation can become a journey.',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: _showCreateTripDialog,
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('New Trip', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                          style: FilledButton.styleFrom(
                            backgroundColor: coral,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Search and View Switcher Row
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 600;

                        final searchBar = TextField(
                          decoration: InputDecoration(
                            hintText: 'Search trips, destinations, or chatrooms...',
                            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                            prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: coral, width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                          ),
                          onChanged: (val) => setState(() => _searchQuery = val),
                        );

                        final viewSwitcher = Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildViewSwitchBtn('Folders', Icons.folder_open, !_isCalendarView, () {
                                setState(() => _isCalendarView = false);
                              }),
                              _buildViewSwitchBtn('Calendar', Icons.calendar_month, _isCalendarView, () {
                                setState(() => _isCalendarView = true);
                              }),
                            ],
                          ),
                        );

                        return isWide
                            ? Row(
                                children: [
                                  Expanded(child: searchBar),
                                  const SizedBox(width: 12),
                                  viewSwitcher,
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  searchBar,
                                  const SizedBox(height: 10),
                                  Align(alignment: Alignment.centerLeft, child: viewSwitcher),
                                ],
                              );
                      },
                    ),
                    const SizedBox(height: 14),

                    // Filter Chips: All / Upcoming / Ongoing / Completed + Sort Menu
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All Trips (${_trips.length})', null),
                          const SizedBox(width: 8),
                          _buildFilterChip('Upcoming', TripStatus.upcoming),
                          const SizedBox(width: 8),
                          _buildFilterChip('Ongoing', TripStatus.ongoing),
                          const SizedBox(width: 8),
                          _buildFilterChip('Completed', TripStatus.completed),
                          const SizedBox(width: 10),
                          PopupMenuButton<String>(
                            initialValue: _sortBy,
                            onSelected: (val) => setState(() => _sortBy = val),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.sort, size: 14, color: Color(0xFF475569)),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Sort: ${_sortBy == "places" ? "Places" : _sortBy == "name" ? "Name" : "Date"}',
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                                  ),
                                ],
                              ),
                            ),
                            itemBuilder: (ctx) => const [
                              PopupMenuItem(value: 'date', child: Text('Travel Date')),
                              PopupMenuItem(value: 'places', child: Text('Most Places')),
                              PopupMenuItem(value: 'name', child: Text('Trip Name')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --------------------------------------------------
            // 2. MAIN BODY: CALENDAR VIEW OR FOLDERS GRID
            // --------------------------------------------------
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: _isCalendarView
                  ? SliverToBoxAdapter(
                      child: TripCalendarView(
                        trips: _trips,
                        onOpenTrip: _openTripWorkspace,
                      ),
                    )
                  : _buildFoldersSliverGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewSwitchBtn(String label, IconData icon, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: isActive ? coral : const Color(0xFF64748B)),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                color: isActive ? const Color(0xFF0F172A) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, TripStatus? status) {
    final isSelected = _selectedStatusFilter == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: coral.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? coral : const Color(0xFF475569),
      ),
      onSelected: (_) => setState(() => _selectedStatusFilter = status),
    );
  }

  Widget _buildFoldersSliverGrid() {
    final trips = _filteredTrips;

    if (trips.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(40),
          alignment: Alignment.center,
          child: Column(
            children: [
              const Text('🪺', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              const Text(
                'No trip folders found',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                'Try adjusting your search or create a new trip folder.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.crossAxisExtent >= 1100
            ? 3
            : constraints.crossAxisExtent >= 680
                ? 2
                : 1;

        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.95,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final trip = trips[index];
              return _buildTripFolderCard(trip);
            },
            childCount: trips.length,
          ),
        );
      },
    );
  }

  // ====================================================
  // COMPONENT: Trip Folder Card (Section 4)
  // ====================================================
  Widget _buildTripFolderCard(TripFolderItem trip) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openTripWorkspace(trip),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Cover / Map Preview Thumbnail with Status Badge
            Stack(
              children: [
                Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        trip.themeColor.withValues(alpha: 0.85),
                        const Color(0xFF0F172A),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🗺', style: TextStyle(fontSize: 32)),
                        const SizedBox(height: 4),
                        Text(
                          '${trip.days.length} Days · ${trip.placesCount} Places',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(color: trip.themeColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          trip.status.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            color: trip.themeColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Updated ${trip.lastUpdated}',
                      style: const TextStyle(fontSize: 10, color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),

            // Card Body Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Trip Name
                    Text(
                      trip.name,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Destination & Dates
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 13, color: coral),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            trip.destination,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 12, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Text(
                          '${trip.startDate} – ${trip.endDate}',
                          style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Travellers Avatar Row
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: trip.travellers.take(4).map((t) {
                              return Align(
                                widthFactor: 0.7,
                                child: CircleAvatar(
                                  radius: 11,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: t.avatarColor,
                                    child: Text(
                                      t.avatarLetter,
                                      style: const TextStyle(fontSize: 8.5, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${trip.travellers.length} travellers',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 8),

                    // Connected Chat & Notebook Status
                    Row(
                      children: [
                        const Icon(Icons.forum_outlined, size: 14, color: coral),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            trip.chatName,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '🪺 ${trip.notebookDecisionsCount} decisions',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFC2410C)),
                          ),
                        ),
                      ],
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
}
