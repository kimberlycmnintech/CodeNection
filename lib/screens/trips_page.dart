import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';

class TripsPage extends StatefulWidget {
  final TripData trip;
  final VoidCallback onOpenTrip;
  const TripsPage({super.key, required this.trip, required this.onOpenTrip});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  String _selectedStatus = 'All';

  final List<_TripCardData> _allTrips = [
    _TripCardData(
      name: 'Phi Phi, Thailand',
      status: 'Upcoming',
      dates: '12 Mar - 18 Mar, 2026',
      travellers: '2 Travellers',
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
      isPrimary: false,
    ),
    _TripCardData(
      name: 'Ha Long Bay, Vietnam',
      status: 'Completed',
      dates: '12 Feb - 20 Feb, 2026',
      travellers: '2 Travellers',
      imageUrl: 'https://images.unsplash.com/photo-1528127269322-539801943592?w=800',
      isPrimary: false,
    ),
    _TripCardData(
      name: 'Istanbul, Turkey',
      status: 'Ongoing',
      dates: '05 Apr - 15 Apr, 2026',
      travellers: '3 Travellers',
      imageUrl: 'https://images.unsplash.com/photo-1541432901042-2d8bd64b4a9b?w=800',
      isPrimary: false,
    ),
  ];

  List<_TripCardData> get filteredTrips {
    if (_selectedStatus == 'All') return _allTrips;
    return _allTrips.where((t) => t.status.toLowerCase() == _selectedStatus.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iceBg,
      appBar: AppBar(
        backgroundColor: iceBg,
        elevation: 0,
        title: Text(
          'My Trips',
          style: boldItalicTitle(24, color: darkSlate),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0F0F172A),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(Icons.search_rounded, color: darkSlate, size: 20),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --------------------------------------------------
          // TOP FILTER PILLS (REF MOCKUP SCREEN 3)
          // --------------------------------------------------
          Row(
            children: ['All', 'Upcoming', 'Ongoing', 'Completed'].map((status) {
              final isSelected = _selectedStatus == status;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedStatus = status),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? darkSlate : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: darkSlate.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        else
                          const BoxShadow(
                            color: Color(0x0F0F172A),
                            blurRadius: 4,
                          ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        status,
                        style: isSelected
                            ? boldItalicTitle(11.5, color: Colors.white)
                            : bodyFont(11.5, color: darkSlate, weight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // --------------------------------------------------
          // CURRENT TRIP CARD (LINKED TO STATE)
          // --------------------------------------------------
          _buildTripCard(
            _TripCardData(
              name: widget.trip.name.isNotEmpty ? widget.trip.name : 'Trip to Japan',
              status: 'Active',
              dates: '${widget.trip.startDate} - ${widget.trip.endDate}',
              travellers: '${widget.trip.places.length} Places Saved',
              imageUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800',
              isPrimary: true,
            ),
          ),

          const SizedBox(height: 14),

          // --------------------------------------------------
          // FILTERED TRIPS CARDS (REF MOCKUP SCREEN 3 LAYOUT)
          // --------------------------------------------------
          ...filteredTrips.map((t) => _buildTripCard(t)),
        ],
      ),
    );
  }

  Widget _buildTripCard(_TripCardData data) {
    Color statusBgColor;
    Color statusTextColor = Colors.white;

    if (data.status == 'Upcoming' || data.status == 'Active') {
      statusBgColor = azureBlue;
    } else if (data.status == 'Ongoing') {
      statusBgColor = const Color(0xFF0284C7);
    } else {
      statusBgColor = darkSlate.withValues(alpha: 0.75);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 185,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        onTap: widget.onOpenTrip,
        borderRadius: BorderRadius.circular(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                data.imageUrl,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.4),
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    data.status,
                    style: TextStyle(
                      color: statusTextColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.name,
                      style: boldItalicTitle(20, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, color: Colors.white.withValues(alpha: 0.85), size: 13),
                        const SizedBox(width: 4),
                        Text(
                          data.dates,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 11.5,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Icon(Icons.people_alt_rounded, color: Colors.white.withValues(alpha: 0.85), size: 13),
                        const SizedBox(width: 4),
                        Text(
                          data.travellers,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 11.5,
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
    );
  }

}

class _TripCardData {
  final String name;
  final String status;
  final String dates;
  final String travellers;
  final String imageUrl;
  final bool isPrimary;

  _TripCardData({
    required this.name,
    required this.status,
    required this.dates,
    required this.travellers,
    required this.imageUrl,
    this.isPrimary = false,
  });
}
