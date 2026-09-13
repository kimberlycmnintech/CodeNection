import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/itinerary_trip_models.dart';

class AiNotebookScreen extends StatefulWidget {
  final TripFolderItem trip;
  final Function(String chatId)? onNavigateToChat;

  const AiNotebookScreen({
    super.key,
    required this.trip,
    this.onNavigateToChat,
  });

  @override
  State<AiNotebookScreen> createState() => _AiNotebookScreenState();
}

class _AiNotebookScreenState extends State<AiNotebookScreen> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';
  String _filterType = 'AI Notes';

  final List<_NotebookCategory> _categories = [
    _NotebookCategory(
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Trip Decisions',
      count: 6,
      subtitle: 'Key preferences and decisions from chat',
    ),
    _NotebookCategory(
      icon: Icons.place_outlined,
      title: 'Places We Mentioned',
      count: 4,
      subtitle: 'Attractions, areas and experiences',
    ),
    _NotebookCategory(
      icon: Icons.hotel_outlined,
      title: 'Budget & Stay',
      count: 3,
      subtitle: 'Accommodation and cost discussion',
    ),
    _NotebookCategory(
      icon: Icons.access_time_rounded,
      title: 'Schedule & Pace',
      count: 4,
      subtitle: 'Timing, duration and daily rhythm',
    ),
    _NotebookCategory(
      icon: Icons.restaurant_rounded,
      title: 'Food Ideas',
      count: 5,
      subtitle: 'Cuisines, food preferences, and notes',
    ),
    _NotebookCategory(
      icon: Icons.people_outline_rounded,
      title: 'Group Reminders',
      count: 2,
      subtitle: 'Things to confirm before the trip',
    ),
    _NotebookCategory(
      icon: Icons.star_outline_rounded,
      title: 'Inspiration',
      count: 3,
      subtitle: 'Random ideas and links',
    ),
  ];

  // 1. Trip Decisions
  late final List<_NotebookItem> _decisions = [
    _NotebookItem(
      id: 'd1',
      tag: 'Must Visit',
      tagBgColor: const Color(0xFFFCE7F3),
      tagTextColor: const Color(0xFFDB2777),
      title: 'TeamLab Borderless',
      description: 'Book morning tickets online in advance for Azabudai Hills.',
      author: 'Maya',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      date: '12 Sep 2026',
      isDestination: true,
      destinationAddress: 'Azabudai Hills Garden Plaza B B1F, Tokyo',
      estimatedCost: '¥4,200 (~RM130)',
      lat: 35.6606,
      lng: 139.7432,
      categoryIcon: '📍',
      categoryName: 'Must Visit',
    ),
    _NotebookItem(
      id: 'd2',
      tag: 'Walking Preference',
      tagBgColor: const Color(0xFFDCFCE7),
      tagTextColor: const Color(0xFF16A34A),
      title: 'Walking Limit: Max 15k steps/day',
      description: 'Take metro between distant hubs to avoid fatigue.',
      author: 'Sarah',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      date: '12 Sep 2026',
    ),
    _NotebookItem(
      id: 'd3',
      tag: 'Schedule',
      tagBgColor: const Color(0xFFE0F2FE),
      tagTextColor: const Color(0xFF0284C7),
      title: 'Late morning starts (~10:30 AM)',
      description: 'No rushing early mornings. Skip morning commute crowds.',
      author: 'You',
      authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
      date: '11 Sep 2026',
    ),
    _NotebookItem(
      id: 'd4',
      tag: 'Budget',
      tagBgColor: const Color(0xFFF3E8FF),
      tagTextColor: const Color(0xFF9333EA),
      title: 'Hotel budget ≤ RM250/night',
      description: 'Keep accommodation below RM250/night per person.',
      author: 'Daniel',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      date: '10 Sep 2026',
    ),
    _NotebookItem(
      id: 'd5',
      tag: 'Food Preference',
      tagBgColor: const Color(0xFFFFEDD5),
      tagTextColor: const Color(0xFFEA580C),
      title: 'Prefer local food over fine dining',
      description: 'Focus on street food, local ramen joints and kissaten cafes.',
      author: 'Maya',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      date: '10 Sep 2026',
    ),
    _NotebookItem(
      id: 'd6',
      tag: 'Neighbourhood',
      tagBgColor: const Color(0xFFEFF6FF),
      tagTextColor: const Color(0xFF2563EB),
      title: 'Stay around Shinjuku or Ginza',
      description: 'Central transit hubs with direct Yamanote Line access.',
      author: 'Daniel',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      date: '9 Sep 2026',
    ),
  ];

  // 2. Places We Mentioned
  late final List<_NotebookItem> _places = [
    _NotebookItem(
      id: 'p1',
      tag: 'Must Visit',
      tagBgColor: const Color(0xFFFCE7F3),
      tagTextColor: const Color(0xFFDB2777),
      title: 'TeamLab Borderless Digital Art Museum',
      description: 'Immersive light artwork with borderless rooms at Azabudai Hills.',
      author: 'Maya',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      date: '12 Sep 2026',
      isDestination: true,
      destinationAddress: 'Azabudai Hills Garden Plaza B B1F, Tokyo',
      estimatedCost: '¥4,200 (~RM130)',
      lat: 35.6606,
      lng: 139.7432,
      categoryIcon: '📍',
      categoryName: 'Must Visit',
    ),
    _NotebookItem(
      id: 'p2',
      tag: 'Observation Deck',
      tagBgColor: const Color(0xFFE0F2FE),
      tagTextColor: const Color(0xFF0284C7),
      title: 'Shibuya Sky Observation Deck',
      description: '360° open-air rooftop observatory at Shibuya Scramble Square. Recommended sunset slot (17:15).',
      author: 'Daniel',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      date: '11 Sep 2026',
      isDestination: true,
      destinationAddress: '2-24-12 Shibuya, Shibuya-ku, Tokyo',
      estimatedCost: '¥2,500 (~RM78)',
      lat: 35.6580,
      lng: 139.7016,
      categoryIcon: '🔭',
      categoryName: 'Sightseeing',
    ),
    _NotebookItem(
      id: 'p3',
      tag: 'Market & Food',
      tagBgColor: const Color(0xFFFFEDD5),
      tagTextColor: const Color(0xFFEA580C),
      title: 'Tsukiji Outer Market',
      description: 'Bustling market stalls serving fresh otoro tuna, tamagoyaki skewers, and matcha soft serve.',
      author: 'Sarah',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      date: '10 Sep 2026',
      isDestination: true,
      destinationAddress: '4-16-2 Tsukiji, Chuo-ku, Tokyo',
      estimatedCost: '¥2,000 (~RM62)',
      lat: 35.6655,
      lng: 139.7708,
      categoryIcon: '🐟',
      categoryName: 'Food & Cafés',
    ),
    _NotebookItem(
      id: 'p4',
      tag: 'Culture & Nature',
      tagBgColor: const Color(0xFFDCFCE7),
      tagTextColor: const Color(0xFF16A34A),
      title: 'Meiji Jingu Shrine & Yoyogi Forest',
      description: 'Tranquil forested sanctuary with ancient torii gates and scenic cedar walking trails.',
      author: 'You',
      authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
      date: '9 Sep 2026',
      isDestination: true,
      destinationAddress: '1-1 Yoyogikamizonocho, Shibuya-ku, Tokyo',
      estimatedCost: 'Free entry',
      lat: 35.6764,
      lng: 139.6993,
      categoryIcon: '⛩️',
      categoryName: 'Sightseeing',
    ),
  ];

  // 3. Budget & Stay
  late final List<_NotebookItem> _budgetNotes = [
    _NotebookItem(
      id: 'b1',
      tag: 'Accommodation',
      tagBgColor: const Color(0xFFF3E8FF),
      tagTextColor: const Color(0xFF9333EA),
      title: 'Hotel Budget Target: ≤ RM250/night',
      description: 'Agreed on modern boutique business hotels (e.g. Candeo or Sotetsu Fresa) with close metro walk.',
      author: 'Daniel',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      date: '10 Sep 2026',
    ),
    _NotebookItem(
      id: 'b2',
      tag: 'Transport Pass',
      tagBgColor: const Color(0xFFE0F2FE),
      tagTextColor: const Color(0xFF0284C7),
      title: 'Suica / Pasmo IC Card Budget: ¥5,000 (~RM155)',
      description: 'Load Apple Wallet or physical IC card for effortless subway tap-and-go rides across Tokyo.',
      author: 'Sarah',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      date: '9 Sep 2026',
    ),
    _NotebookItem(
      id: 'b3',
      tag: 'Group Splitting',
      tagBgColor: const Color(0xFFDCFCE7),
      tagTextColor: const Color(0xFF16A34A),
      title: 'Equal Split for Group Dinners & Taxis',
      description: 'Log shared izakaya feasts and late night cab fares in Splitwise; settle via Touch \'n Go eWallet / Wise.',
      author: 'Maya',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      date: '8 Sep 2026',
    ),
  ];

  // 4. Schedule & Pace
  late final List<_NotebookItem> _scheduleNotes = [
    _NotebookItem(
      id: 's1',
      tag: 'Daily Rhythm',
      tagBgColor: const Color(0xFFE0F2FE),
      tagTextColor: const Color(0xFF0284C7),
      title: 'Late Morning Departures (~10:30 AM)',
      description: 'Agreed unanimously in Tokyo Squad chat. Avoids rush hour commuter crush on the Yamanote line.',
      author: 'You',
      authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
      date: '11 Sep 2026',
    ),
    _NotebookItem(
      id: 's2',
      tag: 'Walking Cap',
      tagBgColor: const Color(0xFFDCFCE7),
      tagTextColor: const Color(0xFF16A34A),
      title: 'Max 15k Steps Daily + Afternoon Rest',
      description: 'Schedule a mandatory 45-min café rest stop around 15:00 before evening sightseeing.',
      author: 'Sarah',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      date: '10 Sep 2026',
    ),
    _NotebookItem(
      id: 's3',
      tag: 'Golden Hour',
      tagBgColor: const Color(0xFFFFEDD5),
      tagTextColor: const Color(0xFFEA580C),
      title: 'Sunset Timing Window (17:15 - 18:00)',
      description: 'Be at Shibuya Sky or Roppongi Hills by 16:45 PM for seamless golden hour into night skyline photos.',
      author: 'Daniel',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      date: '10 Sep 2026',
    ),
    _NotebookItem(
      id: 's4',
      tag: 'Night Curfew',
      tagBgColor: const Color(0xFFF3E8FF),
      tagTextColor: const Color(0xFF9333EA),
      title: 'Evening Wrap-Up by 22:30 PM',
      description: 'Wrap up izakaya drinks by 22:00 to comfortably board return trains before the midnight cut-off.',
      author: 'Maya',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      date: '9 Sep 2026',
    ),
  ];

  // 5. Food Ideas
  late final List<_NotebookItem> _foodNotes = [
    _NotebookItem(
      id: 'f1',
      tag: 'Ramen',
      tagBgColor: const Color(0xFFFFEDD5),
      tagTextColor: const Color(0xFFEA580C),
      title: 'ICHIRAN Ramen Shibuya',
      description: 'Famous tonkotsu broth with customizable rich dashi, spicy red pepper sauce, and solo flavor booths.',
      author: 'Maya',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      date: '12 Sep 2026',
      isDestination: true,
      destinationAddress: '1-22-7 Jinnan, Shibuya-ku, Tokyo',
      estimatedCost: '¥1,380 (~RM42)',
      lat: 35.6618,
      lng: 139.7006,
      categoryIcon: '🍜',
      categoryName: 'Food & Cafés',
    ),
    _NotebookItem(
      id: 'f2',
      tag: 'Specialty Café',
      tagBgColor: const Color(0xFFE0F2FE),
      tagTextColor: const Color(0xFF0284C7),
      title: 'Fuglen Tokyo (Yoyogi Park)',
      description: 'Oslo-style artisanal light roast pour-over coffee in a vintage mid-century Norwegian interior.',
      author: 'Daniel',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      date: '11 Sep 2026',
      isDestination: true,
      destinationAddress: '1-16-11 Tomigaya, Shibuya-ku, Tokyo',
      estimatedCost: '¥750 (~RM23)',
      lat: 35.6678,
      lng: 139.6912,
      categoryIcon: '☕',
      categoryName: 'Food & Cafés',
    ),
    _NotebookItem(
      id: 'f3',
      tag: 'Fresh Seafood',
      tagBgColor: const Color(0xFFDCFCE7),
      tagTextColor: const Color(0xFF16A34A),
      title: 'Tsukiji Donburi Senmon (Kaisen-don)',
      description: 'Abundant rice bowls overflowing with fatty bluefin tuna, Hokkaido sea urchin, and sweet salmon roe.',
      author: 'Sarah',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      date: '10 Sep 2026',
      isDestination: true,
      destinationAddress: '4-9-5 Tsukiji, Chuo-ku, Tokyo',
      estimatedCost: '¥2,800 (~RM86)',
      lat: 35.6650,
      lng: 139.7712,
      categoryIcon: '🍣',
      categoryName: 'Food & Cafés',
    ),
    _NotebookItem(
      id: 'f4',
      tag: 'Izakaya & Alley',
      tagBgColor: const Color(0xFFFCE7F3),
      tagTextColor: const Color(0xFFDB2777),
      title: 'Omoide Yokocho (Memory Lane)',
      description: 'Atmospheric lantern-lit alley in Shinjuku serving charcoal yakitori skewers and highballs.',
      author: 'You',
      authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
      date: '10 Sep 2026',
      isDestination: true,
      destinationAddress: '1-2 Nishi-Shinjuku, Shinjuku-ku, Tokyo',
      estimatedCost: '¥2,500 (~RM77)',
      lat: 35.6932,
      lng: 139.6997,
      categoryIcon: '🍢',
      categoryName: 'Food & Cafés',
    ),
    _NotebookItem(
      id: 'f5',
      tag: 'Street Dessert',
      tagBgColor: const Color(0xFFF3E8FF),
      tagTextColor: const Color(0xFF9333EA),
      title: 'Marion Crêpes Harajuku',
      description: 'Takeshita Street staple serving warm crêpes loaded with matcha gelato, strawberries, and custard.',
      author: 'Maya',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      date: '9 Sep 2026',
      isDestination: true,
      destinationAddress: '1-6-15 Jingumae, Shibuya-ku, Tokyo',
      estimatedCost: '¥680 (~RM21)',
      lat: 35.6712,
      lng: 139.7048,
      categoryIcon: '🥞',
      categoryName: 'Food & Cafés',
    ),
  ];

  // 6. Group Reminders
  late final List<_NotebookItem> _reminderNotes = [
    _NotebookItem(
      id: 'r1',
      tag: 'Immigration QR',
      tagBgColor: const Color(0xFFFCE7F3),
      tagTextColor: const Color(0xFFDB2777),
      title: 'Complete Visit Japan Web Online',
      description: 'Register customs declaration and immigration QR codes 24 hours before flight for expedited terminal arrival.',
      author: 'Daniel',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      date: '11 Sep 2026',
    ),
    _NotebookItem(
      id: 'r2',
      tag: 'Hardware & Tech',
      tagBgColor: const Color(0xFFE0F2FE),
      tagTextColor: const Color(0xFF0284C7),
      title: 'Bring Type A 2-Pin Power Adapters & eSIMs',
      description: 'Japan uses two flat parallel pins (100V). Confirm eSIM installation with Airalo / Ubigi before landing.',
      author: 'Sarah',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      date: '10 Sep 2026',
    ),
  ];

  // 7. Inspiration
  late final List<_NotebookItem> _inspirationNotes = [
    _NotebookItem(
      id: 'i1',
      tag: 'Travel Guide',
      tagBgColor: const Color(0xFFEFF6FF),
      tagTextColor: const Color(0xFF2563EB),
      title: 'The Monocle Tokyo Pocket Architecture Guide',
      description: 'Curated architectural route through Daikanyama T-Site, Omotesando Hills, and Nezu Museum.',
      author: 'You',
      authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
      date: '12 Sep 2026',
    ),
    _NotebookItem(
      id: 'i2',
      tag: 'Vintage & Vinyl',
      tagBgColor: const Color(0xFFFFEDD5),
      tagTextColor: const Color(0xFFEA580C),
      title: 'Shimokitazawa Vintage & Jazz Kissa Route',
      description: 'Afternoon thrift shopping in Setagaya followed by vintage analog jazz records at Lion Kissa.',
      author: 'Daniel',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      date: '10 Sep 2026',
    ),
    _NotebookItem(
      id: 'i3',
      tag: 'Photography Style',
      tagBgColor: const Color(0xFFF3E8FF),
      tagTextColor: const Color(0xFF9333EA),
      title: 'Outfit Aesthetic for TeamLab Borderless',
      description: 'Wear clean solid white or pale monochrome clothing for stunning light projection reflections.',
      author: 'Maya',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      date: '9 Sep 2026',
    ),
  ];

  List<_NotebookItem> get _activeCategoryItems {
    switch (_selectedCategoryIndex) {
      case 0:
        return _decisions;
      case 1:
        return _places;
      case 2:
        return _budgetNotes;
      case 3:
        return _scheduleNotes;
      case 4:
        return _foodNotes;
      case 5:
        return _reminderNotes;
      case 6:
        return _inspirationNotes;
      default:
        return _decisions;
    }
  }

  bool _isInItinerary(String title) {
    final lowerTitle = title.toLowerCase();
    for (final day in widget.trip.days) {
      for (final stop in day.stops) {
        final stopName = stop.name.toLowerCase();
        if (stopName.contains(lowerTitle) || lowerTitle.contains(stopName)) {
          return true;
        }
      }
    }
    return false;
  }

  void _showAddToItineraryDialog(_NotebookItem item) {
    int selectedDayIdx = 1; // Default to Day 2
    if (selectedDayIdx >= widget.trip.days.length) {
      selectedDayIdx = 0;
    }
    String timeSlot = '15:30';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
            22,
            16,
            22,
            MediaQuery.of(context).viewInsets.bottom + 26,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pull Handle
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Title & Icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add_location_alt_rounded, color: Color(0xFF2563EB), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add to Itinerary',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          item.title,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Destination Details Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF64748B)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.destinationAddress ?? 'Tokyo, Japan',
                        style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF475569)),
                      ),
                    ),
                    if (item.estimatedCost != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Text(
                          item.estimatedCost!,
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Select Itinerary Day
              Text(
                'Select Day in ${widget.trip.name}:',
                style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(widget.trip.days.length, (idx) {
                    final day = widget.trip.days[idx];
                    final isSel = selectedDayIdx == idx;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        selected: isSel,
                        onSelected: (val) {
                          if (val) setModalState(() => selectedDayIdx = idx);
                        },
                        label: Text('Day ${day.dayNumber}: ${day.date}'),
                        selectedColor: const Color(0xFF2563EB),
                        labelStyle: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                          color: isSel ? Colors.white : const Color(0xFF334155),
                        ),
                        backgroundColor: const Color(0xFFF1F5F9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // Preferred Time Slot
              Text(
                'Preferred Time Slot:',
                style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['11:00 AM', '13:30 PM', '15:30 PM', '17:30 PM', '19:30 PM'].map((t) {
                  final isSel = timeSlot == t;
                  return ChoiceChip(
                    selected: isSel,
                    onSelected: (val) {
                      if (val) setModalState(() => timeSlot = t);
                    },
                    label: Text(t),
                    selectedColor: const Color(0xFF0F172A),
                    labelStyle: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                      color: isSel ? Colors.white : const Color(0xFF475569),
                    ),
                    backgroundColor: const Color(0xFFF8FAFC),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Confirm Action Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _executeAddToItinerary(item, selectedDayIdx, timeSlot);
                  },
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                  label: Text(
                    'Confirm & Add to Day ${selectedDayIdx + 1}',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 13.5),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _executeAddToItinerary(_NotebookItem item, int dayIndex, String time) {
    final newStop = ItineraryPlaceStop(
      id: 'stop_${DateTime.now().millisecondsSinceEpoch}',
      time: time,
      name: item.title,
      category: item.categoryName ?? item.tag,
      categoryIcon: item.categoryIcon ?? '📍',
      address: item.destinationAddress ?? '${item.title}, Tokyo, Japan',
      description: item.description,
      duration: '1.5 hours',
      estimatedCost: item.estimatedCost ?? '¥1,500 (~RM46)',
      distanceToNext: 'Flexible route link',
      travelMethod: 'Direct transit',
      rating: 4.8,
      reviewCount: 9600,
      whyRecommended: 'Saved from group discussion in AI Notebook: "${item.description}"',
      googleMapsUrl: 'https://maps.google.com/?q=${Uri.encodeComponent(item.title)}+Tokyo',
      lat: item.lat ?? 35.6580,
      lng: item.lng ?? 139.7016,
    );

    setState(() {
      if (dayIndex < widget.trip.days.length) {
        widget.trip.days[dayIndex].stops.add(newStop);
        widget.trip.placesCount += 1;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '🎉 Added "${item.title}" to Day ${dayIndex + 1} Itinerary!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'View Itinerary',
          textColor: const Color(0xFF60A5FA),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Notebook',
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                fontSize: 22,
                color: const Color(0xFF0F172A),
              ),
            ),
            Text(
              'Keep your ideas, travel research, and AI insights all in one place.',
              style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B)),
            ),
          ],
        ),
        actions: [
          // -----------------------------------------------------------------
          // 1. GROUP CHAT BUTTON: DIRECTS USER TO RELATED GROUP CHAT
          // -----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: OutlinedButton.icon(
              onPressed: () {
                if (widget.onNavigateToChat != null) {
                  Navigator.pop(context);
                  widget.onNavigateToChat!(widget.trip.chatId);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening ${widget.trip.chatName} group chat...'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFF0F172A),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.forum_rounded, size: 16, color: Color(0xFF2563EB)),
              label: Text(
                '${widget.trip.chatName} Chat',
                style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 12, color: const Color(0xFF2563EB)),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFEFF6FF),
                side: const BorderSide(color: Color(0xFFBFDBFE)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 2. NEW NOTE BUTTON
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Add new note...'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Color(0xFF0F172A),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 16),
              label: Text('New Note', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12)),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Search & Filter Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 18, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (v) => setState(() => _searchQuery = v),
                            decoration: InputDecoration(
                              hintText: 'Search notes in ${_categories[_selectedCategoryIndex].title}...',
                              hintStyle: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _filterType,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFF475569)),
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                      items: const [
                        DropdownMenuItem(value: 'AI Notes', child: Text('AI Notes')),
                        DropdownMenuItem(value: 'Group Chat', child: Text('Group Chat')),
                        DropdownMenuItem(value: 'Saved Links', child: Text('Saved Links')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _filterType = v);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Main 2-Column Responsive Body
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 850;

                if (isDesktop) {
                  return Row(
                    children: [
                      // Left Sidebar Categories (Width 290)
                      SizedBox(
                        width: 290,
                        child: _buildCategorySidebar(),
                      ),
                      const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),

                      // Right Main Content Panel (Dynamically updates for each category)
                      Expanded(
                        child: _buildMainContentPanel(),
                      ),
                    ],
                  );
                }

                // Tablet / Mobile View
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 230, child: _buildCategorySidebar()),
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      _buildMainContentPanel(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Left Sidebar Category List
  Widget _buildCategorySidebar() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategoryIndex == index;

          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? const Color(0xFF2563EB).withValues(alpha: 0.35) : Colors.transparent,
                width: 1.2,
              ),
            ),
            child: ListTile(
              onTap: () => setState(() {
                _selectedCategoryIndex = index;
                _searchQuery = '';
              }),
              dense: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              leading: Icon(cat.icon, size: 20, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      cat.title,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                        color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF334155),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${cat.count} notes',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                cat.subtitle,
                style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Right Main Content Panel (AI Summary + Category-Specific Notes + Itinerary Actions)
  Widget _buildMainContentPanel() {
    final currentCategory = _categories[_selectedCategoryIndex];
    final items = _activeCategoryItems;

    final filtered = items.where((d) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return d.title.toLowerCase().contains(q) ||
          d.description.toLowerCase().contains(q) ||
          d.tag.toLowerCase().contains(q);
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(currentCategory.icon, size: 22, color: const Color(0xFF0F172A)),
                const SizedBox(width: 8),
                Text(
                  currentCategory.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // Quick Group Chat Jump
                OutlinedButton.icon(
                  onPressed: () {
                    if (widget.onNavigateToChat != null) {
                      Navigator.pop(context);
                      widget.onNavigateToChat!(widget.trip.chatId);
                    }
                  },
                  icon: const Icon(Icons.forum_outlined, size: 14, color: Color(0xFF2563EB)),
                  label: Text('Group Chat', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF2563EB))),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    side: const BorderSide(color: Color(0xFF93C5FD)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('✨ AI is analyzing ${currentCategory.title} notes...')),
                    );
                  },
                  icon: const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF2563EB)),
                  label: Text('Ask AI', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF2563EB))),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    side: const BorderSide(color: Color(0xFF2563EB)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ],
        ),
        Text(
          currentCategory.subtitle,
          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
        ),
        const SizedBox(height: 16),

        // AI Summary Banner Card (Category tailored)
        _buildDynamicAiSummaryBanner(),
        const SizedBox(height: 16),

        // Category Notes List
        if (filtered.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            child: Text(
              'No notes match "$_searchQuery".',
              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
            ),
          )
        else
          for (final item in filtered) ...[
            _buildNoteCard(item),
            const SizedBox(height: 10),
          ],

        const SizedBox(height: 16),

        // Bottom Banner Card: Generate Itinerary from Notes
        Container(
          padding: const EdgeInsets.all(16),
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
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.map_outlined, size: 22, color: Color(0xFF2563EB)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Generate Itinerary from Notes',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Let TripNest AI turn these notes into a personalized itinerary.',
                      style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✨ Generating updated itinerary from notes...'),
                      backgroundColor: Color(0xFF0F172A),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: Text('Generate Itinerary', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12)),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicAiSummaryBanner() {
    String summaryText;
    List<String> pills;

    switch (_selectedCategoryIndex) {
      case 0:
        summaryText =
            'We found 6 key decisions from your chat. You prefer a mix of popular attractions and local food, a relaxed pace with late morning starts, and a hotel budget under RM250/night.';
        pills = ['6 decisions', '3 contributors', 'Covers places, food, budget, schedule'];
        break;
      case 1:
        summaryText =
            '4 priority destinations discovered in Tokyo Squad chat. Tap "Add to Itinerary" on any attraction to seamlessly insert it into your daily schedule!';
        pills = ['4 attractions', '2 already in itinerary', '2 available to add'];
        break;
      case 2:
        summaryText =
            'Group consensus: maintain accommodation costs ≤ RM250/night, allocate ~¥5,000 for local metro IC cards, and settle dinners equally via Touch \'n Go eWallet.';
        pills = ['≤ RM250/night stay', '¥5,000 transit budget', 'Equal dinner split'];
        break;
      case 3:
        summaryText =
            'Relaxed pacing model enabled: late 10:30 AM starts to avoid Tokyo commuter crowds, a 15,000 daily walking limit, and a dedicated sunset slot at Shibuya Sky.';
        pills = ['10:30 AM starts', 'Max 15k steps/day', '17:15 Sunset window'];
        break;
      case 4:
        summaryText =
            '5 foodie favorites highlighted by Maya & Sarah: ICHIRAN solo booths, Fuglen pour-over coffee, fresh Tsukiji otoro rice bowls, Omoide Yokocho yakitori, and Harajuku crêpes.';
        pills = ['5 food spots', 'Ramen & Kaisen-don', 'Kissaten & Street eats'];
        break;
      case 5:
        summaryText =
            'Pre-departure checklist: Register Visit Japan Web immigration QR codes at least 24h prior, and ensure everyone packs Type A 2-pin power adapters.';
        pills = ['Visit Japan Web QR', 'Type A Adapters', 'eSIM Active'];
        break;
      case 6:
        summaryText =
            'Visual inspiration & neighborhood bookmarks: The Monocle Tokyo architectural route, Shimokitazawa vintage vinyl record bars, and light monochrome outfits for TeamLab.';
        pills = ['Monocle Guide', 'Shimokitazawa Vinyl', 'Photo outfit tips'];
        break;
      default:
        summaryText = 'Smart insights compiled from group chat.';
        pills = ['AI synchronized'];
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, size: 18, color: Color(0xFF2563EB)),
                  const SizedBox(width: 8),
                  Text(
                    'AI Summary',
                    style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w800, color: const Color(0xFF2563EB)),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✨ Regenerating AI summary with latest chat context...')),
                  );
                },
                icon: const Icon(Icons.refresh, size: 13, color: Color(0xFF2563EB)),
                label: Text('Regenerate', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF2563EB))),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  side: const BorderSide(color: Color(0xFF93C5FD)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            summaryText,
            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF334155), height: 1.4),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: pills.map((p) => _buildSummaryTagPill(p)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTagPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600, color: const Color(0xFF2563EB)),
      ),
    );
  }

  /// Individual Note Card with author meta and destination action buttons
  Widget _buildNoteCard(_NotebookItem item) {
    final bool isAdded = item.isDestination && _isInItinerary(item.title);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tag Badge Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: item.tagBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.tag,
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: item.tagTextColor),
                ),
              ),
              const SizedBox(width: 14),

              // Main Title & Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.description,
                      style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B), height: 1.35),
                    ),
                    if (item.destinationAddress != null) ...[
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.pin_drop_outlined, size: 13, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.destinationAddress!,
                              style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Author Meta & Menu
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(item.authorAvatar),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'by ${item.author}',
                        style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFF475569)),
                      ),
                      Text(
                        item.date,
                        style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.more_vert, size: 16, color: Color(0xFF94A3B8)),
                ],
              ),
            ],
          ),

          // -----------------------------------------------------------------
          // ADD DESTINATION INTO ITINERARY ACTION BAR
          // -----------------------------------------------------------------
          if (item.isDestination) ...[
            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (item.estimatedCost != null)
                  Text(
                    '💰 ${item.estimatedCost}',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF64748B)),
                  )
                else
                  const SizedBox.shrink(),

                if (isAdded)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF16A34A)),
                        const SizedBox(width: 5),
                        Text(
                          'In Itinerary',
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF15803D)),
                        ),
                      ],
                    ),
                  )
                else
                  FilledButton.icon(
                    onPressed: () => _showAddToItineraryDialog(item),
                    icon: const Icon(Icons.add_location_alt_outlined, size: 14),
                    label: Text('Add to Itinerary', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold)),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _NotebookCategory {
  final IconData icon;
  final String title;
  final int count;
  final String subtitle;

  _NotebookCategory({
    required this.icon,
    required this.title,
    required this.count,
    required this.subtitle,
  });
}

class _NotebookItem {
  final String id;
  final String tag;
  final Color tagBgColor;
  final Color tagTextColor;
  final String title;
  final String description;
  final String author;
  final String authorAvatar;
  final String date;
  final bool isDestination;
  final String? destinationAddress;
  final String? estimatedCost;
  final double? lat;
  final double? lng;
  final String? categoryIcon;
  final String? categoryName;

  _NotebookItem({
    required this.id,
    required this.tag,
    required this.tagBgColor,
    required this.tagTextColor,
    required this.title,
    required this.description,
    required this.author,
    required this.authorAvatar,
    required this.date,
    this.isDestination = false,
    this.destinationAddress,
    this.estimatedCost,
    this.lat,
    this.lng,
    this.categoryIcon,
    this.categoryName,
  });
}
