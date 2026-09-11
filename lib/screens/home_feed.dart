import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/models.dart';

class HomeFeed extends StatefulWidget {
  final TripData trip;
  final VoidCallback onOpenTrip;
  final VoidCallback onSeeAll;

  const HomeFeed({
    super.key,
    required this.trip,
    required this.onOpenTrip,
    required this.onSeeAll,
  });

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Flight', 'Hotel', 'Campervan', 'Explore'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iceBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // --------------------------------------------------
            // 1. TOP HEADER: Grid Icon, User Location & Bell (REF SCREEN 2)
            // --------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x0F0F172A),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.grid_view_rounded, color: darkSlate, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alex Carry',
                          style: boldTitle(15, color: darkSlate),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 12, color: azureBlue),
                            const SizedBox(width: 2),
                            Text(
                              'Cologne (GER)',
                              style: bodyFont(11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x0F0F172A),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.bookmark_outline_rounded, color: darkSlate, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x0F0F172A),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.notifications_none_rounded, color: darkSlate, size: 20),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: azureBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 22),

            // --------------------------------------------------
            // 2. HERO TITLE: "Explore Now!" (BOLD ITALIC DISPLAY FONT)
            // --------------------------------------------------
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore Now!',
                  style: boldItalicTitle(32, color: darkSlate),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: darkSlate,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // --------------------------------------------------
            // 3. TILTED FEATURED CARD (REF MOCKUP SCREEN 2)
            // --------------------------------------------------
            Transform.rotate(
              angle: -0.02,
              child: Container(
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E293B).withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.2),
                              Colors.black.withValues(alpha: 0.8),
                            ],
                            stops: const [0.3, 0.6, 1.0],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bavarian Alps',
                                      style: boldItalicTitle(22, color: Colors.white),
                                    ),
                                    Text(
                                      '📍 Germany',
                                      style: bodyFont(12, color: Colors.white.withValues(alpha: 0.85)),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.amber, size: 13),
                                      SizedBox(width: 4),
                                      Text(
                                        '4.9',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 85,
                                  height: 32,
                                  child: Stack(
                                    children: const [
                                      Positioned(
                                        left: 0,
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100'),
                                        ),
                                      ),
                                      Positioned(
                                        left: 20,
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100'),
                                        ),
                                      ),
                                      Positioned(
                                        left: 40,
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '21 explorers recommended this destination',
                                    style: bodyFont(11.5, color: Colors.white.withValues(alpha: 0.9)),
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
            ),

            const SizedBox(height: 26),

            // --------------------------------------------------
            // 4. CATEGORY PILLS & POPULAR DESTINATIONS
            // --------------------------------------------------
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? darkSlate : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: darkSlate.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          else
                            BoxShadow(
                              color: const Color(0x0F0F172A),
                              blurRadius: 6,
                            ),
                        ],
                      ),
                      child: Text(
                        cat,
                        style: isSelected
                            ? boldItalicTitle(12, color: Colors.white)
                            : bodyFont(12, color: darkSlate, weight: FontWeight.w600),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------
            // 5. POPULAR GUIDES / DESTINATIONS
            // --------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Destinations',
                  style: boldItalicTitle(18, color: darkSlate),
                ),
                TextButton(
                  onPressed: widget.onSeeAll,
                  child: Text(
                    'See all',
                    style: boldTitle(13, color: azureBlue),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  guide('Ha Long Bay', 'photo-1528127269322-539801943592', rating: '5.0', location: 'Vietnam'),
                  guide('Bozcaada', 'photo-1507525428034-b723cf961d3e', rating: '4.9', location: 'Turkey'),
                  guide('Kyoto Old Town', 'photo-1493976040374-85c8e12f0c0e', rating: '4.8', location: 'Japan'),
                  guide('Santorini Coast', 'photo-1570077188670-e3a8d69ac5ff', rating: '4.9', location: 'Greece'),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // --------------------------------------------------
            // 6. HOTEL VILLA LUDWIG / FEATURED REVIEW CARD (REF SCREEN 3)
            // --------------------------------------------------
            Text(
              'Featured Accommodation',
              style: boldItalicTitle(18, color: darkSlate),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.07),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        children: [
                          Image.network(
                            'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=600',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 13),
                                  SizedBox(width: 3),
                                  Text(
                                    '4.9',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: darkSlate),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Hotel Villa Ludwig',
                      style: boldItalicTitle(16, color: darkSlate),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Luxurious, romantic hotel with direct view of Neuschwanstein Castle and friendly staff.',
                      style: bodyFont(12),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100'),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Kerry Anderson • 1 week ago',
                          style: bodyFont(11.5, weight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

