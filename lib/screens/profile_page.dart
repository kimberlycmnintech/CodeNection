import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme.dart';
import '../widgets/boarding_pass_ticket.dart';
import '../widgets/travel_id_badge.dart';

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

  bool get _isAllRequiredFilled {
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    return name.isNotEmpty && age.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    final profile = widget.data.myProfile;
    _nameController = TextEditingController(text: profile.name);
    _ageController = TextEditingController(
      text: profile.age > 0 ? profile.age.toString() : '',
    );
    _igController = TextEditingController(text: profile.instagram ?? '');
    _xController = TextEditingController(text: profile.xHandle ?? '');
    _profileImage = (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty)
        ? profile.avatarUrl!
        : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500';

    _nameController.addListener(_onFieldChanged);
    _ageController.addListener(_onFieldChanged);
    _igController.addListener(_onFieldChanged);
    _xController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _igController.dispose();
    _xController.dispose();
    super.dispose();
  }

  void _saveDetails() {
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim()) ?? widget.data.myProfile.age;
    final ig = _igController.text.trim();
    final x = _xController.text.trim();

    setState(() {
      widget.data.myProfile.name = name.isNotEmpty ? name : widget.data.myProfile.name;
      if (age > 0) widget.data.myProfile.age = age;
      widget.data.myProfile.instagram = ig.isNotEmpty ? ig : null;
      widget.data.myProfile.xHandle = x.isNotEmpty ? x : null;
      widget.data.myProfile.avatarUrl = _profileImage;
    });

    widget.onChanged();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAllRequiredFilled
              ? 'Passenger details saved! Your Travel Pass is now active.'
              : 'Details updated. Fill in Name & Age to unlock your Travel Pass.',
        ),
        backgroundColor: const Color(0xFF0B2240),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final profile = widget.data.myProfile;
    final isComplete = _isAllRequiredFilled;

    return Scaffold(
      backgroundColor: iceBg,
      appBar: AppBar(
        backgroundColor: iceBg,
        elevation: 0,
        title: Text(
          'Passenger Profile',
          style: boldItalicTitle(22, color: darkSlate),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        children: [
          // ==========================================
          // 1. BOARDING PASS SECTION (SHOWN WHEN FILLED)
          // ==========================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Travel Pass',
                style: GoogleFonts.cinzel(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0B2240),
                  letterSpacing: 1.0,
                ),
              ),
              Row(
                children: [
                  if (isComplete)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF10B981), width: 1.2),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline, size: 14, color: Color(0xFF10B981)),
                          SizedBox(width: 4),
                          Text(
                            'ISSUED & ACTIVE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade800, width: 1.2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.pending_outlined, size: 14, color: Colors.orange.shade800),
                          const SizedBox(width: 4),
                          Text(
                            'PENDING DETAILS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Conditional Boarding Pass display
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: isComplete
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TravelIdBadge(
                    profile: profile,
                    displayName: _nameController.text,
                    displayAge: _ageController.text,
                    displayInstagram: _igController.text,
                    displayX: _xController.text,
                    profileImage: _profileImage,
                    onPhotoTap: _openPhotoPicker,
                    animateFlipOnMount: false,
                    enableTapToFlip: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app_outlined,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Tap badge to flip & inspect pass',
                        style: GoogleFonts.spaceMono(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.airplane_ticket_outlined,
                      color: Color(0xFF0B2240),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Travel Pass Pending',
                    style: GoogleFonts.cinzel(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0B2240),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Please fill in your Passenger Details (Name & Age) below.\nOnce complete, your official Travel Pass will appear here!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  LinearProgressIndicator(
                    value: (_nameController.text.trim().isNotEmpty ? 0.5 : 0.0) +
                        (_ageController.text.trim().isNotEmpty ? 0.5 : 0.0),
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${(_nameController.text.trim().isNotEmpty ? 1 : 0) + (_ageController.text.trim().isNotEmpty ? 1 : 0)} of 2 required fields completed',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ==========================================
          // 2. PASSENGER DETAILS FORM SECTION
          // ==========================================
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.badge_outlined,
                          color: Color(0xFF0B2240),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Passenger Details',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E242B),
                            ),
                          ),
                          Text(
                            'Fill in to generate or update your Boarding Pass',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Profile Picture Row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _openPhotoPicker,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: primaryColor,
                              backgroundImage: NetworkImage(_profileImage),
                              onBackgroundImageError: (_, _) {},
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0B2240),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Profile Photo (Optional)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Tap photo to select travel avatar or custom URL',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: _openPhotoPicker,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0B2240),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Change'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name of Passenger (Required)',
                      hintText: 'e.g. Harshall D.P',
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Age Field
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age (Required)',
                      hintText: 'e.g. 24',
                      prefixIcon: const Icon(Icons.cake_outlined),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Instagram Field
                  TextFormField(
                    controller: _igController,
                    decoration: InputDecoration(
                      labelText: 'Instagram Link / Handle (Optional)',
                      hintText: '@username',
                      prefixIcon: const Icon(Icons.camera_alt_outlined),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // X / Twitter Field
                  TextFormField(
                    controller: _xController,
                    decoration: InputDecoration(
                      labelText: 'X (Twitter) Link / Handle (Optional)',
                      hintText: '@username',
                      prefixIcon: const Icon(Icons.alternate_email_rounded),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Save Details Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: _saveDetails,
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      label: Text(
                        isComplete
                            ? 'Save & Update Travel Pass'
                            : 'Save Passenger Details',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0B2240),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ==========================================
          // 2.5 OPEN TO PAIR SETTINGS SECTION
          // ==========================================
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: profile.isOpenToPair ? const Color(0xFFDCFCE7) : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      profile.isOpenToPair ? Icons.people_rounded : Icons.people_outline_rounded,
                      color: profile.isOpenToPair ? const Color(0xFF16A34A) : Colors.grey.shade700,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Open to Pair',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E242B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          profile.isOpenToPair
                              ? 'Your profile & Travel Pass are visible to potential travel buddies in the pairing pool.'
                              : 'Your profile is currently hidden from pairing network.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: profile.isOpenToPair,
                    activeThumbColor: const Color(0xFF10B981),
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
          ),
          const SizedBox(height: 20),

          // ==========================================
          // 3. REWARDS SECTION
          // ==========================================
          const Text('Rewards', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.local_fire_department, color: Colors.orange),
            title: const Text('3-Day Journal Streak'),
            trailing: const Text('+150 TripCoins', style: TextStyle(color: coral, fontWeight: FontWeight.bold)),
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(height: 20),

        ],
      ),
    );
  }
}
