import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../widgets/boarding_pass_ticket.dart';

class ProfilePage extends StatefulWidget {
  final SocialData data;
  final TripData trip;
  final VoidCallback onChanged;

  const ProfilePage({
    super.key,
    required this.data,
    required this.trip,
    required this.onChanged,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _igController;
  late TextEditingController _xController;

  late String _profileImage;
  late String _travelPace;
  late String _travelVibe;
  late String _travelStyle;

  final List<Map<String, String>> _recentMemories = [
    {
      'title': 'Banff, Canada',
      'date': 'Jun 2026',
      'image': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=600',
    },
    {
      'title': 'Santorini, Greece',
      'date': 'Sep 2025',
      'image': 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=600',
    },
    {
      'title': 'Tokyo, Japan',
      'date': 'Nov 2025',
      'image': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=600',
    },
    {
      'title': 'Amalfi, Italy',
      'date': 'Apr 2025',
      'image': 'https://images.unsplash.com/photo-1533105079780-92b9be482077?w=600',
    },
  ];

  @override
  void initState() {
    super.initState();
    final profile = widget.data.myProfile;
    _nameController = TextEditingController(text: profile.name.isNotEmpty ? profile.name : 'Ben');
    _ageController = TextEditingController(
      text: profile.age > 0 ? profile.age.toString() : '29',
    );
    _igController = TextEditingController(text: profile.instagram ?? '');
    _xController = TextEditingController(text: profile.xHandle ?? '');

    _profileImage = (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty)
        ? profile.avatarUrl!
        : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500';

    _travelPace = 'Relaxed';
    _travelVibe = 'Vibrant Metropolis';
    _travelStyle = 'Organized';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _igController.dispose();
    _xController.dispose();
    super.dispose();
  }

  void _openPhotoPicker() {
    showAvatarPickerSheet(
      context: context,
      currentImage: _profileImage,
      onSelected: (newUrl) {
        setState(() {
          _profileImage = newUrl;
          widget.data.myProfile.avatarUrl = newUrl;
        });
        widget.onChanged();
      },
    );
  }

  void _openEditProfileModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Profile & Travel Pass',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _openPhotoPicker();
                          setModalState(() {});
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundImage: NetworkImage(_profileImage),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0F172A),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Travel Preferences',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _travelPace,
                      decoration: InputDecoration(
                        labelText: 'Pace',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: ['Relaxed', 'Moderate', 'Fast-Paced']
                          .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => _travelPace = val);
                          setState(() => _travelPace = val);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _travelVibe,
                      decoration: InputDecoration(
                        labelText: 'Vibe',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: ['Vibrant Metropolis', 'Nature & Scenic', 'Cultural Explorer', 'Beach & Sunset']
                          .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => _travelVibe = val);
                          setState(() => _travelVibe = val);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _travelStyle,
                      decoration: InputDecoration(
                        labelText: 'Style',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: ['Organized', 'Spontaneous', 'Balanced']
                          .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => _travelStyle = val);
                          setState(() => _travelStyle = val);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            widget.data.myProfile.name = _nameController.text.trim();
                            widget.data.myProfile.age =
                                int.tryParse(_ageController.text.trim()) ?? 29;
                          });
                          widget.onChanged();
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile details updated!'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Color(0xFF0F172A),
                            ),
                          );
                        },
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _addMemory() {
    final titleCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: 'Oct 2026');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Add Travel Memory',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: 'Destination / Memory Title',
                hintText: 'e.g. Paris, France',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateCtrl,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'e.g. Oct 2026',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
            onPressed: () {
              final title = titleCtrl.text.trim();
              if (title.isNotEmpty) {
                setState(() {
                  _recentMemories.insert(0, {
                    'title': title,
                    'date': dateCtrl.text.trim(),
                    'image':
                        'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=600',
                  });
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add Memory'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.data.myProfile;
    final displayName = _nameController.text.isNotEmpty ? _nameController.text : 'Ben';
    final displayAge = _ageController.text.isNotEmpty ? '${_ageController.text} YRS' : '29 YRS';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 960;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ========================================================
                  // 1. TOP PROFILE HEADER BAR
                  // ========================================================
                  _buildHeaderBar(),
                  const SizedBox(height: 20),

                  // ========================================================
                  // 2. HERO TRAVEL PASS CONTAINER
                  // ========================================================
                  _buildTravelPassHero(displayName, displayAge, isDesktop),
                  const SizedBox(height: 24),

                  // ========================================================
                  // 3. BOTTOM SECTION: MEMORIES & REWARDS/TOGGLE GRID
                  // ========================================================
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildRecentMemoriesSection()),
                        const SizedBox(width: 24),
                        Expanded(flex: 2, child: _buildRightSideCards(profile)),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildRecentMemoriesSection(),
                        const SizedBox(height: 20),
                        _buildRightSideCards(profile),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // =========================================================================
  // HEADER BAR
  // =========================================================================
  Widget _buildHeaderBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Profile',
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Manage your profile, travel pass and preferences.',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(_profileImage),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================================
  // MAIN HERO TRAVEL PASS CONTAINER
  // =========================================================================
  Widget _buildTravelPassHero(String displayName, String displayAge, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF0F6FE),
            Color(0xFFE8F2FD),
            Color(0xFFDBECFE),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Decorative Stamp & Script Illustrations
          Positioned(
            right: 40,
            top: 25,
            child: Opacity(
              opacity: 0.35,
              child: CustomPaint(
                size: const Size(130, 130),
                painter: _StampWatermarkPainter(),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: 30,
            child: Opacity(
              opacity: 0.45,
              child: Transform.rotate(
                angle: -0.15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Good Travellers',
                      style: GoogleFonts.caveat(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    Text(
                      'Brighter Worlds',
                      style: GoogleFonts.caveat(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Top-Right Floating Edit Button
          Positioned(
            top: 18,
            right: 18,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 2,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _openEditProfileModal,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ),
          ),

          // Hero Content Padding
          Padding(
            padding: const EdgeInsets.all(28),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left Details Side
                      Expanded(
                        flex: 5,
                        child: _buildTravelPassLeftColumn(),
                      ),
                      const SizedBox(width: 32),
                      // Center Badge ID Card
                      _buildCenterExplorerBadge(displayName, displayAge),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTravelPassLeftColumn(),
                      const SizedBox(height: 24),
                      Center(
                        child: _buildCenterExplorerBadge(displayName, displayAge),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // LEFT COLUMN OF HERO CARD
  // =========================================================================
  Widget _buildTravelPassLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TRIPNEST',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.6,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Travel Pass',
          style: GoogleFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        Text(
          'Your travel identity',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 20),

        // Friends & Travel Circle Card Box
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.90),
            borderRadius: BorderRadius.circular(18),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.people_alt_rounded, size: 17, color: Color(0xFF0F172A)),
                      const SizedBox(width: 6),
                      Text(
                        'Friends & Travel Circle',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '4 friends >',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Overlapping Avatars Stack
                  SizedBox(
                    width: 120,
                    height: 34,
                    child: Stack(
                      children: [
                        _buildAvatarPositioned('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150', 0),
                        _buildAvatarPositioned('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150', 22),
                        _buildAvatarPositioned('https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150', 44),
                        _buildAvatarPositioned('https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150', 66),
                        Positioned(
                          left: 88,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                '+2',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF475569),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 28,
                    width: 1,
                    color: const Color(0xFFE2E8F0),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.people_outline_rounded, size: 15, color: Color(0xFF3B82F6)),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '2 mutual travel buddies',
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E40AF),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Stats Row (Trips Completed + Countries Visited)
        Row(
          children: [
            Expanded(
              child: _buildStatPill(
                icon: Icons.flight_takeoff_rounded,
                number: '12',
                label: 'Trips Completed',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatPill(
                icon: Icons.public_rounded,
                number: '8',
                label: 'Countries Visited',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Verified Profile & Open to Pair Badges Row
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF16A34A)),
                  const SizedBox(width: 6),
                  Text(
                    'Verified Profile',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF15803D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.group_add_rounded, size: 16, color: Color(0xFF0F172A)),
                  const SizedBox(width: 6),
                  Text(
                    'Open to Pair',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatarPositioned(String url, double left) {
    return Positioned(
      left: left,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(url),
        ),
      ),
    );
  }

  Widget _buildStatPill({
    required IconData icon,
    required String number,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF3B82F6)),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                number,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // CENTER BADGE EXPLORER ID CARD
  // =========================================================================
  // =========================================================================
  // CENTER BADGE EXPLORER ID CARD (3D PERSPECTIVE AT REST, CLICK TO SCROLL-ROTATE)
  // =========================================================================
  Widget _buildCenterExplorerBadge(String displayName, String displayAge) {
    return Column(
      children: [
        // Static 3D Perspective Card (Does not auto-move, opens interactive viewer on tap)
        GestureDetector(
          onTap: () => _openInteractive3DPassViewer(displayName, displayAge),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0013) // Realistic 3D perspective depth
                ..rotateX(0.06)          // Subtle downward pitch
                ..rotateY(-0.11)         // Subtle yaw angle to pop the 3D edge
                ..rotateZ(0.015),        // Gentle roll
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.18),
                      blurRadius: 26,
                      offset: const Offset(14, 20),
                      spreadRadius: -4,
                    ),
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.09),
                      blurRadius: 14,
                      offset: const Offset(4, 6),
                    ),
                  ],
                ),
                child: _buildBadgeCardFace(displayName, displayAge, isFront: true),
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Interactive 3D Affordance Pill Button
        GestureDetector(
          onTap: () => _openInteractive3DPassViewer(displayName, displayAge),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: const Color(0xFFCBD5E1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.threed_rotation_rounded, size: 15, color: Color(0xFF0F172A)),
                const SizedBox(width: 6),
                Text(
                  '3D Pass • Tap to interact & scroll',
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
      ],
    );
  }

  // =========================================================================
  // INTERACTIVE 3D VIEWER: ROTATES THROUGH SCROLLING & DRAGGING
  // =========================================================================
  void _openInteractive3DPassViewer(String displayName, String displayAge) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.78),
      builder: (dialogCtx) {
        double rotY = 0.0;
        double rotX = 0.0;

        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final normY = (rotY % (2 * math.pi)).abs();
            final isFront = normY <= (math.pi / 2) || normY >= (3 * math.pi / 2);

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Listener(
                // Captures mouse wheel / trackpad scrolling to rotate the 3D card
                onPointerSignal: (pointerSignal) {
                  if (pointerSignal is PointerScrollEvent) {
                    setDialogState(() {
                      rotY += pointerSignal.scrollDelta.dy * 0.009;
                      rotX = (rotX + pointerSignal.scrollDelta.dx * 0.003).clamp(-0.45, 0.45);
                    });
                  }
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  // Captures touch scroll and pan gestures
                  onVerticalDragUpdate: (details) {
                    setDialogState(() {
                      rotY += details.primaryDelta! * 0.012;
                      rotX = (rotX - details.primaryDelta! * 0.003).clamp(-0.45, 0.45);
                    });
                  },
                  onHorizontalDragUpdate: (details) {
                    setDialogState(() {
                      rotY += details.primaryDelta! * 0.014;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 420),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 36,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Top Header Bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.threed_rotation_rounded, color: Color(0xFF38BDF8), size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Travel Pass 3D',
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Scroll up/down or swipe to rotate in 3D',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 22),
                              onPressed: () => Navigator.pop(dialogCtx),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Interactive 3D Card with Scroll/Drag Driven Matrix
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.0016)
                            ..rotateX(rotX)
                            ..rotateY(rotY),
                          child: isFront
                              ? _buildBadgeCardFace(displayName, displayAge, isFront: true)
                              : Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()..rotateY(math.pi),
                                  child: _buildBadgeCardFace(displayName, displayAge, isFront: false),
                                ),
                        ),

                        const SizedBox(height: 18),

                        // Active Face Status Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isFront ? Icons.badge_outlined : Icons.qr_code_rounded,
                                size: 14,
                                color: const Color(0xFF38BDF8),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isFront ? 'Showing Front (Identity)' : 'Showing Back (QR & Stamps)',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Flip 180° and Reset Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                              ),
                              onPressed: () {
                                setDialogState(() {
                                  rotY += math.pi;
                                });
                              },
                              icon: const Icon(Icons.flip_camera_android_rounded, size: 16),
                              label: const Text('Flip 180°'),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                              ),
                              onPressed: () {
                                setDialogState(() {
                                  rotX = 0.0;
                                  rotY = 0.0;
                                });
                              },
                              icon: const Icon(Icons.replay_rounded, size: 16),
                              label: const Text('Reset Front'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =========================================================================
  // BADGE CARD FACES (FRONT & BACK RENDERING WITH EXACT IMAGE STYLING)
  // =========================================================================
  Widget _buildBadgeCardFace(String displayName, String displayAge, {required bool isFront}) {
    if (!isFront) {
      // ----------------------------------------------------
      // BACK FACE: CREDENTIALS, QR CODE & TRAVEL STAMPS
      // ----------------------------------------------------
      return Container(
        width: 250,
        height: 420,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TRIPNEST CREDENTIALS',
                  style: GoogleFonts.spaceMono(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: const Color(0xFF475569),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'SECURE',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF16A34A),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // QR Code Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.qr_code_2_rounded, size: 74, color: Color(0xFF0F172A)),
                  const SizedBox(height: 4),
                  Text(
                    'TN-2026-BEN94',
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Emergency & Health Info
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('BLOOD', style: GoogleFonts.spaceMono(fontSize: 8, color: const Color(0xFF64748B))),
                      Text('O+', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
                    ],
                  ),
                  Container(height: 24, width: 1, color: const Color(0xFFE2E8F0)),
                  Column(
                    children: [
                      Text('EMERGENCY', style: GoogleFonts.spaceMono(fontSize: 8, color: const Color(0xFF64748B))),
                      Text('+1 555-019', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Collector Passport Stamps Row
            Text(
              'PASSPORT ARCHIVE STAMPS',
              style: GoogleFonts.spaceMono(fontSize: 8, fontWeight: FontWeight.w700, color: const Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniStamp('🇯🇵', 'Tokyo'),
                _buildMiniStamp('🇨🇦', 'Banff'),
                _buildMiniStamp('🇬🇷', 'Santorini'),
                _buildMiniStamp('🇮🇹', 'Amalfi'),
              ],
            ),

            const Spacer(),

            // Manifesto
            Text(
              '"Collect People, Not Things"',
              style: GoogleFonts.caveat(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF475569),
              ),
            ),
            Text(
              'Same roads. Better company.',
              style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8)),
            ),
          ],
        ),
      );
    }

    // ----------------------------------------------------
    // FRONT FACE: EXACT LAYOUT FROM SCREENSHOT
    // ----------------------------------------------------
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Lanyard Clip Top Hardware
        Container(
          width: 34,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFF475569),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Container(
          width: 18,
          height: 10,
          decoration: BoxDecoration(
            color: const Color(0xFF94A3B8),
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Badge Container
        Container(
          width: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TRIPNEST',
                        style: GoogleFonts.spaceMono(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: const Color(0xFF475569),
                        ),
                      ),
                      Text(
                        'THE EXPLORER',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.3,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(Icons.flight, size: 14, color: Color(0xFF64748B)),
                      Text(
                        '000 - 26',
                        style: GoogleFonts.spaceMono(
                          fontSize: 8.5,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        'EXPLORE\nCONNECT\nBELONG',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.spaceMono(
                          fontSize: 6.5,
                          color: const Color(0xFF94A3B8),
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Portrait Box with Camera Icon
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      _profileImage,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        width: 110,
                        height: 110,
                        color: const Color(0xFFCBD5E1),
                        child: const Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F172A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Metadata Rows (Script / Italic font like screenshot)
              _buildBadgeInfoRow('NAME', displayName, isCursive: true),
              _buildBadgeInfoRow('AGE', displayAge, isItalic: true),
              _buildBadgeInfoRow('PACE', _travelPace, isItalic: true),

              const SizedBox(height: 12),

              // Bottom Emblem & Stamp
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Color(0xFFCBD5E1), thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          children: [
                            const Icon(Icons.terrain_rounded, size: 13, color: Color(0xFF64748B)),
                            Text(
                              'GOOD TRIPS  BETTER PEOPLE',
                              style: GoogleFonts.spaceMono(
                                fontSize: 6.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(child: Divider(color: Color(0xFFCBD5E1), thickness: 1)),
                    ],
                  ),
                  // Round Cancellation Stamp (matches screenshot)
                  Positioned(
                    right: -10,
                    bottom: -16,
                    child: Opacity(
                      opacity: 0.55,
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF64748B), width: 1.2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'TRAVEL',
                              style: GoogleFonts.spaceMono(fontSize: 6, fontWeight: FontWeight.bold, color: const Color(0xFF475569)),
                            ),
                            const Icon(Icons.flight_takeoff_rounded, size: 10, color: Color(0xFF475569)),
                            Text(
                              'REPEAT',
                              style: GoogleFonts.spaceMono(fontSize: 5.5, color: const Color(0xFF475569)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStamp(String emoji, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          Text(title, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600, color: const Color(0xFF475569))),
        ],
      ),
    );
  }

  Widget _buildBadgeInfoRow(String label, String value, {bool isCursive = false, bool isItalic = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceMono(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF94A3B8),
            ),
          ),
          Text(
            value,
            style: isCursive
                ? GoogleFonts.caveat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  )
                : GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                    color: const Color(0xFF0F172A),
                  ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // RECENT TRAVEL MEMORIES SECTION
  // =========================================================================
  Widget _buildRecentMemoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.collections_rounded, size: 20, color: Color(0xFF0F172A)),
                const SizedBox(width: 8),
                Text(
                  'Recent Travel Memories',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    'View All',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF3B82F6)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Horizontal List of Memory Cards
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _recentMemories.length + 1,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == _recentMemories.length) {
                return _buildAddMemoryCard();
              }
              final memory = _recentMemories[index];
              return _buildMemoryCard(memory);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMemoryCard(Map<String, String> memory) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
              memory['image']!,
              height: 110,
              width: 130,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Container(
                height: 110,
                color: const Color(0xFFCBD5E1),
                child: const Icon(Icons.image, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memory['title']!,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  memory['date']!,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMemoryCard() {
    return GestureDetector(
      onTap: _addMemory,
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
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

  // =========================================================================
  // RIGHT SIDE CARDS (OPEN TO PAIR TOGGLE + REWARDS CARD)
  // =========================================================================
  Widget _buildRightSideCards(UserProfile profile) {
    return Column(
      children: [
        // 1. OPEN TO PAIR CARD TOGGLE
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.people_rounded,
                  color: Color(0xFF16A34A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Open to Pair',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Visible to potential travel buddies',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: profile.isOpenToPair,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF10B981),
                onChanged: (val) {
                  setState(() {
                    profile.isOpenToPair = val;
                  });
                  widget.onChanged();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2. REWARDS CARD
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.workspace_premium_rounded, size: 18, color: Color(0xFF0F172A)),
                      const SizedBox(width: 6),
                      Text(
                        'Rewards',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'View Details >',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  // Item 1: Streak
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFEDD5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_fire_department_rounded,
                            color: Color(0xFFEA580C),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '3-Day Streak',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Keep it going!',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 32,
                    width: 1,
                    color: const Color(0xFFE2E8F0),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  // Item 2: TripCoins
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFEF9C3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.monetization_on_rounded,
                            color: Color(0xFFCA8A04),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '150 TripCoins',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Nice progress!',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom Painter for Stamp Watermark on Hero Background
class _StampWatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer circle
    canvas.drawCircle(center, radius, paint);
    // Inner circle
    canvas.drawCircle(center, radius - 6, paint);

    // Inner plane icon
    const icon = Icons.flight_rounded;
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 28,
          fontFamily: icon.fontFamily,
          color: const Color(0xFF64748B),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
