import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/itinerary_trip_models.dart';
import '../theme.dart';

class JournalEntryData {
  final DateTime date;
  final int dayNumber;
  final String text;
  final String moodEmoji;
  final String moodLabel;
  final String imageUrl;

  JournalEntryData({
    required this.date,
    required this.dayNumber,
    required this.text,
    required this.moodEmoji,
    required this.moodLabel,
    required this.imageUrl,
  });
}

class TripCalendarView extends StatefulWidget {
  final List<TripFolderItem> trips;
  final Function(TripFolderItem trip) onOpenTrip;

  const TripCalendarView({
    super.key,
    required this.trips,
    required this.onOpenTrip,
  });

  @override
  State<TripCalendarView> createState() => _TripCalendarViewState();
}

class _TripCalendarViewState extends State<TripCalendarView> {
  late DateTime currentMonth;
  late TripFolderItem activeTrip;
  late DateTime selectedLogDate;
  String selectedMood = 'Loved it';
  
  final TextEditingController _reflectionController = TextEditingController(
    text: 'Loved the food tour today, but we walked more than expected.',
  );

  int nestPoints = 420;
  int streakDays = 3;
  bool showAiNotice = true;

  String? _attachedImageUrl = 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=600';

  final List<Map<String, String>> _sampleTripPhotos = [
    {
      'label': 'Tokyo Nightscape',
      'url': 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=600',
    },
    {
      'label': 'Shibuya Crossing',
      'url': 'https://images.unsplash.com/photo-1542051841857-5f90071e7989?w=600',
    },
    {
      'label': 'Senso-ji Temple',
      'url': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=600',
    },
    {
      'label': 'Mount Fuji Peak',
      'url': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=600',
    },
    {
      'label': 'Santorini Blue',
      'url': 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=600',
    },
    {
      'label': 'Amalfi Coast',
      'url': 'https://images.unsplash.com/photo-1533105079780-92b9be482077?w=600',
    },
  ];

  final List<Map<String, String>> moodOptions = [
    {'emoji': '❤️', 'label': 'Loved it'},
    {'emoji': '😊', 'label': 'Relaxed'},
    {'emoji': '🤩', 'label': 'Excited'},
    {'emoji': '🧭', 'label': 'Adventurous'},
    {'emoji': '🌿', 'label': 'Peaceful'},
    {'emoji': '🥹', 'label': 'Grateful'},
    {'emoji': '😮‍💨', 'label': 'Too tired'},
    {'emoji': '😲', 'label': 'Surprised'},
  ];

  late List<JournalEntryData> journalEntries;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime(2026, 11, 1);
    activeTrip = widget.trips.firstWhere(
      (t) => t.id == 'trip_tokyo_2026',
      orElse: () => widget.trips.isNotEmpty ? widget.trips.first : TripRepository.getDemoTrips().first,
    );
    selectedLogDate = DateTime(2026, 11, 14); // Day 3

    journalEntries = [
      JournalEntryData(
        date: DateTime(2026, 11, 14),
        dayNumber: 3,
        text: 'Loved the food tour today, but we walked more than expected.',
        moodEmoji: '😲',
        moodLabel: 'Surprised',
        imageUrl: 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=400',
      ),
      JournalEntryData(
        date: DateTime(2026, 11, 13),
        dayNumber: 2,
        text: 'Amazing views from Shibuya Sky! Tokyo is even better at night.',
        moodEmoji: '😃',
        moodLabel: 'Loved it',
        imageUrl: 'https://images.unsplash.com/photo-1542051841857-5f90071e7989?w=400',
      ),
      JournalEntryData(
        date: DateTime(2026, 11, 12),
        dayNumber: 1,
        text: 'Arrived in Tokyo! Settled into our hotel and explored Shibuya izakayas.',
        moodEmoji: '😊',
        moodLabel: 'Relaxed',
        imageUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=400',
      ),
    ];
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
    });
  }

  void _saveLog() {
    final text = _reflectionController.text.trim();
    final dayNum = selectedLogDate.difference(activeTrip.startDateTime).inDays + 1;
    final emoji = moodOptions.firstWhere((m) => m['label'] == selectedMood)['emoji']!;

    setState(() {
      final existingIndex = journalEntries.indexWhere((e) =>
          e.date.year == selectedLogDate.year &&
          e.date.month == selectedLogDate.month &&
          e.date.day == selectedLogDate.day);

      final newEntry = JournalEntryData(
        date: selectedLogDate,
        dayNumber: dayNum > 0 ? dayNum : 1,
        text: text.isNotEmpty ? text : 'Logged memory: $selectedMood',
        moodEmoji: emoji,
        moodLabel: selectedMood,
        imageUrl: _attachedImageUrl ??
            activeTrip.coverImageUrl ??
            'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=600',
      );

      if (existingIndex >= 0) {
        journalEntries[existingIndex] = newEntry;
      } else {
        journalEntries.insert(0, newEntry);
        nestPoints += 20;
        if (dayNum > streakDays) {
          streakDays = dayNum;
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
                'Memory Saved for Day $dayNum! +20 Nest Points earned 🔥 (Streak: $streakDays days!)',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
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

  void _openAttachPhotoDialog() {
    final urlCtrl = TextEditingController(text: _attachedImageUrl ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add_photo_alternate_rounded, color: Color(0xFF2563EB), size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'Attach Photo to Memory',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose from trip album',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _sampleTripPhotos.map((photo) {
                    final isSelected = _attachedImageUrl == photo['url'];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _attachedImageUrl = photo['url'];
                        });
                        Navigator.pop(ctx);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0),
                            width: isSelected ? 2.5 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                              child: Image.network(
                                photo['url']!,
                                height: 70,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                photo['label']!,
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                Text(
                  'Or enter an image web link',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: urlCtrl,
                  decoration: InputDecoration(
                    hintText: 'https://...',
                    hintStyle: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
            onPressed: () {
              final link = urlCtrl.text.trim();
              if (link.isNotEmpty) {
                setState(() {
                  _attachedImageUrl = link;
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Attach'),
          ),
        ],
      ),
    );
  }

  void _openDatePickerModal() {
    showDialog(
      context: context,
      builder: (ctx) {
        final tripDaysCount = activeTrip.days.isNotEmpty
            ? activeTrip.days.length
            : (activeTrip.endDateTime.difference(activeTrip.startDateTime).inDays + 1).clamp(1, 14);

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Select Trip Day for Memory',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: SizedBox(
            width: 340,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(tripDaysCount, (index) {
              final day = activeTrip.startDateTime.add(Duration(days: index));
              final isSelected = selectedLogDate.day == day.day &&
                  selectedLogDate.month == day.month &&
                  selectedLogDate.year == day.year;

              return ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: isSelected ? const Color(0xFFEFF6FF) : null,
                leading: Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.calendar_today_rounded,
                  color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8),
                  size: 18,
                ),
                title: Text(
                  'Day ${index + 1} • Nov ${day.day}, 2026',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedLogDate = day;
                    final existing = journalEntries.cast<JournalEntryData?>().firstWhere(
                          (e) =>
                              e?.date.year == day.year &&
                              e?.date.month == day.month &&
                              e?.date.day == day.day,
                          orElse: () => null,
                        );
                    if (existing != null) {
                      _reflectionController.text = existing.text;
                      selectedMood = existing.moodLabel;
                      _attachedImageUrl = existing.imageUrl;
                    } else {
                      _reflectionController.text = '';
                      _attachedImageUrl = null;
                    }
                  });
                  Navigator.pop(ctx);
                },
                );
              }),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);
    final firstDayOffset = DateTime(currentMonth.year, currentMonth.month, 1).weekday % 7;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 920;

        return isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side: Calendar (60%)
                  Expanded(
                    flex: 6,
                    child: _buildCalendarCard(daysInMonth, firstDayOffset),
                  ),
                  const SizedBox(width: 20),

                  // Right Side: Ongoing Trip + Daily Travel Log + Rewards Card (40%)
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        _buildOngoingTripSummaryCard(),
                        const SizedBox(height: 18),
                        _buildMemoriesCard(),
                        const SizedBox(height: 18),
                        _buildTripJournalRewardsCard(),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  _buildOngoingTripSummaryCard(),
                  const SizedBox(height: 16),
                  _buildCalendarCard(daysInMonth, firstDayOffset),
                  const SizedBox(height: 16),
                  _buildMemoriesCard(),
                  const SizedBox(height: 16),
                  _buildTripJournalRewardsCard(),
                ],
              );
      },
    );
  }

  // ====================================================
  // 1. CALENDAR CARD (LEFT TOP)
  // ====================================================
  Widget _buildCalendarCard(int daysInMonth, int firstDayOffset) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calendar_month_rounded, color: Color(0xFFF43F5E), size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'November 2026',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'All scheduled trip journeys & dates',
                    style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B)),
                  ),
                ],
              ),
              const Spacer(),

              // Ongoing Trip Filter Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Ongoing Trip',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF64748B)),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Navigation Buttons
              IconButton.outlined(
                icon: const Icon(Icons.chevron_left, size: 18),
                visualDensity: VisualDensity.compact,
                onPressed: _previousMonth,
              ),
              const SizedBox(width: 4),
              IconButton.outlined(
                icon: const Icon(Icons.chevron_right, size: 18),
                visualDensity: VisualDensity.compact,
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Weekday Labels
          Row(
            children: const [
              _WeekdayHeader('Sun'),
              _WeekdayHeader('Mon'),
              _WeekdayHeader('Tue'),
              _WeekdayHeader('Wed'),
              _WeekdayHeader('Thu'),
              _WeekdayHeader('Fri'),
              _WeekdayHeader('Sat'),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFE2E8F0)),

          // Calendar Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - firstDayOffset + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(2026, 11, dayNumber);
              final isTripDay = dayNumber >= 12 && dayNumber <= 16;
              final tripDayNumber = isTripDay ? (dayNumber - 11) : null;

              final isSelectedDate = selectedLogDate.year == date.year &&
                  selectedLogDate.month == date.month &&
                  selectedLogDate.day == date.day;

              final hasLog = isTripDay && journalEntries.any(
                (e) => e.date.year == date.year &&
                       e.date.month == date.month &&
                       e.date.day == date.day &&
                       e.text.trim().isNotEmpty,
              );

              return InkWell(
                onTap: () {
                  setState(() {
                    selectedLogDate = date;
                    if (isTripDay) {
                      final foundEntry = journalEntries.firstWhere(
                        (e) => e.date.day == dayNumber,
                        orElse: () => JournalEntryData(
                          date: date,
                          dayNumber: tripDayNumber!,
                          text: '',
                          moodEmoji: '❤️',
                          moodLabel: 'Loved it',
                          imageUrl: '',
                        ),
                      );
                      _reflectionController.text = foundEntry.text;
                      selectedMood = foundEntry.moodLabel;
                    }
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: hasLog
                        ? const Color(0xFF0F172A)
                        : isTripDay
                            ? const Color(0xFFFFE4E6)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelectedDate
                          ? (hasLog ? const Color(0xFF38BDF8) : const Color(0xFF0F172A))
                          : isTripDay
                              ? (hasLog ? const Color(0xFF1E293B) : const Color(0xFFFDA4AF))
                              : Colors.transparent,
                      width: isSelectedDate ? 2.5 : 1.2,
                    ),
                    boxShadow: hasLog
                        ? [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.18),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNumber',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: isTripDay ? FontWeight.w800 : FontWeight.w500,
                          color: hasLog
                              ? Colors.white
                              : isTripDay
                                  ? const Color(0xFF9F1239)
                                  : const Color(0xFF334155),
                        ),
                      ),
                      if (isTripDay) ...[
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: hasLog ? const Color(0xFFFB7185) : const Color(0xFFE11D48),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'Day $tripDayNumber',
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: hasLog ? const Color(0xFFFDA4AF) : const Color(0xFFBE123C),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }



  // ====================================================
  // 3. ONGOING TRIP SUMMARY CARD (RIGHT TOP)
  // ====================================================
  Widget _buildOngoingTripSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Trip Image Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              activeTrip.coverImageUrl ?? activeTrip.mapPreviewUrl,
              width: 76,
              height: 76,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 76,
                height: 76,
                color: const Color(0xFFCBD5E1),
                child: const Icon(Icons.landscape, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Trip Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'ONGOING TRIP',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF059669),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  activeTrip.name,
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 13, color: coral),
                    const SizedBox(width: 3),
                    Text(
                      activeTrip.destination,
                      style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      '${activeTrip.startDate} – ${activeTrip.endDate}',
                      style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Flock Members Row
                Text(
                  'Flock Members',
                  style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Wrap(
                  spacing: 4,
                  children: activeTrip.travellers.map((traveller) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 7,
                          backgroundColor: traveller.avatarColor,
                          child: Text(
                            traveller.avatarLetter,
                            style: const TextStyle(fontSize: 7, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          traveller.name,
                          style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600, color: const Color(0xFF334155)),
                        ),
                        const SizedBox(width: 6),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Day Progress Ring Widget
          Column(
            children: [
              TextButton.icon(
                onPressed: () => widget.onOpenTrip(activeTrip),
                icon: const Icon(Icons.edit_outlined, size: 13, color: Color(0xFF64748B)),
                label: Text(
                  'Edit Trip',
                  style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B), fontWeight: FontWeight.w600),
                ),
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact, padding: EdgeInsets.zero),
              ),
              const SizedBox(height: 4),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      value: 3 / 5,
                      strokeWidth: 4,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Day 3',
                        style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A)),
                      ),
                      Text(
                        'of 5',
                        style: GoogleFonts.inter(fontSize: 9, color: const Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '3 days completed',
                style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ====================================================
  // 4. MEMORIES CARD (RIGHT MIDDLE - SAME AS PROFILE PAGE)
  // ====================================================
  Widget _buildMemoriesCard() {
    final dayNum = selectedLogDate.difference(activeTrip.startDateTime).inDays + 1;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Date Dropdown
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE7F3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.collections_rounded, color: Color(0xFFDB2777), size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                'Memories',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const Spacer(),

              // Date Dropdown Selector (Tap to switch trip day)
              InkWell(
                onTap: _openDatePickerModal,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF64748B)),
                      const SizedBox(width: 5),
                      Text(
                        'Nov ${selectedLogDate.day}, 2026 (Day ${dayNum > 0 ? dayNum : 1})',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 15, color: Color(0xFF64748B)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Horizontal "Recent Travel Memories" Gallery (Same as Profile Page)
          Text(
            'Recent Travel Memories',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),

          SizedBox(
            height: 145,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: journalEntries.length + 1,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                if (index == journalEntries.length) {
                  return _buildAddTripMemoryCard();
                }
                final entry = journalEntries[index];
                final isSelected = entry.date.day == selectedLogDate.day &&
                    entry.date.month == selectedLogDate.month;
                return _buildTripMemoryCard(entry, isSelected);
              },
            ),
          ),
          const SizedBox(height: 16),

          // Divider
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 14),

          // Mood Emoji Selector Label
          Text(
            'How did you feel today?',
            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          // Mood Emoji Chips Row (Food highlight removed, new feelings added)
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: moodOptions.map((mood) {
              final isSelected = selectedMood == mood['label'];
              return InkWell(
                onTap: () => setState(() => selectedMood = mood['label']!),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFECEB) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? coral : const Color(0xFFE2E8F0),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(mood['emoji']!, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 5),
                      Text(
                        mood['label']!,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? coral : const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Attach Picture Section (Choose to attach picture)
          _buildAttachedPictureSection(),
          const SizedBox(height: 14),

          // Reflection Textbox Label
          Text(
            'Write a short reflection (optional)',
            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),

          // Text Field Container
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _reflectionController,
                  maxLines: 3,
                  onChanged: (_) => setState(() {}),
                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF0F172A)),
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts, feelings, or trip highlights today...',
                    hintStyle: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 6),
                  child: Text(
                    '${_reflectionController.text.length}/500',
                    style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Save Memory Action Button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _saveLog,
              icon: const Icon(Icons.bookmark_added_rounded, size: 16),
              label: Text(
                'Save Memory',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripMemoryCard(JournalEntryData entry, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLogDate = entry.date;
          _reflectionController.text = entry.text;
          selectedMood = entry.moodLabel;
          _attachedImageUrl = entry.imageUrl;
        });
      },
      child: Container(
        width: 125,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                entry.imageUrl,
                height: 85,
                width: 125,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  height: 85,
                  color: const Color(0xFFCBD5E1),
                  child: const Icon(Icons.image, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Day ${entry.dayNumber} • Tokyo',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(entry.moodEmoji, style: const TextStyle(fontSize: 11)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Nov ${entry.date.day}',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
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
    );
  }

  Widget _buildAddTripMemoryCard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLogDate = DateTime(2026, 11, 15); // Day 4
          _reflectionController.text = '';
          selectedMood = 'Loved it';
          _attachedImageUrl = null;
        });
      },
      child: Container(
        width: 125,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, size: 20, color: Color(0xFF3B82F6)),
            ),
            const SizedBox(height: 8),
            Text(
              'Add Memory',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachedPictureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Memory Picture',
              style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B), fontWeight: FontWeight.w600),
            ),
            if (_attachedImageUrl != null)
              GestureDetector(
                onTap: () => setState(() => _attachedImageUrl = null),
                child: Text(
                  'Remove photo',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFFEF4444),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        if (_attachedImageUrl != null)
          Container(
            height: 105,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Image.network(
                    _attachedImageUrl!,
                    width: double.infinity,
                    height: 105,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: const Color(0xFFE2E8F0),
                      child: const Center(
                        child: Icon(Icons.broken_image_rounded, color: Color(0xFF94A3B8)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.photo_camera_rounded, size: 11, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'Photo Attached',
                          style: GoogleFonts.inter(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: InkWell(
                    onTap: _openAttachPhotoDialog,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.swap_horiz_rounded, size: 13, color: Color(0xFF0F172A)),
                          const SizedBox(width: 4),
                          Text(
                            'Change Photo',
                            style: GoogleFonts.inter(
                              fontSize: 11,
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
          )
        else
          InkWell(
            onTap: _openAttachPhotoDialog,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_a_photo_outlined, size: 18, color: Color(0xFF3B82F6)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attach a picture for this memory',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Choose from trip photos or paste an image URL',
                          style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 18),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ====================================================
  // 5. MEMORIES REWARDS & STREAK CARD (RIGHT BOTTOM)
  // ====================================================
  Widget _buildTripJournalRewardsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Points Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.card_giftcard_rounded, color: Color(0xFFF97316), size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                'Memories Rewards',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const Spacer(),

              // Points Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFEDD5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.monetization_on_rounded, size: 14, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 4),
                    Text(
                      '$nestPoints Nest Points',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFC2410C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Streak Track & Points Bonus Box
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Streak Circles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department_rounded, size: 16, color: Color(0xFFEF4444)),
                        const SizedBox(width: 4),
                        Text(
                          '$streakDays-day streak',
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "You're on a roll! Keep sharing your journey.",
                      style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 12),

                    // Day Circles Line Tracker
                    Row(
                      children: List.generate(5, (index) {
                        final dayNum = index + 1;
                        final isCompleted = dayNum <= streakDays;
                        return Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: isCompleted ? const Color(0xFFF43F5E) : const Color(0xFFF1F5F9),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isCompleted ? const Color(0xFFF43F5E) : const Color(0xFFCBD5E1),
                                  ),
                                ),
                                child: Center(
                                  child: isCompleted
                                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Day $dayNum',
                                style: GoogleFonts.inter(
                                  fontSize: 9.5,
                                  fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                                  color: isCompleted ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Right: Points Box
              Container(
                width: 130,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '+20 points today',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Complete all 5 days to earn +120 bonus points',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: const Color(0xFF64748B),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // AI Algorithm Learning Banner
          if (showAiNotice) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Your travel reflections help TripNest learn your preferences and improve future trip suggestions.',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF1E40AF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() => showAiNotice = false),
                    child: const Icon(Icons.close, size: 14, color: Color(0xFF1E40AF)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  final String text;
  const _WeekdayHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }
}
