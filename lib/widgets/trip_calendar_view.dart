import 'package:flutter/material.dart';
import '../models/itinerary_trip_models.dart';
import '../theme.dart';

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
  TripFolderItem? selectedTrip;
  DateTime? selectedDate;

  final List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    // Default to November 2026 where Tokyo Adventure takes place
    currentMonth = DateTime(2026, 11, 1);
    selectedTrip = widget.trips.isNotEmpty ? widget.trips.first : null;
    selectedDate = DateTime(2026, 11, 12);
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

  bool _isTripOnDate(TripFolderItem trip, DateTime date) {
    final cleanDate = DateTime(date.year, date.month, date.day);
    final cleanStart = DateTime(trip.startDateTime.year, trip.startDateTime.month, trip.startDateTime.day);
    final cleanEnd = DateTime(trip.endDateTime.year, trip.endDateTime.month, trip.endDateTime.day);
    return !cleanDate.isBefore(cleanStart) && !cleanDate.isAfter(cleanEnd);
  }

  List<TripFolderItem> _getTripsForDate(DateTime date) {
    return widget.trips.where((t) => _isTripOnDate(t, date)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);
    final firstDayOffset = DateTime(currentMonth.year, currentMonth.month, 1).weekday % 7; // Sunday = 0

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;

        return isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Calendar Grid (60%)
                  Expanded(
                    flex: 6,
                    child: _buildCalendarCard(daysInMonth, firstDayOffset),
                  ),
                  const SizedBox(width: 18),
                  // Right Trip Schedule Detail (40%)
                  Expanded(
                    flex: 4,
                    child: _buildSideScheduleCard(),
                  ),
                ],
              )
            : Column(
                children: [
                  _buildCalendarCard(daysInMonth, firstDayOffset),
                  const SizedBox(height: 16),
                  _buildSideScheduleCard(),
                ],
              );
      },
    );
  }

  Widget _buildCalendarCard(int daysInMonth, int firstDayOffset) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month Header & Navigation Controls
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: coral.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calendar_month, color: coral, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${monthNames[currentMonth.month - 1]} ${currentMonth.year}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const Text(
                    'All scheduled trip journeys & dates',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const Spacer(),
              IconButton.outlined(
                icon: const Icon(Icons.chevron_left, size: 18),
                visualDensity: VisualDensity.compact,
                tooltip: 'Previous month',
                onPressed: _previousMonth,
              ),
              const SizedBox(width: 6),
              IconButton.outlined(
                icon: const Icon(Icons.chevron_right, size: 18),
                visualDensity: VisualDensity.compact,
                tooltip: 'Next month',
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 16),

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
          const Divider(height: 16, color: Color(0xFFE2E8F0)),

          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42, // 6 weeks * 7 days
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - firstDayOffset + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(currentMonth.year, currentMonth.month, dayNumber);
              final tripsOnDate = _getTripsForDate(date);
              final hasTrips = tripsOnDate.isNotEmpty;
              final isSelected = selectedDate != null &&
                  selectedDate!.year == date.year &&
                  selectedDate!.month == date.month &&
                  selectedDate!.day == date.day;

              return InkWell(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                    if (hasTrips) {
                      selectedTrip = tripsOnDate.first;
                    }
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  margin: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0F172A)
                        : hasTrips
                            ? (tripsOnDate.first.themeColor.withValues(alpha: 0.12))
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF0F172A)
                          : hasTrips
                              ? tripsOnDate.first.themeColor.withValues(alpha: 0.5)
                              : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNumber',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: (hasTrips || isSelected) ? FontWeight.w900 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : hasTrips
                                  ? tripsOnDate.first.themeColor
                                  : const Color(0xFF334155),
                        ),
                      ),
                      if (hasTrips) ...[
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: tripsOnDate.take(2).map((t) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1.5),
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : t.themeColor,
                                shape: BoxShape.circle,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Trip Color Legend
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: widget.trips.map((t) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(color: t.themeColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${t.name} (${t.startDate} - ${t.endDate})',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF475569), fontWeight: FontWeight.w600),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSideScheduleCard() {
    final activeTrip = selectedTrip ?? (widget.trips.isNotEmpty ? widget.trips.first : null);

    if (activeTrip == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Center(
          child: Text('Select a date on the calendar to view its trip details.'),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: activeTrip.themeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('🪺', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 8),
              const Text(
                'FOLDER SCHEDULE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.6,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${activeTrip.days.length} Days',
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Trip Name & Destination
          Text(
            activeTrip.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: coral),
              const SizedBox(width: 4),
              Text(
                activeTrip.destination,
                style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569), fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Dates banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 13, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Text(
                  '${activeTrip.startDate} – ${activeTrip.endDate}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const Spacer(),
                Text(
                  '${activeTrip.placesCount} Places',
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Travellers Preview
          const Text(
            'Flock Members',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: activeTrip.travellers.map((traveller) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: traveller.avatarColor,
                      child: Text(
                        traveller.avatarLetter,
                        style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      traveller.name,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Connected Chat link & Notebook status
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: coral.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                const Icon(Icons.forum_outlined, size: 16, color: coral),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Chat: ${activeTrip.chatName}',
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF9A3412)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '🪺 ${activeTrip.notebookDecisionsCount} decisions',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: coral),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action: Open Complete Trip Itinerary
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => widget.onOpenTrip(activeTrip),
              icon: const Icon(Icons.folder_open, size: 16),
              label: const Text('Open Itinerary Workspace', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
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
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }
}
