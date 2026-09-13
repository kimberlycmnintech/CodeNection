import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/itinerary_trip_models.dart';

class TravelMemoryItem {
  final int dayNumber;
  final String dateStr;
  final String destination;
  final String photoUrl;
  final String emoji;
  final String feelingLabel;
  final String reflection;
  final String heading;

  TravelMemoryItem({
    required this.dayNumber,
    required this.dateStr,
    required this.destination,
    required this.photoUrl,
    required this.emoji,
    required this.feelingLabel,
    required this.reflection,
    required this.heading,
  });
}

/// =========================================================================
/// 1. TRAVEL MEMORIES DIALOG (MATCHING PICTURE 1 EXACTLY, CENTER POPUP)
/// =========================================================================
class TravelMemoriesDialog extends StatefulWidget {
  final TripFolderItem trip;
  final int initialDayIndex;

  const TravelMemoriesDialog({
    super.key,
    required this.trip,
    this.initialDayIndex = 3, // Default to Day 4 in reference
  });

  @override
  State<TravelMemoriesDialog> createState() => _TravelMemoriesDialogState();
}

class _TravelMemoriesDialogState extends State<TravelMemoriesDialog> {
  late int _selectedDayNumber;
  late String _selectedDateLabel;
  int _selectedFeelingIndex = 0;
  final TextEditingController _reflectionController = TextEditingController();
  String? _attachedImageUrl;

  final List<Map<String, String>> _feelings = [
    {'emoji': '❤️', 'label': 'Loved it'},
    {'emoji': '😊', 'label': 'Relaxed'},
    {'emoji': '🤩', 'label': 'Excited'},
    {'emoji': '🧭', 'label': 'Adventurous'},
    {'emoji': '🌿', 'label': 'Peaceful'},
    {'emoji': '🥹', 'label': 'Grateful'},
    {'emoji': '😴', 'label': 'Too tired'},
    {'emoji': '😲', 'label': 'Surprised'},
  ];

  late List<TravelMemoryItem> _recentMemories;

  @override
  void initState() {
    super.initState();
    _selectedDayNumber = widget.initialDayIndex + 1;
    _selectedDateLabel = 'Nov 15, 2026 (Day 4)';

    _recentMemories = [
      TravelMemoryItem(
        dayNumber: 1,
        dateStr: 'Nov 12',
        destination: 'Tokyo',
        photoUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=600',
        emoji: '😊',
        feelingLabel: 'Peaceful',
        heading: 'Arrival & Autumn Pagoda Walk',
        reflection:
            'Arrived in Tokyo! Crisp autumn 18°C weather. We walked through historic cedar alleys and watched the golden dusk illuminate the pagodas. Ended with piping hot yakitori.',
      ),
      TravelMemoryItem(
        dayNumber: 2,
        dateStr: 'Nov 13',
        destination: 'Tokyo',
        photoUrl: 'https://images.unsplash.com/photo-1542051841857-5f90071e7989?w=600',
        emoji: '😃',
        feelingLabel: 'Loved it',
        heading: 'TeamLab Lights & Ginza Coffee',
        reflection:
            'TeamLab Azabudai Hills was pure magic! Wandering between endless crystal lights and floating tea flower rooms felt like a dream. Followed by rooftop pour-overs at Ginza Six.',
      ),
      TravelMemoryItem(
        dayNumber: 3,
        dateStr: 'Nov 14',
        destination: 'Tokyo',
        photoUrl: 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=600',
        emoji: '😲',
        feelingLabel: 'Surprised',
        heading: 'Neon Shinjuku & Midnight Ramen',
        reflection:
            'Hit 15,200 steps today! Shibuya Scramble from above was hypnotic. Slurped spicy tonkotsu ramen at Ichiran in our solo booths and walked through glowing lantern alleys in Omoide Yokocho.',
      ),
      TravelMemoryItem(
        dayNumber: 4,
        dateStr: 'Nov 15',
        destination: 'Tokyo',
        photoUrl: 'https://images.unsplash.com/photo-1536098561742-ca998e48cbcc?w=600',
        emoji: '🤩',
        feelingLabel: 'Excited',
        heading: 'Vintage Shimokita & Golden Gai',
        reflection:
            'Hunted rare vinyl in Shimokitazawa and found Daniel’s dream vintage camera. Ended the trip soaking in retro Tokyo nightlife under glowing paper lanterns.',
      ),
    ];
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  void _open3DBook({int? initialPage}) {
    int targetPage = 0;
    if (initialPage != null) {
      targetPage = initialPage;
    } else {
      final foundIdx = _recentMemories.indexWhere((m) => m.dayNumber == _selectedDayNumber);
      if (foundIdx != -1) targetPage = foundIdx;
    }

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.78),
      builder: (_) => TripMemories3DBookDialog(
        trip: widget.trip,
        memories: _recentMemories,
        initialPage: targetPage,
      ),
    );
  }

  void _attachImageDialog() {
    final urlController = TextEditingController();
    final presets = [
      'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=600',
      'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=600',
      'https://images.unsplash.com/photo-1542051841857-5f90071e7989?w=600',
      'https://images.unsplash.com/photo-1536098561742-ca998e48cbcc?w=600',
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Select Memory Picture', style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose from trip photo stream:', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: presets.map((url) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _attachedImageUrl = url);
                    Navigator.pop(ctx);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(url, width: 60, height: 60, fit: BoxFit.cover),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Or enter an image URL:', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
            const SizedBox(height: 6),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                hintText: 'https://...',
                hintStyle: GoogleFonts.inter(fontSize: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (urlController.text.trim().isNotEmpty) {
                setState(() => _attachedImageUrl = urlController.text.trim());
              }
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
            child: const Text('Attach'),
          ),
        ],
      ),
    );
  }

  void _saveMemory() {
    final feeling = _feelings[_selectedFeelingIndex];
    final text = _reflectionController.text.trim();

    final newMem = TravelMemoryItem(
      dayNumber: _selectedDayNumber,
      dateStr: 'Nov 15',
      destination: widget.trip.destination.split(',').first,
      photoUrl: _attachedImageUrl ??
          'https://images.unsplash.com/photo-1536098561742-ca998e48cbcc?w=600',
      emoji: feeling['emoji']!,
      feelingLabel: feeling['label']!,
      heading: 'Day $_selectedDayNumber Highlights',
      reflection: text.isNotEmpty
          ? text
          : 'Had a wonderful day exploring ${widget.trip.destination}! Feeling ${feeling['label']}.',
    );

    setState(() {
      _recentMemories.insert(0, newMem);
      _reflectionController.clear();
      _attachedImageUrl = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.auto_stories_rounded, color: Color(0xFF38BDF8), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '🎉 Travel memory saved! Added to your 3D Trip Book.',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'Flip 3D Book',
          textColor: const Color(0xFF60A5FA),
          onPressed: () => _open3DBook(initialPage: 0),
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 730),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ----------------------------------------------------
                // 1. TOP HEADER: ICON + TITLE + DATE DROPDOWN + CLOSE
                // ----------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCE7F3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.photo_library_outlined,
                            size: 20,
                            color: Color(0xFFDB2777),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Memories',
                          style: GoogleFonts.inter(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        // Interactive 3D Book Quick Button
                        OutlinedButton.icon(
                          onPressed: () => _open3DBook(),
                          icon: const Icon(Icons.menu_book_rounded, size: 14, color: Color(0xFF2563EB)),
                          label: Text(
                            '3D Book',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF2563EB)),
                          ),
                          style: OutlinedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            backgroundColor: const Color(0xFFEFF6FF),
                            side: const BorderSide(color: Color(0xFFBFDBFE)),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Date dropdown selector pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFCBD5E1)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 13, color: Color(0xFF64748B)),
                              const SizedBox(width: 6),
                              Text(
                                _selectedDateLabel,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF334155),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF64748B)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20, color: Color(0xFF94A3B8)),
                          visualDensity: VisualDensity.compact,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // ----------------------------------------------------
                // 2. RECENT TRAVEL MEMORIES HORIZONTAL CARDS
                // ----------------------------------------------------
                Text(
                  'Recent Travel Memories',
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: 135,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (int i = 0; i < _recentMemories.length; i++) ...[
                        _buildRecentMemoryCard(_recentMemories[i], i),
                        const SizedBox(width: 12),
                      ],
                      _buildAddMemoryCard(),
                    ],
                  ),
                ),

                const SizedBox(height: 18),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 16),

                // ----------------------------------------------------
                // 3. HOW DID YOU FEEL TODAY? (MOOD PILLS)
                // ----------------------------------------------------
                Text(
                  'How did you feel today?',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_feelings.length, (i) {
                    final isSel = _selectedFeelingIndex == i;
                    final item = _feelings[i];

                    return InkWell(
                      onTap: () => setState(() => _selectedFeelingIndex = i),
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 140),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFFFFF1F2) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSel ? const Color(0xFFEF4444) : const Color(0xFFE2E8F0),
                            width: 1.2,
                          ),
                          boxShadow: isSel
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(item['emoji']!, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(
                              item['label']!,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                color: isSel ? const Color(0xFFE11D48) : const Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 18),

                // ----------------------------------------------------
                // 4. MEMORY PICTURE ATTACHMENT CARD
                // ----------------------------------------------------
                Text(
                  'Memory Picture',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 8),

                InkWell(
                  onTap: _attachImageDialog,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        if (_attachedImageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(_attachedImageUrl!, width: 42, height: 42, fit: BoxFit.cover),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(9),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEFF6FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add_a_photo_outlined, size: 18, color: Color(0xFF2563EB)),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _attachedImageUrl != null ? 'Picture attached' : 'Attach a picture for this memory',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _attachedImageUrl != null
                                    ? 'Tap to change photo'
                                    : 'Choose from trip photos or paste an image URL',
                                style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        if (_attachedImageUrl != null)
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF94A3B8)),
                            onPressed: () => setState(() => _attachedImageUrl = null),
                          )
                        else
                          const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF94A3B8)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ----------------------------------------------------
                // 5. WRITE A SHORT REFLECTION (OPTIONAL)
                // ----------------------------------------------------
                Text(
                  'Write a short reflection (optional)',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _reflectionController,
                        maxLines: 3,
                        maxLength: 500,
                        onChanged: (v) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Share your thoughts, feelings, or trip highlights today...',
                          hintStyle: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                          border: InputBorder.none,
                          counterText: '',
                          isDense: true,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${_reflectionController.text.length}/500',
                            style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ----------------------------------------------------
                // 6. SAVE MEMORY ACTION BUTTON
                // ----------------------------------------------------
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _saveMemory,
                    icon: const Icon(Icons.bookmark_added_rounded, size: 18, color: Colors.white),
                    label: Text(
                      'Save Memory',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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

  Widget _buildRecentMemoryCard(TravelMemoryItem mem, int index) {
    return GestureDetector(
      onTap: () => _open3DBook(initialPage: index),
      child: Container(
        width: 105,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 75,
              width: double.infinity,
              child: Image.network(
                mem.photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, st) => Container(color: const Color(0xFFE2E8F0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Day ${mem.dayNumber} • ${mem.destination}',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(mem.emoji, style: const TextStyle(fontSize: 11)),
                      const SizedBox(width: 4),
                      Text(
                        mem.dateStr,
                        style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B)),
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

  Widget _buildAddMemoryCard() {
    return GestureDetector(
      onTap: _attachImageDialog,
      child: Container(
        width: 105,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, size: 20, color: Color(0xFF2563EB)),
            ),
            const SizedBox(height: 8),
            Text(
              'Add Memory',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =========================================================================
/// 2. 3D OPEN BOOK DIALOG WITH AUTHENTIC SPREAD & REAL-TIME DRAG PAGE FLIP
/// =========================================================================
class TripMemories3DBookDialog extends StatefulWidget {
  final TripFolderItem trip;
  final List<TravelMemoryItem> memories;
  final int initialPage;

  const TripMemories3DBookDialog({
    super.key,
    required this.trip,
    required this.memories,
    this.initialPage = 0,
  });

  @override
  State<TripMemories3DBookDialog> createState() => _TripMemories3DBookDialogState();
}

class _TripMemories3DBookDialogState extends State<TripMemories3DBookDialog> with SingleTickerProviderStateMixin {
  late int _currentPage;
  late AnimationController _animController;
  late Animation<double> _flipAnimation;

  bool _isDragging = false;
  double _dragProgress = 0.0; // 0.0 to 1.0
  bool _isFlippingForward = true;
  double _dragStartX = 0.0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage.clamp(0, widget.memories.length - 1);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _flipAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    if (_animController.isAnimating) return;
    _dragStartX = details.localPosition.dx;
    _isDragging = true;
    _dragProgress = 0.0;
  }

  void _onDragUpdate(DragUpdateDetails details, double pageWidth) {
    if (_animController.isAnimating || !_isDragging) return;
    final deltaX = details.localPosition.dx - _dragStartX;

    if (deltaX < 0) {
      // Dragging left -> turning forward to next page
      if (_currentPage < widget.memories.length - 1) {
        setState(() {
          _isFlippingForward = true;
          _dragProgress = (-deltaX / pageWidth).clamp(0.0, 1.0);
        });
      }
    } else if (deltaX > 0) {
      // Dragging right -> turning backward to previous page
      if (_currentPage > 0) {
        setState(() {
          _isFlippingForward = false;
          _dragProgress = (deltaX / pageWidth).clamp(0.0, 1.0);
        });
      }
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_isDragging) return;
    _isDragging = false;

    final velocity = details.primaryVelocity ?? 0;
    final shouldComplete = _dragProgress > 0.35 || velocity.abs() > 300;

    if (shouldComplete && _dragProgress > 0.0) {
      final remaining = (1.0 - _dragProgress).clamp(0.0, 1.0);
      _animController.value = _dragProgress;
      _animController
          .animateTo(
            1.0,
            duration: Duration(milliseconds: (320 * remaining).round().clamp(120, 350)),
            curve: Curves.easeOutCubic,
          )
          .then((_) {
        setState(() {
          if (_isFlippingForward) {
            _currentPage = (_currentPage + 1).clamp(0, widget.memories.length - 1);
          } else {
            _currentPage = (_currentPage - 1).clamp(0, widget.memories.length - 1);
          }
          _dragProgress = 0.0;
          _animController.reset();
        });
      });
    } else {
      _animController.value = _dragProgress;
      _animController
          .animateBack(
            0.0,
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
          )
          .then((_) {
        setState(() {
          _dragProgress = 0.0;
          _animController.reset();
        });
      });
    }
  }

  void _turnPage(bool forward) {
    if (_animController.isAnimating || _isDragging) return;

    if (forward && _currentPage < widget.memories.length - 1) {
      setState(() {
        _isFlippingForward = true;
        _dragProgress = 0.0;
      });
      _animController.forward(from: 0.0).then((_) {
        setState(() {
          _currentPage++;
          _animController.reset();
        });
      });
    } else if (!forward && _currentPage > 0) {
      setState(() {
        _isFlippingForward = false;
        _dragProgress = 0.0;
      });
      _animController.forward(from: 0.0).then((_) {
        setState(() {
          _currentPage--;
          _animController.reset();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 640;
          final spreadWidth = isWide
              ? (constraints.maxWidth - 32).clamp(620.0, 780.0)
              : (constraints.maxWidth - 20).clamp(300.0, 420.0);
          final spreadHeight = isWide ? 490.0 : 520.0;
          final innerWidth = spreadWidth - 16;
          final pageWidth = isWide ? innerWidth / 2 : innerWidth;

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ----------------------------------------------------
                // FLOATING TOP BAR (Title, hint & close button)
                // ----------------------------------------------------
                SizedBox(
                  width: spreadWidth + 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.auto_stories_rounded, color: Color(0xFF38BDF8), size: 18),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trip Memory Book',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Drag page to flip with 3D depth',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: const Color(0xFFCBD5E1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.16),
                          shape: const CircleBorder(),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ----------------------------------------------------
                // AUTHENTIC OPEN BOOK WITH 3D TURNING SPREAD
                // ----------------------------------------------------
                GestureDetector(
                  onHorizontalDragStart: _onDragStart,
                  onHorizontalDragUpdate: (details) => _onDragUpdate(details, pageWidth),
                  onHorizontalDragEnd: _onDragEnd,
                  child: AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      final progress = _isDragging ? _dragProgress : _flipAnimation.value;
                      return isWide
                          ? _buildWideTwoPageBook(spreadWidth, spreadHeight, progress)
                          : _buildSinglePageBook(pageWidth, spreadHeight, progress);
                    },
                  ),
                ),

                const SizedBox(height: 18),

                // ----------------------------------------------------
                // FLOATING BOTTOM CONTROLS (Prev / Next & Spread Counter)
                // ----------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _currentPage > 0 ? () => _turnPage(false) : null,
                      icon: const Icon(Icons.arrow_back_rounded, size: 15),
                      label: const Text('Prev Page'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white24,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                        backgroundColor: Colors.black.withValues(alpha: 0.35),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                      ),
                      child: Text(
                        'Day ${widget.memories[_currentPage].dayNumber} (${_currentPage + 1} of ${widget.memories.length})',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    FilledButton.icon(
                      onPressed: _currentPage < widget.memories.length - 1 ? () => _turnPage(true) : null,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 15),
                      label: const Text('Next Page'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        disabledBackgroundColor: Colors.white12,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Builds the full two-page open book spread with spine crease and turning leaf
  Widget _buildWideTwoPageBook(double spreadWidth, double spreadHeight, double progress) {
    final pageWidth = (spreadWidth - 16) / 2;
    final currentMem = widget.memories[_currentPage];
    final totalMemories = widget.memories.length;
    final isTurning = progress > 0.0;

    return Container(
      width: spreadWidth,
      height: spreadHeight,
      decoration: BoxDecoration(
        // Hardcover book base: deep midnight navy leather with gold-rim stitching
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          // Soft ambient drop shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 40,
            offset: const Offset(0, 22),
          ),
          // Layered page stack edge effect
          const BoxShadow(
            color: Color(0xFFE5DDD3),
            blurRadius: 0,
            offset: Offset(0, 4),
          ),
          const BoxShadow(
            color: Color(0xFFD3C6B8),
            blurRadius: 0,
            offset: Offset(0, 7),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // ----------------------------------------------------
            // 1. UNDERNEATH BASE SPREAD (Left & Right Pages)
            // ----------------------------------------------------
            Row(
              children: [
                // Left half underneath
                Expanded(
                  child: SizedBox(
                    height: spreadHeight,
                    child: _buildLeftPage(
                      isTurning && !_isFlippingForward && _currentPage > 0
                          ? widget.memories[_currentPage - 1]
                          : currentMem,
                    ),
                  ),
                ),
                // Right half underneath
                Expanded(
                  child: SizedBox(
                    height: spreadHeight,
                    child: _buildRightPage(
                      isTurning && _isFlippingForward && _currentPage < widget.memories.length - 1
                          ? widget.memories[_currentPage + 1]
                          : currentMem,
                    ),
                  ),
                ),
              ],
            ),

            // ----------------------------------------------------
            // 2. CENTER SPINE CREASE SHADOW
            // ----------------------------------------------------
            Positioned(
              left: pageWidth - 16,
              top: 0,
              bottom: 0,
              width: 32,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.18),
                        Colors.black.withValues(alpha: 0.32),
                        Colors.black.withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ----------------------------------------------------
            // 3. 3D FLIPPING LEAF (Real-Time Rotating Around Spine)
            // ----------------------------------------------------
            if (isTurning) ...[
              if (_isFlippingForward && _currentPage < totalMemories - 1)
                _buildFlippingForwardLeaf(pageWidth, spreadHeight, progress),
              if (!_isFlippingForward && _currentPage > 0)
                _buildFlippingBackwardLeaf(pageWidth, spreadHeight, progress),
            ],
          ],
        ),
      ),
    );
  }

  /// 3D Flipping leaf turning forward (right page lifts and rotates to the left)
  Widget _buildFlippingForwardLeaf(double pageWidth, double pageHeight, double progress) {
    final currentMem = widget.memories[_currentPage];
    final nextMem = widget.memories[_currentPage + 1];
    final angle = -progress * math.pi;

    return Positioned(
      left: pageWidth,
      top: 0,
      width: pageWidth,
      height: pageHeight,
      child: Transform(
        alignment: Alignment.centerLeft,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0012)
          ..rotateY(angle),
        child: Stack(
          children: [
            if (angle.abs() < math.pi * 0.5) ...[
              // Front side of flipping page: current memory right page
              _buildRightPage(currentMem),
              // Dynamic darkening shadow as page lifts
              Container(
                color: Colors.black.withValues(
                  alpha: (math.sin(progress * math.pi) * 0.28).clamp(0.0, 0.4),
                ),
              ),
            ] else ...[
              // Back side of flipping page: next memory left page
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(math.pi),
                child: _buildLeftPage(nextMem),
              ),
              // Dynamic shadow as page lands on the left
              Container(
                color: Colors.black.withValues(
                  alpha: (math.sin(progress * math.pi) * 0.28).clamp(0.0, 0.4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 3D Flipping leaf turning backward (left page lifts and rotates to the right)
  Widget _buildFlippingBackwardLeaf(double pageWidth, double pageHeight, double progress) {
    final currentMem = widget.memories[_currentPage];
    final prevMem = widget.memories[_currentPage - 1];
    final angle = progress * math.pi;

    return Positioned(
      left: 0,
      top: 0,
      width: pageWidth,
      height: pageHeight,
      child: Transform(
        alignment: Alignment.centerRight,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0012)
          ..rotateY(angle),
        child: Stack(
          children: [
            if (angle < math.pi * 0.5) ...[
              // Front side: current memory left page
              _buildLeftPage(currentMem),
              Container(
                color: Colors.black.withValues(
                  alpha: (math.sin(progress * math.pi) * 0.28).clamp(0.0, 0.4),
                ),
              ),
            ] else ...[
              // Back side: previous memory right page
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(math.pi),
                child: _buildRightPage(prevMem),
              ),
              Container(
                color: Colors.black.withValues(
                  alpha: (math.sin(progress * math.pi) * 0.28).clamp(0.0, 0.4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Single-page responsive fallback for narrow screens with 3D drag turning
  Widget _buildSinglePageBook(double pageWidth, double pageHeight, double progress) {
    final currentMem = widget.memories[_currentPage];
    final totalMemories = widget.memories.length;
    final isTurning = progress > 0.0;
    final angle = _isFlippingForward ? -progress * math.pi : (1.0 - progress) * math.pi;

    return Container(
      width: pageWidth,
      height: pageHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 30, offset: const Offset(0, 16)),
          const BoxShadow(color: Color(0xFFE5DDD3), offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Positioned.fill(
              child: _buildLeftPage(
                isTurning && _isFlippingForward
                    ? widget.memories[(_currentPage + 1).clamp(0, totalMemories - 1)]
                    : isTurning && !_isFlippingForward
                        ? widget.memories[(_currentPage - 1).clamp(0, totalMemories - 1)]
                        : currentMem,
              ),
            ),
            if (isTurning)
              Positioned.fill(
                child: Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0014)
                    ..rotateY(angle),
                  child: angle.abs() < math.pi * 0.5
                      ? _buildLeftPage(currentMem)
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(math.pi),
                          child: _buildLeftPage(
                            _isFlippingForward
                                ? widget.memories[(_currentPage + 1).clamp(0, totalMemories - 1)]
                                : widget.memories[(_currentPage - 1).clamp(0, totalMemories - 1)],
                          ),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds the Left Page (Visual & Archive focus with Polaroid photo, tape, and seals)
  Widget _buildLeftPage(TravelMemoryItem mem) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFBF8F2), // Warm ivory parchment paper
        borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
      ),
      child: Stack(
        children: [
          // Inner spine shadow gradient along right edge
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 28,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.16),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Badges: Day Date & Feeling
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'DAY ${mem.dayNumber} • ${mem.dateStr.toUpperCase()}',
                        style: GoogleFonts.spaceMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(mem.emoji, style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Text(
                            mem.feelingLabel,
                            style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFF334155)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Polaroid-style Framed Photograph
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  mem.photoUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, st) => Container(
                                    color: const Color(0xFFE2E8F0),
                                    child: const Center(child: Icon(Icons.image_outlined, color: Color(0xFF94A3B8))),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '📍 ${mem.destination} Moments',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF64748B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '#TokyoArchive',
                                  style: GoogleFonts.spaceMono(
                                    fontSize: 9.5,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Corner Washi tape effect
                        Positioned(
                          top: -2,
                          right: 14,
                          child: Transform.rotate(
                            angle: 0.05,
                            child: Container(
                              width: 38,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDE68A).withValues(alpha: 0.75),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Bottom Page Footer: Hand-pressed stamp & Left Page Number
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFDC2626).withValues(alpha: 0.4), width: 1.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '💮 TRIP ARCHIVE',
                        style: GoogleFonts.spaceMono(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFDC2626),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Text(
                      '- ${(mem.dayNumber * 2) - 1} -',
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the Right Page (Journal story, reflection prose & highlight notes)
  Widget _buildRightPage(TravelMemoryItem mem) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFBF8F2), // Warm ivory parchment paper
        borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
      ),
      child: Stack(
        children: [
          // Inner spine shadow gradient along left edge
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 28,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.16),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Memory Heading
                Text(
                  mem.heading,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18.5,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Subtle Flourish Divider
                Row(
                  children: [
                    Container(width: 24, height: 1, color: const Color(0xFFCBD5E1)),
                    const SizedBox(width: 6),
                    const Text('✦', style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
                    const SizedBox(width: 6),
                    Container(width: 24, height: 1, color: const Color(0xFFCBD5E1)),
                  ],
                ),
                const SizedBox(height: 10),

                // Journal Reflection Text
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mem.reflection,
                          style: GoogleFonts.crimsonPro(
                            fontSize: 15.5,
                            height: 1.5,
                            color: const Color(0xFF334155),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Day Highlight Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('💡', style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Day ${mem.dayNumber} Highlight',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Captured with the Tokyo Squad. Memories synced with trip itinerary.',
                                      style: GoogleFonts.inter(
                                        fontSize: 10.5,
                                        color: const Color(0xFF64748B),
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Right Page Footer: Ribbon bookmark & Right Page Number
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bookmark_rounded, size: 13, color: Color(0xFFEF4444)),
                        const SizedBox(width: 4),
                        Text(
                          'Tokyo Squad Memory',
                          style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                    Text(
                      '- ${mem.dayNumber * 2} -',
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
