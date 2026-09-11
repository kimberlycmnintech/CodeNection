import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/itinerary_trip_models.dart';

class AiNotebookScreen extends StatefulWidget {
  final TripFolderItem trip;

  const AiNotebookScreen({
    super.key,
    required this.trip,
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

  final List<_NotebookDecisionItem> _decisions = [
    _NotebookDecisionItem(
      id: 'd1',
      tag: 'Must Visit',
      tagBgColor: Color(0xFFFCE7F3),
      tagTextColor: Color(0xFFDB2777),
      title: 'TeamLab Borderless',
      description: 'Book morning tickets online in advance.',
      author: 'Maya',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      date: '12 Sep 2026',
    ),
    _NotebookDecisionItem(
      id: 'd2',
      tag: 'Walking Preference',
      tagBgColor: Color(0xFFDCFCE7),
      tagTextColor: Color(0xFF16A34A),
      title: 'Walking Limit: Max 15k steps/day',
      description: 'Take metro between distant hubs.',
      author: 'Sarah',
      authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      date: '12 Sep 2026',
    ),
    _NotebookDecisionItem(
      id: 'd3',
      tag: 'Schedule',
      tagBgColor: Color(0xFFE0F2FE),
      tagTextColor: Color(0xFF0284C7),
      title: 'Late morning starts (~10:30 AM)',
      description: 'No rushing early mornings.',
      author: 'You',
      authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
      date: '11 Sep 2026',
    ),
    _NotebookDecisionItem(
      id: 'd4',
      tag: 'Budget',
      tagBgColor: Color(0xFFF3E8FF),
      tagTextColor: Color(0xFF9333EA),
      title: 'Hotel budget ≤ RM250/night',
      description: 'Keep accommodation below RM250/night.',
      author: 'Daniel',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      date: '10 Sep 2026',
    ),
    _NotebookDecisionItem(
      id: 'd5',
      tag: 'Food Preference',
      tagBgColor: Color(0xFFFFEDD5),
      tagTextColor: Color(0xFFEA580C),
      title: 'Prefer local food over fine dining',
      description: 'Focus on street food, local restaurants and cafes.',
      author: 'Maya',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      date: '10 Sep 2026',
    ),
    _NotebookDecisionItem(
      id: 'd6',
      tag: 'Neighbourhood',
      tagBgColor: Color(0xFFEFF6FF),
      tagTextColor: Color(0xFF2563EB),
      title: 'Stay around Hongdae or Myeongdong',
      description: 'Good food, shopping and easy transport access.',
      author: 'Daniel',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      date: '9 Sep 2026',
    ),
  ];

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
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Add new note...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 16),
              label: Text('New Note', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12)),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Filter Bar
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
                              hintText: 'Search notes...',
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

          // Main 2-Column Body
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 850;

                if (isDesktop) {
                  return Row(
                    children: [
                      // Left Sidebar Categories (Width ~300)
                      SizedBox(
                        width: 300,
                        child: _buildCategorySidebar(),
                      ),
                      const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),

                      // Right Main Content Panel
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
                      SizedBox(height: 220, child: _buildCategorySidebar()),
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
                color: isSelected ? const Color(0xFF2563EB).withValues(alpha: 0.3) : Colors.transparent,
              ),
            ),
            child: ListTile(
              onTap: () => setState(() => _selectedCategoryIndex = index),
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
                    style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
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

  /// Right Main Content Panel (AI Summary + Saved Group Decision Cards)
  Widget _buildMainContentPanel() {
    final filtered = _decisions.where((d) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return d.title.toLowerCase().contains(q) || d.description.toLowerCase().contains(q) || d.tag.toLowerCase().contains(q);
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
                const Icon(Icons.chat_outlined, size: 20, color: Color(0xFF0F172A)),
                const SizedBox(width: 8),
                Text(
                  'Trip Discussion Notes',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.more_horiz, size: 20, color: Color(0xFF64748B)),
                  onPressed: () {},
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✨ AI is analyzing chat decisions...')),
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
          'Notes automatically compiled from your group chat. Edit, add or ask AI to refine them.',
          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
        ),
        const SizedBox(height: 16),

        // AI Summary Banner Card
        Container(
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
                    onPressed: () {},
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
                'We found 6 key decisions from your chat. You prefer a mix of popular attractions and local food, a relaxed pace with late morning starts, and a hotel budget under RM250/night.',
                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF334155), height: 1.4),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  _buildSummaryTagPill('6 decisions'),
                  _buildSummaryTagPill('3 contributors'),
                  _buildSummaryTagPill('Covers places, food, budget, schedule and more'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // List of 6 Decision Cards
        for (final item in filtered) ...[
          _buildDecisionCard(item),
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
                      content: Text('✨ Generating updated itinerary from group notes...'),
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

  Widget _buildDecisionCard(_NotebookDecisionItem item) {
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
      child: Row(
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
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                ),
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

class _NotebookDecisionItem {
  final String id;
  final String tag;
  final Color tagBgColor;
  final Color tagTextColor;
  final String title;
  final String description;
  final String author;
  final String authorAvatar;
  final String date;

  _NotebookDecisionItem({
    required this.id,
    required this.tag,
    required this.tagBgColor,
    required this.tagTextColor,
    required this.title,
    required this.description,
    required this.author,
    required this.authorAvatar,
    required this.date,
  });
}
